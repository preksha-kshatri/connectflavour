import django_filters
from django.db.models import Q
from .models import Recipe
from apps.categories.models import Category, Tag, DifficultyLevel


class RecipeFilter(django_filters.FilterSet):
    """
    Custom filter for recipes
    """
    # Category filtering
    category = django_filters.ModelChoiceFilter(
        queryset=Category.objects.all(),
        field_name='category'
    )

    # Difficulty filtering
    difficulty = django_filters.ModelChoiceFilter(
        queryset=DifficultyLevel.objects.all(),
        field_name='difficulty_level'
    )

    # Tag filtering
    tags = django_filters.ModelMultipleChoiceFilter(
        queryset=Tag.objects.all(),
        field_name='tags'
    )

    # Time filtering
    prep_time_max = django_filters.NumberFilter(
        field_name='prep_time',
        lookup_expr='lte'
    )
    cook_time_max = django_filters.NumberFilter(
        field_name='cook_time',
        lookup_expr='lte'
    )
    total_time_max = django_filters.NumberFilter(
        field_name='total_time',
        lookup_expr='lte'
    )

    # Serving size filtering
    servings_min = django_filters.NumberFilter(
        field_name='servings',
        lookup_expr='gte'
    )
    servings_max = django_filters.NumberFilter(
        field_name='servings',
        lookup_expr='lte'
    )

    # Rating filtering
    min_rating = django_filters.NumberFilter(
        field_name='average_rating',
        lookup_expr='gte'
    )

    # Calorie filtering
    max_calories = django_filters.NumberFilter(
        field_name='calories_per_serving',
        lookup_expr='lte'
    )

    # Author filtering
    author = django_filters.CharFilter(
        field_name='author__username',
        lookup_expr='icontains'
    )

    # Featured recipes
    is_featured = django_filters.BooleanFilter(
        field_name='is_featured'
    )

    # Ingredient filtering
    has_ingredient = django_filters.CharFilter(
        method='filter_by_ingredient'
    )

    class Meta:
        model = Recipe
        fields = {
            'created_at': ['gte', 'lte'],
            'view_count': ['gte'],
            'save_count': ['gte'],
        }

    def filter_by_ingredient(self, queryset, name, value):
        """
        Filter recipes that contain specific ingredient
        """
        if value:
            return queryset.filter(
                recipe_ingredients__ingredient__name__icontains=value
            ).distinct()
        return queryset
