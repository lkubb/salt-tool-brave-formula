{%- from 'tool-brave/map.jinja' import brave -%}

{#- dev channel has been merged with beta
    see https://github.com/brave/brave-browser/wiki/Brave-Release-Schedule
 -#}

{#- prereleases need --pre flag on Windows -#}
{%- set pkg = salt['match.filter_by']({
  'stable': {
    'name': 'brave',
    'pre': False
  },
  'beta': {
    'name': 'brave',
    'pre': True,
  },
  'nightly': {
    'name': 'brave-nightly',
    'pre': True,
  }}, minion_id=brave.version) -%}


Brave Browser is installed:
  chocolatey.installed:
    - name: {{ pkg.name }}
    - pre_versions: {{ pkg.pre }}

Brave Browser setup is completed:
  test.nop:
    - name: Brave Browser setup has finished, hooray.
    - require:
      - chocolatey: {{ pkg.name }}
