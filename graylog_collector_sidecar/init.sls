{%- if pillar.graylog_collector_sidecar is defined %}
include:
{%- if pillar.graylog_collector_sidecar.agent is defined %}
- graylog_collector_sidecar.agent
{%- endif %}
{%- endif %}
