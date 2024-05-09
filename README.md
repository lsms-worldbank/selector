# `selector`

Select variables by characteristic (char) or regular expression (regex)

<img src='src/dev/assets/logo.png' align="right" height="139" />


<!-- badges: start -->
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

The goal of `selector` is to provide methods for selecting variables of interest in ways that base Stata cannot. For those who find Stata's glob patterns limiting, `selector` offers selection by regex pattern. For those who use [Survey Solutions](https://mysurvey.solutions/), `selector` enables variable selection based on questionnaire metadata (e.g., question type).

##  Installation

To install the latest published version of the package: 

```stata
* install the package from the SSC package repository
ssc install selector
```

To update the package:

```stata
* check for updates
* if any are available, apply them
adoupdate selector
```

### Development version

The version of `selector` on SSC corresponds to the code in the `main` branch of [the package's GitHub repository](https://github.com/lsms-worldbank/selector).

To get a bug fix or test bleeding-edge features, you can install code from other branches of the repository. To install the version in a particular branch:

```stata
* set tag to be the name of the target branch
* for example, the development branch, which contains code for the next release
local tag "dev"
* download the code from that GitHub branch
* install the package
net install selector, ///
  from("https://raw.githubusercontent.com/lsms-worldbank/selector/`tag'/src") replace
```

### Previous versions

If you need to install a previously releases version of `selector`, then you can use the following method. This can be useful, for example, during reproducibility verifications. To install the version in a particular release, set the local `tag` to the target release you want to install in this code:

```stata
* set the tag to the name of the target release
* for example v1.0, say, if the current version were v2.0
local tag "v1.0"
* download the code from that GitHub release
* install the package
net install selector, ///
  from("https://raw.githubusercontent.com/lsms-worldbank/selector/`tag'/src") replace
```

## Commands

| Command | Description |
| --- | --- |
| [selector](https://lsms-worldbank.github.io/selector/reference/selector.html) | Package command with utilities for the rest of the package
| [sel_matches_regex](https://lsms-worldbank.github.io/selector/reference/sel_matches_regex.html) | Get variables that match a regular expression.
| [sel_add_metadata](https://lsms-worldbank.github.io/selector/reference/sel_add_metadata.html) | Apply SuSo metadata to current data
| [sel_remove_metadata](https://lsms-worldbank.github.io/selector/reference/sel_remove_metadata.html) | Clean up metadata only needed during cleaning
| [sel_char](https://lsms-worldbank.github.io/selector/reference/sel_char.html) | Select varaibles based on `char` value
| [sel_vars](https://lsms-worldbank.github.io/selector/reference/sel_vars.html) | List variables with matching characteristics in the Survey Solutions’ Designer.

## Usage

`selector` currently provides two means of selecting variables:

1. [Regular expressions](#regular-expressions)
2. [Survey Solutions questionnaire metadata (and other `chars`)](#survey-solutions-metadata-and-other-chars)

### Regular expressions

By default, Stata allows users to select variables by either specifying a variable range (e.g., `var1 - var5`) or a variable name (glob) pattern (e.g., `var*`).

However, there is no straight-forward way to specify a list of variables that match a regular expression--a pattern specification that is typically more precise than either of the foregoing Stata options. The `sel_matches_regex` command fills that gap in functionality.

In particular, this function aims to meet a few needs:

- [Select variables more precisely](#select-variables-more-precisely)
- [Identify variables that fail to follow a pattern](#identify-variables-that-fail-to-follow-a-pattern)

#### Select variables more precisely

```stata
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

The workflow involves the following steps:

- [Get the Survey Solutions questionnaire in JSON format](#get-the-survey-solutions-questionnaire-in-json-format)
- [Create a questionnaire metadata data set from the JSON file](#create-a-questionnaire-metadata-data-set-from-the-json-file)
- [Add the questionnaire metadata to the survey microdata](#add-the-questionnaire-metadata-to-the-survey-microdata)
- [Select based on metadata](#select-based-on-metadata)
- [Remove metadata](#remove-metadata)

##### Get the Survey Solutions questionnaire in JSON format

The short answer: download it from your Survey Solutions server. See [here](https://lsms-worldbank.github.io/selector/articles/how-to-get-questionnaire-json.html) for more details.

##### Create a questionnaire metadata data set from the JSON file

The short answer: use the `susometa` R package to transform the questionnaire metadata from JSON to a data frame, and to save that data frame as a `.dta` file for `selector` to use it. See [here](https://lsms-worldbank.github/io/selector/articles/how-to-create-qnr-metadata-dta.md) for more details.

##### Add the questionnaire metadata to the survey microdata

For `selector` to use Survey Solutions' questionnaire metadata, it must be added to the data set in memory.
The `sel_add_metadata` command does exactly that: ingects metadata so that other `selector` commands can use this information.

```stata
* add Survey Solutions questionnaire metadata
sel_add_metadata using "path/to/your/metadata.dta"
```

##### Select based on metadata

Once metadata have been added to microdata, `selector` commands can select variables based on their characteristics in the Survey Solutions questionnaire that generated them.

For example, one can select by inidividual characteristics like question type:

```stata
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
```

Alternatively, one can combine multiple selectors, since the outputs of one command--that is, the variables with a certain characteristic--can be passed as input into another commend--that is, the variables to consider for another characteristic.

```stata
* combine selectors

* first, select multi-select
sel_vars is_multi_select
local multi_select "`r(varlist)'"
* then, select linked questions among them
sel_vars is_linked, varlist(`multi_select')
```

##### Remove metadata

Once metadata are no longer needed--for example, as data files are prepared for publication--they can be removed with `sel_remove_metadata`.

```stata
* remove metadata (e.g., before saving data for dissemination)
sel_remove_metadata
```

#### Other arbitrary `chars`

The `selector` package uses Stata `chars` to select variables.
For Survey Solutions users, `selector` provides a dedicated command for accessing particular `chars` corresponding to Survey Solutions questionnaire metadata (i.e., `sel_vars` and its subcommands like `is_numeric`, `is_multi_select`, `is_linked`, etc.).

For those interested in using different `chars`, `selector` provides a general-purpose selector to query and select on the basis of user-provided `chars`: `sel_char`.

For example:

```stata
* use the automobile data set
sysuse auto, clear

* add a currency unit char to the price variable
char price[currency] "USD"

* create another price variable and attach a currency unit char
gen  price_eur = price * .9
char price_eur[currency] "EUR"

* select those variables whose currency unit is USD
sel_char "currency USD"
return list
```

## Learn more

To learn more about the package:

- Consult the reference documentation
- Read how-to articles

## Contact

LSMS Team, World Bank
lsms@worldbank.org
