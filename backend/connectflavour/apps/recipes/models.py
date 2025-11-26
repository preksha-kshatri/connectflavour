from django.db import models
from django.contrib.auth import get_user_model
from django.core.validators import MinValueValidator, MaxValueValidator
from django.utils.text import slugify
from apps.core.models import BaseModel

User = get_user_model()


class Recipe(BaseModel):
    """
    Main Recipe model based on ER diagram
    """
    # Core recipe information
    title = models.CharField(
        max_length=200,
        help_text='Recipe title/name'
    )
    slug = models.SlugField(
        max_length=200,
        unique=True,
        blank=True,
        help_text='URL-friendly version of title'
    )
    description = models.TextField(
        max_length=1000,
        help_text='Recipe description and overview'
    )

    # Recipe metadata
    author = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='recipes',
        help_text='Recipe creator'
    )
    category = models.ForeignKey(
        'categories.Category',
        on_delete=models.SET_NULL,
        null=True,
        related_name='recipes',
        help_text='Primary recipe category'
    )
    difficulty_level = models.ForeignKey(
        'categories.DifficultyLevel',
        on_delete=models.SET_NULL,
        null=True,
        related_name='recipes',
        help_text='Recipe difficulty'
    )
    tags = models.ManyToManyField(
        'categories.Tag',
        blank=True,
        related_name='recipes',
        help_text='Recipe tags'
    )

    # Time and serving information
    prep_time = models.PositiveIntegerField(
        help_text='Preparation time in minutes'
    )
    cook_time = models.PositiveIntegerField(
        help_text='Cooking time in minutes'
    )
    total_time = models.PositiveIntegerField(
        blank=True,
        null=True,
        help_text='Total time (prep + cook) in minutes'
    )
    servings = models.PositiveIntegerField(
        validators=[MinValueValidator(1), MaxValueValidator(100)],
        help_text='Number of servings this recipe makes'
    )

    # Recipe media
    featured_image = models.ImageField(
        upload_to='recipes/images/',
        null=True,
        blank=True,
        help_text='Main recipe image'
    )
    video_url = models.URLField(
        blank=True,
        null=True,
        help_text='Optional recipe video URL'
    )

    # Nutritional information (optional)
    calories_per_serving = models.PositiveIntegerField(
        null=True,
        blank=True,
        help_text='Calories per serving'
    )

    # Recipe status and visibility
    is_published = models.BooleanField(
        default=True,
        help_text='Whether recipe is published and visible'
    )
    is_featured = models.BooleanField(
        default=False,
        help_text='Whether recipe should be featured'
    )

    # Engagement metrics (denormalized for performance)
    view_count = models.PositiveIntegerField(default=0)
    save_count = models.PositiveIntegerField(default=0)
    share_count = models.PositiveIntegerField(default=0)
    rating_count = models.PositiveIntegerField(default=0)
    average_rating = models.DecimalField(
        max_digits=3,
        decimal_places=2,
        default=0.00,
        validators=[MinValueValidator(0), MaxValueValidator(5)]
    )

    # Popularity score for recommendations
    popularity_score = models.FloatField(
        default=0.0,
        help_text='Calculated popularity score for recommendations'
    )

    class Meta:
        db_table = 'recipes_recipe'
        verbose_name = 'Recipe'
        verbose_name_plural = 'Recipes'
        ordering = ['-created_at']
        indexes = [
            models.Index(fields=['is_published', '-popularity_score']),
            models.Index(fields=['category', '-created_at']),
            models.Index(fields=['author', '-created_at']),
        ]

    def save(self, *args, **kwargs):
        if not self.slug:
            self.slug = slugify(self.title)

        # Calculate total time if not provided
        if not self.total_time:
            self.total_time = self.prep_time + self.cook_time

        super().save(*args, **kwargs)

    def __str__(self):
        return self.title

    @property
    def total_time_display(self):
        """Return formatted total time"""
        hours, minutes = divmod(self.total_time, 60)
        if hours:
            return f"{hours}h {minutes}m"
        return f"{minutes}m"


class RecipeIngredient(BaseModel):
    """
    Ingredients for a recipe with quantities
    """
    recipe = models.ForeignKey(
        Recipe,
        on_delete=models.CASCADE,
        related_name='recipe_ingredients'
    )
    ingredient = models.ForeignKey(
        'Ingredient',
        on_delete=models.CASCADE,
        related_name='recipe_uses'
    )

    # Quantity information
    quantity = models.DecimalField(
        max_digits=10,
        decimal_places=2,
        help_text='Amount of ingredient needed'
    )
    unit = models.CharField(
        max_length=50,
        help_text='Unit of measurement (cups, tbsp, etc.)'
    )

    # Additional details
    preparation_note = models.CharField(
        max_length=100,
        blank=True,
        help_text='How to prepare ingredient (chopped, minced, etc.)'
    )
    is_optional = models.BooleanField(
        default=False,
        help_text='Whether ingredient is optional'
    )
    display_order = models.PositiveIntegerField(
        default=0,
        help_text='Order to display ingredient in list'
    )

    class Meta:
        db_table = 'recipes_recipe_ingredient'
        verbose_name = 'Recipe Ingredient'
        verbose_name_plural = 'Recipe Ingredients'
        ordering = ['display_order']
        unique_together = ['recipe', 'ingredient']

    def __str__(self):
        return f"{self.quantity} {self.unit} {self.ingredient.name}"


