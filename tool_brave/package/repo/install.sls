# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as brave with context %}
{%- from tplroot ~ "/libtofsstack.jinja" import files_switch with context %}


{%- if grains.os in ["Debian", "Ubuntu"] %}

Ensure Brave Browser APT repository can be managed:
  pkg.installed:
    - pkgs:
      - python-apt                    # required by Salt
{%-   if grains.os == "Ubuntu" %}
      - python-software-properties    # to better support PPA repositories
{%-   endif %}
{%- endif %}

{%- for reponame in brave.lookup.pkg.enablerepo %}

{%-   if brave.lookup.pkg.manager == "apt" %}

Brave Browser {{ reponame }} signing key is available:
  file.managed:
    - name: {{ brave.lookup.pkg.repos[reponame].keyring.file }}
    - source: {{ (
                    files_switch(
                      [salt["file.basename"](brave.lookup.pkg.repos[reponame].keyring.file)],
                      lookup="Brave Browser {} signing key is available".format(reponame),
                      config=brave,
                    ) | load_json + [brave.lookup.pkg.repos[reponame].keyring.source]
                 ) | json
              }}
    - source_hash: {{ brave.lookup.pkg.repos[reponame].keyring.source_hash }}
    - user: root
    - group: {{ brave.lookup.rootgroup }}
    - mode: '0644'
    - dir_mode: '0755'
    - makedirs: true
{%-   endif %}

Brave Browser {{ reponame }} repository is available:
  pkgrepo.managed:
{%-   for conf, val in brave.lookup.pkg.repos[reponame].items() %}
{%-     if conf != "keyring" %}
    - {{ conf }}: {{ val }}
{%-     endif %}
{%-   endfor %}
{%-   if brave.lookup.pkg.manager in ["dnf", "yum", "zypper"] %}
    - enabled: 1
{%-   endif %}
    - require_in:
      - Brave Browser is installed
{%- endfor %}

{%- for reponame, repodata in brave.lookup.pkg.repos.items() %}

{%-   if reponame not in brave.lookup.pkg.enablerepo %}
Brave Browser {{ reponame }} repository is disabled:
  pkgrepo.absent:
{%-     for conf in ["name", "ppa", "ppa_auth", "keyid", "keyid_ppa", "copr"] %}
{%-       if conf in repodata %}
    - {{ conf }}: {{ repodata[conf] }}
{%-       endif %}
{%-     endfor %}
    - require_in:
      - Brave Browser is installed

{%-     if brave.lookup.pkg.manager == "apt" %}

Brave Browser {{ reponame }} signing key is absent:
  file.absent:
    - name: {{ brave.lookup.pkg.repos[reponame].keyring.file }}
{%-     endif %}
{%-   endif %}
{%- endfor %}
