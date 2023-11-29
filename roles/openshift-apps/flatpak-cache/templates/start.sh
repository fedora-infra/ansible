exec varnishd \
  -F \
  -f /etc/varnish/flatpak-cache.vcl
  -a :8080
  -t 120
  -s file,/srv/varnish_storage.bin,20G
