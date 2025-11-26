from django.urls import path
from .views import (
    FollowView,
    toggle_follow,
    UserFollowersView,
    UserFollowingView,
    WishlistView,
    toggle_wishlist,
    CollectionListView,
    CollectionDetailView,
    CommentListView
)

urlpatterns = [
    # Following system
    path('follows/', FollowView.as_view(), name='follow-list'),
    path('follow/<str:username>/', toggle_follow, name='toggle-follow'),
    path('users/<str:username>/followers/',
         UserFollowersView.as_view(), name='user-followers'),
    path('users/<str:username>/following/',
         UserFollowingView.as_view(), name='user-following'),

    # Wishlist
    path('wishlist/', WishlistView.as_view(), name='wishlist'),
    path('wishlist/<int:recipe_id>/', toggle_wishlist, name='toggle-wishlist'),

    # Collections
    path('collections/', CollectionListView.as_view(), name='collection-list'),
    path('collections/<int:pk>/', CollectionDetailView.as_view(),
         name='collection-detail'),

    # Comments
    path('recipes/<int:recipe_id>/comments/',
         CommentListView.as_view(), name='recipe-comments'),
]
