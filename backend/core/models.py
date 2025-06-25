from django.db import models
from django.conf import settings
# Create your models here.
from django.contrib.auth.models import AbstractUser
from django.db import models

class User(AbstractUser):
    name = models.CharField(max_length=150)  
    email = models.EmailField(unique=True)

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['username', 'name'] 

    def __str__(self):
        return self.name or self.email  # 👈 Show name if available

class Expense(models.Model):
    CATEGORY_CHOICES = [
        ('FOOD', 'Food'),
        ('RENT', 'Rent'),
        ('UTILITIES', 'Utilities'),
        ('ENTERTAINMENT', 'Entertainment'),
        ('SAVINGS', 'Savings'),
        ('OTHER', 'Other'),
    ]

    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='expenses')
    title = models.CharField(max_length=255)
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    category = models.CharField(max_length=50, choices=CATEGORY_CHOICES)
    custom_category_name = models.CharField(max_length=100, blank=True, null=True)  # 👈 new field
    date = models.DateField()
    notes = models.TextField(blank=True)

    def get_category_display_name(self):
        if self.category == 'OTHER' and self.custom_category_name:
            return self.custom_category_name
        return dict(self.CATEGORY_CHOICES).get(self.category, 'Unknown')

    def __str__(self):
        return f"{self.title} - {self.amount} ({self.get_category_display_name()})"

