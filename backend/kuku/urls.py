from django.contrib import admin
from django.http import HttpResponse
from django.urls import include, path
from django.conf import settings
from django.conf.urls.static import static


def home(_request):
    return HttpResponse(
        """<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>KUKU DIARY API</title>
  <style>
    body { font-family: sans-serif; max-width: 640px; margin: 48px auto; color: #111827; }
    a { color: #059669; }
    code { background: #f3f4f6; padding: 2px 6px; border-radius: 4px; }
  </style>
</head>
<body>
  <h1>KUKU DIARY API</h1>
  <p>Backend is running. Database: <strong>kuku</strong> (PostgreSQL).</p>
  <ul>
    <li><a href="/api/health/">API health</a> — <code>/api/health/</code></li>
    <li><a href="/admin/">Django admin</a> — <code>/admin/</code></li>
    <li>Mobile API base — <code>/api/</code></li>
  </ul>
  <p>The Flutter app talks to <code>/api/</code>, not this page.</p>
</body>
</html>""",
        content_type='text/html',
    )


urlpatterns = [
    path('', home),
    path('admin/', admin.site.urls),
    path('api/', include('core.urls')),
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
