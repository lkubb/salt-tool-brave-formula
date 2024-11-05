# vim: ft=yaml
# yamllint disable rule:comments-indentation
---
tool_global:
  users:
    user:
      completions: .completions
      configsync: true
      persistenv: .bash_profile
      rchook: .bashrc
      xdg: true
      brave:
        flags:
          - disable-accelerated-2d-canvas
          - enable-javascript-harmony
          - enable-webrtc-hide-local-ips-with-mdns@1
tool_brave:
  lookup:
    master: template-master
    # Just for testing purposes
    winner: lookup
    added_in_lookup: lookup_value

    pkg:
      name: brave-browser
      enable_repo:
        - stable
    paths:
      confdir: '.config/brave-browser'
      conffile: 'config'
  extensions:
    absent:
      - tampermonkey
    defaults:
      installation_mode: normal_installed
      override_update_url: false
      update_url: https://clients2.google.com/service/update2/crx
    forced: true
    local:
      source: /opt/brave_extensions
      sync: true
    wanted:
      - bitwarden
      - ublock-origin:
          installation_mode: force_installed
          runtime_blocked_hosts:
            - '*://*.supersensitive.bank'
      - metamask:
          blocked_permissions:
            - geolocation
          local: true
          local_version: 10.8.1
          toolbar_pin: force_pinned
  policies:
    forced:
      SSLErrorOverrideAllowed: false
      SSLVersionMin: tls1.2
    recommended:
      AutofillCreditCardEnabled: false
      BlockThirdPartyCookies: true
      BookmarkBarEnabled: true
      BrowserNetworkTimeQueriesEnabled: false
      BrowserSignin: 0
      BuiltInDnsClientEnabled: false
      IPFSEnabled: true
      MetricsReportingEnabled: false
      PromotionalTabsEnabled: false
      SafeBrowsingExtendedReportingEnabled: false
      SearchSuggestEnabled: false
      ShowFullUrlsInAddressBar: true
      SyncDisabled: true
      TorDisabled: false
      UrlKeyedAnonymizedDataCollectionEnabled: false
      UserFeedbackAllowed: false
  version: stable

  tofs:
    # The files_switch key serves as a selector for alternative
    # directories under the formula files directory. See TOFS pattern
    # doc for more info.
    # Note: Any value not evaluated by `config.get` will be used literally.
    # This can be used to set custom paths, as many levels deep as required.
    files_switch:
      - any/path/can/be/used/here
      - id
      - roles
      - osfinger
      - os
      - os_family
    # All aspects of path/file resolution are customisable using the options below.
    # This is unnecessary in most cases; there are sensible defaults.
    # Default path: salt://< path_prefix >/< dirs.files >/< dirs.default >
    #         I.e.: salt://tool_brave/files/default
    # path_prefix: template_alt
    # dirs:
    #   files: files_alt
    #   default: default_alt
    # The entries under `source_files` are prepended to the default source files
    # given for the state
    # source_files:
    #   tool-brave-config-file-file-managed:
    #     - 'example_alt.tmpl'
    #     - 'example_alt.tmpl.jinja'

  # Just for testing purposes
  winner: pillar
  added_in_pillar: pillar_value
