from django.contrib import admin
from django.utils.html import format_html
from django.db.models import Count, Avg
from .models import (
    Recipe, RecipeIngredient, Ingredient, RecipeProcedure,
    RecipeRating, RecipeView
)


class RecipeIngredientInline(admin.TabularInline):
    model = RecipeIngredient
    extra = 1
    fields = ['ingredient', 'quantity', 'unit',
              'preparation_note', 'is_optional', 'display_order']
    raw_id_fields = ['ingredient']


class RecipeProcedureInline(admin.StackedInline):
    model = RecipeProcedure
    extra = 1
    fields = ['step_number', 'instruction', 'image', 'estimated_time']


@admin.register(Recipe)
class RecipeAdmin(admin.ModelAdmin):
    """
    Recipe Admin with comprehensive features
    """
    inlines = [RecipeIngredientInline, RecipeProcedureInline]

    list_display = [
        'title', 'author', 'category', 'difficulty_level',
        'average_rating', 'view_count', 'is_published', 'is_featured',
        'created_at'
    ]
    list_filter = [
        'is_published', 'is_featured', 'difficulty_level', 'category',
        'created_at', 'updated_at'
    ]
    search_fields = ['title', 'description',
                     'author__username', 'author__email']
    prepopulated_fields = {'slug': ('title',)}
    readonly_fields = [
        'view_count', 'save_count', 'share_count', 'rating_count',
        'average_rating', 'popularity_score', 'total_time', 'created_at', 'updated_at'
    ]
    raw_id_fields = ['author']
    filter_horizontal = ['tags']

    fieldsets = (
        ('Basic Information', {
            'fields': ('title', 'slug', 'description', 'author', 'category', 'difficulty_level')
        }),
        ('Time & Servings', {
            'fields': ('prep_time', 'cook_time', 'total_time', 'servings')
        }),
        ('Media', {
            'fields': ('featured_image', 'video_url')
        }),
        ('Tags', {
            'fields': ('tags',),
            'classes': ('collapse',)
        }),
        ('Nutrition', {
            'fields': ('calories_per_serving',),
            'classes': ('collapse',)
        }),
        ('Status', {
            'fields': ('is_published', 'is_featured')
        }),
        ('Statistics', {
            'fields': ('view_count', 'save_count', 'share_count', 'rating_count', 'average_rating', 'popularity_score'),
            'classes': ('collapse',)
        }),
        ('Timestamps', {
            'fields': ('created_at', 'updated_at'),
            'classes': ('collapse',)
        }),
    )

    actions = ['publish_recipes', 'unpublish_recipes',
               'feature_recipes', 'unfeature_recipes']

    def publish_recipes(self, request, queryset):
        updated = queryset.update(is_published=True)
        self.message_user(
            request, f'{updated} recipe(s) published successfully.')
    publish_recipes.short_description = 'Publish selected recipes'

    def unpublish_recipes(self, request, queryset):
        updated = queryset.update(is_published=False)
        self.message_user(
            request, f'{updated} recipe(s) unpublished successfully.')
    unpublish_recipes.short_description = 'Unpublish selected recipes'

    def feature_recipes(self, request, queryset):
        updated = queryset.update(is_featured=True)
        self.message_user(
            request, f'{updated} recipe(s) featured successfully.')
    feature_recipes.short_description = 'Feature selected recipes'

    def unfeature_recipes(self, request, queryset):
        updated = queryset.update(is_featured=False)
        self.message_user(
            request, f'{updated} recipe(s) unfeatured successfully.')
    unfeature_recipes.short_description = 'Unfeature selected recipes'


@admin.register(Ingredient)
class IngredientAdmin(admin.ModelAdmin):
    """
    Ingredient Admin
    """
    list_display = ['name', 'category', 'usage_count',
                    'calories_per_100g', 'created_at']
    list_filter = ['category', 'created_at']
    search_fields = ['name', 'description']
    prepopulated_fields = {'slug': ('name',)}
    readonly_fields = ['usage_count', 'created_at', 'updated_at']

    fieldsets = (
        ('Basic Information', {
            'fields': ('name', 'slug', 'description', 'category')
        }),
        ('Nutrition', {
            'fields': ('calories_per_100g',)
        }),
        ('Statistics', {
            'fields': ('usage_count',),
            'classes': ('collapse',)
        }),
        ('Timestamps', {
            'fields': ('created_at', 'updated_at'),
            'classes': ('collapse',)
        }),
    )


@admin.register(RecipeIngredient)
class RecipeIngredientAdmin(admin.ModelAdmin):
    """
    Recipe Ingredient Admin
    """
    list_display = ['recipe', 'ingredient', 'quantity',
                    'unit', 'is_optional', 'display_order']
    list_filter = ['is_optional', 'unit']
    search_fields = ['recipe__title', 'ingredient__name']
    raw_id_fields = ['recipe', 'ingredient']
    ordering = ['recipe', 'display_order']


@admin.register(RecipeProcedure)
class RecipeProcedureAdmin(admin.ModelAdmin):
    """
    Recipe Procedure Admin
    """
    list_display = ['recipe', 'step_number',
                    'instruction_preview', 'estimated_time']
    list_filter = ['recipe']
    search_fields = ['recipe__title', 'instruction']
    raw_id_fields = ['recipe']
    ordering = ['recipe', 'step_number']

    def instruction_preview(self, obj):
        return obj.instruction[:100] + '...' if len(obj.instruction) > 100 else obj.instruction
    instruction_preview.short_description = 'Instruction'


@admin.register(RecipeRating)
class RecipeRatingAdmin(admin.ModelAdmin):
    """
    Recipe Rating Admin
    """
    list_display = ['recipe', 'user', 'rating', 'created_at']
    list_filter = ['rating', 'created_at']
    search_fields = ['recipe__title', 'user__username', 'review']
    raw_id_fields = ['recipe', 'user']
    readonly_fields = ['created_at', 'updated_at']

    fieldsets = (
        ('Rating Information', {
            'fields': ('recipe', 'user', 'rating', 'review')
        }),
        ('Timestamps', {
            'fields': ('created_at', 'updated_at'),
            'classes': ('collapse',)
        }),
    )


@admin.register(RecipeView)
class RecipeViewAdmin(admin.ModelAdmin):
    """
    Recipe View Admin for Analytics
    """
    list_display = ['recipe', 'user_display', 'ip_address', 'viewed_at']
    list_filter = ['viewed_at']
    search_fields = ['recipe__title', 'user__username', 'ip_address']
    raw_id_fields = ['recipe', 'user']
    readonly_fields = ['viewed_at']
    date_hierarchy = 'viewed_at'

    def user_display(self, obj):
        return obj.user.username if obj.user else f"Anonymous ({obj.ip_address})"
    user_display.short_description = 'User'

    def has_add_permission(self, request):
        return False

    def has_change_permission(self, request, obj=None):
        return False
