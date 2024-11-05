# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as brave with context %}

{%- set require_local_sync = brave.get("_local_extensions") | to_bool
                         and brave.extensions.local.sync | to_bool %}

{%- if grains.kernel == "Windows" or require_local_sync %}

include:
{%-   if require_local_sync %}
  - {{ tplroot }}.local_extensions
{%-   endif %}
{%-   if grains.kernel == "Windows" %}
  - {{ slsdotpath }}.winadm
{%-   endif %}
{%- endif %}


{%- if brave.get("_policies") %}
{%-   if grains.kernel == "Windows" %}
{%-     if brave._policies.get("forced") %}

Brave Browser forced policies are applied as Group Policy:
  lgpo.set:
    - computer_policy: {{ brave._policies.forced | json }}
    - adml_language: {{ brave.lookup.win_gpo.lang }}
    - watch_in:
      - Group policies are updated
    - require:
      - sls: {{ slsdotpath }}.winadm
{%-       if require_local_sync %}
      - sls: {{ tplroot }}.local_extensions
{%-       endif %}
{%-     endif %}

{%-     if brave._policies.get("recommended") %}

Brave Browser recommended policies are applied as Group Policy:
  lgpo.set:
    - user_policy: {{ brave._policies.recommended | json }}
    - adml_language: {{ brave.lookup.win_gpo.lang }}
    - watch_in:
      - Group policies are updated
    - require:
      - sls: {{ slsdotpath }}.winadm
{%-       if require_local_sync %}
      - sls: {{ tplroot }}.local_extensions
{%-       endif %}
{%-     endif %}

Group policies are updated (Brave):
  cmd.wait:  # noqua 123
    - name: gpupdate /wait:0
    - watch: []

{%-   elif grains.kernel == "Darwin" %}
{%-     if brave._policies.get("forced") %}

Brave Browser forced policies are applied as profile:
  macprofile.installed:
    - name: salt.tool.com.brave.Browser
    - displayname: Brave Browser configuration (salt-tool)
    - description: brave default configuration managed by Salt state tool_brave.policies
    - organization: salt.tool
    - removaldisallowed: false
    - ptype: com.brave.Browser
    - content:
      - {{ brave._policies.forced | json }}
{%-       if require_local_sync %}
    - require:
      - sls: {{ tplroot }}.local_extensions
{%-       endif %}
{%-     endif %}

{%-     if brave._policies.get("recommended") %}

Brave Browser recommended policies are applied as plist:
  file.serialize:
    - name: /Library/Preferences/com.brave.Browser.plist
    - serializer: plist
    - merge_if_exists: true
    - user: root
    - group: {{ brave.lookup.rootgroup }}
    - mode: '0644'
    - dataset: {{ brave._policies.recommended | json }}
{%-       if require_local_sync %}
    - require:
      - sls: {{ tplroot }}.local_extensions
{%-       endif %}

MacOS plist cache is updated (Brave):
  cmd.run:
    - name: defaults read /Library/Preferences/com.brave.Browser.plist
    - onchanges:
      - Brave Browser recommended policies are applied as plist
{%-     endif %}

{%-   else %}
{%-     if brave._policies.get("forced") %}

Brave Browser enforced policies are synced to json file:
  file.serialize:
    - name: /etc/brave/policies/managed/salt_tool_managed_policies.json
    - dataset: {{ brave._policies.forced | json }}
    - serializer: json
    - makedirs: true
    - user: root
    - group: {{ brave.lookup.rootgroup }}
    - mode: '0644'
{%-       if require_local_sync %}
    - require:
      - sls: {{ tplroot }}.local_extensions
{%-       endif %}
{%-     endif %}

{%-     if brave._policies.get("recommended") %}

Brave Browser recommended policies are synced to json file:
  file.serialize:
    - name: /etc/brave/policies/recommended/salt_tool_recommended_policies.json
    - dataset: {{ brave._policies.recommended | json }}
    - serializer: json
    - makedirs: true
    - user: root
    - group: {{ brave.lookup.rootgroup }}
    - mode: '0644'
{%-       if require_local_sync %}
    - require:
      - sls: {{ tplroot }}.local_extensions
{%-       endif %}
{%-     endif %}
{%-   endif %}
{%- endif %}
