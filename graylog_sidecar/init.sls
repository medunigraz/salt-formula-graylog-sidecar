{%- if pillar.graylog is defined %}
include:
{%- if pillar.graylog.sidecar is defined %}
  - graylog_sidecar.sidecar
{%- endif %}
{%- endif %}
