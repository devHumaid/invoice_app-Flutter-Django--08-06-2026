from django.db import models
from users.models import CustomUser


class Item(models.Model):
    TYPE_CHOICES = (
        ('goods', 'Goods'),
        ('service', 'Service'),
    )
    TAX_CHOICES = (
        ('taxable', 'Taxable'),
        ('non_taxable', 'Non-Taxable'),
    )

    created_by = models.ForeignKey(CustomUser, on_delete=models.CASCADE, related_name='items')
    name = models.CharField(max_length=255)
    type = models.CharField(max_length=10, choices=TYPE_CHOICES)
    hsn_code = models.CharField(max_length=6, blank=True, null=True)   # for goods
    sac_code = models.CharField(max_length=6, blank=True, null=True)   # for services
    tax_type = models.CharField(max_length=15, choices=TAX_CHOICES)
    price = models.DecimalField(max_digits=10, decimal_places=2)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.name
