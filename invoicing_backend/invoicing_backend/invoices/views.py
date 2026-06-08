from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .models import Invoice
from .serializers import InvoiceSerializer
from users.permissions import IsRegularUser, IsAdminUser
from rest_framework.permissions import IsAuthenticated


class InvoiceListCreateView(APIView):
    permission_classes = [IsRegularUser]

    def get(self, request):
        invoices = Invoice.objects.filter(created_by=request.user).select_related('item')
        serializer = InvoiceSerializer(invoices, many=True)
        return Response(serializer.data)

    def post(self, request):
        serializer = InvoiceSerializer(data=request.data, context={'request': request})
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class InvoiceDeleteView(APIView):
    permission_classes = [IsRegularUser]

    def delete(self, request, invoice_id):
        try:
            invoice = Invoice.objects.get(id=invoice_id, created_by=request.user)
            invoice.delete()
            return Response({"message": "Invoice deleted."})
        except Invoice.DoesNotExist:
            return Response({"error": "Invoice not found."}, status=status.HTTP_404_NOT_FOUND)


class AdminInvoiceListView(APIView):
    permission_classes = [IsAdminUser]

    def get(self, request):
        invoices = Invoice.objects.all().select_related('item', 'created_by')
        serializer = InvoiceSerializer(invoices, many=True)
        return Response(serializer.data)
