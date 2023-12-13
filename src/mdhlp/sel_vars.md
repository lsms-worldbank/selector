# Title

__sel_vars__ - This command lists variables by matching char values

# Syntax

__sel_vars__  _query_string_, __**t**ype__(_string_)

where _query_string_ is a string with custom values to match on.
More details on this in the Options section below.

| _options_ | Description |
|-----------|-------------|
| __**t**ype__(_string_)   | The value to match on for char `type`  |

# Description

This command is intended to filter variables on values in chars.
See the Stata helpfile for char for more info on chars.
This command has options provided for chars that
the dataset will typically have after
the command `sel_add_metadata` has been used.
That command takes meta information from SurveySolutions (SuSo) and
apply meta data in chars.
Then this command can be used to filter variable by matching on that meta data.

While some convenience options has been provided for a SuSo workflow,
this command is by no means limited to data collected by SuSo.
The _query_string_ allows the user to filter on any value in any custom char
in any Stata dataset.

The command can at this point not match on multiple values. For example,
filter all variables with either the value `TextQuestion` or
`NumericQuestion` in the char `type`.
However, example TODO below suggest a simple way of accomplishing that
by running the command twice and then
get the union of the result in those two runs.

# Options

_query_string_ is a string on with pairs of char names and char values.
Each pair should be enclosed as it's own string.
That string should be on format `"char value"` where
 `char` must be a single word
(as that is a requirement for `chars` in stat)
but `value` can be any text as long as
it does not include the character `"`.

You can have a single char/value pair or several.
Regardless of which you must enclose the pair or pairs in a compounded quote.
For example, if you want to list all variables that has `NumericQuestion` as value in a `char` named `type`, you can do:

```
sel_vars `" "type NumericQuestion" "'
```
If you want to list all variables that has `NumericQuestion` as value in a `char` named `type` and has `2` as value in a `char` named `num_decimal_places`, you can do:

```
sel_vars `" "type NumericQuestion" "num_decimal_places 2" "'
```
You may not use the same char name twice.
So there is no way to do a char being either of two values.
However, example 3 below shows an simple way of
accomplishing this running the command twice.

__**t**ype__(_string_) is used as a short hand
for the query string `"type NumericQuestion"`.
This shorthand exists as `type` is a common meta info character in SuSo data.

# Stored results

If the command is set to only filter on one char name,
then the command stores the following results in `r()`:

| _r-macro_ | Description |
|-----------|-------------|
| `varlist`   | The list of variables which char values matched the filtering criteria |
| `match_count`   | The number of variables in `varlist` |

If two or more char values are used to filter, then for each char, these results are also store in `r()`. These stored results is intended to be helpful when doing a complex filtering and the users do not get the result they expected. Then this information may be useful in debugging purposes:

| _r-macro_ | Description |
|-----------|-------------|
| `char*`   | The name of the char |
| `char*_value`   | The char value used to filter on |
| `has_char*`   | The list of variables that had this char regardless of what value |
| `has_char*_count`   | The number of variables in `has_char*`  |
| `match_char*`   | The list of variables that had this char and the value matched `char*_value` |
| `match_char*_count`   | The number of variables in `match_char*` |

# Examples

## Example 1

The following two examples are identical and filter variables that has `NumericQuestion` as value in a `char` named `type`:

Example 1a:
```
sel_vars `" "type NumericQuestion" "'
```

Example 1b:
```
sel_vars, type("NumericQuestion")
```

## Example 2

In this examples, the command lists all variables that has `NumericQuestion` as value in a `char` named `type` and has `my text` as value in a `char` named `mychar`. This way you can combine SuSo chars with your own custom chars.

```
sel_vars  `" "mychar my text" "', type("NumericQuestion")
```

## Example 3

If you want to do an either or match you need to run the command twice and then combine the varlists. For example, if you want to filter the variables that  that has either `NumericQuestion` or `TextQuestion` as value in a `char` named `type`, then you can do this:

```
* First get all variables with value "NumericQuestion"
sel_vars, type("NumericQuestion")
local varlist1 = `r(varlist)''

* Then get all variable with value "TextQuestion"
sel_vars, type("TextQuestion")
local varlist2 = `r(varlist)'

* Then combine them into one list. This results in the union of
* varlist1 and varlist2, and do not create duplicates
local varlist : list varlist1 | varlist1
```

# Feedback, Bug Reports, and Contributions

Read more about the commands in this package at https://github.com/lsms-worldbank/selector.

Please provide any feedback by opening an issue at https://github.com/lsms-worldbank/selector/issues.

PRs with suggestions for improvements are also greatly appreciated.

# Authors

LSMS Team, The World Bank lsms@worldbank.org
