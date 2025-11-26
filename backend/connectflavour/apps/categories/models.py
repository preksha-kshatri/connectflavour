from django.db import models
from django.utils.text import slugify
from apps.core.models import BaseModel


class Category(BaseModel):
    """
    Recipe category model based on project requirements
    """
    name = models.CharField(
        max_length=100,
        unique=True,
        help_text='Category name (e.g., Appetizers, Main Courses)'
    )
    slug = models.SlugField(
        max_length=100,
        unique=True,
        blank=True,
        help_text='URL-friendly version of the name'
    )
    description = models.TextField(
        max_length=500,
        blank=True,
        help_text='Category description'
    )
    image = models.ImageField(
        upload_to='categories/',
        null=True,
        blank=True,
        help_text='Category image for display'
    )

    # Display and sorting
    display_order = models.PositiveIntegerField(
        default=0,
        help_text='Order for category display (0 = first)'
    )
    is_featured = models.BooleanField(
        default=False,
        help_text='Whether to feature this category prominently'
    )

    # Recipe count (denormalized for performance)
    recipes_count = models.PositiveIntegerField(
        default=0,
        help_text='Number of recipes in this category'
    )

    # SEO fields
    meta_title = models.CharField(max_length=150, blank=True)
    meta_description = models.TextField(max_length=300, blank=True)

    class Meta:
        db_table = 'categories_category'
        verbose_name = 'Category'
        verbose_name_plural = 'Categories'
        ordering = ['display_order', 'name']

    def save(self, *args, **kwargs):
        if not self.slug:
            self.slug = slugify(self.name)
        super().save(*args, **kwargs)

    def __str__(self):
        return self.name


class Tag(BaseModel):
    """
    Recipe tags for more granular categorization
    """
    name = models.CharField(
        max_length=50,
        unique=True,
        help_text='Tag name (e.g., healthy, quick, vegetarian)'
    )
    slug = models.SlugField(
        max_length=50,
        unique=True,
        blank=True
    )
    color = models.CharField(
        max_length=7,
        default='#007bff',
        help_text='Hex color code for tag display'
    )

    # Usage statistics
    usage_count = models.PositiveIntegerField(
        default=0,
        help_text='Number of times this tag has been used'
    )

    class Meta:
        db_table = 'categories_tag'
        verbose_name = 'Tag'
        verbose_name_plural = 'Tags'
        ordering = ['name']

    def save(self, *args, **kwargs):
        if not self.slug:
            self.slug = slugify(self.name)
        super().save(*args, **kwargs)

    def __str__(self):
        return self.name


class DifficultyLevel(BaseModel):
    """
    Difficulty levels for recipes
    """
    DIFFICULTY_CHOICES = [
        ('easy', 'Easy'),
        ('medium', 'Medium'),
        ('hard', 'Hard'),
        ('expert', 'Expert'),
    ]

    name = models.CharField(
        max_length=20,
        choices=DIFFICULTY_CHOICES,
        unique=True,
        help_text='Difficulty level name'
    )
    description = models.TextField(
        max_length=200,
        blank=True,
        help_text='Description of what this difficulty level means'
    )
    display_order = models.PositiveIntegerField(
        default=0,
        help_text='Order for difficulty display (0 = easiest)'
    )
    icon = models.CharField(
        max_length=50,
        blank=True,
        help_text='Icon class or emoji for display'
    )

    class Meta:
        db_table = 'categories_difficulty_level'
        verbose_name = 'Difficulty Level'
        verbose_name_plural = 'Difficulty Levels'
        ordering = ['display_order']

    def __str__(self):
        return self.get_name_display()
