from rest_framework import generics, status, permissions, filters
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework.views import APIView
from django.contrib.auth import get_user_model
from django.shortcuts import get_object_or_404
from django.db import transaction
from django.db.models import Q, F, Avg
from django_filters.rest_framework import DjangoFilterBackend
from .models import (
    Recipe,
    Ingredient,
    RecipeRating,
    RecipeView
)
from .serializers import (
    RecipeListSerializer,
    RecipeDetailSerializer,
    RecipeCreateUpdateSerializer,
    RecipeRatingCreateSerializer,
    IngredientSerializer
)
from .filters import RecipeFilter

User = get_user_model()


class RecipeListCreateView(generics.ListCreateAPIView):
    """
    List recipes or create new recipe
    """
    queryset = Recipe.objects.filter(is_published=True).select_related(
        'author', 'category', 'difficulty_level'
    ).prefetch_related('tags')
    filter_backends = [DjangoFilterBackend,
                       filters.SearchFilter, filters.OrderingFilter]
    filterset_class = RecipeFilter
    search_fields = ['title', 'description',
                     'recipe_ingredients__ingredient__name']
    ordering_fields = ['created_at', 'popularity_score',
                       'average_rating', 'view_count']
    ordering = ['-created_at']

    def get_serializer_class(self):
        if self.request.method == 'POST':
            return RecipeCreateUpdateSerializer
        return RecipeListSerializer

    def get_permissions(self):
        """
        Allow anyone to view recipes, require auth to create
        """
        if self.request.method == 'POST':
            return [permissions.IsAuthenticated()]
        return [permissions.AllowAny()]

    def perform_create(self, serializer):
        """
        Save recipe with current user as author
        """
        serializer.save(author=self.request.user)


class RecipeDetailView(generics.RetrieveUpdateDestroyAPIView):
    """
    Retrieve, update or delete a recipe
    """
    queryset = Recipe.objects.select_related(
        'author', 'category', 'difficulty_level'
    ).prefetch_related(
        'tags', 'recipe_ingredients__ingredient', 'procedures', 'ratings__user'
    )
    serializer_class = RecipeDetailSerializer
    lookup_field = 'slug'

    def get_serializer_class(self):
        if self.request.method in ['PUT', 'PATCH']:
            return RecipeCreateUpdateSerializer
        return RecipeDetailSerializer

    def get_permissions(self):
        """
        Allow anyone to view, only author can edit/delete
        """
        if self.request.method == 'GET':
            return [permissions.AllowAny()]
        return [permissions.IsAuthenticated(), IsAuthorOrReadOnly()]

    def retrieve(self, request, *args, **kwargs):
        """
        Retrieve recipe and track view
        """
        instance = self.get_object()

        # Track recipe view
        if request.user.is_authenticated:
            RecipeView.objects.create(
                recipe=instance,
                user=request.user,
                ip_address=self.get_client_ip(request),
                user_agent=request.META.get('HTTP_USER_AGENT', '')
            )
        else:
            RecipeView.objects.create(
                recipe=instance,
                ip_address=self.get_client_ip(request),
                user_agent=request.META.get('HTTP_USER_AGENT', '')
            )

        serializer = self.get_serializer(instance)
        return Response(serializer.data)

    def get_client_ip(self, request):
        """
        Get client IP address
        """
        x_forwarded_for = request.META.get('HTTP_X_FORWARDED_FOR')
        if x_forwarded_for:
            ip = x_forwarded_for.split(',')[0]
        else:
            ip = request.META.get('REMOTE_ADDR')
        return ip


class UserRecipesView(generics.ListAPIView):
    """
    List recipes by a specific user
    """
    serializer_class = RecipeListSerializer
    permission_classes = [permissions.AllowAny]

    def get_queryset(self):
        username = self.kwargs['username']
        user = get_object_or_404(User, username=username)

        # Show only published recipes for other users
        if self.request.user != user:
            return Recipe.objects.filter(
                author=user,
                is_published=True
            ).select_related('author', 'category', 'difficulty_level').prefetch_related('tags')

        # Show all recipes for recipe owner
        return Recipe.objects.filter(
            author=user
        ).select_related('author', 'category', 'difficulty_level').prefetch_related('tags')


