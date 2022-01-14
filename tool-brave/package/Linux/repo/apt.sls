{%- from 'tool-brave/map.jinja' import brave -%}

{#- rationale for signed-by directive (https://wiki.debian.org/DebianRepository/UseThirdParty):
        The reason we point to a file instead of a fingerprint is that the latter forces the user
        to add the key to the global SecureApt trust anchor in /etc/apt/trusted.gpg.d, which would
        cause the system to accept signatures from the third-party keyholder on all other
        repositories configured on the system that don't have a signed-by option
        (including the official Debian repositories).
-#}

{#- dev channel has been merged with beta
    see https://github.com/brave/brave-browser/wiki/Brave-Release-Schedule
 -#}

Ensure Debian repositories can be managed by tool-brave:
  pkg.installed:
    - pkgs:
      - python-apt

{%- if 'stable' == brave.version %}

Brave Browser signing key is available:
  file.managed:
    - name: /usr/share/keyrings/brave-browser-archive-keyring.gpg
    - source:
      - salt://tool-brave/package/Linux/files/brave-browser-archive-keyring.gpg # currently
      - https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    - source_hash: 48b3ec34ec0a874126c559eaff94602aab8b1f25b4312a368676ab08380ee236 # currently
    - user: root
    - group: {{ salt['user.primary_group']('root') }}
    - mode: '0644'
    - dir_mode: '0755'
    - makedirs: true

Brave Browser apt repository is available:
  pkgrepo.managed:
    - humanname: Brave Browser
    - name: deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main
    - file: /etc/apt/sources.list.d/brave-browser-release.list
    - require:
      - Brave Browser signing key is available

{%- elif 'beta' == brave.version %}

Brave Browser Beta signing key is available:
  file.managed:
    - name: /usr/share/keyrings/brave-browser-beta-keyring.gpg
    - source:
      - salt://tool-brave/package/Linux/files/brave-browser-beta-keyring.gpg # currently
      - https://brave-browser-apt-beta.s3.brave.com/brave-browser-beta-archive-keyring.gpg
    - source_hash: ea6c27e9d8bf6f899014a9cb014741b2d874180f5eebcf899b98e79b7c87f05e # currently
    - user: root
    - group: {{ salt['user.primary_group']('root') }}
    - mode: '0644'
    - dir_mode: '0755'
    - makedirs: true

Brave Browser Beta apt repository is available:
  pkgrepo.managed:
    - humanname: Brave Browser Beta
    - name: deb [signed-by=/usr/share/keyrings/brave-browser-beta-keyring.gpg arch=amd64] https://brave-browser-apt-beta.s3.brave.com/ stable main
    - file: /etc/apt/sources.list.d/brave-browser-beta.list
    - require:
      - Brave Browser Beta signing key is available

{%- elif 'nightly' == brave.version %}

Brave Browser Nightly signing key is available:
  file.managed:
    - name: /usr/share/keyrings/brave-browser-nightly-keyring.gpg
    - source:
      - salt://tool-brave/package/Linux/files/brave-browser-nightly-keyring.gpg # currently (same as beta)
      - https://brave-browser-apt-nightly.s3.brave.com/brave-browser-nightly-archive-keyring.gpg
    - source_hash: ea6c27e9d8bf6f899014a9cb014741b2d874180f5eebcf899b98e79b7c87f05e # currently (same as beta)
    - user: root
    - group: {{ salt['user.primary_group']('root') }}
    - mode: '0644'
    - dir_mode: '0755'
    - makedirs: true

Brave Browser Nightly apt repository is available:
  pkgrepo.managed:
    - humanname: Brave Browser Nightly
    - name: deb [signed-by=/usr/share/keyrings/brave-browser-nightly-keyring.gpg arch=amd64] https://brave-browser-apt-nightly.s3.brave.com/ stable main
    - file: /etc/apt/sources.list.d/brave-browser-nightly.list
    - require:
      - Brave Browser Nightly signing key is available

{%- endif %}
