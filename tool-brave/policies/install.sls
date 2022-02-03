{%- from 'tool-brave/map.jinja' import brave -%}

include:
  - .synclocalexts
{%- if 'Windows' == grains.kernel %}
  - .winadm

Brave Browser forced policies are applied as Group Policy:
  lgpo.set:
    - computer_policy: {{ brave._policies.forced | json }}
    - adml_language: {{ brave.win_gpo_lang | default('en_US') }}
    - require:
      - sls: {{ slsdotpath }}.winadm
      - sls: {{ slsdotpath }}.synclocaladdons

Brave Browser recommended policies are applied as Group Policy:
  lgpo.set:
    - user_policy: {{ brave._policies.recommended | json }}
    - adml_language: {{ brave.win_gpo_lang | default('en_US') }}
    - require:
      - sls: {{ slsdotpath }}.winadm
      - sls: {{ slsdotpath }}.synclocaladdons

Group policies are updated:
  cmd.run:
    - name: gpupdate /wait:0
    - onchanges:
      - Brave Browser forced policies are applied as Group Policy
      - Brave Browser recommended policies are applied as Group Policy

{%- elif 'Darwin' == grains.kernel %}

Brave Browser forced policies are applied as profile:
  macprofile.installed:
    - name: salt.tool.com.brave.Browser
    - description: brave default configuration managed by Salt state tool-brave.policies
    - organization: salt.tool
    - removaldisallowed: False
    - ptype: com.brave.Browser
    - content:
      - {{ brave._policies.forced | json }}

Brave Browser recommended policies are applied as plist:
  file.serialize:
    - name: /Library/Preferences/com.brave.Browser.plist
    - serializer: plist
    - merge_if_exists: True
    - user: root
    - group: {{ salt['user.primary_group']('root') }}
    - mode: '0644'
    - dataset: {{ brave._policies.recommended | json }}

MacOS plist cache is updated for Brave:
  cmd.run:
    - name: defaults read /Library/Preferences/com.brave.Browser.plist
    - onchanges:
      - Brave Browser recommended policies are applied as plist

{%- else %}

Brave Browser enforced policies are synced to json file:
  file.serialize:
    - name: /etc/brave/policies/managed/salt_tool_managed_policies.json
    - dataset: {{ brave._policies.enforced | json }}
    - serializer: json
    - makedirs: true
    - user: root
    - group: root
    - mode: '0644'

Brave Browser recommended policies are synced to json file:
  file.serialize:
    - name: /etc/brave/policies/recommended/salt_tool_recommended_policies.json
    - dataset: {{ brave._policies.recommended | json }}
    - serializer: json
    - makedirs: true
    - user: root
    - group: root
    - mode: '0644'
{%- endif %}
