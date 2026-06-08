from django.urls import path
from .views import ItemListCreateView, ItemDeleteView

urlpatterns = [
    path('', ItemListCreateView.as_view(), name='item-list-create'),
    path('<int:item_id>/delete/', ItemDeleteView.as_view(), name='item-delete'),
]
