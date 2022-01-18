config = {
     {% if env == "staging" %}
    'datanommer.sqlalchemy.url': 'postgresql://{{datanommerDBUser}}:{{datanommer_stg_db_password}}@db-datanommer01.stg.iad2.fedoraproject.org/datanommer2',
    {% else %}
    'datanommer.sqlalchemy.url': 'postgresql://{{datanommerDBUser}}:{{datanommerDBPassword}}@db-datanommer02/datanommer2',
    {% endif %}
}
