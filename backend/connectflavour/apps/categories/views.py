from rest_framework import generics, permissions
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from .models import Category, Tag, DifficultyLevel
from .serializers import CategorySerializer, TagSerializer, DifficultyLevelSerializer


class CategoryListView(generics.ListAPIView):
    """
    List all categories
    """
    queryset = Category.objects.filter(
        is_active=True).order_by('display_order', 'name')
    serializer_class = CategorySerializer
    permission_classes = [permissions.AllowAny]


class CategoryDetailView(generics.RetrieveAPIView):
    """
    Category detail with recipes count
    """
    queryset = Category.objects.filter(is_active=True)
    serializer_class = CategorySerializer
    permission_classes = [permissions.AllowAny]
    lookup_field = 'slug'


class TagListView(generics.ListAPIView):
    """
    List all tags
    """
    queryset = Tag.objects.filter(
        is_active=True).order_by('-usage_count', 'name')
    serializer_class = TagSerializer
    permission_classes = [permissions.AllowAny]


class DifficultyLevelListView(generics.ListAPIView):
    """
    List all difficulty levels
    """
    queryset = DifficultyLevel.objects.filter(
        is_active=True).order_by('display_order')
    serializer_class = DifficultyLevelSerializer
    permission_classes = [permissions.AllowAny]
