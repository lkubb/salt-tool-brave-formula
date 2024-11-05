# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as brave with context %}


{%- if grains.kernel == "Windows" %}

Brave GPO ADMX file is absent:
  file.absent:
    - name: {{ brave.lookup.win_gpo.policy_dir | path_join("brave.admx") }}

Brave GPO ADML file is absent:
  file.absent:
    - name: {{ brave.lookup.win_gpo.policy_dir | path_join(brave.lookup.win_gpo.lang, "brave.adml") }}
{%-   endfor %}
{%- endif %}
