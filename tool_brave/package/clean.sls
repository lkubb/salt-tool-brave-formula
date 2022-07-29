# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as brave with context %}


{%- if 'Windows' == grains.os %}

Brave Browser is removed:
  chocolatey.uninstalled:
    - name: {{ brave._pkg.name }}
    - pre_versions: {{ brave._pkg.pre }}
{%- else %}

Brave Browser is removed:
  pkg.removed:
    - name: {{ brave._pkg.name }}
{%- endif %}
