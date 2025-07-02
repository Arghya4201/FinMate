from rest_framework import serializers
from django.contrib.auth import get_user_model
from rest_framework.validators import UniqueValidator
from django.contrib.auth.password_validation import validate_password
from .models import Expense

User = get_user_model()

class RegisterSerializer(serializers.ModelSerializer):
    email = serializers.EmailField(
        required=True,
        validators=[UniqueValidator(queryset=User.objects.all())]
    )
    password = serializers.CharField(write_only=True, required=True, validators=[validate_password])
    password2 = serializers.CharField(write_only=True, required=True)
    name = serializers.CharField(required=True)

    class Meta:
        model = User
        fields = ('username', 'email', 'name', 'password', 'password2')
        extra_kwargs = {'username': {'required': True}}

    def validate(self, attrs):
        if attrs['password'] != attrs['password2']:
            raise serializers.ValidationError({"password": "Passwords didn't match."})
        return attrs

    def create(self, validated_data):
        validated_data.pop('password2')
        return User.objects.create_user(**validated_data)

class ExpenseSerializer(serializers.ModelSerializer):
    category_display = serializers.SerializerMethodField()

    class Meta:
        model = Expense
        fields = [
            'id', 'title', 'amount', 'category', 'custom_category_name',
            'date', 'notes', 'category_display'
        ]
        read_only_fields = ['id', 'category_display']

    def get_category_display(self, obj):
        return obj.get_category_display_name()
