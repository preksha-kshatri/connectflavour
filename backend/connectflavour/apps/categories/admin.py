from django.contrib import admin
from django.utils.html import format_html
from .models import Category, Tag, DifficultyLevel


@admin.register(Category)
class CategoryAdmin(admin.ModelAdmin):
    """
    Category Admin with comprehensive features
    """
    list_display = [
        'name', 'display_order', 'recipes_count', 'is_featured',
        'image_preview', 'created_at'
    ]
    list_filter = ['is_featured', 'created_at']
    search_fields = ['name', 'description', 'meta_title', 'meta_description']
    prepopulated_fields = {'slug': ('name',)}
    readonly_fields = ['recipes_count', 'created_at', 'updated_at']

    fieldsets = (
        ('Basic Information', {
            'fields': ('name', 'slug', 'description', 'image')
        }),
        ('Display Settings', {
            'fields': ('display_order', 'is_featured')
        }),
        ('SEO', {
            'fields': ('meta_title', 'meta_description'),
            'classes': ('collapse',)
        }),
        ('Statistics', {
            'fields': ('recipes_count',),
            'classes': ('collapse',)
        }),
        ('Timestamps', {
            'fields': ('created_at', 'updated_at'),
            'classes': ('collapse',)
        }),
    )

    actions = ['feature_categories', 'unfeature_categories']

    def image_preview(self, obj):
        if obj.image:
            return format_html('<img src="{}" width="50" height="50" />', obj.image.url)
        return '-'
    image_preview.short_description = 'Image'

    def feature_categories(self, request, queryset):
        updated = queryset.update(is_featured=True)
        self.message_user(
            request, f'{updated} category(ies) featured successfully.')
    feature_categories.short_description = 'Feature selected categories'

    def unfeature_categories(self, request, queryset):
        updated = queryset.update(is_featured=False)
        self.message_user(
            request, f'{updated} category(ies) unfeatured successfully.')
    unfeature_categories.short_description = 'Unfeature selected categories'


@admin.register(Tag)
class TagAdmin(admin.ModelAdmin):
    """
    Tag Admin
    """
    list_display = ['name', 'color_preview', 'usage_count', 'created_at']
    list_filter = ['created_at']
    search_fields = ['name']
    prepopulated_fields = {'slug': ('name',)}
    readonly_fields = ['usage_count', 'created_at', 'updated_at']

    fieldsets = (
        ('Basic Information', {
            'fields': ('name', 'slug', 'color')
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

    def color_preview(self, obj):
        return format_html(
            '<span style="background-color: {}; padding: 5px 15px; border-radius: 3px; color: white;">{}</span>',
            obj.color, obj.color
        )
    color_preview.short_description = 'Color'


@admin.register(DifficultyLevel)
class DifficultyLevelAdmin(admin.ModelAdmin):
    """
    Difficulty Level Admin
    """
    list_display = ['name', 'display_order', 'icon', 'created_at']
    list_filter = ['name', 'created_at']
    search_fields = ['name', 'description']
    readonly_fields = ['created_at', 'updated_at']

    fieldsets = (
        ('Basic Information', {
            'fields': ('name', 'description', 'icon', 'display_order')
        }),
        ('Timestamps', {
            'fields': ('created_at', 'updated_at'),
            'classes': ('collapse',)
        }),
    )
