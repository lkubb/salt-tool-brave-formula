# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_package_install = tplroot ~ ".package.install" %}
{%- from tplroot ~ "/map.jinja" import mapdata as brave with context %}

include:
  - {{ sls_package_install }}


{%- for user in brave.users %}

Brave Browser has been run once for user '{{ user.name }}':
  cmd.run:
    - name: |
        "{{ brave._bin }}"
    - runas: {{ user.name }}
    - bg: true
    - timeout: 20
    - hide_output: true
    - require:
      - sls: {{ sls_package_install }}
    - creates:
      - {{ user._brave.confdir | path_join("Default") }}

Brave Browser has generated the default profile for user '{{ user.name }}':
  file.exists:
    - name: {{ user._brave.confdir | path_join("Default") }}
    - retry:
        attempts: 10
        interval: 1
    - require:
      - Brave Browser has been run once for user '{{ user.name }}'

Brave Browser is not running for user '{{ user.name }}':
  process.absent:
    - name: {{ salt["file.basename"](brave._bin) }}
    - user: {{ user.name }}
    - onchanges:
      - Brave Browser has been run once for user '{{ user.name }}'
{%- endfor %}
