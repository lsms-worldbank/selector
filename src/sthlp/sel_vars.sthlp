{smcl}
{* *! version 1.0 16FEB2024}{...}
{hline}
{pstd}help file for {hi:sel_vars}{p_end}
{hline}

{title:Title}

{phang}{bf:sel_vars} - List variables with matching characteristics in the Survey Solutions{c 39} Designer.
{p_end}

{title:Syntax}

{phang}{bf:sel_vars} {it:sub-command}, [{bf:{ul:var}list}({it:varlist}) {bf:{ul:neg}ate}]
{p_end}

{phang}where {it:sub-command} is one of the sub-commands listed in the {bf:Sub-commands} section below.
{p_end}

{synoptset 16}{...}
{synopthdr:options}
{synoptline}
{synopt: {bf:{ul:neg}ate}}Returns variables **not** matched by the sub-command{p_end}
{synopt: {bf:{ul:var}list}({it:varlist})}Specify a subset of the current variables to search{p_end}
{synoptline}

{title:Description}

{pstd}For data collected with Survey Solutions, data users can only select variables based on variable names.
{p_end}

{pstd}This command aims to select variables in the data based on the characteristics of their corresponding questions/variables in Designer. This selection is powered by the Designer questionnaire metadata that is attached to the Stata data by the {inp:sel_add_metadata} as {browse "https://www.stata.com/manuals/pchar.pdf":chars}. 
{p_end}

{pstd}To make selection simple, this command provides several short-hand selectors for common variable searches. Several selectors target variables linked to particular question types (e.g., text, numeric, or multi-select). Some selectors target question sub-types (e.g., multi-select captured as yes/no, multi-select where answer order is recorded, etc.). And still other selectors target characteristics that span several question types (e.g. is linked).
{p_end}

{pstd}To make compound selections, this command could be used in a selection pipeline. For example, a user could first select linked questions and then select those among them that are also-multi-select.
{p_end}

{pstd}For selections not covered by this command--for example, different question types, non-SuSo chars, etc.--see the {inp:sel_char} command also found in the {inp:selector} package. 
{p_end}

{title:Sub-commands}

{pstd}Each sub-command lists variables linked to particular question types or question attributes
in the Survey Solutions{c 39} questionnaire used to collect the data.
{p_end}

{pstd}{bf:is_numeric}. Numeric questions
(i.e., where the {inp:Question type} field is set to {inp:Numeric} in Designer) 
{p_end}

{pstd}{bf:has_decimals}. Numeric questions with any number of decimal places allowed
(i.e., where the {inp:Question type} field is set to {inp:Numeric} and 
the {inp:Integer} checkbox is not ticked in Designer). 
{p_end}

{pstd}{bf:is_text}. Text question 
(i.e. where the {inp:Question type} field is set to {inp:Text}). 
{p_end}

{pstd}{bf:follows_pattern}. Text question with a pattern specified
(i.e. where the {inp:Question type} field is set to {inp:Text} and the {inp:Pattern} is non-empty). 
{p_end}

{pstd}{bf:is_list}. List question
(i.e. where the {inp:Question type} field is set to {inp:List}) 
{p_end}

{pstd}{bf:is_single_select}. Single-select questions
(i.e., where the {inp:Question type} field is set to {inp:Categorical: Single-select} in Designer).  
{p_end}

{pstd}{bf:is_multi_select} Multi-select question
(i.e. where the {inp:Question type} field is set to {inp:Categorical: Multi-select}). 
{p_end}

{pstd}{bf:is_multi_ordered} Multi-select question with answer order recorded
(i.e. where the {inp:Question type} field is set to {inp:Categorical: Multi-select} and the {inp:Record answer order} box is ticked). 
{p_end}

{pstd}{bf:is_multi_yn}. Multi-select question where items are selected as yes/no questions
(i.e. where the {inp:Question type} field is set to {inp:Categorical: Multi-select} and the {inp:Display mode} field is set to {inp:Yes/No buttons}). 
{p_end}

{pstd}{bf:is_multi_checkbox}. Multi-select question where answers are provided as ticked checkboxes
(i.e. where the {inp:Question type} field is set to {inp:Categorical: Multi-select} and the {inp:Display mode} field is set to {inp:Checkboxes}). 
{p_end}

{pstd}{bf:is_linked}. Single-select or multi-select question whose answers are linked to a roster ID or a (list) question
(i.e. where the {inp:Source of categories} field is set to {inp:List of question or question from roster group} and the {inp:Bind list question or question from roster group} field is set to a roster or question). 
{p_end}

{pstd}{bf:is_date}. Date question, whether calendar date or timestamp 
(i.e. where the {inp:Question type} field is set to {inp:Date}). 
{p_end}

{pstd}{bf:is_calendar_date}. Date question where the answer is provided as a selection from a calendar 
(i.e. where the {inp:Question type} field is set to {inp:Date} and the {inp:Current timestamp (date & time)} box is not ticked). 
{p_end}

{pstd}{bf:is_timestamp}. Date question where the answer represents a timestamp.
(i.e. where the {inp:Question type} field is set to {inp:Date} and the {inp:Current timestamp (date & time)} box is ticked). 
{p_end}

{pstd}{bf:is_gps}. GPS question
(i.e. where the {inp:Question type} field is set to {inp:GPS}). 
{p_end}

{pstd}{bf:is_variable}. Variable rather than a question
(i.e., a variable that Survey Solutions computed rather than a question that interviewer/respondent answered).
{p_end}

{pstd}{bf:is_picture}. Picture question
(i.e. where the {inp:Question type} field is set to {inp:Picture}). 
{p_end}

{pstd}{bf:is_barcode}. QR/barcode question
(i.e. where the {inp:Question type} field is set to {inp:Barcode}). 
{p_end}

{title:Options}

{pstd}{bf:{ul:neg}ate} inverts the matching. Rather than return variables variables that match the criteria, this option returns variables that do not match.
{p_end}

{pstd}{bf:{ul:var}list}({it:varlist}) allows the user to specify a subset of the variables in the data set to filter on. The default is that the command filter on all variables in the current data set. With {bf:{ul:var}list}({it:varlist}), the scope of the search can be narrowed. This narrower variable list could come, for example, from other commands in {inp:selector}. 
{p_end}

{title:Examples}

{dlgtab:Example 1}

{pstd}This example lists all variables linked to numeric question in SuSo Designer:
{p_end}

{input}{space 8}sel_vars is_numeric
{space 8}return list
{text}
{title:Feedback, Bug Reports, and Contributions}

{pstd}Read more about these commands on {browse "https://github.com/lsms-worldbank/selector":this repo} where this package is developed. Please provide any feedback by {browse "https://github.com/lsms-worldbank/selector/issues":opening an issue}. PRs with suggestions for improvements are also greatly appreciated.
{p_end}

{title:Authors}

{pstd}LSMS Team, The World Bank lsms@worldbank.org
{p_end}
