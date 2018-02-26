{%- if pillar.graylog_collector_sidecar is defined %}
include:
{%- if pillar.graylog_collector_sidecar.sidecar is defined %}
  - graylog_collector_sidecar.sidecar
{%- endif %}
{%- endif %}
