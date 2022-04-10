# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as brave with context %}

include:
  - {{ slsdotpath }}.repo


{%- if 'Windows' == grains.os %}

Brave Browser is installed:
  chocolatey.installed:
    - name: {{ brave._pkg.name }}
    - pre_versions: {{ brave._pkg.pre }}
{%- else %}

Brave Browser is installed:
  pkg.installed:
    - name: {{ brave._pkg.name }}
{%- endif %}

Brave Browser setup is completed:
  test.nop:
    - name: Hooray, Brave Browser setup has finished.
    - require:
      - Brave Browser is installed
