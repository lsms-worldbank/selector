# `selector`

Load SuSo meta data into chars and utilities using them
<!-- 
TODO: uncomment when logo is posted
<img src='src/dev/assets/logo.png' align="right" height="139" />
 -->

<!-- badges: start -->
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

The goal of `selector` is to provide methods for selecting variables of interest in ways that base Stata cannot. For those who find Stata's glob patterns limiting, `selector` offers selection by regex pattern. For those who use [Survey Solutions](https://mysurvey.solutions/), `selector` enables variable selection based on questionnaire metadata (e.g., question type).

##  Installation

This package is not yet available on SSC, but can be installed from GitHub with the following commands.

To get the latest stable version, run the following two commands:

```
local tag "main"
net install selector, ///
  from("https://raw.githubusercontent.com/lsms-worldbank/selector/`tag'/src")
```

To target a particular release, set `tag` to your target release:

```stata
local tag "v1.0"
net install selector, ///
  from("https://raw.githubusercontent.com/lsms-worldbank/selector/`tag'/src")
```

Note also: while this package does not require [selector](https://github.com/lsms-worldbank/selector), some commands in selector do leverage the questionnaire metadata that selector adds to survey metadata. 

## Commands

| Command | Description |
| --- | --- |
| [sel_add_metadata](https://lsms-worldbank.github.io/selector/reference/sel_add_metadata.html) | Apply SuSo metadata to current data
| [sel_char](https://lsms-worldbank.github.io/selector/reference/sel_char.html) | Select varaibles based on `char` value
| [sel_matches_regex](https://lsms-worldbank.github.io/selector/reference/sel_matches_regex.html) | Get variables that match a regular expression.
| [sel_remove_metadata](https://lsms-worldbank.github.io/selector/reference/sel_remove_metadata.html) | Clean up metadata only needed during cleaning
| [sel_vars](https://lsms-worldbank.github.io/selector/reference/sel_vars.html) | List variables with matching characteristics in the Survey Solutions’ Designer.
| [selector](https://lsms-worldbank.github.io/selector/reference/selector.html) | Package command with utilities for the rest of the package

## Usage

`selector` currently provides two means of selecting variables:

- [Regular expressions](#regular-expressions)
- [Survey Solutions questionnaire metadata (and other `chars`)](#survey-solutions-metadata-and-other-chars)

### Regular expressions

By default, Stata allows users to specify a list of variables through a range (e.g., `var1 - var5`) or a (glob) pattern (e.g., `var*`).

However, there is no straight-forward way to specify a list of variables that match a regular expression, a pattern specification that is typically more precise than either of the foregoing Stata options. The sel_matches_regex command fills that gap in functionality.

In particular, this function aims to meet a few needs:

- Select variables more precisely
- Identify variables that fail to follow a pattern

#### Select variables more precisely

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

* select variables that end in _unit
sel_matches_regex "_unit$"

* select variables that end in _unit for questions 02 and 03
sel_matches_regex "0[23]_unit$"
```
#### Identify variables that fail to follow a pattern

```stata
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

### Survey Solutions metadata (and other `chars`)

- [Survey Solutions metadata](#survey-solutions-metadata)
- [Other arbitrary `chars`](#other-arbitrary-chars)

#### Survey Solutions metadata

```stata
* add Survey Solutions questionnaire metadata
sel_add_metadata

* select by question type

* numeric
* any type of numeric
sel_vars is_numeric
* any with decimals
sel_vars is_demical

* multi-select
* any type of multi-select
sel_vars is_multi_select
* yes/no
sel_vars is_multi_yn
* checkboxes
sel_vars is_multi_checkbox
* with answer order recorded
is_multi_ordered

* combine selectors
* first, select multi-select
sel_vars is_multi_select
local multi_select "`r(varlist)'"
* then, select linked questions among them
sel_vars is_linked, varlist(`multi_select')

* remove metadata (e.g., before saving data for dissemination)
sel_remove_metadata
```

#### Other arbitrary `chars`

## Learn more

To learn more about the package:

- Consult the reference documentation
- Read how-to articles

## Contact

LSMS Team, World Bank
lsms@worldbank.org
