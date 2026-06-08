from django.urls import path
from .views import InvoiceListCreateView, InvoiceDeleteView, AdminInvoiceListView

urlpatterns = [
    path('', InvoiceListCreateView.as_view(), name='invoice-list-create'),
    path('<int:invoice_id>/delete/', InvoiceDeleteView.as_view(), name='invoice-delete'),
    path('admin/all/', AdminInvoiceListView.as_view(), name='admin-invoice-list'),
]
