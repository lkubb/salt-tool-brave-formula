{%- from 'tool-brave/map.jinja' import brave -%}

{%- load_yaml as gpo -%}
lang: {{ brave.win_gpo_lang | default('en_US') }}
dir: {{ brave.win_gpo_policy_dir | default('C:/Windows/PolicyDefinitions') }}
owner: {{ brave.win_gpo_owner | default('Administrators') }}
source: {{ brave.win_gpo_source | default('salt://tool-brave/policies/files/gpo/Policy Templates/v97.0.4692.71') }}
hashes: {{ brave.win_gpo_hashes | default({}) }}
{%- endload -%}


# https://support.google.com/chrome/a/answer/187202?ref_topic=9023406&hl=en#zippy=%2Clinux%2Cwindows
# https://dl.google.com/dl/edgedl/chrome/policy/policy_templates.zip

{%- if 'Windows' == grains.kernel %}

Brave Browser GPO ADMX file is installed:
  file.managed:
    - name: {{ gpo.dir }}/brave.admx
    - source: {{ gpo.source }}/brave.admx
  {%- if gpo.get('hashes', {}).get('admx') %}
    - source_hash: {{ gpo.hashes.admx }}
  {%- else %}
    - skip_verify: True
  {%- endif %}
    - win_owner: {{ gpo.owner }}

Brave Browser GPO ADML file is installed:
  file.managed:
    - name: {{ gpo.dir }}/{{ gpo.lang }}/brave.adml
    - source: {{ gpo.source }}/brave.adml
  {%- if gpo.get('hashes', {}).get('adml') %}
    - source_hash: {{ gpo.hashes.adml }}
  {%- else %}
    - skip_verify: True
  {%- endif %}
    - win_owner: {{ gpo.owner }}
{%- endif %}
