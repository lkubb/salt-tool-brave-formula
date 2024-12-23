# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as brave with context %}
{%- from tplroot ~ "/libtofsstack.jinja" import files_switch with context %}


{%- if brave.get("_local_extensions") and brave.extensions.local.sync %}

Requested local Brave Browser extensions are synced:
  file.managed:
    - names:
{%-   for extension in brave._local_extensions %}
      - {{ brave.extensions.local.source | path_join(extension ~ ".crx") }}:
        - source: {{ files_switch(
                        [extension ~ ".crx"],
                        lookup="Requested local Brave Browser extension {} is synced".format(extension),
                        config=brave,
                        path_prefix=tplroot ~ "/extensions",
                     )
                  }}
{%-   endfor %}
    - mode: '0644'
    - user: root
    - group: {{ brave.lookup.rootgroup }}
    - makedirs: true

Local Brave Browser extension update file contains current versions:
  file.managed:
    - name: {{ brave.extensions.local.source | path_join("update") }}
    - source: {{ files_switch(
                    ["update"],
                    lookup="Local Brave Browser extension update file contains current versions",
                    config=chromium,
                 )
              }}
    - template: jinja
    - context:
        local_source: {{ brave.extensions.local.source }}
        extensions: {{ brave._local_extensions | json }}
    - mode: '0644'
    - user: root
    - group: {{ brave.lookup.rootgroup }}
    - require:
      - Requested local Brave Browser extensions are synced
{%- endif %}
