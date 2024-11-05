# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as brave with context %}


{%- if brave.get("_local_extensions") and brave.extensions.local.sync %}

Synced local Brave Browser extensions are absent:
  file.absent:
    - names:
{%-   for extension in brave._local_extensions %}
      - {{ brave.extensions.local.source | path_join(extension ~ ".crx") }}
{%-   endfor %}
      - {{ brave.extensions.local.source | path_join("update") }}
{%- endif %}
