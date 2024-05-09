# How to create a questionnaire metadata data set from the JSON file

To create a questionnaire metadata data set, one must:

- Extract data from JSON
- Reshape data into rectangular form
- Extract data from reusable categories
- Reshape that data into desired form
- Combine JSON and reusable categories data
- Select data relevant for questions and variables
- Write data to a Stata file

At present,  this can be achieved with the R script below.

In the future, this will likely be done through a simple function in the `{susometa}` package, and potentially in a `selector` command that wraps this function.

```r
# =============================================================================
# Set up paths
# =============================================================================

# NOTE: provide paths with / rather than \
json_dir <- ""
out_dir <- ""

# =============================================================================
# Install required packages
# =============================================================================

# for package installation
if (!require("pak")) {
  install.packages("pak")
}

# install required packages
required_packages <- c(
  "stringr",
  "lsms-worldbank/susometa",
  "fs",
  "haven"
)

pak::pak(required_packages)

# =============================================================================
# Ingest JSON questionnaire metadata
# =============================================================================

qnr_df <- susometa::parse_questionnaire(path = fs::path(json_dir, "document.json"))

# =============================================================================
# Add reusable categories
# =============================================================================

categories_df_raw <- susometa::parse_categories(dir = fs::path(json_dir, "Categories"))
categories_df <- susometa::reshape_categories(categories_df = categories_df_raw)
qnr_df <- susometa::join_categories(
  qnr_json_df = qnr_df,
  categories_df = categories_df
)

# =============================================================================
# Make the metadata data frame Stata-friendly in form and content
# =============================================================================

# function to convert Boolean values to integer
from_bool_to_int <- function(x) {
  dplyr::case_when(
    x == TRUE ~ 1,
    x == FALSE ~ 0,
    TRUE ~ NA
  ) %>%
  as.integer()
}

# create a Stata-friendly version of the data frame
stata_qnr_df <- qnr_df %>%
  # rename columns with illegal names
  dplyr::rename_with(
    .fn = ~ stringr::str_replace_all(
      string = .x,
      pattern = "\\.", 
      replacement = "_"
    )
  ) %>%
  dplyr::mutate(
    # remove newline from string variables
    dplyr::across(
      .cols = tidyselect::where(is.character),
      .fns = ~ stringr::str_replace_all(
        string = .x,
        pattern = "\n",
        replacement = ""
      )
    ),
    dplyr::across(
      .cols = tidyselect::starts_with("is_"),
      .fns = ~ from_bool_to_int(.x)
    )
  ) %>%
  # remove columns with stubborn newline characters
  dplyr::select(-text)

# =============================================================================
# Extract data for questions in the export data
# =============================================================================

# get question metadata
q_df <- stata_qnr_df |>
  # keep only questions and relevant metadata attributes
  susometa::get_questions() |>
  # remove columns that may have newline characters
  dplyr::select(
    -dplyr::matches("_expression") # filter, enablement, and validation expressions
  )

# get variable metadata
var_df <- susometa::get_variables(qnr_df = stata_qnr_df) |>
  # populate `varname` column with `name_variable`
  dplyr::mutate(varname = name_variable)

# combine question and variable metadata
qv_df <- dplyr::bind_rows(q_df, var_df)

# =============================================================================
# Save metadata to a Stata file
# =============================================================================

# question and variable metadata
haven::write_dta(data = qv_df, path = fs::path(out_dir, "question_metadata.dta"))

```
