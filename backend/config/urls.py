from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),

    # Auth endpoints
    path('api/auth/', include('core.auth_urls')),

    # Expense and other core APIs
    path('api/', include('core.urls')),
]
