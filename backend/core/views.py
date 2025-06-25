from django.shortcuts import render
from rest_framework import viewsets, permissions
from .models import Expense
from .serializers import ExpenseSerializer

# Create your views here.
from rest_framework import generics, permissions
from .serializers import RegisterSerializer
from django.contrib.auth import get_user_model

User = get_user_model()

class RegisterView(generics.CreateAPIView):
    queryset = User.objects.all()
    permission_classes = [permissions.AllowAny]
    serializer_class = RegisterSerializer

class ExpenseViewSet(viewsets.ModelViewSet):
    queryset = Expense.objects.all()
    serializer_class = ExpenseSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        # Return only expenses belonging to the logged-in user
        return Expense.objects.filter(user=self.request.user)

    def perform_create(self, serializer):
        # Automatically associate expense with the user
        serializer.save(user=self.request.user)

