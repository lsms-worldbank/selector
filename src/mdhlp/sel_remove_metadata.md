# Title

__sel_remove_metadata__ - Clean up metadata only needed during cleaning

# Syntax

__sel_remove_metadata__ , [__**c**har__(_string_) __**miss**charok__]

| _options_ | Description |
|-----------|-------------|
| __**c**har__(_string_)   | Manually add chars to be removed. |
| __**miss**charok__ | Suppress error when __chars()__ is not used and no list of chars in chars.

# Description

This command clean up meta data in `char` storage.
The intended use case is to clean up `char` values after the cleaning stage
that were only needed during that stage,
but the command can of course be used to clean up `char` values in any context.

If the `char` values the should be removed was added by the command
`sel_add_metadata` in the same package as this command,
the the user do not need to list any `char` names.
`sel_add_metadata` stores a list of the name of the chars it adds in a `char`.
This command will use that list to know which chars should be deleted.

The option `char()` is only required when
removing chars not added by `sel_add_metadata`.

# Options
<!-- Longer description (paragraph length) of all options, their intended use case and best practices related to them. -->

__**c**har__(_string_) allows the user to manually add chars to be removed.
If the chars to be removed were added by `sel_add_metadata`,
then this option is not required as `sel_remove_metadata` can read what chars  
that was added by `sel_add_metadata`. If other custom chars were added by the user or other commands and should also be removed, then this option is required.

__**miss**__ suppresses the error that is thrown when
no chars to remove was provided. Neither through the option `char()` or
in meta data written by `sel_add_metadata`

# Examples

## Example 1

If the meta data to be removed was added by `sel_add_metadata` then
this command can be specified as simply as this:

```
  sel_remove_metadata
```

## Example 2

If it custom chars to be removed, for example `mychar` and `abc`,
the the command should be specified like thisL

```
  sel_remove_metadata, chars(mychar abc)
```

# Feedback, Bug Reports, and Contributions

Read more about the commands in this package at https://github.com/lsms-worldbank/selector.

Please provide any feedback by opening an issue at https://github.com/lsms-worldbank/selector/issues.

PRs with suggestions for improvements are also greatly appreciated.

# Authors

LSMS Team, The World Bank lsms@worldbank.org
