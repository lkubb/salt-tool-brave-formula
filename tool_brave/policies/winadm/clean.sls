# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as brave with context %}


{%- if 'Windows' == grains.kernel %}

Brave GPO ADMX file is absent:
  file.absent:
    - name: {{ brave.lookup.win_gpo.policy_dir | path_join('brave.admx') }}

Brave GPO ADML file is absent:
  file.absent:
    - name: {{ brave.lookup.win_gpo.policy_dir | path_join(brave.lookup.win_gpo.lang, 'brave.adml') }}
{%-   endfor %}
{%- endif %}
