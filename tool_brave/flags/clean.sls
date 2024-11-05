# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as brave with context %}


{%- for user in brave.users | selectattr("brave.flags", "defined") %}

Brave Browser flags are inactive for user {{ user.name }}:
  file.serialize:
    - name: {{ user._brave.confdir | path_join("Local State") }}
    - serializer: json
    - merge_if_exists: true
    - dataset: {{ {"browser": {"enabled_labs_experiments": []} } |  json }}
    - mode: '0600'
    - user: {{ user.name }}
    - group: {{ user.group }}
    - onlyif:
      - test -e '{{ user._brave.confdir | path_join("Local State") }}'
{%- endfor %}
