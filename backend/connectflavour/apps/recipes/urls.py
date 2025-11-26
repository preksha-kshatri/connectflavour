from django.urls import path
from .views import (
    RecipeListCreateView,
    RecipeDetailView,
    UserRecipesView,
    MyRecipesView,
    RecipeRatingView,
    IngredientListCreateView,
    IngredientDetailView,
    toggle_recipe_save,
    share_recipe
)

urlpatterns = [
    # Recipe CRUD
    path('', RecipeListCreateView.as_view(), name='recipe-list-create'),
    path('<slug:slug>/', RecipeDetailView.as_view(), name='recipe-detail'),

    # Recipe interactions
    path('<slug:slug>/rate/', RecipeRatingView.as_view(), name='recipe-rate'),
    path('<slug:slug>/save/', toggle_recipe_save, name='recipe-save'),
    path('<slug:slug>/share/', share_recipe, name='recipe-share'),

    # User recipes
    path('user/<str:username>/', UserRecipesView.as_view(), name='user-recipes'),
    path('my/recipes/', MyRecipesView.as_view(), name='my-recipes'),

    # Ingredients
    path('ingredients/', IngredientListCreateView.as_view(),
         name='ingredient-list-create'),
    path('ingredients/<slug:slug>/',
         IngredientDetailView.as_view(), name='ingredient-detail'),
]
