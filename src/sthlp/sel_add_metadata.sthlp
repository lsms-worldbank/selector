{smcl}
{* 01 Jan 1960}{...}
{hline}
{pstd}help file for {hi:sel_add_metadata}{p_end}
{hline}

{title:Title}

{phang}{bf:sel_add_metadata} - Apply SuSo metadata to current data
{p_end}

{title:Syntax}

{phang}{bf:sel_add_metadata} using {it:path/to/metadata.dta}
{p_end}

{title:Description}

{pstd}This command applies Survey Solutions (SuSo) meta data to {browse "https://www.stata.com/manuals/pchar.pdf":chars}. This command expects as input the file outputted by the R-function {browse "https://github.com/lsms-worldbank/cleanstart/":cleanstart}.
{p_end}

{pstd}After this commands runs successfully, SuSo meta data is stored in {inp:char} values that can be read like this:
{p_end}

{input}{space 8}local type : char varA[type]"
{space 8}if "`type'" == "NumericQuestion" {
{space 8}  // Do something to numeric questons
{space 8}}
{text}
{title:Options}

{pstd}This command does not have any options. It only takes the path to the meta data file in {inp:using}.
{p_end}

{title:Examples}

{input}{space 8}local metadatafile "${meta_data}/question_metadata.dta"
{space 8}sel_add_metadata using `metadatafile'
{text}
{title:Feedback, Bug Reports, and Contributions}

{pstd}Read more about these commands on {browse "https://github.com/lsms-worldbank/selector":this repo} where this package is developed. Please provide any feedback by {browse "https://github.com/lsms-worldbank/selector/issues":opening an issue}. PRs with suggestions for improvements are also greatly appreciated.
{p_end}

{title:Authors}

{pstd}LSMS Team, The World Bank lsms@worldbank.org
{p_end}
