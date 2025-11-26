from django.db import models
from django.contrib.auth import get_user_model
from apps.core.models import BaseModel

User = get_user_model()


class Follow(BaseModel):
    """
    User following system
    """
    follower = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='following',
        help_text='User who is following'
    )
    followed = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='followers',
        help_text='User being followed'
    )

    class Meta:
        db_table = 'social_follow'
        verbose_name = 'Follow'
        verbose_name_plural = 'Follows'
        unique_together = ['follower', 'followed']
        ordering = ['-created_at']

    def __str__(self):
        return f"{self.follower.username} follows {self.followed.username}"


class Wishlist(BaseModel):
    """
    User recipe wishlist/favorites system
    """
    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='wishlist_items'
    )
    recipe = models.ForeignKey(
        'recipes.Recipe',
        on_delete=models.CASCADE,
        related_name='wishlisted_by'
    )

    # Optional categorization
    collection_name = models.CharField(
        max_length=100,
        blank=True,
        help_text='Optional collection name (e.g., "Weekend Cooking", "Quick Meals")'
    )

    # Personal notes
    notes = models.TextField(
        max_length=500,
        blank=True,
        help_text='Personal notes about this recipe'
    )

    class Meta:
        db_table = 'social_wishlist'
        verbose_name = 'Wishlist Item'
        verbose_name_plural = 'Wishlist Items'
        unique_together = ['user', 'recipe']
        ordering = ['-created_at']

    def __str__(self):
        return f"{self.user.username} saved {self.recipe.title}"


class RecipeShare(BaseModel):
    """
    Track recipe sharing for analytics and popularity
    """
    SHARE_PLATFORMS = [
        ('whatsapp', 'WhatsApp'),
        ('facebook', 'Facebook'),
        ('twitter', 'Twitter'),
        ('instagram', 'Instagram'),
        ('email', 'Email'),
        ('link', 'Copy Link'),
        ('other', 'Other'),
    ]

    recipe = models.ForeignKey(
        'recipes.Recipe',
        on_delete=models.CASCADE,
        related_name='shares'
    )
    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='recipe_shares'
    )
    platform = models.CharField(
        max_length=20,
        choices=SHARE_PLATFORMS,
        help_text='Platform where recipe was shared'
    )

    class Meta:
        db_table = 'social_recipe_share'
        verbose_name = 'Recipe Share'
        verbose_name_plural = 'Recipe Shares'
        ordering = ['-created_at']

    def __str__(self):
        return f"{self.user.username} shared {self.recipe.title} on {self.platform}"


class UserActivity(BaseModel):
    """
    Track user activity for analytics and recommendations
    """
    ACTIVITY_TYPES = [
        ('recipe_created', 'Recipe Created'),
        ('recipe_viewed', 'Recipe Viewed'),
        ('recipe_rated', 'Recipe Rated'),
        ('recipe_saved', 'Recipe Saved'),
        ('recipe_shared', 'Recipe Shared'),
        ('user_followed', 'User Followed'),
        ('profile_updated', 'Profile Updated'),
    ]

    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='activities'
    )
    activity_type = models.CharField(
        max_length=30,
        choices=ACTIVITY_TYPES
    )

    # Related objects (using generic foreign keys for flexibility)
    object_id = models.PositiveIntegerField(null=True, blank=True)

    # Additional context data
    metadata = models.JSONField(
        default=dict,
        blank=True,
        help_text='Additional activity metadata'
    )

    class Meta:
        db_table = 'social_user_activity'
        verbose_name = 'User Activity'
        verbose_name_plural = 'User Activities'
        ordering = ['-created_at']
        indexes = [
            models.Index(fields=['user', '-created_at']),
            models.Index(fields=['activity_type', '-created_at']),
        ]

    def __str__(self):
        return f"{self.user.username} - {self.get_activity_type_display()}"


class Collection(BaseModel):
    """
    User-created recipe collections
    """
    name = models.CharField(
        max_length=100,
        help_text='Collection name'
    )
    description = models.TextField(
        max_length=500,
        blank=True,
        help_text='Collection description'
    )
    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='collections'
    )

    # Collection settings
    is_public = models.BooleanField(
        default=True,
        help_text='Whether collection is visible to other users'
    )

    # Collection image
    cover_image = models.ImageField(
        upload_to='collections/',
        null=True,
        blank=True,
        help_text='Collection cover image'
    )

    # Statistics
    recipes_count = models.PositiveIntegerField(default=0)
    followers_count = models.PositiveIntegerField(default=0)

    class Meta:
        db_table = 'social_collection'
        verbose_name = 'Collection'
        verbose_name_plural = 'Collections'
        ordering = ['-created_at']
        unique_together = ['user', 'name']

    def __str__(self):
        return f"{self.user.username}'s {self.name} collection"


class CollectionRecipe(BaseModel):
    """
    Recipes in a collection
    """
    collection = models.ForeignKey(
        Collection,
        on_delete=models.CASCADE,
        related_name='collection_recipes'
    )
    recipe = models.ForeignKey(
        'recipes.Recipe',
        on_delete=models.CASCADE,
        related_name='in_collections'
    )

    # Optional personal notes
    notes = models.TextField(
        max_length=300,
        blank=True,
        help_text='Personal notes about this recipe in the collection'
    )

    # Display order in collection
    display_order = models.PositiveIntegerField(default=0)

    class Meta:
        db_table = 'social_collection_recipe'
        verbose_name = 'Collection Recipe'
        verbose_name_plural = 'Collection Recipes'
        ordering = ['display_order', '-created_at']
        unique_together = ['collection', 'recipe']

    def __str__(self):
        return f"{self.recipe.title} in {self.collection.name}"


class Comment(BaseModel):
    """
    Comments on recipes
    """
    recipe = models.ForeignKey(
        'recipes.Recipe',
        on_delete=models.CASCADE,
        related_name='comments'
    )
    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='recipe_comments'
    )
    content = models.TextField(
        max_length=1000,
        help_text='Comment content'
    )

    # Comment threading
    parent = models.ForeignKey(
        'self',
        on_delete=models.CASCADE,
        null=True,
        blank=True,
        related_name='replies'
    )

    # Comment status
    is_approved = models.BooleanField(
        default=True,
        help_text='Whether comment is approved and visible'
    )

    class Meta:
        db_table = 'social_comment'
        verbose_name = 'Comment'
        verbose_name_plural = 'Comments'
        ordering = ['-created_at']
        indexes = [
            models.Index(fields=['recipe', '-created_at']),
            models.Index(fields=['user', '-created_at']),
        ]

    def __str__(self):
        return f"Comment by {self.user.username} on {self.recipe.title}"