class MyRecipesView(generics.ListAPIView):
    """
    List current user's recipes
    """
    serializer_class = RecipeListSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return Recipe.objects.filter(
            author=self.request.user
        ).select_related('author', 'category', 'difficulty_level').prefetch_related('tags')


class RecipeRatingView(APIView):
    """
    Rate a recipe
    """
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request, slug):
        """
        Create or update recipe rating
        """
        recipe = get_object_or_404(Recipe, slug=slug, is_published=True)

        # Prevent authors from rating their own recipes
        if recipe.author == request.user:
            return Response({
                'error': 'You cannot rate your own recipe.'
            }, status=status.HTTP_400_BAD_REQUEST)

        serializer = RecipeRatingCreateSerializer(
            data=request.data,
            context={'recipe': recipe, 'request': request}
        )
        serializer.is_valid(raise_exception=True)
        rating = serializer.save()

        return Response({
            'message': 'Recipe rated successfully.',
            'rating': RecipeRatingCreateSerializer(rating).data
        }, status=status.HTTP_201_CREATED)

    def delete(self, request, slug):
        """
        Delete recipe rating
        """
        recipe = get_object_or_404(Recipe, slug=slug)

        try:
            rating = recipe.ratings.get(user=request.user)
            rating.delete()
            return Response({
                'message': 'Rating deleted successfully.'
            }, status=status.HTTP_200_OK)
        except RecipeRating.DoesNotExist:
            return Response({
                'error': 'No rating found.'
            }, status=status.HTTP_404_NOT_FOUND)


class IngredientListCreateView(generics.ListCreateAPIView):
    """
    List ingredients or create new ingredient
    """
    queryset = Ingredient.objects.all()
    serializer_class = IngredientSerializer
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = ['name', 'description']
    ordering_fields = ['name', 'usage_count']
    ordering = ['name']

    def get_permissions(self):
        """
        Allow anyone to view ingredients, require auth to create
        """
        if self.request.method == 'POST':
            return [permissions.IsAuthenticated()]
        return [permissions.AllowAny()]


class IngredientDetailView(generics.RetrieveAPIView):
    """
    Retrieve ingredient details
    """
    queryset = Ingredient.objects.all()
    serializer_class = IngredientSerializer
    permission_classes = [permissions.AllowAny]
    lookup_field = 'slug'


@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def toggle_recipe_save(request, slug):
    """
    Save or unsave a recipe to/from wishlist
    """
    recipe = get_object_or_404(Recipe, slug=slug, is_published=True)

    from apps.social.models import Wishlist

    wishlist_item, created = Wishlist.objects.get_or_create(
        user=request.user,
        recipe=recipe
    )

    if created:
        # Recipe was saved
        recipe.save_count = F('save_count') + 1
        recipe.save(update_fields=['save_count'])
        message = 'Recipe saved to wishlist.'
        action = 'saved'
    else:
        # Recipe was unsaved
        wishlist_item.delete()
        recipe.save_count = F('save_count') - 1
        recipe.save(update_fields=['save_count'])
        message = 'Recipe removed from wishlist.'
        action = 'removed'

    return Response({
        'message': message,
        'action': action
    }, status=status.HTTP_200_OK)


@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def share_recipe(request, slug):
    """
    Track recipe sharing
    """
    recipe = get_object_or_404(Recipe, slug=slug, is_published=True)
    platform = request.data.get('platform', 'link')

    from apps.social.models import RecipeShare

    # Create share record
    RecipeShare.objects.create(
        recipe=recipe,
        user=request.user,
        platform=platform
    )

    # Update share count
    recipe.share_count = F('share_count') + 1
    recipe.save(update_fields=['share_count'])

    return Response({
        'message': 'Recipe share tracked successfully.'
    }, status=status.HTTP_200_OK)


class IsAuthorOrReadOnly(permissions.BasePermission):
    """
    Custom permission to only allow recipe authors to edit their recipes
    """

    def has_object_permission(self, request, view, obj):
        # Read permissions for any request
        if request.method in permissions.SAFE_METHODS:
            return True

        # Write permissions only for recipe author
        return obj.author == request.user
