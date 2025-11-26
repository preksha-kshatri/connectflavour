from django.db import models
from django.utils import timezone


class BaseModel(models.Model):
    """
    Base model with common fields for all models
    """
    created_at = models.DateTimeField(default=timezone.now, editable=False)
    updated_at = models.DateTimeField(auto_now=True)
    is_active = models.BooleanField(default=True)

    class Meta:
        abstract = True


class TimestampedModel(models.Model):
    """
    Abstract model with timestamp fields
    """
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        abstract = True
