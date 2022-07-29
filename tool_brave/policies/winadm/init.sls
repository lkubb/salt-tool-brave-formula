# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as brave with context %}

include:
  - {{ sls_package_install }}


# This will always attempt to reinstall templates. @FIXME

# https://support.google.com/chrome/a/answer/187202?ref_topic=9023406&hl=en#zippy=%2Clinux%2Cwindows
# https://dl.google.com/dl/edgedl/chrome/policy/policy_templates.zip

# This is intended to install the Brave Browser-specific files found in
# https://github.com/Prowler2/Brave-Browser-GPO-Policy

{%- if 'Windows' == grains.kernel %}

{%-   set temp = salt['temp.dir']() %}

Brave Browser Group Policy definitions are downloaded:
  archive.extracted:
    - name: {{ temp }}
    - source: {{ brave.lookup.win_gpo.source }}
{%-   if brave.lookup.win_gpo.get('source_hash') %}
    - source_hash: {{ brave.lookup.win_gpo.source_hash }}
{%-   else %}
    - skip_verify: true  # not recommended
{%-   endif %}
    - require:
      - {{ sls_package_install }}

Brave GPO ADMX file is installed:
  file.managed:
    - name: {{ brave.lookup.win_gpo.policy_dir | path_join('brave.admx') }}
    - source: {{ temp | path_join(brave.lookup.win_gpo.source_path, 'brave.admx') }}
    - win_owner: {{ brave.lookup.win_gpo.owner }}
    - require:
      - Brave Browser Group Policy definitions are downloaded

Brave GPO ADML file is installed:
  file.managed:
    - name: {{ brave.lookup.win_gpo.policy_dir | path_join(brave.lookup.win_gpo.lang, 'brave.adml') }}
    - source: {{ temp | path_join(brave.lookup.win_gpo.source_path, brave.lookup.win_gpo.lang, 'brave.adml') }}
    - win_owner: {{ brave.lookup.win_gpo.owner }}
    - require:
      - Brave GPO ADMX file is installed
{%-   endfor %}
{%- endif %}
