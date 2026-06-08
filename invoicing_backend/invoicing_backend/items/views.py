from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .models import Item
from .serializers import ItemSerializer
from users.permissions import IsRegularUser


class ItemListCreateView(APIView):
    permission_classes = [IsRegularUser]

    def get(self, request):
        items = Item.objects.filter(created_by=request.user)
        serializer = ItemSerializer(items, many=True)
        return Response(serializer.data)

    def post(self, request):
        serializer = ItemSerializer(data=request.data, context={'request': request})
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class ItemDeleteView(APIView):
    permission_classes = [IsRegularUser]

    def delete(self, request, item_id):
        try:
            item = Item.objects.get(id=item_id, created_by=request.user)
            item.delete()
            return Response({"message": "Item deleted."})
        except Item.DoesNotExist:
            return Response({"error": "Item not found."}, status=status.HTTP_404_NOT_FOUND)
