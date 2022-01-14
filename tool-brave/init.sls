{%- from 'tool-brave/map.jinja' import brave -%}

include:
  - .package
{%- if brave.users | selectattr('brave.flags', 'defined') | list %}
  - .flags
{%- endif %}
{%- if brave.get('_policies') %}
  - .policies
{%- endif %}
