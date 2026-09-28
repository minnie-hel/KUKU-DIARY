from django.urls import include, path
from rest_framework.routers import DefaultRouter

from . import views

router = DefaultRouter()
router.register(r'poultry-batches', views.PoultryBatchViewSet, basename='poultry-batches')
router.register(r'production-logs', views.ProductionLogViewSet, basename='production-logs')
router.register(r'feed-inventory', views.FeedInventoryViewSet, basename='feed-inventory')
router.register(r'vaccinations', views.VaccinationViewSet, basename='vaccinations')
router.register(r'marketplace', views.MarketplaceViewSet, basename='marketplace')
router.register(r'community', views.CommunityViewSet, basename='community')
router.register(r'finance', views.FinanceViewSet, basename='finance')
router.register(r'notifications', views.NotificationViewSet, basename='notifications')
router.register(r'chat', views.ChatViewSet, basename='chat')
router.register(r'vets', views.VetViewSet, basename='vets')
router.register(r'vet-consultations', views.VetConsultationViewSet, basename='vet-consultations')
router.register(r'disease-reports', views.DiseaseReportViewSet, basename='disease-reports')
router.register(r'service-providers', views.ServiceProviderViewSet, basename='service-providers')
router.register(r'training', views.TrainingViewSet, basename='training')

urlpatterns = [
    path('health/', views.health),
    path('auth/register/', views.RegisterView.as_view()),
    path('auth/verify-otp/', views.VerifyOtpView.as_view()),
    path('auth/login/', views.LoginView.as_view()),
    path('auth/request-otp/', views.RequestOtpView.as_view()),
    path('auth/forgot-password/', views.ForgotPasswordView.as_view()),
    path('auth/reset-password/', views.ResetPasswordView.as_view()),
    path('auth/change-password/', views.ChangePasswordView.as_view()),
    path('auth/logout/', views.LogoutView.as_view()),
    path('bootstrap/', views.BootstrapView.as_view()),
    path('farm/', views.FarmProfileView.as_view()),
    path('settings/', views.UserSettingsView.as_view()),
    path('', include(router.urls)),
]
