{smcl}
{* 01 Jan 1960}{...}
{hline}
{pstd}help file for {hi:sel_vars}{p_end}
{hline}

{title:Title}

{phang}{bf:sel_vars} - This command lists variables by matching char values
{p_end}

{title:Syntax}

{phang}{bf:sel_vars}  {it:query}string{it:, {bf:{ul:t}ype}(}string{it:)
{p_end}

{phang}where {it:query}string{it: is a string with custom values to match on.
More details on this in the Options section below.
{p_end}

{synoptset 12}{...}
{synopthdr:options}
{synoptline}
{synopt: {bf:{ul:t}ype}({it:string})}The value to match on for char {inp:type}{p_end}
{synoptline}

{title:Description}

{pstd}This command is intended to filter variables on values in chars.
See the Stata helpfile for char for more info on chars.
This command has options provided for chars that
the dataset will typically have after
the command {inp:sel_add_metadata} has been used.
That command takes meta information from SurveySolutions (SuSo) and
apply meta data in chars.
Then this command can be used to filter variable by matching on that meta data.
{p_end}

{pstd}While some convenience options has been provided for a SuSo workflow,
this command is by no means limited to data collected by SuSo.
The {it:query}string{it: allows the user to filter on any value in any custom char
in any Stata dataset.
{p_end}

{pstd}The command can at this point not match on multiple values. For example,
filter all variables with either the value {inp:TextQuestion} or
{inp:NumericQuestion} in the char {inp:type}.
However, example TODO below suggest a simple way of accomplishing that
by running the command twice and then
get the union of the result in those two runs.
{p_end}

{title:Options}

{pstd}{it:query}string{it: is a string on with pairs of char names and char values.
Each pair should be enclosed as it{c 39}s own string.
That string should be on format {inp:{c 34}char value{c 34}} where
 {inp:char} must be a single word
(as that is a requirement for {inp:chars} in stat)
but {inp:value} can be any text as long as
it does not include the character {inp:{c 34}}.
{p_end}

{pstd}You can have a single char/value pair or several.
Regardless of which you must enclose the pair or pairs in a compounded quote.
For example, if you want to list all variables that has {inp:NumericQuestion} as value in a {inp:char} named {inp:type}, you can do:
{p_end}

{input}{space 8}sel_vars `" "type NumericQuestion" "'
{text}
{pstd}If you want to list all variables that has {inp:NumericQuestion} as value in a {inp:char} named {inp:type} and has {inp:2} as value in a {inp:char} named {inp:num_decimal_places}, you can do:
{p_end}

{input}{space 8}sel_vars `" "type NumericQuestion" "num_decimal_places 2" "'
{text}
{pstd}You may not use the same char name twice.
So there is no way to do a char being either of two values.
However, example 3 below shows an simple way of
accomplishing this running the command twice.
{p_end}

{pstd}{bf:{ul:t}ype}({it:string}) is used as a short hand
for the query string {inp:{c 34}type NumericQuestion{c 34}}.
This shorthand exists as {inp:type} is a common meta info character in SuSo data.
{p_end}

{title:Stored results}

{pstd}If the command is set to only filter on one char name,
then the command stores the following results in {inp:r()}:
{p_end}

{pstd}If two or more char values are used to filter, then for each char, these results are also store in {inp:r()}. These stored results is intended to be helpful when doing a complex filtering and the users do not get the result they expected. Then this information may be useful in debugging purposes:
{p_end}

{title:Examples}

{dlgtab:Example 1}

{pstd}The following two examples are identical and filter variables that has {inp:NumericQuestion} as value in a {inp:char} named {inp:type}:
{p_end}

{pstd}Example 1a:
{input}{space 8}sel_vars `" "type NumericQuestion" "'
{text}
{p_end}

{pstd}Example 1b:
{input}{space 8}sel_vars, type("NumericQuestion")
{text}
{p_end}

{dlgtab:Example 2}

{pstd}In this examples, the command lists all variables that has {inp:NumericQuestion} as value in a {inp:char} named {inp:type} and has {inp:my text} as value in a {inp:char} named {inp:mychar}. This way you can combine SuSo chars with your own custom chars.
{p_end}

{input}{space 8}sel_vars  `" "mychar my text" "', type("NumericQuestion")
{text}
{dlgtab:Example 3}

{pstd}If you want to do an either or match you need to run the command twice and then combine the varlists. For example, if you want to filter the variables that  that has either {inp:NumericQuestion} or {inp:TextQuestion} as value in a {inp:char} named {inp:type}, then you can do this:
{p_end}

{input}{space 8}* First get all variables with value "NumericQuestion"
{space 8}sel_vars, type("NumericQuestion")
{space 8}local varlist1 = `r(varlist)''
{space 8}
{space 8}* Then get all variable with value "TextQuestion"
{space 8}sel_vars, type("TextQuestion")
{space 8}local varlist2 = `r(varlist)'
{space 8}
{space 8}* Then combine them into one list. This results in the union of
{space 8}* varlist1 and varlist2, and do not create duplicates
{space 8}local varlist : list varlist1 | varlist1
{text}
{title:Feedback, Bug Reports, and Contributions}

{pstd}Read more about the commands in this package at https://github.com/lsms-worldbank/selector.
{p_end}

{pstd}Please provide any feedback by opening an issue at https://github.com/lsms-worldbank/selector/issues.
{p_end}

{pstd}PRs with suggestions for improvements are also greatly appreciated.
{p_end}

{title:Authors}

{pstd}LSMS Team, The World Bank lsms@worldbank.org
{p_end}
