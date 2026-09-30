from django.conf import settings
from django.contrib import admin
from django.urls import include, path, re_path
from django.views.generic import RedirectView
from django.views.static import serve


urlpatterns = [
    path('', RedirectView.as_view(url='/manage/', permanent=False)),
    path('manage/', include('core.panel_urls')),
    path('admin/', admin.site.urls),
    path('api/', include('core.urls')),
]

if settings.SERVE_MEDIA or settings.DEBUG:
    urlpatterns += [
        re_path(r'^media/(?P<path>.*)$', serve, {'document_root': settings.MEDIA_ROOT}),
    ]
