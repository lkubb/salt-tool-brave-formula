{%- from 'tool-brave/map.jinja' import brave -%}

{#- dev channel has been merged with beta
    see https://github.com/brave/brave-browser/wiki/Brave-Release-Schedule
 -#}

{%- set pkg = salt['match.filter_by']({
  'stable': 'homebrew/cask/brave-browser',
  'beta': 'homebrew/cask-versions/brave-browser-beta',
  'nightly': 'homebrew/cask-versions/brave-browser-nightly',
  }, minion_id=brave.version) -%}

Brave Browser is installed:
  pkg.installed:
    - name: {{ pkg }}

Brave Browser setup is completed:
  test.nop:
    - name: Brave Browser setup has finished, hooray.
    - require:
      - pkg: {{ pkg }}
