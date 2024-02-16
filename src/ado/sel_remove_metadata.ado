*! version 1.0 20240216 LSMS Team, World Bank lsms@worldbank.org

cap program drop   sel_remove_metadata
    program define sel_remove_metadata

qui {

    version 14.1

    * Update the syntax. This is only a placeholder to make the command run
    syntax , [Chars(string) MISScharsok]

    * Get data set char with char names added by sel_add_metadata.
    local selector_chars : char _dta[selector_chars]

    * Make sure there are some chars to
    if missing("`misscharsok'") {
      if (missing("`selector_chars'`chars'")) {
        noi di as error "{pstd}Option {opt char()} may not be missing when there is no dataset char named {inp:selector_chars} with the chars to remove. Suppress this error message by using the option {inp:misscharsok}.{p_end}"
        error 99
        exit
      }
    }

    * Combine manually passed charnames and those from dataset chars
    local chars : list chars | selector_chars
    local relevant_vars = ""

    * Get the variables with these chars so we do not need to loop over all vars
    foreach char of local chars {
      qui ds, has(char `char')
      local varlist = "`r(varlist)'"
      local relevant_vars : list relevant_vars | varlist
    }

    * Loop over relevant vars and delete the chars
    foreach var of local relevant_vars {
      foreach char of local chars {
        * clear the char for this var
        char `var'[`char']
      }
    }

    * End by deleting the data set char
    char _dta[selector_chars]

}
end
