from django.db import models
from users.models import CustomUser
from items.models import Item


class Invoice(models.Model):
    created_by = models.ForeignKey(CustomUser, on_delete=models.CASCADE, related_name='invoices')
    item = models.ForeignKey(Item, on_delete=models.SET_NULL, null=True, related_name='invoices')
    customer_name = models.CharField(max_length=255)
    customer_email = models.EmailField()
    customer_phone = models.CharField(max_length=15)
    customer_address = models.TextField()
    date = models.DateField()
    total_amount = models.DecimalField(max_digits=12, decimal_places=2, default=0)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Invoice #{self.id} - {self.customer_name}"
