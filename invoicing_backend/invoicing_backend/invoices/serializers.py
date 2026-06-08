from rest_framework import serializers
from .models import Invoice
from items.serializers import ItemSerializer
import re


class InvoiceSerializer(serializers.ModelSerializer):
    created_by = serializers.StringRelatedField(read_only=True)
    item_detail = ItemSerializer(source='item', read_only=True)

    class Meta:
        model = Invoice
        fields = [
            'id', 'created_by', 'item', 'item_detail',
            'customer_name', 'customer_email', 'customer_phone',
            'customer_address', 'date', 'total_amount', 'created_at'
        ]
        read_only_fields = ['id', 'created_by', 'item_detail', 'total_amount', 'created_at']

    def validate_customer_email(self, value):
        pattern = r'^[\w\.-]+@[\w\.-]+\.\w{2,}$'
        if not re.match(pattern, value):
            raise serializers.ValidationError("Invalid email format.")
        return value

    def validate_customer_phone(self, value):
        pattern = r'^\+?[0-9]{10,15}$'
        if not re.match(pattern, value):
            raise serializers.ValidationError("Phone must be 10-15 digits.")
        return value

    def create(self, validated_data):
        validated_data['created_by'] = self.context['request'].user
        item = validated_data.get('item')
        if item:
            validated_data['total_amount'] = item.price
        return super().create(validated_data)
