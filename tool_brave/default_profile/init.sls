# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as brave with context %}

include:
  - {{ sls_package_install }}


{%- for user in brave.users | selectattr('brave.flags', 'defined') | selectattr('brave.flags') %}

Brave Browser has generated the default profile for user '{{ user.name }}':
  cmd.run:
    - name: |
        "{{ brave._bin }}" &
        while [ ! -d '{{ user._brave.confdir | path_join('Default') }}' ]; do
          sleep 1;
        done
        sleep 1
        killall "$(basename '{{ brave._bin }}')"
    - runas: {{ user.name }}
    - require:
      - sls: {{ sls_package_install }}
    - unless:
      - test -d '{{ user._brave.confdir | path_join('Default') }}'
{%- endfor %}
