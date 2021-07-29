config = dict(
    fas_credentials=dict(
        username="fedoradummy",
        password="{{ fedoraDummyUserPassword }}",
    {% if env == 'staging' %}
        base_url="https://accounts.stg.fedoraproject.org/",
    {% endif %}
    ),
)
