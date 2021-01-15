#!/bin/bash


{% if env == 'staging' %}
until $(curl --output /dev/null --silent --head --fail https://stg.release-monitoring.org); do
{% else %}
until $(curl --output /dev/null --silent --head --fail https://release-monitoring.org); do
{% endif %}
    sleep 5
done
