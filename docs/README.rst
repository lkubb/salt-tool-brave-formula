.. _readme:

Brave Browser Formula
=====================

Manages Brave Browser in the user environment.

.. contents:: **Table of Contents**
   :depth: 1

Usage
-----
Applying ``tool_brave`` will make sure ``brave`` is configured as specified.

Differences From Google Chrome Formula
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
This formula mostly behaves almost exactly like ``tool_chrome``. One exception is Brave Browser's rather **obtrusive behavior** on the first startup asking if you want to make it your default browser - when you kill the application, the application popup will transform into a system popup instead of vanish (wtf – on MacOS, at least). This made me reconsider writing this formula for a moment (ie, stopped me from using Brave Browser). Please don't get on my nerves. Killing the application should be taken as a sign. `This <https://github.com/brave/brave-browser/issues/12203>`_ `was <https://community.brave.com/t/stop-brave-asking-to-be-my-default-browser/212793/5>`_ `supposedly <https://community.brave.com/t/how-to-disable-default-browser-check/213614>`_ `even <https://github.com/brave/brave-browser/issues/14502>`_ `worse <https://github.com/brave/brave-browser/issues/14469>`_ on initial launch of this feature. Why not ask nicely inside the window like every other browser instead of a blocking popup?

This will only manifest during the run of this formula if you specify flags (because the default profile needs to have been generated to add them).

Brave Browser Specifics
~~~~~~~~~~~~~~~~~~~~~~~
Group Policies
^^^^^^^^^^^^^^
There are `no official GPO ADML/X templates <https://github.com/Prowler2/Brave-Browser-GPO-Policy>`_ for Windows currently. Some `inofficial ones <https://github.com/Prowler2/Brave-Browser-GPO-Policy>`_ have been added to the default configuration of this formula for Windows. The installation of those might break at any point and require some tweaks to the configuration. See ``tool_brave/parameters/os_family/Windows.yaml`` for details.

In addition to default Chromium settings, Brave Browser also supports the following policy settings:

* TorDisabled
* IPFSEnabled

Configuration
-------------

This formula
~~~~~~~~~~~~
The general configuration structure is in line with all other formulae from the `tool` suite, for details see :ref:`toolsuite`. An example pillar is provided, see :ref:`pillar.example`. Note that you do not need to specify everything by pillar. Often, it's much easier and less resource-heavy to use the ``parameters/<grain>/<value>.yaml`` files for non-sensitive settings. The underlying logic is explained in :ref:`map.jinja`.

User-specific
^^^^^^^^^^^^^
The following shows an example of ``tool_brave`` per-user configuration. If provided by pillar, namespace it to ``tool_global:users`` and/or ``tool_brave:users``. For the ``parameters`` YAML file variant, it needs to be nested under a ``values`` parent key. The YAML files are expected to be found in

1. ``salt://tool_brave/parameters/<grain>/<value>.yaml`` or
2. ``salt://tool_global/parameters/<grain>/<value>.yaml``.

.. code-block:: yaml

  user:

      # Force the usage of XDG directories for this user.
    xdg: true

      # Persist environment variables used by this formula for this
      # user to this file (will be appended to a file relative to $HOME)
    persistenv: '.config/zsh/zshenv'

      # Add runcom hooks specific to this formula to this file
      # for this user (will be appended to a file relative to $HOME)
    rchook: '.config/zsh/zshrc'

      # This user's configuration for this formula. Will be overridden by
      # user-specific configuration in `tool_brave:users`.
      # Set this to `false` to disable configuration for this user.
    brave:
        # Enable Brave Browser flags via Local State file. To find the correct syntax,
        # it is best to set them manually and look inside "Local State" (json)
        # `browser:enabled_labs_experiments`.
        # `chrome://version` will show an overview of enabled flags in the CLI variant
        # `chrome://flags` shows available flags and highlights
        # those different from default.
        # Mind that CLI switches will not be detected on that page.
      flags:
        - disable-accelerated-2d-canvas
        - enable-javascript-harmony
        - enable-webrtc-hide-local-ips-with-mdns@1

Formula-specific
^^^^^^^^^^^^^^^^

