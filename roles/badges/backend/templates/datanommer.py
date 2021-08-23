config = {
     {% if env == "staging" %}
    'datanommer.sqlalchemy.url': 'postgresql://{{datanommerDBUser}}:{{datanommerDBPassword}}@db-datanommer.stg.iad2.fedoraproject.org/datanommer',
    {% else %}
    'datanommer.sqlalchemy.url': 'postgresql://{{datanommerDBUser}}:{{datanommerDBPassword}}@db-datanommer/datanommer',
    {% endif %}
}
