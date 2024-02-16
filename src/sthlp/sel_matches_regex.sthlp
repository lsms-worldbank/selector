{smcl}
{* *! version 1.0 16FEB2024}{...}
{hline}
{pstd}help file for {hi:sel_matches_regex}{p_end}
{hline}

{title:Title}

{phang}{bf:sel_matches_regex} - Get variables that match a regular expression.
{p_end}

{title:Syntax}

{phang}{bf:sel_matches_regex} {it:regex}string{it:, [{bf:{ul:var}list}(}varlist{it:) {bf:{ul:neg}ate}]
{p_end}

{synoptset 16}{...}
{synopthdr:options}
{synoptline}
{synopt: {bf:{ul:neg}ate}}Returns variables **not** matched by regex{p_end}
{synopt: {bf:{ul:var}list}({it:varlist})}Sets the scope of the regex search{p_end}
{synoptline}

{title:Description}

{pstd}By default, Stata allows users to specify a list of variables through a range (e.g., {inp:var1 - var5}) or a (glob) pattern (e.g., {inp:var*}). See more {browse "https://www.stata.com/manuals/u11.pdf#u11.4varnameandvarlists":here}. 
{p_end}

{pstd}However, there is no straight-forward way to specify a list of variables that match a regular expression, a pattern specification that is typically more precise than either of the foregoing Stata options. The {inp:sel_matches_regex} command fills that gap in functionality. 
{p_end}

{pstd}In particular, this function aims to meet a few needs:
{p_end}

{pstd}1. Select variables more precisely
1. Identify no variables fail to follow a pattern
{p_end}

{pstd}See examples below.
{p_end}

{title:Options}

{pstd}{bf:{ul:neg}ate} inverts the regex selection. Rather than return matching variables, this option returns variables that do not match.
{p_end}

{pstd}{bf:{ul:var}list}({it:varlist}) restricts the scope of the regex search to the user-provided variable list. By default, {inp:sel_matches_regex} searches for matches in all variables in memory. With {bf:varlist}, the scope of the search can be narrowed. This narrower varlist could come, for example, from other commands in {inp:selector}. 
{p_end}

{title:Examples}

{dlgtab:Example 1: Select variables more precisely}

{input}{space 8}* create sets of variables
{space 8}gen housing_unit = .
{space 8}gen s01q01_quantity = .
{space 8}gen s01q01_unit = .
{space 8}gen s01q02_quantity = .
{space 8}gen s01q02_unit = .
{space 8}gen s01q03_quantity = .
{space 8}gen s01q03_unit = .
{space 8}gen s01q04_quantity = .
{space 8}gen s01q04_unit = .
{space 8}
{space 8}* select variables that end in _unit
{space 8}sel_matches_regex "_unit$"
{space 8}
{space 8}* select variables that end in _unit for questions 02 and 03
{space 8}sel_matches_regex "0[23]_unit$"
{text}
{dlgtab:Example 2: Identify variables that do not follow a pattern}

{input}{space 8}* create a set of variables that mostly follow a pattern
{space 8}* importantly, some don't
{space 8}gen s01q01 = .
{space 8}gen s01q02 = .
{space 8}gen s01_q03 = .
{space 8}gen s01q04 = .
{space 8}gen S01q04 = .
{space 8}gen s01q05a = .
{space 8}gen s01q05_unit = .
{space 8}
{space 8}* identify variables that do NOT follow the pattern
{space 8}sel_matches_regex "s01q0[0-9][a-z]*$", negate
{space 8}
{space 8}* assert that there are no variables fail to follow the pattern
{space 8}* preventing variable naming problems, say, in disseminated data
{space 8}local pattern_for_data "s01q0[0-9][a-z]*$"
{space 8}qui: sel_matches_regex "`pattern_for_data'", negate 
{space 8}local not_follow = r(varlist)
{space 8}local n_not_follow : list sizeof not_follow
{space 8}capture assert n_not_follow == 0
{space 8}if _rc != 1 {
{space 8}    di as error "Some variables do not follow the desired pattern (`pattern_for_data')" 
{space 8}    di as text "`not_follow'" 
{space 8}}
{text}
{title:Feedback, Bug Reports, and Contributions}

{pstd}Read more about these commands on {browse "https://github.com/lsms-worldbank/selector":this repo} where this package is developed. Please provide any feedback by {browse "https://github.com/lsms-worldbank/selector/issues":opening an issue}. PRs with suggestions for improvements are also greatly appreciated.
{p_end}

{title:Authors}

{pstd}LSMS Team, The World Bank lsms@worldbank.org
{p_end}
