{%- from 'tool-brave/map.jinja' import brave -%}

{%- if brave.users | selectattr('brave.flags', 'defined') | list %}
include:
  - .active
{%- endif %}
