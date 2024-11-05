# vim: ft=sls

{#-
    This state will install the configured Brave Browser repository.
    This works for apt/dnf/yum/zypper-based distributions only by default.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as brave with context %}

include:
{%- if brave.lookup.pkg.manager in ["apt", "dnf", "yum", "zypper"] %}
  - {{ slsdotpath }}.install
{%- elif salt["state.sls_exists"](slsdotpath ~ "." ~ brave.lookup.pkg.manager) %}
  - {{ slsdotpath }}.{{ brave.lookup.pkg.manager }}
{%- else %}
  []
{%- endif %}
