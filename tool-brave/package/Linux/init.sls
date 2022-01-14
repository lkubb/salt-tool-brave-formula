{%- from 'tool-brave/map.jinja' import brave -%}

{#- dev channel has been merged with beta
    see https://github.com/brave/brave-browser/wiki/Brave-Release-Schedule
 -#}

{%- set pkg = salt['match.filter_by']({
  'stable': 'brave-browser',
  'beta': 'brave-browser-beta',
  'nightly': 'brave-browser-nightly',
  }, minion_id=brave.version) -%}

include:
  - .repo

Brave Browser is installed:
  pkg.installed:
    - name: {{ pkg }}
    - refresh: true

Brave Browser setup is completed:
  test.nop:
    - name: Brave Browser setup has finished, hooray.
    - require:
      - pkg: {{ pkg }}
