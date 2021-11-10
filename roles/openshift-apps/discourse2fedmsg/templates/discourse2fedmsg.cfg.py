# secret set in discourse webhooks UI
{% if env == "staging" %}
DISCOURSE2FEDMSG_SECRET = "{{ discourse2fedmsg_stg_webhook_secret }}"
{% else %}
DISCOURSE2FEDMSG_SECRET = "{{ discourse2fedmsg_webhook_secret }}"
{% endif %}
