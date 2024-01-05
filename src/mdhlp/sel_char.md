# Title

__sel_char__ - This command is used for short description.

# Syntax

__sel_char__ _querystring_ __**var**list__(_varlist_)

| _options_ | Description |
|-----------|-------------|
| __**var**list__(_varlist_) | Specify a subset of current variables to search  |

# Description

This command allows the user to filter variables based on values in [chars](https://www.stata.com/manuals/pchar.pdf). It will return a local in `r(varlist)` with all variables that matches the query string.
See the examples below for instructions on how to specify the _querystring_.

# Options

__**var**list__(_varlist_) allows the user to specify a subset of the variables in the data set to filter on. The default is that the command filter on all variables in the current data set. With __**var**list__(_varlist_), the scope of the search can be narrowed. This narrower variable list could come, for example, from other commands in `selector`.

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

In this example a second price varible is created. The currency used for the variables is stored in the `char` value "currency". Then `sel_char` is used to list all variables that has the value "USD" in the `char` "currency".

```
sysuse auto, clear

char price[currency] "USD"

gen  price_eur = price * .9
char price_eur[currency] "EUR"

sel_char "currency USD"
return list
```

## Example 2

You can combine multiple `char` values to filter your variable list further. When combining multiple chars the command returns data on the filtering on each `char`.

```
sysuse auto, clear

char price[currency] "USD"

gen  price_eur = price * .9
char price_eur[currency] "EUR"

char price[raw] "1"
char price_eur[raw] "1"

sel_char "raw 1" "currency USD"
return list
```

## Example 3

This example is synonymous with example 2, as the variable list that is a result of the first run of `sel_char` is passed into the `varlist()` option in the second run of `sel_char`. This can be especially useful when combining this command with other commands in the selector package.

```
sysuse auto, clear

char price[currency] "USD"

gen  price_eur = price * .9
char price_eur[currency] "EUR"

char price[raw] "1"
char price_eur[raw] "1"

sel_char "raw 1"
sel_char "currency USD" , varlist(`r(varlist)')
return list
```

# Feedback, Bug Reports, and Contributions

Read more about these commands on [this repo](https://github.com/lsms-worldbank/selector) where this package is developed. Please provide any feedback by [opening an issue](https://github.com/lsms-worldbank/selector/issues). PRs with suggestions for improvements are also greatly appreciated.

# Authors

LSMS Team, The World Bank lsms@worldbank.org
