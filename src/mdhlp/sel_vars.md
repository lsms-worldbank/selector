# Title

__sel_vars__ - List variables with matching characteristics in the Survey Solutions' Designer.

# Syntax

__sel_vars__ _sub-command_, [__**var**list__(_varlist_) __**neg**ate__]

where _sub-command_ is one of the sub-commands listed in the __Sub-commands__ section below.

| _options_ | Description |
|-----------|-------------|
| __**neg**ate__ | Returns variables **not** matched by the sub-command |
| __**var**list__(_varlist_) | Specify a subset of the current variables to search  |

# Description

For data collected with Survey Solutions, data users can only select variables based on variable names.

This command aims to select variables in the data based on the characteristics of their corresponding questions/variables in Designer. This selection is powered by the Designer questionnaire metadata that is attached to the Stata data by the `sel_add_metadata` as [chars](https://www.stata.com/manuals/pchar.pdf).

To make selection simple, this command provides several short-hand selectors for common variable searches. Several selectors target variables linked to particular question types (e.g., text, numeric, or multi-select). Some selectors target question sub-types (e.g., multi-select captured as yes/no, multi-select where answer order is recorded, etc.). And still other selectors target characteristics that span several question types (e.g. is linked).

To make compound selections, this command could be used in a selection pipeline. For example, a user could first select linked questions and then select those among them that are also-multi-select.

For selections not covered by this command--for example, different question types, non-SuSo chars, etc.--see the `sel_char` command also found in the `selector` package.

# Sub-commands

Each sub-command lists variables linked to particular question types or question attributes
in the Survey Solutions' questionnaire used to collect the data.

__is_numeric__. Numeric questions
(i.e., where the `Question type` field is set to `Numeric` in Designer)

__has_decimals__. Numeric questions with any number of decimal places allowed
(i.e., where the `Question type` field is set to `Numeric` and
the `Integer` checkbox is not ticked in Designer).

__is_text__. Text question 
(i.e. where the `Question type` field is set to `Text`).

__follows_pattern__. Text question with a pattern specified
(i.e. where the `Question type` field is set to `Text` and the `Pattern` is non-empty).

__is_list__. List question
(i.e. where the `Question type` field is set to `List`)

__is_single_select__. Single-select questions
(i.e., where the `Question type` field is set to `Categorical: Single-select` in Designer). 

__is_multi_select__ Multi-select question
(i.e. where the `Question type` field is set to `Categorical: Multi-select`).

__is_multi_ordered__ Multi-select question with answer order recorded
(i.e. where the `Question type` field is set to `Categorical: Multi-select` and the `Record answer order` box is ticked).

__is_multi_yn__. Multi-select question where items are selected as yes/no questions
(i.e. where the `Question type` field is set to `Categorical: Multi-select` and the `Display mode` field is set to `Yes/No buttons`).

__is_multi_checkbox__. Multi-select question where answers are provided as ticked checkboxes
(i.e. where the `Question type` field is set to `Categorical: Multi-select` and the `Display mode` field is set to `Checkboxes`).

__is_linked__. Single-select or multi-select question whose answers are linked to a roster ID or a (list) question
(i.e. where the `Source of categories` field is set to `List of question or question from roster group` and the `Bind list question or question from roster group` field is set to a roster or question).

__is_date__. Date question, whether calendar date or timestamp 
(i.e. where the `Question type` field is set to `Date`).

__is_calendar_date__. Date question where the answer is provided as a selection from a calendar 
(i.e. where the `Question type` field is set to `Date` and the `Current timestamp (date & time)` box is not ticked).

__is_timestamp__. Date question where the answer represents a timestamp.
(i.e. where the `Question type` field is set to `Date` and the `Current timestamp (date & time)` box is ticked).

__is_gps__. GPS question
(i.e. where the `Question type` field is set to `GPS`).

__is_variable__. Variable rather than a question
(i.e., a variable that Survey Solutions computed rather than a question that interviewer/respondent answered).

__is_picture__. Picture question
(i.e. where the `Question type` field is set to `Picture`).

__is_barcode__. QR/barcode question
(i.e. where the `Question type` field is set to `Barcode`).

# Options

__**neg**ate__ inverts the matching. Rather than return variables variables that match the criteria, this option returns variables that do not match.

__**var**list__(_varlist_) allows the user to specify a subset of the variables in the data set to filter on. The default is that the command filter on all variables in the current data set. With __**var**list__(_varlist_), the scope of the search can be narrowed. This narrower variable list could come, for example, from other commands in `selector`.

# Examples

## Example 1

This example lists all variables linked to numeric question in SuSo Designer:

```
sel_vars is_numeric
return list
```

# Feedback, Bug Reports, and Contributions

Read more about these commands on [this repo](https://github.com/lsms-worldbank/selector) where this package is developed. Please provide any feedback by [opening an issue](https://github.com/lsms-worldbank/selector/issues). PRs with suggestions for improvements are also greatly appreciated.

# Authors

LSMS Team, The World Bank lsms@worldbank.org
