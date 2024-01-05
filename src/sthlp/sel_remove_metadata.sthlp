{smcl}
{* 01 Jan 1960}{...}
{hline}
{pstd}help file for {hi:sel_remove_metadata}{p_end}
{hline}

{title:Title}

{phang}{bf:sel_remove_metadata} - Clean up metadata only needed during cleaning
{p_end}

{title:Syntax}

{phang}{bf:sel_remove_metadata} , [{bf:{ul:c}har}({it:string}) {bf:{ul:miss}charok}]
{p_end}

{synoptset 12}{...}
{synopthdr:options}
{synoptline}
{synopt: {bf:{ul:c}har}({it:string})}Manually add chars to be removed.{p_end}
{synopt: {bf:{ul:miss}charok}}Suppress error when {bf:chars()} is not used and no list of chars in chars.{p_end}
{synoptline}

{title:Description}

{pstd}This command clean up meta data in {inp:char} storage.
The intended use case is to clean up {inp:char} values after the cleaning stage
that were only needed during that stage,
but the command can of course be used to clean up {inp:char} values in any context.
{p_end}

{pstd}If the {inp:char} values the should be removed was added by the command
{inp:sel_add_metadata} in the same package as this command,
the the user do not need to list any {inp:char} names.
{inp:sel_add_metadata} stores a list of the name of the chars it adds in a {inp:char}.
This command will use that list to know which chars should be deleted.
{p_end}

{pstd}The option {inp:char()} is only required when
removing chars not added by {inp:sel_add_metadata}.
{p_end}

{title:Options}

{pstd}{bf:{ul:c}har}({it:string}) allows the user to manually add chars to be removed.
If the chars to be removed were added by {inp:sel_add_metadata},
then this option is not required as {inp:sel_remove_metadata} can read what chars  
that was added by {inp:sel_add_metadata}. If other custom chars were added by the user or other commands and should also be removed, then this option is required.
{p_end}

{pstd}{bf:{ul:miss}} suppresses the error that is thrown when
no chars to remove was provided. Neither through the option {inp:char()} or
in meta data written by {inp:sel_add_metadata}.
{p_end}

{title:Examples}

{dlgtab:Example 1}

{pstd}If the meta data to be removed was added by {inp:sel_add_metadata} then
this command can be specified as simply as this:
{p_end}

{input}{space 8}  sel_remove_metadata
{text}
{dlgtab:Example 2}

{pstd}If it custom chars to be removed, for example {inp:mychar} and {inp:abc},
the the command should be specified like thisL
{p_end}

{input}{space 8}  sel_remove_metadata, chars(mychar abc)
{text}
{title:Feedback, Bug Reports, and Contributions}

{pstd}Read more about these commands on {browse "https://github.com/lsms-worldbank/selector":this repo} where this package is developed. Please provide any feedback by {browse "https://github.com/lsms-worldbank/selector/issues":opening an issue}. PRs with suggestions for improvements are also greatly appreciated.
{p_end}

{title:Authors}

{pstd}LSMS Team, The World Bank lsms@worldbank.org
{p_end}
