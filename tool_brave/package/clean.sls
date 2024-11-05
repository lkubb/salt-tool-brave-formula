# vim: ft=sls

{#-
    Removes the Brave Browser package.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as brave with context %}


{%- if grains.os == "Windows" %}

Brave Browser is removed:
  chocolatey.uninstalled:
    - name: {{ brave._pkg.name }}
    - pre_versions: {{ brave._pkg.pre }}
{%- else %}

Brave Browser is removed:
  pkg.removed:
    - name: {{ brave._pkg.name }}
{%- endif %}
