{smcl}
{* 01 Jan 1960}{...}
{hline}
{pstd}help file for {hi:sel_vars}{p_end}
{hline}

{title:Title}

{phang}{bf:sel_vars} - This command lists variables by matching char values
{p_end}

{title:Syntax}

{phang}{bf:sel_vars} {it:sub-command}, [{bf:{ul:var}list}({it:varlist}) {bf:{ul:neg}ate}]
{p_end}

{phang}where {it:sub-command} is one of the sub-commands listed in the {bf:Sub-commands} section below.
{p_end}

{synoptset 16}{...}
{synopthdr:options}
{synoptline}
{synopt: {bf:{ul:neg}ate}}Returns variables **not** matched{p_end}
{synopt: {bf:{ul:var}list}({it:varlist})}Specify a subset of current variables to search{p_end}
{synoptline}

{title:Description}

{pstd}This command is intended to filter variables on {browse "https://www.stata.com/manuals/pchar.pdf":chars} set up by {inp:sel_add_metadata}. That command takes meta information from Survey Solutions (SuSo) questionnaires and applies meta data in to {inp:chars}.
{p_end}

{pstd}This command {inp:sel_vars} provides short-hands for common searches. For example, this command can be used to filter all variables with types such as  {inp:TextQuestion} or {inp:NumericQuestion}. Another example is filter all variables that are time stamps or are dates. See full description of the options below.
{p_end}

{pstd}Custom searches not covered by this command can be made by the command {inp:sel_char} also found in this package {inp:selector}.
{p_end}

{title:Sub-commands}

{pstd}{bf:is_single_select} filters variables that are of type {it:SingleQuestion} and
  and has no value in the char {inp:linked_to_roster_id}.
{p_end}

{pstd}{bf:is_numeric} filters variables that are of type {it:NumericQuestion}.
{p_end}

{pstd}{bf:has_decimals} filters variables that are of type {it:NumericQuestion} and is not an integer.
{p_end}

{pstd}{bf:is_text} filters variables that are of type {it:NumericQuestion} and do {it:not} have any mask value.
{p_end}

{pstd}{bf:follows_pattern} filters variables that are of type {it:NumericQuestion} and have any mask value.
{p_end}

{pstd}{bf:is_list} filters variables that are of type {it:TextListQuestion}.
{p_end}

{pstd}{bf:is_multi_select} filters variables that are of type {it:MultyOptionsQuestion}.
{p_end}

{pstd}{bf:is_multi_ordered} filters variables that are of type {it:MultyOptionsQuestion} and has value 1 for {inp:are_answers_ordered}.
{p_end}

{pstd}{bf:is_multi_yn} filters variables that are of type {it:MultyOptionsQuestion}  and has value 1 for {inp:yes_no_view}.
{p_end}

{pstd}{bf:is_multi_checkbox} filters variables that are of type {it:MultyOptionsQuestion}  and has value 1 for {inp:yes_no_view}.
{p_end}

{pstd}{bf:is_date} filters variables that are of type {it:DateTimeQuestion}  and has value 0 for {inp:is_timestamp}.
{p_end}

{pstd}{bf:is_timestamp} filters variables that are of type {it:DateTimeQuestion}  and has value 1 for {inp:is_timestamp}.
{p_end}

{pstd}{bf:is_gps} filters variables that are of type {it:GpsCoordinateQuestion}.
{p_end}

{pstd}{bf:is_variable} filters variables that are of type {it:Variable}.
{p_end}

{pstd}{bf:is_picture} filters variables that are of type {it:MultimediaQuestion}.
{p_end}

{pstd}{bf:is_barcode} filters variables that are of type {it:QRBarcodeQuestion}.
{p_end}

{title:Options}

{pstd}{bf:{ul:neg}ate} inverts the matching. Rather than return variables variables that match the criteria, this option returns variables that do not match.
{p_end}

{pstd}{bf:{ul:var}list}({it:varlist}) allows the user to specify a subset of the variables in the data set to filter on. The default is that the command filter on all variables in the current data set. With {bf:{ul:var}list}({it:varlist}), the scope of the search can be narrowed. This narrower variable list could come, for example, from other commands in {inp:selector}.
{p_end}

{title:Examples}

{dlgtab:Example 1}

{pstd}This example lists all variables that are collected as {inp:NumericQuestion} in SuSo.
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
