from django.urls import path
from .views import (
    RegisterView,
    LoginView,
    ProfileView,
    PasswordChangeView,
    EmailVerificationView,
    UserDetailView,
    UserSearchView,
    resend_verification_email,
    logout_view
)
from rest_framework_simplejwt.views import TokenRefreshView

urlpatterns = [
    # Authentication
    path('register/', RegisterView.as_view(), name='register'),
    path('login/', LoginView.as_view(), name='login'),
    path('logout/', logout_view, name='logout'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token-refresh'),

    # Profile management
    path('profile/', ProfileView.as_view(), name='profile'),
    path('password/change/', PasswordChangeView.as_view(), name='password-change'),

    # Email verification
    path('verify-email/', EmailVerificationView.as_view(), name='verify-email'),
    path('resend-verification/', resend_verification_email,
         name='resend-verification'),

    # User discovery
    path('users/search/', UserSearchView.as_view(), name='user-search'),
    path('users/<str:username>/', UserDetailView.as_view(), name='user-detail'),
]
