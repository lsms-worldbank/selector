# Title

__sel_matches_regex__ - Get variables that match a regular expression.

# Syntax

__sel_matches_regex__ _regex_string_, [__**neg**ate__]

| _options_ | Description |
|-----------|-------------|
| __**neg**ate__   | Returns variables **not** matched by regex  |
| __varlist__   | Sets the scope of the regex search  |

# Description

By default, Stata allows users to specify a list of variables through a range (e.g., `var1 - var5`) or a (glob) pattern (e.g., `var*`). See more [here](https://www.stata.com/manuals/u11.pdf#u11.4varnameandvarlists).

However, there is no straight-forward way to specify a list of variables that match a regular expression, a pattern specification that is typically more precise than either of the foregoing Stata options. The `sel_matches_regex` command fills that gap in functionality.

In particular, this function aims to meet a few needs:

1. Select variables more precisely
1. Identify no variables fail to follow a pattern

See examples below.

# Options

__**neg**ate__ inverts the regex selection. Rather than return matching variables, this option returns variables that do not match.

__varlist__ restricts the scope of the regex search to the user-provided variable list. By default, `sel_matches_regex` searches for matches in all variables in memory. With __varlist__, the scope of the search can be narrowed. This narrower varlist could come, for example, from other commands in `selector`.

# Examples
<!-- A couple of examples to help the user get started and a short explanation of each of them. -->

## Example 1: Select variables more precisely

```
* create sets of variables
gen housing_unit = .
gen s01q01_quantity = .
gen s01q01_unit = .
gen s01q02_quantity = .
gen s01q02_unit = .
gen s01q03_quantity = .
gen s01q03_unit = .
gen s01q04_quantity = .
gen s01q04_unit = .

* select variables that end in `_unit`
sel_matches_regex "_unit$"

* select variables that end in `_unit` for questions 02 and 03
sel_matches_regex "0[23]_unit$"
```

## Example 2: Identify variables that do not follow a pattern

```
* create a set of variables that mostly follow a pattern
* importantly, some don't
gen s01q01 = .
gen s01q02 = .
gen s01_q03 = .
gen s01q04 = .
gen S01q04 = .
gen s01q05a = .
gen s01q05_unit = .

* identify variables that do NOT follow the pattern
sel_matches_regex "s01q0[0-9][a-z]*$", negate

* assert that there are no variables fail to follow the pattern
* preventing variable naming problems, say, in disseminated data
local pattern_for_data "s01q0[0-9][a-z]*$"
qui: sel_matches_regex "`pattern_for_data'", negate
local not_follow = r(varlist)
local n_not_follow : list sizeof not_follow
capture assert n_not_follow == 0
if _rc != 1 {
    di as error "Some variables do not follow the desired pattern (`pattern_for_data')"
    di as text "`not_follow'"
}
```

# Feedback, bug reports and contributions

Read more about the commands in this package at https://github.com/lsms-worldbank/selector.

Please provide any feedback by opening an issue at https://github.com/lsms-worldbank/selector/issues.

PRs with suggestions for improvements are also greatly appreciated.

# Authors

LSMS Team, The World Bank lsms@worldbank.org
