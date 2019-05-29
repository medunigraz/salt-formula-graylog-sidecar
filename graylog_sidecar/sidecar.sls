{%- from "graylog_sidecar/map.jinja" import sidecar with context %}
{%- set noservices = salt['grains.get']('noservices', None) %}

{%- if sidecar.enabled %}

graylog_sidecar_package:
  pkg.installed:
  - sources:
    - graylog-sidecar: {{ sidecar.pkgurl }}

graylog_sidecar_service_install:
  cmd.wait:
    - name: graylog-sidecar -service install
    {%- if noservices %}
    - onlyif: /bin/false
    {%- endif %}
    - watch:
      - pkg: graylog_sidecar_package
    - require:
      - pkg: graylog_sidecar_package

graylog_sidecar_config:
  file.managed:
  - name: /etc/graylog/sidecar/sidecar.yml
  - source: salt://graylog_sidecar/files/sidecar.yml
  - template: jinja
  - require:
    - pkg: graylog_sidecar_package
  - watch_in:
    - service: graylog_sidecar_service

graylog_sidecar_service:
  service.running:
    - name: {{ sidecar.service }}
    - enable: true
    {%- if noservices %}
    - onlyif: /bin/false
    {%- endif %}
    - require:
      - pkg: graylog_sidecar_package

{%- else %}

graylog_sidecar_service_uninstall:
  cmd.wait:
    - name: graylog-sidecar -service uninstall
    - watch:
      - pkg: graylog_sidecar_package
    - require:
      - pkg: graylog_sidecar_package

graylog_sidecar_service_dead:
  service.dead:
  - name: {{ sidecar.service }}
  {%- if noservices %}
  - onlyif: /bin/false
  {%- endif %}

{%- endif %}
