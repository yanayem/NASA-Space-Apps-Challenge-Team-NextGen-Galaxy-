from django.urls import path
from . import views

urlpatterns = [
    path('health/', views.health_check, name='health_check'),
    path('apod/', views.apod, name='apod'),
    path('indicators/', views.environmental_indicators, name='environmental_indicators'),
    path('risk-analysis/', views.site_risk_analysis, name='site_risk_analysis'),
    path('site-comparison/', views.site_comparison, name='site_comparison'),
]
