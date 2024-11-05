# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as brave with context %}

{%- set require_local_sync = brave.get("_local_extensions") | to_bool
                         and brave.extensions.local.sync | to_bool %}

{%- if grains.kernel == "Windows" or require_local_sync %}
include:
{%-   if require_local_sync %}
  - {{ tplroot }}.local_addons.clean
{%-   endif %}
{%-   if grains.kernel == "Windows" %}
  - {{ slsdotpath }}.winadm.clean
{%-   endif %}
{%- endif %}

{%- if grains.kernel == "Windows" %}

Brave Browser forced policies are removed from Group Policy:
  lgpo.set:
    - computer_policy: {}
    - adml_language: {{ brave.lookup.win_gpo.lang }}
    # this might very well not be allowed @FIXME
    - require_in:
      - sls: {{ slsdotpath }}.winadm.clean

Brave Browser recommended policies are removed from Group Policy:
  lgpo.set:
    - user_policy: {}
    - adml_language: {{ brave.lookup.win_gpo.lang }}
    # this might very well not be allowed @FIXME
    - require_in:
      - sls: {{ slsdotpath }}.winadm.clean

Group policies are updated (Brave):
  cmd.run:
    - name: gpupdate /wait:0
    - onchanges:
      - Brave Browser forced policies are removed from Group Policy
      - Brave Browser recommended policies are removed from Group Policy

{%- elif grains.kernel == "Darwin" %}

Brave Browser forced policy profile cannot be silently removed:
  test.show_notification:
    - text: >
        Salt cannot silently remove an installed system profile.
        You will need to do that manually. See
            System Preferences > Profiles

Brave Browser recommended policies are removed:
  file.absent:
    - name: /Library/Preferences/com.brave.Browser.plist
{%-   if require_local_sync %}
    - require:
      - sls: {{ tplroot }}.local_extensions.clean
{%-   endif %}

MacOS plist cache is updated (Brave):
  cmd.run:
    - name: defaults read /Library/Preferences/com.brave.Browser.plist
    - onchanges:
      - Brave Browser recommended policies are removed

{%- else %}

Brave Browser enforced policies are removed:
  file.absent:
    - name: /etc/brave/policies/managed/salt_tool_managed_policies.json

Brave Browser recommended policies are removed:
  file.absent:
    - name: /etc/brave/policies/recommended/salt_tool_recommended_policies.json
{%- endif %}
