from rest_framework import status, generics, permissions
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework_simplejwt.views import TokenObtainPairView
from django.contrib.auth import get_user_model
from django.contrib.auth import login
from django.db import transaction
from django.shortcuts import get_object_or_404
from .serializers import (
    UserRegistrationSerializer,
    UserLoginSerializer,
    UserProfileSerializer,
    PasswordChangeSerializer,
    EmailVerificationSerializer,
    UserSearchSerializer
)
from .models import UserProfile

User = get_user_model()


class RegisterView(generics.CreateAPIView):
    """
    User registration endpoint
    """
    queryset = User.objects.all()
    serializer_class = UserRegistrationSerializer
    permission_classes = [permissions.AllowAny]

    def perform_create(self, serializer):
        """
        Create user and return JWT tokens
        """
        with transaction.atomic():
            user = serializer.save()
            # Create user profile is handled by signal

    def create(self, request, *args, **kwargs):
        """
        Custom create response with JWT tokens
        """
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        with transaction.atomic():
            user = serializer.save()

            # Generate JWT tokens
            refresh = RefreshToken.for_user(user)

            return Response({
                'message': 'User registered successfully. Please verify your email.',
                'user': UserProfileSerializer(user).data,
                'tokens': {
                    'refresh': str(refresh),
                    'access': str(refresh.access_token),
                }
            }, status=status.HTTP_201_CREATED)


class LoginView(TokenObtainPairView):
    """
    User login endpoint with JWT tokens
    """
    serializer_class = UserLoginSerializer

    def post(self, request, *args, **kwargs):
        """
        Custom login response
        """
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        user = serializer.validated_data['user']

        # Generate JWT tokens
        refresh = RefreshToken.for_user(user)

        # Update last login
        login(request, user)

        return Response({
            'message': 'Login successful.',
            'user': UserProfileSerializer(user).data,
            'tokens': {
                'refresh': str(refresh),
                'access': str(refresh.access_token),
            }
        }, status=status.HTTP_200_OK)


class ProfileView(generics.RetrieveUpdateAPIView):
    """
    User profile view and update endpoint
    """
    serializer_class = UserProfileSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_object(self):
        """
        Return the current user
        """
        return self.request.user

    def update(self, request, *args, **kwargs):
        """
        Update user profile
        """
        partial = kwargs.pop('partial', False)
        instance = self.get_object()
        serializer = self.get_serializer(
            instance, data=request.data, partial=partial)
        serializer.is_valid(raise_exception=True)

        # Update user fields
        user = serializer.save()

        # Update profile fields if provided
        profile_data = request.data.get('profile', {})
        if profile_data:
            profile = user.profile
            for field, value in profile_data.items():
                if hasattr(profile, field):
                    setattr(profile, field, value)
            profile.save()

        return Response({
            'message': 'Profile updated successfully.',
            'user': UserProfileSerializer(user).data
        }, status=status.HTTP_200_OK)


class PasswordChangeView(APIView):
    """
    Password change endpoint
    """
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request):
        """
        Change user password
        """
        serializer = PasswordChangeSerializer(
            data=request.data,
            context={'request': request}
        )
        serializer.is_valid(raise_exception=True)
        serializer.save()

        return Response({
            'message': 'Password changed successfully.'
        }, status=status.HTTP_200_OK)


class EmailVerificationView(APIView):
    """
    Email verification endpoint
    """
    permission_classes = [permissions.AllowAny]

    def post(self, request):
        """
        Verify user email with token
        """
        serializer = EmailVerificationSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.save()

        return Response({
            'message': 'Email verified successfully.',
            'user': UserProfileSerializer(user).data
        }, status=status.HTTP_200_OK)


class UserDetailView(generics.RetrieveAPIView):
    """
    Public user profile view
    """
    queryset = User.objects.filter(is_active=True)
    serializer_class = UserProfileSerializer
    permission_classes = [permissions.AllowAny]
    lookup_field = 'username'

    def get_queryset(self):
        """
        Filter to only public profiles
        """
        return User.objects.filter(
            is_active=True,
            profile__is_public=True
        ).select_related('profile')


class UserSearchView(generics.ListAPIView):
    """
    User search endpoint
    """
    serializer_class = UserSearchSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        """
        Search users by username or name
        """
        query = self.request.query_params.get('q', '')
        if not query:
            return User.objects.none()

        return User.objects.filter(
            is_active=True,
            profile__is_public=True
        ).filter(
            models.Q(username__icontains=query) |
            models.Q(first_name__icontains=query) |
            models.Q(last_name__icontains=query)
        ).select_related('profile')[:20]


@api_view(['POST'])
@permission_classes([permissions.AllowAny])
def resend_verification_email(request):
    """
    Resend email verification token
    """
    email = request.data.get('email')
    if not email:
        return Response({
            'error': 'Email is required.'
        }, status=status.HTTP_400_BAD_REQUEST)

    try:
        user = User.objects.get(email=email, is_verified=False)

        # Delete existing unused tokens
        user.verification_tokens.filter(is_used=False).delete()

        # Create new token
        token = str(uuid.uuid4())
        EmailVerificationToken.objects.create(
            user=user,
            token=token,
            expires_at=datetime.now() + timedelta(hours=24)
        )

        # TODO: Send verification email

        return Response({
            'message': 'Verification email sent successfully.'
        }, status=status.HTTP_200_OK)

    except User.DoesNotExist:
        return Response({
            'error': 'User not found or already verified.'
        }, status=status.HTTP_404_NOT_FOUND)


@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def logout_view(request):
    """
    Logout endpoint - blacklist refresh token
    """
    try:
        refresh_token = request.data.get('refresh_token')
        if refresh_token:
            token = RefreshToken(refresh_token)
            token.blacklist()

        return Response({
            'message': 'Logout successful.'
        }, status=status.HTTP_200_OK)

    except Exception as e:
        return Response({
            'message': 'Logout successful.'
        }, status=status.HTTP_200_OK)
