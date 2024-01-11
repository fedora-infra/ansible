exec /bin/mkdir -p /tmp/ssl_db && \
  /usr/lib64/squid/security_file_certgen -c -s /tmp/ssl_db -M 4096 && \
  /sbin/squid -z && \
  /sbin/squid --foreground -f /etc/squid/squid.conf
