from django.contrib import admin
from .models import CustomUser

@admin.register(CustomUser)
class CustomUserAdmin(admin.ModelAdmin):
    list_display = ['username', 'name', 'email', 'role', 'is_approved']
    list_editable = ['is_approved']
    list_filter = ['is_approved', 'role']