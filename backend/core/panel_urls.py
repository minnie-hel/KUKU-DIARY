from django.urls import path

from . import panel

urlpatterns = [
    path('login/', panel.login_view, name='panel_login'),
    path('logout/', panel.logout_view, name='panel_logout'),
    path('language/', panel.language_view, name='panel_language'),
    path('', panel.home, name='panel_home'),
    path('<slug:key>/', panel.object_list, name='panel_list'),
    path('<slug:key>/new/', panel.object_create, name='panel_create'),
    path('<slug:key>/<uuid:pk>/', panel.object_detail, name='panel_detail'),
    path('<slug:key>/<uuid:pk>/edit/', panel.object_edit, name='panel_edit'),
    path('<slug:key>/<uuid:pk>/delete/', panel.object_delete, name='panel_delete'),
]
