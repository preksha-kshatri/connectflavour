from rest_framework import serializers
from django.contrib.auth import authenticate, get_user_model
from django.contrib.auth.password_validation import validate_password
from django.core.exceptions import ValidationError as DjangoValidationError
from rest_framework.validators import UniqueValidator
from .models import UserProfile, EmailVerificationToken
import uuid
from datetime import datetime, timedelta

User = get_user_model()


class UserRegistrationSerializer(serializers.ModelSerializer):
    """
    Serializer for user registration
    """
    email = serializers.EmailField(
        required=True,
        validators=[UniqueValidator(queryset=User.objects.all())]
    )
    username = serializers.CharField(
        required=True,
        validators=[UniqueValidator(queryset=User.objects.all())]
    )
    password = serializers.CharField(
        write_only=True,
        required=True,
        style={'input_type': 'password'}
    )
    password_confirm = serializers.CharField(
        write_only=True,
        required=True,
        style={'input_type': 'password'}
    )
    first_name = serializers.CharField(required=False, allow_blank=True)
    last_name = serializers.CharField(required=False, allow_blank=True)

    class Meta:
        model = User
        fields = (
            'username', 'email', 'password', 'password_confirm',
            'first_name', 'last_name'
        )

    def validate(self, attrs):
        """
        Validate passwords match and meet requirements
        """
        password = attrs.get('password')
        password_confirm = attrs.pop('password_confirm', None)

        if password != password_confirm:
            raise serializers.ValidationError("Passwords don't match.")

        # Validate password strength
        try:
            validate_password(password)
        except DjangoValidationError as e:
            raise serializers.ValidationError({'password': list(e.messages)})

        return attrs

    def create(self, validated_data):
        """
        Create user with encrypted password
        """
        password = validated_data.pop('password')
        user = User.objects.create_user(password=password, **validated_data)

        # Create email verification token
        token = str(uuid.uuid4())
        EmailVerificationToken.objects.create(
            user=user,
            token=token,
            expires_at=datetime.now() + timedelta(hours=24)
        )

        # TODO: Send verification email

        return user


class UserLoginSerializer(serializers.Serializer):
    """
    Serializer for user login
    """
    username = serializers.CharField(required=True)
    password = serializers.CharField(
        required=True,
        style={'input_type': 'password'}
    )

    def validate(self, attrs):
        """
        Validate user credentials
        """
        username = attrs.get('username')
        password = attrs.get('password')

        if username and password:
            # The custom authentication backend will handle both username and email
            user = authenticate(
                request=self.context.get('request'),
                username=username,
                password=password
            )

            if not user:
                raise serializers.ValidationError(
                    'Unable to log in with provided credentials.'
                )

            if not user.is_active:
                raise serializers.ValidationError(
                    'User account is disabled.'
                )

            attrs['user'] = user
            return attrs
        else:
            raise serializers.ValidationError(
                'Must include "username" and "password".'
            )


class UserProfileSerializer(serializers.ModelSerializer):
    """
    Serializer for user profile information
    """
    full_name = serializers.ReadOnlyField()
    followers_count = serializers.ReadOnlyField()
    following_count = serializers.ReadOnlyField()
    recipes_count = serializers.ReadOnlyField()
    profile = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = (
            'id', 'username', 'email', 'first_name', 'last_name',
            'full_name', 'profile_picture', 'bio', 'is_verified',
            'followers_count', 'following_count', 'recipes_count',
            'dietary_preferences', 'preferred_categories', 'profile',
            'date_joined'
        )
        read_only_fields = (
            'id', 'email', 'is_verified', 'followers_count',
            'following_count', 'recipes_count', 'date_joined'
        )

    def get_profile(self, obj):
        """
        Get user profile information
        """
        if hasattr(obj, 'profile'):
            return UserProfileDetailSerializer(obj.profile).data
        return None


class UserProfileDetailSerializer(serializers.ModelSerializer):
    """
    Detailed serializer for UserProfile model
    """
    class Meta:
        model = UserProfile
        fields = (
            'location', 'country', 'timezone', 'skill_level',
            'is_public', 'show_email', 'email_notifications',
            'push_notifications'
        )


class PasswordChangeSerializer(serializers.Serializer):
    """
    Serializer for password change
    """
    old_password = serializers.CharField(
        required=True,
        style={'input_type': 'password'}
    )
    new_password = serializers.CharField(
        required=True,
        style={'input_type': 'password'}
    )
    new_password_confirm = serializers.CharField(
        required=True,
        style={'input_type': 'password'}
    )

    def validate_old_password(self, value):
        """
        Validate old password
        """
        user = self.context['request'].user
        if not user.check_password(value):
            raise serializers.ValidationError('Old password is incorrect.')
        return value

    def validate(self, attrs):
        """
        Validate new passwords match
        """
        new_password = attrs.get('new_password')
        new_password_confirm = attrs.get('new_password_confirm')

        if new_password != new_password_confirm:
            raise serializers.ValidationError("New passwords don't match.")

        # Validate password strength
        try:
            validate_password(new_password)
        except DjangoValidationError as e:
            raise serializers.ValidationError(
                {'new_password': list(e.messages)})

        return attrs

    def save(self):
        """
        Set new password
        """
        user = self.context['request'].user
        user.set_password(self.validated_data['new_password'])
        user.save()
        return user


class EmailVerificationSerializer(serializers.Serializer):
    """
    Serializer for email verification
    """
    token = serializers.CharField(required=True)

    def validate_token(self, value):
        """
        Validate verification token
        """
        try:
            token = EmailVerificationToken.objects.get(
                token=value,
                is_used=False,
                expires_at__gte=datetime.now()
            )
            self.token_instance = token
            return value
        except EmailVerificationToken.DoesNotExist:
            raise serializers.ValidationError('Invalid or expired token.')

    def save(self):
        """
        Verify user email
        """
        token = self.token_instance
        user = token.user
        user.is_verified = True
        user.save(update_fields=['is_verified'])

        token.is_used = True
        token.save(update_fields=['is_used'])

        return user


class UserSearchSerializer(serializers.ModelSerializer):
    """
    Serializer for user search results
    """
    full_name = serializers.ReadOnlyField()

    class Meta:
        model = User
        fields = (
            'id', 'username', 'first_name', 'last_name', 'full_name',
            'profile_picture', 'followers_count', 'recipes_count',
            'is_verified'
        )
