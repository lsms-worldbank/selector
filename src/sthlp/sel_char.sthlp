{smcl}
{* *! version 1.0 12FEB2024}{...}
{hline}
{pstd}help file for {hi:sel_char}{p_end}
{hline}

{title:Title}

{phang}{bf:sel_char} - This command is used for short description.
{p_end}

{title:Syntax}

{phang}{bf:sel_char} {it:querystring} {bf:{ul:var}list}({it:varlist})
{p_end}

{synoptset 16}{...}
{synopthdr:options}
{synoptline}
{synopt: {bf:{ul:var}list}({it:varlist})}Specify a subset of current variables to search{p_end}
{synoptline}

{title:Description}

{pstd}This command allows the user to filter variables based on values in {browse "https://www.stata.com/manuals/pchar.pdf":chars}. It will return a local in {inp:r(varlist)} with all variables that matches the query string. 
See the examples below for instructions on how to specify the {it:querystring}.
{p_end}

{title:Options}

{pstd}{bf:{ul:var}list}({it:varlist}) allows the user to specify a subset of the variables in the data set to filter on. The default is that the command filter on all variables in the current data set. With {bf:{ul:var}list}({it:varlist}), the scope of the search can be narrowed. This narrower variable list could come, for example, from other commands in {inp:selector}. 
{p_end}

{title:Stored results}

{pstd}If the command is set to only filter on one char name,
then the command stores the following results in {inp:r()}: 
{p_end}

{pstd}If two or more char values are used to filter, then for each char, these results are also store in {inp:r()}. These stored results is intended to be helpful when doing a complex filtering and the users do not get the result they expected. Then this information may be useful in debugging purposes: 
{p_end}

{title:Examples}

{dlgtab:Example 1}

{pstd}In this example a second price varible is created. The currency used for the variables is stored in the {inp:char} value {c 34}currency{c 34}. Then {inp:sel_char} is used to list all variables that has the value {c 34}USD{c 34} in the {inp:char} {c 34}currency{c 34}. 
{p_end}

{input}{space 8}sysuse auto, clear
{space 8}
{space 8}char price[currency] "USD"
{space 8}
{space 8}gen  price_eur = price * .9
{space 8}char price_eur[currency] "EUR"
{space 8}
{space 8}sel_char "currency USD"
{space 8}return list
{text}
{dlgtab:Example 2}

{pstd}You can combine multiple {inp:char} values to filter your variable list further. When combining multiple chars the command returns data on the filtering on each {inp:char}. 
{p_end}

{input}{space 8}sysuse auto, clear
{space 8}
{space 8}char price[currency] "USD"
{space 8}
{space 8}gen  price_eur = price * .9
{space 8}char price_eur[currency] "EUR"
{space 8}
{space 8}char price[raw] "1"
{space 8}char price_eur[raw] "1"
{space 8}
{space 8}sel_char "raw 1" "currency USD"
{space 8}return list
{text}
{dlgtab:Example 3}

{pstd}This example is synonymous with example 2, as the variable list that is a result of the first run of {inp:sel_char} is passed into the {inp:varlist()} option in the second run of {inp:sel_char}. This can be especially useful when combining this command with other commands in the selector package. 
{p_end}

{input}{space 8}sysuse auto, clear
{space 8}
{space 8}char price[currency] "USD"
{space 8}
{space 8}gen  price_eur = price * .9
{space 8}char price_eur[currency] "EUR"
{space 8}
{space 8}char price[raw] "1"
{space 8}char price_eur[raw] "1"
{space 8}
{space 8}sel_char "raw 1"
{space 8}sel_char "currency USD" , varlist(`r(varlist)') 
{space 8}return list
{text}
{title:Feedback, Bug Reports, and Contributions}

{pstd}Read more about these commands on {browse "https://github.com/lsms-worldbank/selector":this repo} where this package is developed. Please provide any feedback by {browse "https://github.com/lsms-worldbank/selector/issues":opening an issue}. PRs with suggestions for improvements are also greatly appreciated.
{p_end}

{title:Authors}

{pstd}LSMS Team, The World Bank lsms@worldbank.org
{p_end}
