{%- from 'tool-brave/map.jinja' import brave -%}

{%- if brave.get('_local_extensions') and brave.get('ext_local_source_sync', True) %}
Requested local Brave Browser extensions are synced:
  file.managed:
    - names:
  {%- for extension in brave._local_extensions %}
      - {{ brave.ext_local_source}}/{{ extension }}.crx:
        - source: salt://tool-brave/files/extensions/{{ extension }}.crx
  {%- endfor %}
    - mode: '0644'
    - user: root
    - group: {{ salt['user.primary_group']('root') }}
    - makedirs: true

Local Brave Browser extension update file contains current versions:
  file.managed:
    - name: {{ brave.ext_local_source}}/update
    - source: salt://tool-brave/policies/files/update
    - template: jinja
    - context:
        local_source: {{ brave.ext_local_source }}
        extensions: {{ brave._local_extensions | json }}
    - user: root
    - group: {{ salt['user.primary_group']('root') }}
    - mode: '0644'
{%- endif %}
