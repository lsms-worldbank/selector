# Title

__sel_add_metadata__ - Apply SuSo metadata to current data

# Syntax

__sel_add_metadata__ using _path/to/metadata.dta_

# Description

This command applies Survey Solutions (SuSo) meta data to [chars](https://www.stata.com/manuals/pchar.pdf). This command expects as input the file outputted by the R-function [cleanstart](https://github.com/lsms-worldbank/cleanstart/).

After this commands runs successfully, SuSo meta data is stored in `char` values that can be read like this:

```
local type : char varA[type]"
if "`type'" == "NumericQuestion" {
  // Do something to numeric questons
}
```

# Options

This command does not have any options. It only takes the path to the meta data file in `using`.

# Examples

```
local metadatafile "${meta_data}/question_metadata.dta"
sel_add_metadata using `metadatafile'
```

# Feedback, Bug Reports, and Contributions

Read more about these commands on [this repo](https://github.com/lsms-worldbank/selector) where this package is developed. Please provide any feedback by [opening an issue](https://github.com/lsms-worldbank/selector/issues). PRs with suggestions for improvements are also greatly appreciated.

# Authors

LSMS Team, The World Bank lsms@worldbank.org
