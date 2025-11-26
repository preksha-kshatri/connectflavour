from django.db.models.signals import post_save, post_delete, m2m_changed
from django.dispatch import receiver
from django.contrib.auth import get_user_model
from .models import Recipe, RecipeRating, RecipeView, RecipeIngredient

User = get_user_model()


@receiver(post_save, sender=RecipeRating)
def update_recipe_rating(sender, instance, created, **kwargs):
    """
    Update recipe average rating when a new rating is added
    """
    recipe = instance.recipe
    ratings = recipe.ratings.all()
    if ratings:
        total_rating = sum(rating.rating for rating in ratings)
        recipe.average_rating = total_rating / ratings.count()
        recipe.rating_count = ratings.count()
        recipe.save(update_fields=['average_rating', 'rating_count'])


@receiver(post_delete, sender=RecipeRating)
def update_recipe_rating_on_delete(sender, instance, **kwargs):
    """
    Update recipe average rating when a rating is deleted
    """
    recipe = instance.recipe
    ratings = recipe.ratings.all()
    if ratings:
        total_rating = sum(rating.rating for rating in ratings)
        recipe.average_rating = total_rating / ratings.count()
        recipe.rating_count = ratings.count()
    else:
        recipe.average_rating = 0.00
        recipe.rating_count = 0
    recipe.save(update_fields=['average_rating', 'rating_count'])


@receiver(post_save, sender=RecipeView)
def update_recipe_view_count(sender, instance, created, **kwargs):
    """
    Update recipe view count when a new view is recorded
    """
    if created:
        recipe = instance.recipe
        recipe.view_count = recipe.views.count()
        recipe.save(update_fields=['view_count'])


@receiver(post_save, sender=Recipe)
def update_author_recipes_count(sender, instance, created, **kwargs):
    """
    Update user's recipe count when recipe is created/updated
    """
    if created:
        author = instance.author
        author.recipes_count = author.recipes.filter(is_published=True).count()
        author.save(update_fields=['recipes_count'])


@receiver(post_delete, sender=Recipe)
def update_author_recipes_count_on_delete(sender, instance, **kwargs):
    """
    Update user's recipe count when recipe is deleted
    """
    author = instance.author
    author.recipes_count = author.recipes.filter(is_published=True).count()
    author.save(update_fields=['recipes_count'])
