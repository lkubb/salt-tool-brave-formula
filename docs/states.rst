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