class Ingredient(BaseModel):
    """
    Individual ingredients that can be used in recipes
    """
    name = models.CharField(
        max_length=100,
        unique=True,
        help_text='Ingredient name'
    )
    slug = models.SlugField(
        max_length=100,
        unique=True,
        blank=True
    )
    description = models.TextField(
        max_length=500,
        blank=True,
        help_text='Ingredient description'
    )

    # Categorization
    category = models.CharField(
        max_length=50,
        choices=[
            ('vegetable', 'Vegetable'),
            ('fruit', 'Fruit'),
            ('meat', 'Meat'),
            ('dairy', 'Dairy'),
            ('grain', 'Grain'),
            ('spice', 'Spice'),
            ('herb', 'Herb'),
            ('oil', 'Oil'),
            ('other', 'Other'),
        ],
        default='other',
        help_text='Ingredient category'
    )

    # Nutritional information (optional)
    calories_per_100g = models.PositiveIntegerField(
        null=True,
        blank=True,
        help_text='Calories per 100 grams'
    )

    # Usage statistics
    usage_count = models.PositiveIntegerField(
        default=0,
        help_text='Number of recipes using this ingredient'
    )

    class Meta:
        db_table = 'recipes_ingredient'
        verbose_name = 'Ingredient'
        verbose_name_plural = 'Ingredients'
        ordering = ['name']

    def save(self, *args, **kwargs):
        if not self.slug:
            self.slug = slugify(self.name)
        super().save(*args, **kwargs)

    def __str__(self):
        return self.name


class RecipeProcedure(BaseModel):
    """
    Recipe cooking steps/procedures based on ER diagram
    """
    recipe = models.ForeignKey(
        Recipe,
        on_delete=models.CASCADE,
        related_name='procedures'
    )
    step_number = models.PositiveIntegerField(
        help_text='Step number in the cooking process'
    )
    instruction = models.TextField(
        help_text='Detailed cooking instruction for this step'
    )

    # Optional step media
    image = models.ImageField(
        upload_to='recipes/steps/',
        null=True,
        blank=True,
        help_text='Optional image for this step'
    )

    # Timing information
    estimated_time = models.PositiveIntegerField(
        null=True,
        blank=True,
        help_text='Estimated time for this step in minutes'
    )

    class Meta:
        db_table = 'recipes_procedure'
        verbose_name = 'Recipe Procedure'
        verbose_name_plural = 'Recipe Procedures'
        ordering = ['recipe', 'step_number']
        unique_together = ['recipe', 'step_number']

    def __str__(self):
        return f"Step {self.step_number}: {self.recipe.title}"


class RecipeRating(BaseModel):
    """
    User ratings for recipes
    """
    recipe = models.ForeignKey(
        Recipe,
        on_delete=models.CASCADE,
        related_name='ratings'
    )
    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='recipe_ratings'
    )
    rating = models.PositiveIntegerField(
        validators=[MinValueValidator(1), MaxValueValidator(5)],
        help_text='Rating from 1 to 5 stars'
    )
    review = models.TextField(
        max_length=1000,
        blank=True,
        help_text='Optional written review'
    )

    class Meta:
        db_table = 'recipes_rating'
        verbose_name = 'Recipe Rating'
        verbose_name_plural = 'Recipe Ratings'
        ordering = ['-created_at']
        unique_together = ['recipe', 'user']

    def __str__(self):
        return f"{self.user.username} rated {self.recipe.title}: {self.rating}/5"


class RecipeView(models.Model):
    """
    Track recipe views for analytics and popularity
    """
    recipe = models.ForeignKey(
        Recipe,
        on_delete=models.CASCADE,
        related_name='views'
    )
    user = models.ForeignKey(
        User,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='recipe_views'
    )
    ip_address = models.GenericIPAddressField(null=True, blank=True)
    user_agent = models.TextField(blank=True)
    viewed_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'recipes_view'
        verbose_name = 'Recipe View'
        verbose_name_plural = 'Recipe Views'
        ordering = ['-viewed_at']
        indexes = [
            models.Index(fields=['recipe', '-viewed_at']),
            models.Index(fields=['user', '-viewed_at']),
        ]

    def __str__(self):
        user_info = self.user.username if self.user else f"Anonymous ({self.ip_address})"
        return f"{user_info} viewed {self.recipe.title}"
