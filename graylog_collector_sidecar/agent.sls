{%- from "graylog_sidecar_collector/map.jinja" import agent with context %}
{%- set noservices = salt['grains.get']('noservices', None) %}

{%- if agent.enabled %}

graylog_collector_sidecar_package:
  pkg.installed:
  - sources:
    - collector-sidecar: {{ agent.pkgurl }}

graylog_collector_sidecar_service_install:
  cmd.wait:
    - name: graylog-collector-sidecar -service install
    {%- if noservices %}
    - onlyif: /bin/false
    {%- endif %}
    - watch:
      - pkg: graylog_collector_sidecar_package
    - require:
      - pkg: graylog_collector_sidecar_package

graylog_collector_sidecar_ports_config:
  file.managed:
  - name: /etc/graylog/collector-sidecar/collector_sidecar.yml
  - source: salt://graylog_collector/files/collector_sidecar.yml
  - template: jinja
  - require:
    - pkg: graylog_collector_sidecar_package
  - watch_in:
    - service: graylog_collector_sidecar_service

graylog_collector_sidecar_service:
  service.running:
    - name: {{ agent.service }}
    - reload: true
    - enable: true
    {%- if noservices %}
    - onlyif: /bin/false
    {%- endif %}
    - require:
      - pkg: graylog_collector_sidecar_package

{%- else %}

graylog_collector_sidecar_service_uninstall:
  cmd.wait:
    - name: graylog-collector-sidecar -service install
    - watch:
      - pkg: graylog_collector_sidecar_package
    - require:
      - pkg: graylog_collector_sidecar_package

graylog_collector_sidecar_service_dead:
  service.dead:
  - name: {{ agent.service }}
  {%- if noservices %}
  - onlyif: /bin/false
  {%- endif %}

{%- endif %}
