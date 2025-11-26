from django.urls import path
from .views import (
    CategoryListView,
    CategoryDetailView,
    TagListView,
    DifficultyLevelListView
)

urlpatterns = [
    # Categories
    path('categories/', CategoryListView.as_view(), name='category-list'),
    path('categories/<slug:slug>/',
         CategoryDetailView.as_view(), name='category-detail'),

    # Tags
    path('tags/', TagListView.as_view(), name='tag-list'),

    # Difficulty levels
    path('difficulty-levels/', DifficultyLevelListView.as_view(),
         name='difficulty-level-list'),
]
