from rest_framework import serializers
from .models import Item
import re


class ItemSerializer(serializers.ModelSerializer):
    created_by = serializers.StringRelatedField(read_only=True)

    class Meta:
        model = Item
        fields = ['id', 'created_by', 'name', 'type', 'hsn_code', 'sac_code', 'tax_type', 'price', 'created_at']
        read_only_fields = ['id', 'created_by', 'created_at']

    def validate(self, data):
        item_type = data.get('type')
        hsn = data.get('hsn_code')
        sac = data.get('sac_code')
        pattern = r'^\d{6}$'

        if item_type == 'goods':
            if not hsn:
                raise serializers.ValidationError({"hsn_code": "HSN code is required for goods."})
            if not re.match(pattern, hsn):
                raise serializers.ValidationError({"hsn_code": "HSN must be exactly 6 digits."})
            if Item.objects.filter(hsn_code=hsn).exclude(id=self.instance.id if self.instance else None).exists():
                raise serializers.ValidationError({"hsn_code": "HSN code already exists."})

        elif item_type == 'service':
            if not sac:
                raise serializers.ValidationError({"sac_code": "SAC code is required for services."})
            if not re.match(pattern, sac):
                raise serializers.ValidationError({"sac_code": "SAC must be exactly 6 digits."})
            if Item.objects.filter(sac_code=sac).exclude(id=self.instance.id if self.instance else None).exists():
                raise serializers.ValidationError({"sac_code": "SAC code already exists."})

        return data

    def create(self, validated_data):
        validated_data['created_by'] = self.context['request'].user
        return super().create(validated_data)
