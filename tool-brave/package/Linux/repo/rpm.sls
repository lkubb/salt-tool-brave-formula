{%- from 'tool-brave/map.jinja' import brave -%}

{#- dev channel has been merged with beta
    see https://github.com/brave/brave-browser/wiki/Brave-Release-Schedule
 -#}

{%- if 'stable' == brave.version %}

Brave Browser RPM repository is available:
  pkgrepo.managed:
    - humanname: Brave Browser
    - name: brave-browser-rpm-release.s3.brave.com_x86_64_
    - baseurl: https://brave-browser-rpm-release.s3.brave.com/x86_64/
    - key_url: https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
    - gpgcheck: 1

{%- elif 'beta' == brave.version %}

Brave Browser RPM repository is available:
  pkgrepo.managed:
    - humanname: Brave Browser Beta
    - name: brave-browser-rpm-beta.s3.brave.com_x86_64_
    - baseurl: https://brave-browser-rpm-beta.s3.brave.com/x86_64/
    - key_url: https://brave-browser-rpm-beta.s3.brave.com/brave-core-nightly.asc
    - gpgcheck: 1

{%- elif 'nightly' == brave.version %}

Brave Browser RPM repository is available:
  pkgrepo.managed:
    - humanname: Brave Browser Nightly
    - name: brave-browser-rpm-nightly.s3.brave.com_x86_64_
    - baseurl: https://brave-browser-rpm-nightly.s3.brave.com/x86_64/
    - key_url: https://brave-browser-rpm-nightly.s3.brave.com/brave-core-nightly.asc
    - gpgcheck: 1

{%- endif %}