.. code-block:: yaml

  tool_brave:

      # Which Brave Browser version to install:
      # stable, beta, nightly
      # dev channel has been merged with beta, see
      # https://github.com/brave/brave-browser/wiki/Brave-Release-Schedule
    version: stable

    extensions:
        # List of extensions that should not be installed.
      absent:
        - tampermonkey
        # Defaults for extension installation settings
      defaults:
        installation_mode: normal_installed
        override_update_url: false
        update_url: https://clients2.google.com/service/update2/crx
        # add generated ExtensionSettings to forced policies
        # (necessary on MacOS at least)
      forced: true
        # This formula allows using extensions from the local file system.
        # Those extensions will not be updated automatically from the web.
      local:
          # When marking extensions as local, use this path on the minion to look for
          # `<extension>.crx` by default.
        source: /opt/brave_extensions
          # When using local source, sync extensions automatically from the fileserver.
          # You will need to provide the extensions as
          # `tool_brave/extensions/<tofs_grain>/<extension>.crx`
        sync: true
        # List of extensions that are to be installed. When using policies, can also
        # be specified there manually, but this provides convenience. See
        # `tool_brave/parameters/defaults.yaml` for a list of available extensions under
        # `lookup:extension_data`. Of course, you can also specify your own on top.
      wanted:
        - bitwarden
          # If you want to override defaults, you can specify them
          # in a mapping like this:
        - ublock-origin:
            installation_mode: force_installed
            runtime_blocked_hosts:
              - '*://*.supersensitive.bank'
          # If you don't want an extension to be loaded from the Chrome Web Store
          # (or it's unlisted there), but rather from a local directory specified in
          # `extensions:defaults:local_source`, set local to true and make sure to
          # provide e.g. `metamask.crx` in there.
          # Since we simulate a local repo, you will need to tell Salt explicitly
          # which version you're providing and need to change the value when you want to
          # make Brave Browser aware the extension was updated on the next startup.
        - metamask:
            blocked_permissions:
              - geolocation
            local: true
            local_version: 10.8.1
            toolbar_pin: force_pinned

      # This is where you specify enterprise policies.
      # See https://chromeenterprise.google/policies/ and
      # https://support.brave.com/hc/en-us/articles/360039248271-Group-Policy
      # for available settings.
    policies:
        # These policies are installed as forced, i.e. cannot be changed
        # by the user. On MacOS at least, this is where ExtensionSettings
        # has to be specified to take effect.
      forced:
        SSLErrorOverrideAllowed: false
        SSLVersionMin: tls1.2
        # These policies are installed as recommended, i.e. only provide
        # default values.
      recommended:
        AutofillCreditCardEnabled: false
        BlockThirdPartyCookies: true
        BookmarkBarEnabled: true
        BrowserNetworkTimeQueriesEnabled: false
        BrowserSignin: 0
        BuiltInDnsClientEnabled: false
          # This one is Brave Browser-specific.
        IPFSEnabled: true
        MetricsReportingEnabled: false
        PromotionalTabsEnabled: false
        SafeBrowsingExtendedReportingEnabled: false
        SearchSuggestEnabled: false
        ShowFullUrlsInAddressBar: true
        SyncDisabled: true
          # This one is Brave Browser-specific.
        TorDisabled: false
        UrlKeyedAnonymizedDataCollectionEnabled: false
        UserFeedbackAllowed: false

      # Default formula configuration for all users.
    defaults:
      flags: default value for all users


Available states
----------------

The following states are found in this formula:

.. contents::
   :local:


``tool_brave``
~~~~~~~~~~~~~~
*Meta-state*.

Performs all operations described in this formula according to the specified configuration.


``tool_brave.package``
~~~~~~~~~~~~~~~~~~~~~~
Installs the Brave Browser package only.


``tool_brave.package.repo``
~~~~~~~~~~~~~~~~~~~~~~~~~~~
This state will install the configured Brave Browser repository.
This works for apt/dnf/yum/zypper-based distributions only by default.


``tool_brave.local_extensions``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



``tool_brave.flags``
~~~~~~~~~~~~~~~~~~~~



``tool_brave.policies``
~~~~~~~~~~~~~~~~~~~~~~~



``tool_brave.policies.winadm``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



``tool_brave.default_profile``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



``tool_brave.clean``
~~~~~~~~~~~~~~~~~~~~
*Meta-state*.

Undoes everything performed in the ``tool_brave`` meta-state
in reverse order.


``tool_brave.package.clean``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Removes the Brave Browser package.


``tool_brave.package.repo.clean``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
This state will remove the configured Brave Browser repository.
This works for apt/dnf/yum/zypper-based distributions only by default.


``tool_brave.local_extensions.clean``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



``tool_brave.flags.clean``
~~~~~~~~~~~~~~~~~~~~~~~~~~



``tool_brave.policies.clean``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



``tool_brave.policies.winadm.clean``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~




Development
-----------

Contributing to this repo
~~~~~~~~~~~~~~~~~~~~~~~~~

Commit messages
^^^^^^^^^^^^^^^

Commit message formatting is significant.

Please see `How to contribute <https://github.com/saltstack-formulas/.github/blob/master/CONTRIBUTING.rst>`_ for more details.

pre-commit
^^^^^^^^^^

`pre-commit <https://pre-commit.com/>`_ is configured for this formula, which you may optionally use to ease the steps involved in submitting your changes.
First install  the ``pre-commit`` package manager using the appropriate `method <https://pre-commit.com/#installation>`_, then run ``bin/install-hooks`` and
now ``pre-commit`` will run automatically on each ``git commit``.

.. code-block:: console

  $ bin/install-hooks
  pre-commit installed at .git/hooks/pre-commit
  pre-commit installed at .git/hooks/commit-msg

State documentation
~~~~~~~~~~~~~~~~~~~
There is a script that semi-autodocuments available states: ``bin/slsdoc``.

If a ``.sls`` file begins with a Jinja comment, it will dump that into the docs. It can be configured differently depending on the formula. See the script source code for details currently.

This means if you feel a state should be documented, make sure to write a comment explaining it.
