exec /usr/lib64/squid/security_file_certgen -M 4096 -c -s /var/spool/squid/ssl_db && \
  /sbin/squid -z && \
  /sbin/squid --foreground -f /etc/squid/squid.conf
