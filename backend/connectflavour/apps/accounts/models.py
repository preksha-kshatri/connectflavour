from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin
from django.core.validators import RegexValidator
from apps.core.models import BaseModel


class UserManager(BaseUserManager):
    """
    Custom user manager for the User model
    """

    def create_user(self, email, username, password=None, **extra_fields):
        """
        Create and return a regular user with an email and password.
        """
        if not email:
            raise ValueError('The Email field must be set')
        if not username:
            raise ValueError('The Username field must be set')

        email = self.normalize_email(email)
        user = self.model(email=email, username=username, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, email, username, password=None, **extra_fields):
        """
        Create and return a superuser with an email, username and password.
        """
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)

        if extra_fields.get('is_staff') is not True:
            raise ValueError('Superuser must have is_staff=True.')
        if extra_fields.get('is_superuser') is not True:
            raise ValueError('Superuser must have is_superuser=True.')

        return self.create_user(email, username, password, **extra_fields)


class User(AbstractBaseUser, PermissionsMixin, BaseModel):
    """
    Custom User model based on the ER diagram Account table
    """
    # Username validator
    username_validator = RegexValidator(
        regex=r'^[a-zA-Z0-9_]+$',
        message='Username can only contain letters, numbers, and underscores.',
    )

    # Core fields from ER diagram
    username = models.CharField(
        max_length=150,
        unique=True,
        validators=[username_validator],
        help_text='Required. 150 characters or fewer. Letters, digits and _ only.',
    )
    email = models.EmailField(
        unique=True,
        help_text='Required. Valid email address.'
    )
    password = models.CharField(max_length=128)  # Handled by AbstractBaseUser

    # Profile fields
    first_name = models.CharField(max_length=30, blank=True)
    last_name = models.CharField(max_length=30, blank=True)
    profile_picture = models.ImageField(
        upload_to='profile_pictures/',
        null=True,
        blank=True,
        help_text='Profile picture image'
    )
    bio = models.TextField(max_length=500, blank=True)

    # User status and verification
    is_verified = models.BooleanField(
        default=False,
        help_text='Email verification status'
    )
    is_staff = models.BooleanField(
        default=False,
        help_text='Staff status. Designates whether the user can log into admin site.'
    )

    # Preferences
    dietary_preferences = models.JSONField(
        default=list,
        blank=True,
        help_text='User dietary preferences and restrictions'
    )
    preferred_categories = models.JSONField(
        default=list,
        blank=True,
        help_text='User preferred recipe categories'
    )

    # Social features
    followers_count = models.PositiveIntegerField(default=0)
    following_count = models.PositiveIntegerField(default=0)
    recipes_count = models.PositiveIntegerField(default=0)

    # Authentication fields
    date_joined = models.DateTimeField(auto_now_add=True)
    last_login = models.DateTimeField(null=True, blank=True)

    objects = UserManager()

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['username']

    class Meta:
        db_table = 'accounts_user'
        verbose_name = 'User'
        verbose_name_plural = 'Users'
        ordering = ['-date_joined']

    def __str__(self):
        return self.username

    @property
    def full_name(self):
        """Return the user's full name."""
        return f"{self.first_name} {self.last_name}".strip()

    def get_short_name(self):
        """Return the short name for the user."""
        return self.first_name or self.username


class UserProfile(BaseModel):
    """
    Extended user profile information
    """
    user = models.OneToOneField(
        User,
        on_delete=models.CASCADE,
        related_name='profile'
    )

    # Location information
    location = models.CharField(max_length=100, blank=True)
    country = models.CharField(max_length=50, blank=True)
    timezone = models.CharField(max_length=50, blank=True)

    # Cooking preferences and skill level
    skill_level = models.CharField(
        max_length=20,
        choices=[
            ('beginner', 'Beginner'),
            ('intermediate', 'Intermediate'),
            ('advanced', 'Advanced'),
            ('expert', 'Expert'),
        ],
        default='beginner'
    )

    # Privacy settings
    is_public = models.BooleanField(
        default=True,
        help_text='Whether profile is visible to other users'
    )
    show_email = models.BooleanField(
        default=False,
        help_text='Whether to show email to other users'
    )

    # Notification preferences
    email_notifications = models.BooleanField(default=True)
    push_notifications = models.BooleanField(default=True)

    class Meta:
        db_table = 'accounts_userprofile'
        verbose_name = 'User Profile'
        verbose_name_plural = 'User Profiles'

    def __str__(self):
        return f"{self.user.username}'s Profile"


class EmailVerificationToken(BaseModel):
    """
    Email verification tokens for user registration
    """
    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='verification_tokens'
    )
    token = models.CharField(max_length=255, unique=True)
    expires_at = models.DateTimeField()
    is_used = models.BooleanField(default=False)

    class Meta:
        db_table = 'accounts_email_verification_token'
        verbose_name = 'Email Verification Token'
        verbose_name_plural = 'Email Verification Tokens'
        ordering = ['-created_at']

    def __str__(self):
        return f"Verification token for {self.user.email}"


class PasswordResetToken(BaseModel):
    """
    Password reset tokens for password recovery
    """
    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='password_reset_tokens'
    )
    token = models.CharField(max_length=255, unique=True)
    expires_at = models.DateTimeField()
    is_used = models.BooleanField(default=False)

    class Meta:
        db_table = 'accounts_password_reset_token'
        verbose_name = 'Password Reset Token'
        verbose_name_plural = 'Password Reset Tokens'
        ordering = ['-created_at']

    def __str__(self):
        return f"Password reset token for {self.user.email}"
