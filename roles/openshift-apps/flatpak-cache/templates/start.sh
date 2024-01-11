exec /usr/lib64/squid/security_file_certgen -c -s /var/spool/squid/ssl_db -M 4096 && \
  /sbin/squid -z && \
  /sbin/squid --foreground -f /etc/squid/squid.conf
