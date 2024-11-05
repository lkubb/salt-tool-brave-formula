# vim: ft=sls

{#-
    This state will remove the configured Brave Browser repository.
    This works for apt/dnf/yum/zypper-based distributions only by default.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as brave with context %}


{%- if brave.lookup.pkg.manager not in ["apt", "dnf", "yum", "zypper"] %}
{%-   if salt['state.sls_exists'](slsdotpath ~ "." ~ brave.lookup.pkg.manager ~ ".clean") %}

include:
  - {{ slsdotpath ~ "." ~ brave.lookup.pkg.manager ~ ".clean" }}
{%-   endif %}

{%- else %}


{%-   for reponame, repodata in brave.lookup.pkg.repos.items() %}

Brave Browser {{ reponame }} repository is absent:
  pkgrepo.absent:
{%-     for conf in ["name", "ppa", "ppa_auth", "keyid", "keyid_ppa", "copr"] %}
{%-       if conf in repodata %}
    - {{ conf }}: {{ repodata[conf] }}
{%-       endif %}
{%-     endfor %}

{%-     if 'apt' == brave.lookup.pkg.manager %}

Brave Browser {{ reponame }} signing key is absent:
  file.absent:
    - name: {{ brave.lookup.pkg.repos[reponame].keyring.file }}
{%-     endif %}
{%-   endfor %}
{%- endif %}
