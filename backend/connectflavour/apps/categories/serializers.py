from rest_framework import serializers
from .models import Category, Tag, DifficultyLevel


class CategorySerializer(serializers.ModelSerializer):
    """
    Serializer for recipe categories
    """
    class Meta:
        model = Category
        fields = (
            'id', 'name', 'slug', 'description', 'image',
            'display_order', 'is_featured', 'recipes_count'
        )
        read_only_fields = ('id', 'slug', 'recipes_count')


class TagSerializer(serializers.ModelSerializer):
    """
    Serializer for recipe tags
    """
    class Meta:
        model = Tag
        fields = (
            'id', 'name', 'slug', 'color', 'usage_count'
        )
        read_only_fields = ('id', 'slug', 'usage_count')


class DifficultyLevelSerializer(serializers.ModelSerializer):
    """
    Serializer for difficulty levels
    """
    class Meta:
        model = DifficultyLevel
        fields = (
            'id', 'name', 'description', 'display_order', 'icon'
        )
        read_only_fields = ('id',)
