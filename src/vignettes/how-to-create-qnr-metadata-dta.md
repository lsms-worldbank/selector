---
title: How to create a questionnaire metadata data set from the JSON file
---


```r
# install necessary packages
if (!require("pak")) install.packages("pak")
pak::pak("lsms-worldbank/susometa")
pak::pak("haven")

# create a data frame from the questionnaire JSON file
qnr_df <- susometa::parse_questionnaire(path = fs::path(json_dir, "document.json"))
# write the data frame to disk for use by selector
haven::write_dta(data = qnr_df, path = "path/to/your/directory/suso_metadata/dta)
```

<!-- TODO: either replace with a link to a script or point to a newly created function in susometa -->
