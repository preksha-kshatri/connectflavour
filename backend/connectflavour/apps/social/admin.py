from django.contrib import admin
from django.db.models import Count
from .models import (
    Follow, Wishlist, RecipeShare, UserActivity,
    Collection, CollectionRecipe, Comment
)


@admin.register(Follow)
class FollowAdmin(admin.ModelAdmin):
    """
    Follow Admin
    """
    list_display = ['follower', 'followed', 'created_at']
    list_filter = ['created_at']
    search_fields = ['follower__username', 'followed__username']
    raw_id_fields = ['follower', 'followed']
    readonly_fields = ['created_at', 'updated_at']
    date_hierarchy = 'created_at'


@admin.register(Wishlist)
class WishlistAdmin(admin.ModelAdmin):
    """
    Wishlist Admin
    """
    list_display = ['user', 'recipe', 'collection_name', 'created_at']
    list_filter = ['collection_name', 'created_at']
    search_fields = ['user__username',
                     'recipe__title', 'collection_name', 'notes']
    raw_id_fields = ['user', 'recipe']
    readonly_fields = ['created_at', 'updated_at']
    date_hierarchy = 'created_at'

    fieldsets = (
        ('Basic Information', {
            'fields': ('user', 'recipe', 'collection_name')
        }),
        ('Notes', {
            'fields': ('notes',)
        }),
        ('Timestamps', {
            'fields': ('created_at', 'updated_at'),
            'classes': ('collapse',)
        }),
    )


@admin.register(RecipeShare)
class RecipeShareAdmin(admin.ModelAdmin):
    """
    Recipe Share Admin for Analytics
    """
    list_display = ['recipe', 'user', 'platform', 'created_at']
    list_filter = ['platform', 'created_at']
    search_fields = ['recipe__title', 'user__username']
    raw_id_fields = ['recipe', 'user']
    readonly_fields = ['created_at', 'updated_at']
    date_hierarchy = 'created_at'

    def has_add_permission(self, request):
        return False

    def has_change_permission(self, request, obj=None):
        return False


@admin.register(UserActivity)
class UserActivityAdmin(admin.ModelAdmin):
    """
    User Activity Admin for Analytics
    """
    list_display = ['user', 'activity_type', 'object_id', 'created_at']
    list_filter = ['activity_type', 'created_at']
    search_fields = ['user__username']
    raw_id_fields = ['user']
    readonly_fields = ['created_at', 'updated_at']
    date_hierarchy = 'created_at'

    fieldsets = (
        ('Activity Information', {
            'fields': ('user', 'activity_type', 'object_id', 'metadata')
        }),
        ('Timestamps', {
            'fields': ('created_at', 'updated_at'),
            'classes': ('collapse',)
        }),
    )

    def has_add_permission(self, request):
        return False

    def has_change_permission(self, request, obj=None):
        return False


class CollectionRecipeInline(admin.TabularInline):
    model = CollectionRecipe
    extra = 1
    fields = ['recipe', 'notes', 'display_order']
    raw_id_fields = ['recipe']


@admin.register(Collection)
class CollectionAdmin(admin.ModelAdmin):
    """
    Collection Admin
    """
    inlines = [CollectionRecipeInline]

    list_display = ['name', 'user', 'recipes_count',
                    'followers_count', 'is_public', 'created_at']
    list_filter = ['is_public', 'created_at']
    search_fields = ['name', 'description', 'user__username']
    raw_id_fields = ['user']
    readonly_fields = ['recipes_count',
                       'followers_count', 'created_at', 'updated_at']

    fieldsets = (
        ('Basic Information', {
            'fields': ('name', 'description', 'user', 'cover_image')
        }),
        ('Settings', {
            'fields': ('is_public',)
        }),
        ('Statistics', {
            'fields': ('recipes_count', 'followers_count'),
            'classes': ('collapse',)
        }),
        ('Timestamps', {
            'fields': ('created_at', 'updated_at'),
            'classes': ('collapse',)
        }),
    )

    actions = ['make_public', 'make_private']

    def make_public(self, request, queryset):
        updated = queryset.update(is_public=True)
        self.message_user(
            request, f'{updated} collection(s) made public successfully.')
    make_public.short_description = 'Make selected collections public'

    def make_private(self, request, queryset):
        updated = queryset.update(is_public=False)
        self.message_user(
            request, f'{updated} collection(s) made private successfully.')
    make_private.short_description = 'Make selected collections private'


@admin.register(CollectionRecipe)
class CollectionRecipeAdmin(admin.ModelAdmin):
    """
    Collection Recipe Admin
    """
    list_display = ['collection', 'recipe', 'display_order', 'created_at']
    list_filter = ['created_at']
    search_fields = ['collection__name', 'recipe__title', 'notes']
    raw_id_fields = ['collection', 'recipe']
    readonly_fields = ['created_at', 'updated_at']
    ordering = ['collection', 'display_order']


@admin.register(Comment)
class CommentAdmin(admin.ModelAdmin):
    """
    Comment Admin
    """
    list_display = ['user', 'recipe',
                    'content_preview', 'is_approved', 'created_at']
    list_filter = ['is_approved', 'created_at']
    search_fields = ['user__username', 'recipe__title', 'content']
    raw_id_fields = ['recipe', 'user', 'parent']
    readonly_fields = ['created_at', 'updated_at']
    date_hierarchy = 'created_at'

    fieldsets = (
        ('Comment Information', {
            'fields': ('recipe', 'user', 'content', 'parent')
        }),
        ('Status', {
            'fields': ('is_approved',)
        }),
        ('Timestamps', {
            'fields': ('created_at', 'updated_at'),
            'classes': ('collapse',)
        }),
    )

    actions = ['approve_comments', 'unapprove_comments']

    def content_preview(self, obj):
        return obj.content[:50] + '...' if len(obj.content) > 50 else obj.content
    content_preview.short_description = 'Content'

    def approve_comments(self, request, queryset):
        updated = queryset.update(is_approved=True)
        self.message_user(
            request, f'{updated} comment(s) approved successfully.')
    approve_comments.short_description = 'Approve selected comments'

    def unapprove_comments(self, request, queryset):
        updated = queryset.update(is_approved=False)
        self.message_user(
            request, f'{updated} comment(s) unapproved successfully.')
    unapprove_comments.short_description = 'Unapprove selected comments'
