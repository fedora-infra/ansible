"""Configuration file for mailman gunicorn instance."""
import multiprocessing

workers = multiprocessing.cpu_count() * 2 + 1
max_requests = 50000
timeout = 1000
threads = 2 * multiprocessing.cpu_count()
forwarded_allow_ips = "*"
