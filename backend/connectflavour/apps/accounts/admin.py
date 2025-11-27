from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from django.contrib.auth import get_user_model
from django.utils.html import format_html
from .models import UserProfile, EmailVerificationToken, PasswordResetToken

User = get_user_model()


class UserProfileInline(admin.StackedInline):
    model = UserProfile
    can_delete = False
    verbose_name_plural = 'Profile'
    fields = [
        'location', 'country', 'timezone', 'skill_level',
        'is_public', 'show_email', 'email_notifications', 'push_notifications'
    ]


@admin.register(User)
class UserAdmin(BaseUserAdmin):
    """
    Custom User Admin with enhanced features
    """
    inlines = [UserProfileInline]

    list_display = [
        'username', 'email', 'full_name', 'is_verified',
        'is_active', 'is_staff', 'followers_count', 'recipes_count', 'date_joined'
    ]
    list_filter = [
        'is_active', 'is_staff', 'is_superuser', 'is_verified',
        'date_joined', 'last_login'
    ]
    search_fields = ['username', 'email', 'first_name', 'last_name']
    ordering = ['-date_joined']
    readonly_fields = ['date_joined', 'last_login', 'id']

    fieldsets = (
        ('Authentication', {
            'fields': ('email', 'username', 'password')
        }),
        ('Personal Info', {
            'fields': ('first_name', 'last_name', 'profile_picture', 'bio')
        }),
        ('Preferences', {
            'fields': ('dietary_preferences', 'preferred_categories'),
            'classes': ('collapse',)
        }),
        ('Statistics', {
            'fields': ('followers_count', 'following_count', 'recipes_count'),
            'classes': ('collapse',)
        }),
        ('Permissions', {
            'fields': ('is_active', 'is_staff', 'is_superuser', 'is_verified', 'groups', 'user_permissions'),
            'classes': ('collapse',)
        }),
        ('Important Dates', {
            'fields': ('date_joined', 'last_login'),
            'classes': ('collapse',)
        }),
    )

    add_fieldsets = (
        ('Create New User', {
            'classes': ('wide',),
            'fields': ('email', 'username', 'password1', 'password2', 'is_staff', 'is_active'),
        }),
    )

    actions = ['verify_users', 'activate_users', 'deactivate_users']

    def verify_users(self, request, queryset):
        updated = queryset.update(is_verified=True)
        self.message_user(request, f'{updated} user(s) verified successfully.')
    verify_users.short_description = 'Verify selected users'

    def activate_users(self, request, queryset):
        updated = queryset.update(is_active=True)
        self.message_user(
            request, f'{updated} user(s) activated successfully.')
    activate_users.short_description = 'Activate selected users'

    def deactivate_users(self, request, queryset):
        updated = queryset.update(is_active=False)
        self.message_user(
            request, f'{updated} user(s) deactivated successfully.')
    deactivate_users.short_description = 'Deactivate selected users'


@admin.register(UserProfile)
class UserProfileAdmin(admin.ModelAdmin):
    """
    User Profile Admin
    """
    list_display = ['user', 'location', 'country', 'skill_level', 'is_public']
    list_filter = ['skill_level', 'is_public',
                   'email_notifications', 'push_notifications']
    search_fields = ['user__username', 'user__email', 'location', 'country']
    raw_id_fields = ['user']
    readonly_fields = ['created_at', 'updated_at']

    fieldsets = (
        ('User', {
            'fields': ('user',)
        }),
        ('Location', {
            'fields': ('location', 'country', 'timezone')
        }),
        ('Preferences', {
            'fields': ('skill_level',)
        }),
        ('Privacy', {
            'fields': ('is_public', 'show_email')
        }),
        ('Notifications', {
            'fields': ('email_notifications', 'push_notifications')
        }),
        ('Timestamps', {
            'fields': ('created_at', 'updated_at'),
            'classes': ('collapse',)
        }),
    )


@admin.register(EmailVerificationToken)
class EmailVerificationTokenAdmin(admin.ModelAdmin):
    """
    Email Verification Token Admin
    """
    list_display = ['user', 'token_preview',
                    'expires_at', 'is_used', 'created_at']
    list_filter = ['is_used', 'expires_at', 'created_at']
    search_fields = ['user__username', 'user__email', 'token']
    raw_id_fields = ['user']
    readonly_fields = ['created_at', 'updated_at']

    def token_preview(self, obj):
        return f"{obj.token[:20]}..." if len(obj.token) > 20 else obj.token
    token_preview.short_description = 'Token'


@admin.register(PasswordResetToken)
class PasswordResetTokenAdmin(admin.ModelAdmin):
    """
    Password Reset Token Admin
    """
    list_display = ['user', 'token_preview',
                    'expires_at', 'is_used', 'created_at']
    list_filter = ['is_used', 'expires_at', 'created_at']
    search_fields = ['user__username', 'user__email', 'token']
    raw_id_fields = ['user']
    readonly_fields = ['created_at', 'updated_at']

    def token_preview(self, obj):
        return f"{obj.token[:20]}..." if len(obj.token) > 20 else obj.token
    token_preview.short_description = 'Token'
