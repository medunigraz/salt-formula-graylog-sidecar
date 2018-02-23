{%- if pillar.graylog_collector_sidecar is defined %}
include:
{%- if pillar.graylog_collector_sidecar.agent is defined %}
- graylog-collector-sidecar.agent
{%- endif %}
{%- endif %}
