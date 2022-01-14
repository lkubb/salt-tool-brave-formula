# Brave Browser Formula
Sets up, configures and updates Brave Browser.

## Usage
Applying `tool-brave` will make sure `brave` is configured as specified.

### Differences From Google Chrome Formula
This formula mostly behaves exactly like tool-chrome. One exception is Brave Browser's rather **obtrusive behavior** on the first startup asking if you want to make it your default browser - when you kill the application, the application popup will transform into a system popup instead of vanish (wtf – on MacOS, at least). This made me reconsider writing this formula for a moment (ie, stopped me from using Brave Browser). Please don't get on my nerves. Killing the application should be taken as a sign. [This](https://github.com/brave/brave-browser/issues/12203) [was](https://community.brave.com/t/stop-brave-asking-to-be-my-default-browser/212793/5) [supposedly](https://community.brave.com/t/how-to-disable-default-browser-check/213614) [even](https://github.com/brave/brave-browser/issues/14502) [worse](https://github.com/brave/brave-browser/issues/14469) on initial launch of this feature. Why not ask nicely inside the window like every other browser instead of a blocking popup?

This will only manifest during the run of this formula if you specify flags (because the default profile needs to have been generated to add them).

### Brave Browser Specifics
#### Group Policies
There are [no official GPO ADML/X templates](https://github.com/Prowler2/Brave-Browser-GPO-Policy) for Windows currently. The inofficial ones have been added to this formula as a submodule, which will [not work with GitFS currently](https://github.com/saltstack/salt/issues/13664). Make sure to provide them.

In addition to default Chromium settings, Brave Browser also supports the following policy settings:
- TorDisabled
- IPFSEnabled

## Configuration
### Pillar
#### General `tool` architecture
Since installing user environments is not the primary use case for saltstack, the architecture is currently a bit awkward. All `tool` formulas assume running as root. There are three scopes of configuration:
1. per-user `tool`-specific
  > e.g. generally force usage of XDG dirs in `tool` formulas for this user
2. per-user formula-specific
  > e.g. setup this tool with the following configuration values for this user
3. global formula-specific (All formulas will accept `defaults` for `users:username:formula` default values in this scope as well.)
  > e.g. setup system-wide configuration files like this

**3** goes into `tool:formula` (e.g. `tool:git`). Both user scopes (**1**+**2**) are mixed per user in `users`. `users` can be defined in `tool:users` and/or `tool:formula:users`, the latter taking precedence. (**1**) is namespaced directly under `username`, (**2**) is namespaced under `username: {formula: {}}`.

```yaml
tool:
######### user-scope 1+2 #########
  users:                         #
    username:                    #
      xdg: true                  #
      dotconfig: true            #
      formula:                   #
        config: value            #
####### user-scope 1+2 end #######
  formula:
    formulaspecificstuff:
      conf: val
    defaults:
      yetanotherconfig: somevalue
######### user-scope 1+2 #########
    users:                       #
      username:                  #
        xdg: false               #
        formula:                 #
          otherconfig: otherval  #
####### user-scope 1+2 end #######
```

#### User-specific
The following shows an example of `tool-brave` pillar configuration. Namespace it to `tool:users` and/or `tool:brave:users`.
```yaml
user:
  brave:
    flags:    # Enable Brave Browser flags via Local State file.
              # To find the correct syntax, it is best to set them
              # and look inside "Local State" (json) browser:enabled_labs_experiments.
              # chrome://version will show an overview of enabled flags in the cli version
              # chrome://flags shows available flags and highlights those different from default
              # mind that cli switches will not be detected on that page
      - disable-accelerated-2d-canvas
      - enable-javascript-harmony
      - enable-webrtc-hide-local-ips-with-mdns@1
```

#### Formula-specific
```yaml
tool:
  brave:
    version: stable                        # stable, beta, nightly (dev was merged with beta)
    # When using policies.json on Linux, there are two global policy directories, therefore these
    # settings have to be global there. User-specific settings with policies are possible on MacOS
    # afaik where policies are installed via a profile.
    #################################################################################################
    # provide default values for ExtensionSettings
    # see https://support.google.com/chrome/a/answer/9867568?hl=en&ref_topic=9023246
    ext_defaults:
      installation_mode: normal_installed # When not specified, use this extension installation mode by default.
      # Setting update_url to something different than specified in the extension's manifest.json
      # and enabling override of update url will cause even update requests (not just installation)
      # to be routed there instead of the official source. For local extensions, this is set automatically.
      override_update_url: False
      # If you want to update from another repo by default, specify it here.
      # For local extensions, this is set automatically.
      update_url: https://clients2.google.com/service/update2/crx 
    # This formula allows using extensions from the local file system.
    # Those extensions will not be updated automatically from the web. Since we simulate a local repo,
    # you will need to tell salt explicitly which version you're providing and need to change
    # the setting when you want to make Brave Browser aware the extension was updated on the next startup.
    ext_local_source: /some/path # when marking extensions as local, use this path to look for extension.crx by default
    ext_local_source_sync: true  # when using local source, sync extensions from salt://tool-brave/files/extensions (you should leave that on, unless you know what you're doing)
    ext_forced: false            # add parsed extension config to forced policies
    # List of extensions that are to be installed. When using policies, can also be specified there
    # manually, but this provides convenience. see tool-brave/policies/extensions for list of
    # available extensions
    extensions:
      - bitwarden
      # If you don't want the default extension settings for your policy, you can specify them
      # in a mapping like this:
      - ublock-origin:
          installation_mode: force_installed
          runtime_blocked_hosts:
            - '*://*.supersensitive.bank'
      # If you don't want an extension to be loaded from the Chrome Web Store (or can't),
      # but rather from a local directory specified in tool:brave:ext_local_source,
      # set local to true and make sure to provide e.g. metamask.crx in there. You will
      # also need to specify the extension version and change it when you update the file
      # to make Brave Browser aware of it.
      - metamask:
          local: true
          local_version: '10.8.1'
          blocked_permissions:
            - geolocation
          toolbar_pin: force_pinned
    # Specify global Brave Browser policies here. There are two types, managed (=forced) and
    # recommended (default, but modifiable by users)
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
        MetricsReportingEnabled: false
        PromotionalTabsEnabled: false
        SafeBrowsingExtendedReportingEnabled: false
        SearchSuggestEnabled: false
        ShowFullUrlsInAddressBar: true
        SyncDisabled: true
        UrlKeyedAnonymizedDataCollectionEnabled: false
        UserFeedbackAllowed: false
    # Windows-specific settings when using policies, defaults as seen below
    # To be able to use Group Policies, this formula needs to ensure the ADML/X templates are available.
    win_gpo_owner: Administrators
    win_gpo_policy_dir: C:/Windows/PolicyDefinitions
    win_gpo_lang: en_US
    # specify where to get AMDL/X templates from. expected:
    # brave.admx
    # <win_gpo_lang>
    # |
    # ----- brave.adml
    win_gpo_source: salt://tool-brave/policies/files/gpo/Policy Templates/v97.0.4692.71
    # specify the source hash to enable verification. by default, verification is skipped (not recommended)
    win_gpo_source_hash:
      admx: ef5592fe093595c48d728c19855b62431ab09cb66cfb08b1272a0ecaeba22299
      adml: 53b61f13c4c5b9492f0b56a625cafbe5dd5c544f9287288e36119ffd312c244c

    defaults:   # user-level defaults
      flags: []
```
