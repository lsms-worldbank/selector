# Title

__sel_vars__ - This command lists variables by matching char values

# Syntax

__sel_vars__ _sub-command_, [__**var**list__(_varlist_) __**neg**ate__]

where _sub-command_ is one of the sub-commands listed in the __Sub-commands__ section below.

| _options_ | Description |
|-----------|-------------|
| __**neg**ate__ | Returns variables **not** matched |
| __**var**list__(_varlist_) | Specify a subset of current variables to search  |

# Description

This command is intended to filter variables on [chars](https://www.stata.com/manuals/pchar.pdf) set up by `sel_add_metadata`. That command takes meta information from Survey Solutions (SuSo) questionnaires and applies meta data in to `chars`.

This command `sel_vars` provides short-hands for common searches. For example, this command can be used to filter all variables with types such as  `TextQuestion` or `NumericQuestion`. Another example is filter all variables that are time stamps or are dates. See full description of the options below.

Custom searches not covered by this command can be made by the command `sel_char` also found in this package `selector`.

# Sub-commands

__is_single_select__ filters variables that are of type _SingleQuestion_ and
  and has no value in the char `linked_to_roster_id`.

__is_numeric__ filters variables that are of type _NumericQuestion_.

__has_decimals__ filters variables that are of type _NumericQuestion_ and is not an integer.

__is_text__ filters variables that are of type _NumericQuestion_ and do _not_ have any mask value.

__follows_pattern__ filters variables that are of type _NumericQuestion_ and have any mask value.

__is_list__ filters variables that are of type _TextListQuestion_.

__is_multi_select__ filters variables that are of type _MultyOptionsQuestion_.

__is_multi_ordered__ filters variables that are of type _MultyOptionsQuestion_ and has value 1 for `are_answers_ordered`.

__is_multi_yn__ filters variables that are of type _MultyOptionsQuestion_  and has value 1 for `yes_no_view`.

__is_multi_checkbox__ filters variables that are of type _MultyOptionsQuestion_  and has value 1 for `yes_no_view`.

__is_date__ filters variables that are of type _DateTimeQuestion_  and has value 0 for `is_timestamp`.

__is_timestamp__ filters variables that are of type _DateTimeQuestion_  and has value 1 for `is_timestamp`.

__is_gps__ filters variables that are of type _GpsCoordinateQuestion_.

__is_variable__ filters variables that are of type _Variable_.

__is_picture__ filters variables that are of type _MultimediaQuestion_.

__is_barcode__ filters variables that are of type _QRBarcodeQuestion_.

# Options

__**neg**ate__ inverts the matching. Rather than return variables variables that match the criteria, this option returns variables that do not match.

__**var**list__(_varlist_) allows the user to specify a subset of the variables in the data set to filter on. The default is that the command filter on all variables in the current data set. With __**var**list__(_varlist_), the scope of the search can be narrowed. This narrower variable list could come, for example, from other commands in `selector`.

# Examples

## Example 1

This example lists all variables that are collected as `NumericQuestion` in SuSo.

```
sel_vars is_numeric
return list
```

# Feedback, Bug Reports, and Contributions

Read more about these commands on [this repo](https://github.com/lsms-worldbank/selector) where this package is developed. Please provide any feedback by [opening an issue](https://github.com/lsms-worldbank/selector/issues). PRs with suggestions for improvements are also greatly appreciated.

# Authors

LSMS Team, The World Bank lsms@worldbank.org
