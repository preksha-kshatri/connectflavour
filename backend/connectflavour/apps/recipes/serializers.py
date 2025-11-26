from rest_framework import serializers
from django.contrib.auth import get_user_model
from .models import (
    Recipe,
    RecipeIngredient,
    Ingredient,
    RecipeProcedure,
    RecipeRating,
    RecipeView
)
from apps.categories.models import Category, Tag, DifficultyLevel
from apps.accounts.serializers import UserSearchSerializer

User = get_user_model()


class IngredientSerializer(serializers.ModelSerializer):
    """
    Serializer for ingredients
    """
    class Meta:
        model = Ingredient
        fields = '__all__'
        read_only_fields = ('id', 'slug', 'usage_count',
                            'created_at', 'updated_at')


class RecipeIngredientSerializer(serializers.ModelSerializer):
    """
    Serializer for recipe ingredients with details
    """
    ingredient = IngredientSerializer(read_only=True)
    ingredient_id = serializers.IntegerField(write_only=True)

    class Meta:
        model = RecipeIngredient
        fields = (
            'id', 'ingredient', 'ingredient_id', 'quantity', 'unit',
            'preparation_note', 'is_optional', 'display_order'
        )


class RecipeProcedureSerializer(serializers.ModelSerializer):
    """
    Serializer for recipe procedures/steps
    """
    class Meta:
        model = RecipeProcedure
        fields = (
            'id', 'step_number', 'instruction', 'image', 'estimated_time'
        )


class RecipeRatingSerializer(serializers.ModelSerializer):
    """
    Serializer for recipe ratings
    """
    user = UserSearchSerializer(read_only=True)

    class Meta:
        model = RecipeRating
        fields = (
            'id', 'user', 'rating', 'review', 'created_at'
        )
        read_only_fields = ('id', 'user', 'created_at')


class RecipeListSerializer(serializers.ModelSerializer):
    """
    Serializer for recipe list view (minimal data)
    """
    author = UserSearchSerializer(read_only=True)
    category_name = serializers.CharField(
        source='category.name', read_only=True)
    difficulty_name = serializers.CharField(
        source='difficulty_level.name', read_only=True)
    tags = serializers.StringRelatedField(many=True, read_only=True)
    is_saved = serializers.SerializerMethodField()

    class Meta:
        model = Recipe
        fields = (
            'id', 'title', 'slug', 'description', 'author', 'category_name',
            'difficulty_name', 'prep_time', 'cook_time', 'total_time',
            'servings', 'featured_image', 'calories_per_serving',
            'view_count', 'save_count', 'average_rating', 'rating_count',
            'tags', 'is_saved', 'created_at'
        )

    def get_is_saved(self, obj):
        """
        Check if current user has saved this recipe
        """
        request = self.context.get('request')
        if request and request.user.is_authenticated:
            return obj.wishlisted_by.filter(user=request.user).exists()
        return False


class RecipeDetailSerializer(serializers.ModelSerializer):
    """
    Detailed serializer for recipe view
    """
    author = UserSearchSerializer(read_only=True)
    category = serializers.StringRelatedField(read_only=True)
    difficulty_level = serializers.StringRelatedField(read_only=True)
    tags = serializers.StringRelatedField(many=True, read_only=True)
    recipe_ingredients = RecipeIngredientSerializer(many=True, read_only=True)
    procedures = RecipeProcedureSerializer(many=True, read_only=True)
    ratings = RecipeRatingSerializer(many=True, read_only=True)
    is_saved = serializers.SerializerMethodField()
    user_rating = serializers.SerializerMethodField()

    class Meta:
        model = Recipe
        fields = (
            'id', 'title', 'slug', 'description', 'author', 'category',
            'difficulty_level', 'tags', 'prep_time', 'cook_time', 'total_time',
            'servings', 'featured_image', 'video_url', 'calories_per_serving',
            'is_published', 'is_featured', 'view_count', 'save_count',
            'share_count', 'rating_count', 'average_rating', 'popularity_score',
            'recipe_ingredients', 'procedures', 'ratings', 'is_saved',
            'user_rating', 'created_at', 'updated_at'
        )

    def get_is_saved(self, obj):
        """
        Check if current user has saved this recipe
        """
        request = self.context.get('request')
        if request and request.user.is_authenticated:
            return obj.wishlisted_by.filter(user=request.user).exists()
        return False

    def get_user_rating(self, obj):
        """
        Get current user's rating for this recipe
        """
        request = self.context.get('request')
        if request and request.user.is_authenticated:
            try:
                rating = obj.ratings.get(user=request.user)
                return RecipeRatingSerializer(rating).data
            except RecipeRating.DoesNotExist:
                return None
        return None


