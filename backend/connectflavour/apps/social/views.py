from rest_framework import generics, status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from django.contrib.auth import get_user_model
from django.shortcuts import get_object_or_404

from .models import Follow, Wishlist, Collection, Comment
from .serializers import (
    FollowSerializer, WishlistSerializer, CollectionSerializer,
    CommentSerializer, UserSerializer
)

User = get_user_model()


class FollowView(generics.ListCreateAPIView):
    """List and create user follows."""
    serializer_class = FollowSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return Follow.objects.filter(follower=self.request.user)

    def perform_create(self, serializer):
        serializer.save(follower=self.request.user)


@api_view(['POST', 'DELETE'])
@permission_classes([IsAuthenticated])
def toggle_follow(request, username):
    """Follow or unfollow a user."""
    target_user = get_object_or_404(User, username=username)

    if target_user == request.user:
        return Response(
            {'error': 'You cannot follow yourself'},
            status=status.HTTP_400_BAD_REQUEST
        )

    follow, created = Follow.objects.get_or_create(
        follower=request.user,
        following=target_user
    )

    if request.method == 'POST':
        if created:
            return Response({'message': 'Now following user'}, status=status.HTTP_201_CREATED)
        return Response({'message': 'Already following user'}, status=status.HTTP_200_OK)

    elif request.method == 'DELETE':
        if follow:
            follow.delete()
            return Response({'message': 'Unfollowed user'}, status=status.HTTP_200_OK)
        return Response({'message': 'Not following user'}, status=status.HTTP_400_BAD_REQUEST)


class WishlistView(generics.ListCreateAPIView):
    """List and manage user wishlist."""
    serializer_class = WishlistSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return Wishlist.objects.filter(user=self.request.user)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)


@api_view(['POST', 'DELETE'])
@permission_classes([IsAuthenticated])
def toggle_wishlist(request, recipe_id):
    """Add or remove recipe from wishlist."""
    from apps.recipes.models import Recipe

    recipe = get_object_or_404(Recipe, id=recipe_id)
    wishlist_item, created = Wishlist.objects.get_or_create(
        user=request.user,
        recipe=recipe
    )

    if request.method == 'POST':
        if created:
            return Response({'message': 'Added to wishlist'}, status=status.HTTP_201_CREATED)
        return Response({'message': 'Already in wishlist'}, status=status.HTTP_200_OK)

    elif request.method == 'DELETE':
        if wishlist_item:
            wishlist_item.delete()
            return Response({'message': 'Removed from wishlist'}, status=status.HTTP_200_OK)
        return Response({'message': 'Not in wishlist'}, status=status.HTTP_400_BAD_REQUEST)


class CollectionListView(generics.ListCreateAPIView):
    """List and create user collections."""
    serializer_class = CollectionSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return Collection.objects.filter(user=self.request.user)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)


class CollectionDetailView(generics.RetrieveUpdateDestroyAPIView):
    """Retrieve, update, or delete a collection."""
    serializer_class = CollectionSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return Collection.objects.filter(user=self.request.user)


class CommentListView(generics.ListCreateAPIView):
    """List and create recipe comments."""
    serializer_class = CommentSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        recipe_id = self.kwargs.get('recipe_id')
        return Comment.objects.filter(recipe_id=recipe_id)

    def perform_create(self, serializer):
        recipe_id = self.kwargs.get('recipe_id')
        from apps.recipes.models import Recipe
        recipe = get_object_or_404(Recipe, id=recipe_id)
        serializer.save(user=self.request.user, recipe=recipe)


class UserFollowersView(generics.ListAPIView):
    """List user's followers."""
    serializer_class = UserSerializer

    def get_queryset(self):
        username = self.kwargs.get('username')
        user = get_object_or_404(User, username=username)
        followers = Follow.objects.filter(
            following=user).values_list('follower', flat=True)
        return User.objects.filter(id__in=followers)


class UserFollowingView(generics.ListAPIView):
    """List users that a user is following."""
    serializer_class = UserSerializer

    def get_queryset(self):
        username = self.kwargs.get('username')
        user = get_object_or_404(User, username=username)
        following = Follow.objects.filter(
            follower=user).values_list('following', flat=True)
        return User.objects.filter(id__in=following)
