"""
Custom authentication backend for ConnectFlavour
"""
from django.contrib.auth import get_user_model
from django.contrib.auth.backends import ModelBackend

User = get_user_model()


class EmailOrUsernameBackend(ModelBackend):
    """
    Custom authentication backend that allows users to log in with either
    their email or username.
    """

    def authenticate(self, request, username=None, password=None, **kwargs):
        """
        Authenticate user with either email or username
        """
        if username is None:
            username = kwargs.get(User.USERNAME_FIELD)

        if username is None or password is None:
            return None

        try:
            # Try to fetch the user by searching for username or email
            if '@' in username:
                # If username contains @, treat it as email
                user = User.objects.get(email=username)
            else:
                # Otherwise, treat it as username
                user = User.objects.get(username=username)
        except User.DoesNotExist:
            # Run the default password hasher once to reduce the timing
            # difference between an existing and a nonexistent user
            User().set_password(password)
            return None

        # Check the password
        if user.check_password(password) and self.user_can_authenticate(user):
            return user

        return None