class RecipeCreateUpdateSerializer(serializers.ModelSerializer):
    """
    Serializer for recipe creation and updates
    """
    ingredients = RecipeIngredientSerializer(many=True, write_only=True)
    procedures = RecipeProcedureSerializer(many=True, write_only=True)
    tag_ids = serializers.ListField(
        child=serializers.IntegerField(),
        write_only=True,
        required=False
    )

    class Meta:
        model = Recipe
        fields = (
            'title', 'description', 'category', 'difficulty_level',
            'prep_time', 'cook_time', 'servings', 'featured_image',
            'video_url', 'calories_per_serving', 'is_published',
            'ingredients', 'procedures', 'tag_ids'
        )

    def validate(self, attrs):
        """
        Validate recipe data
        """
        ingredients = attrs.get('ingredients', [])
        procedures = attrs.get('procedures', [])

        if not ingredients:
            raise serializers.ValidationError({
                'ingredients': 'At least one ingredient is required.'
            })

        if not procedures:
            raise serializers.ValidationError({
                'procedures': 'At least one cooking step is required.'
            })

        # Validate step numbers are sequential
        step_numbers = [proc['step_number'] for proc in procedures]
        expected_steps = list(range(1, len(procedures) + 1))
        if sorted(step_numbers) != expected_steps:
            raise serializers.ValidationError({
                'procedures': 'Step numbers must be sequential starting from 1.'
            })

        return attrs

    def create(self, validated_data):
        """
        Create recipe with ingredients and procedures
        """
        ingredients_data = validated_data.pop('ingredients', [])
        procedures_data = validated_data.pop('procedures', [])
        tag_ids = validated_data.pop('tag_ids', [])

        # Set author to current user
        validated_data['author'] = self.context['request'].user

        # Create recipe
        recipe = Recipe.objects.create(**validated_data)

        # Add tags
        if tag_ids:
            recipe.tags.set(tag_ids)

        # Create ingredients
        for ingredient_data in ingredients_data:
            ingredient_id = ingredient_data.pop('ingredient_id')
            ingredient = Ingredient.objects.get(id=ingredient_id)
            RecipeIngredient.objects.create(
                recipe=recipe,
                ingredient=ingredient,
                **ingredient_data
            )

        # Create procedures
        for procedure_data in procedures_data:
            RecipeProcedure.objects.create(
                recipe=recipe,
                **procedure_data
            )

        return recipe

    def update(self, instance, validated_data):
        """
        Update recipe with ingredients and procedures
        """
        ingredients_data = validated_data.pop('ingredients', None)
        procedures_data = validated_data.pop('procedures', None)
        tag_ids = validated_data.pop('tag_ids', None)

        # Update recipe fields
        for attr, value in validated_data.items():
            setattr(instance, attr, value)
        instance.save()

        # Update tags
        if tag_ids is not None:
            instance.tags.set(tag_ids)

        # Update ingredients
        if ingredients_data is not None:
            # Delete existing ingredients
            instance.recipe_ingredients.all().delete()

            # Create new ingredients
            for ingredient_data in ingredients_data:
                ingredient_id = ingredient_data.pop('ingredient_id')
                ingredient = Ingredient.objects.get(id=ingredient_id)
                RecipeIngredient.objects.create(
                    recipe=instance,
                    ingredient=ingredient,
                    **ingredient_data
                )

        # Update procedures
        if procedures_data is not None:
            # Delete existing procedures
            instance.procedures.all().delete()

            # Create new procedures
            for procedure_data in procedures_data:
                RecipeProcedure.objects.create(
                    recipe=instance,
                    **procedure_data
                )

        return instance


class RecipeRatingCreateSerializer(serializers.ModelSerializer):
    """
    Serializer for creating recipe ratings
    """
    class Meta:
        model = RecipeRating
        fields = ('rating', 'review')

    def create(self, validated_data):
        """
        Create or update recipe rating
        """
        recipe = self.context['recipe']
        user = self.context['request'].user

        # Update existing rating or create new one
        rating, created = RecipeRating.objects.update_or_create(
            recipe=recipe,
            user=user,
            defaults=validated_data
        )

        return rating
