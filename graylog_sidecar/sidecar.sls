{%- from "graylog_sidecar/map.jinja" import sidecar with context %}
{%- set noservices = salt['grains.get']('noservices', None) %}

{%- if sidecar.enabled %}

graylog_sidecar_cleanup:
  pkg.purged:
    - pkgs:
      - collector-sidecar

graylog_sidecar_packages:
  pkg.installed:
    - sources:
      - graylog-sidecar: {{ sidecar.sidecar }}
      - filebeat: {{ sidecar.filebeat }}
    - require:
      - pkg: graylog_sidecar_cleanup

graylog_sidecar_service_install:
  cmd.wait:
    - name: graylog-sidecar -service install
    {%- if noservices %}
    - onlyif: /bin/false
    {%- endif %}
    - watch:
      - pkg: graylog_sidecar_packages
    - require:
      - pkg: graylog_sidecar_packages

graylog_sidecar_config:
  file.managed:
  - name: /etc/graylog/sidecar/sidecar.yml
  - source: salt://graylog_sidecar/files/sidecar.yml
  - template: jinja
  - require:
    - pkg: graylog_sidecar_packages
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
      - pkg: graylog_sidecar_packages

{%- endif %}
