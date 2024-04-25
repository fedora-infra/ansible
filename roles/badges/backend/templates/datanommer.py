config = {
     {% if env == "staging" %}
    'datanommer.sqlalchemy.url': 'postgresql://{{datanommerDBUser}}:{{datanommer_stg_db_password}}@{{datanommer_db_hostname}}.stg.iad2.fedoraproject.org/datanommer2',
    {% else %}
    'datanommer.sqlalchemy.url': 'postgresql://{{datanommerDBUser}}:{{datanommerDBPassword}}@{{datanommer_db_hostname}}/datanommer2',
    {% endif %}
}
