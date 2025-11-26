from rest_framework import serializers
from django.contrib.auth import get_user_model

from .models import Follow, Wishlist, Collection, Comment

User = get_user_model()


class UserSerializer(serializers.ModelSerializer):
    """Serializer for user information in social features."""
    full_name = serializers.CharField(source='get_full_name', read_only=True)

    class Meta:
        model = User
        fields = ['id', 'username', 'email',
                  'first_name', 'last_name', 'full_name']
        read_only_fields = ['id', 'email']


class FollowSerializer(serializers.ModelSerializer):
    """Serializer for follow relationships."""
    follower = UserSerializer(read_only=True)
    following = UserSerializer(read_only=True)
    following_username = serializers.CharField(write_only=True)

    class Meta:
        model = Follow
        fields = ['id', 'follower', 'following',
                  'following_username', 'created_at']
        read_only_fields = ['id', 'created_at']

    def validate_following_username(self, value):
        """Validate that the user to follow exists."""
        try:
            user = User.objects.get(username=value)
        except User.DoesNotExist:
            raise serializers.ValidationError("User not found.")

        # Check if trying to follow self
        if user == self.context['request'].user:
            raise serializers.ValidationError("You cannot follow yourself.")

        # Check if already following
        if Follow.objects.filter(
            follower=self.context['request'].user,
            following=user
        ).exists():
            raise serializers.ValidationError("Already following this user.")

        return value

    def create(self, validated_data):
        following_username = validated_data.pop('following_username')
        following_user = User.objects.get(username=following_username)

        follow = Follow.objects.create(
            follower=validated_data['follower'],
            following=following_user
        )
        return follow


class WishlistSerializer(serializers.ModelSerializer):
    """Serializer for wishlist items."""
    recipe_title = serializers.CharField(source='recipe.title', read_only=True)
    recipe_slug = serializers.CharField(source='recipe.slug', read_only=True)

    class Meta:
        model = Wishlist
        fields = ['id', 'recipe', 'recipe_title', 'recipe_slug', 'created_at']
        read_only_fields = ['id', 'created_at']

    def validate_recipe(self, value):
        """Ensure recipe is not already in user's wishlist."""
        user = self.context['request'].user
        if Wishlist.objects.filter(user=user, recipe=value).exists():
            raise serializers.ValidationError("Recipe already in wishlist.")
        return value


class CollectionSerializer(serializers.ModelSerializer):
    """Serializer for recipe collections."""
    recipe_count = serializers.IntegerField(
        source='recipes.count', read_only=True)
    recipes = serializers.PrimaryKeyRelatedField(
        many=True,
        read_only=True
    )

    class Meta:
        model = Collection
        fields = [
            'id', 'name', 'description', 'is_public',
            'recipes', 'recipe_count', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'created_at', 'updated_at']

    def validate_name(self, value):
        """Ensure collection name is unique for the user."""
        user = self.context['request'].user
        if self.instance:
            # Update case - exclude current instance
            if Collection.objects.filter(
                user=user, name=value
            ).exclude(id=self.instance.id).exists():
                raise serializers.ValidationError(
                    "You already have a collection with this name."
                )
        else:
            # Create case
            if Collection.objects.filter(user=user, name=value).exists():
                raise serializers.ValidationError(
                    "You already have a collection with this name."
                )
        return value


class CommentSerializer(serializers.ModelSerializer):
    """Serializer for recipe comments."""
    user = UserSerializer(read_only=True)
    username = serializers.CharField(source='user.username', read_only=True)

    class Meta:
        model = Comment
        fields = [
            'id', 'user', 'username', 'recipe', 'content',
            'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'recipe', 'created_at', 'updated_at']

    def validate(self, data):
        """Ensure user hasn't already commented on this recipe."""
        user = self.context['request'].user
        recipe = self.context.get('recipe')  # Set in view

        if recipe and self.instance is None:  # Only for creation
            if Comment.objects.filter(user=user, recipe=recipe).exists():
                raise serializers.ValidationError(
                    "You have already commented on this recipe."
                )
        return data


class ActivitySerializer(serializers.Serializer):
    """Serializer for user activity feed."""
    activity_type = serializers.CharField()
    message = serializers.CharField()
    timestamp = serializers.DateTimeField()
    user = UserSerializer(read_only=True)
    recipe = serializers.SerializerMethodField()

    def get_recipe(self, obj):
        """Get recipe information if activity is recipe-related."""
        if hasattr(obj, 'recipe') and obj.recipe:
            return {
                'id': obj.recipe.id,
                'title': obj.recipe.title,
                'slug': obj.recipe.slug
            }
        return None
