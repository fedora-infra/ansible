# -*- coding: utf-8 -*-

from django.contrib import admin
from django.urls import include, re_path, reverse_lazy
from django.views.generic import RedirectView

urlpatterns = [
    re_path(r'^$', RedirectView.as_view(
        url=reverse_lazy('list_index'),
        permanent=True)),
    re_path(r'^admin/', include('postorius.urls')),
    re_path(r'^archives/', include('hyperkitty.urls')),
    re_path(r'', include('django_mailman3.urls')),
    re_path(r'^accounts/', include('allauth.urls')),
    re_path(r'^django-admin/', include(admin.site.urls)),
]
