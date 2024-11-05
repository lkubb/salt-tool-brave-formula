# vim: ft=sls

{#-
    *Meta-state*.

    Undoes everything performed in the ``tool_brave`` meta-state
    in reverse order.
#}

include:
  - .policies.clean
  - .flags.clean
  - .local_extensions.clean
  - .package.clean
