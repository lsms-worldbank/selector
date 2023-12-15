*! version XX XXXXXXXXX ADAUTHORNAME ADCONTACTINFO

cap program drop   sel_add_metadata
    program define sel_add_metadata, rclass
qui {
    * Update the syntax. This is only a placeholder to make the command run
    syntax [using]

    //List all properties to add to char
    local cols "variable_label type"

    char _dta[selector_chars] "`cols'"

    * Store meta data in a frame
    tempname metadata
    frame create `metadata'
    frame `metadata': use `using', clear

    * Make sure that varname is unique in the frame
    frame `metadata' {
      cap isid varname
      if _rc {
        // TODO: clean up this output - good for debuggin
        noi di as error "{pstd}duplicates or missing values in varname{p_end}"
        noi list if missing(varname)
        duplicates tag varname , gen(_dup)
        noi list if _dup != 0
        error _rc
        exit
      }
    }

    // Loop over all variables and get the properties from the char
    foreach var of varlist _all {
      frame `metadata': noi extract_value, var("`var'") cols("`cols'")
      if ("`r(success)'" == "true") {
        foreach col of local cols {
          char `var'[`col'] "`r(`col')'"
        }
      }
      else if ("`r(success)'" == "false") {
        noi di "{pstd}Var `var' not found in meta data.{p_end}"
      }
    }
    return list
}
end

cap program drop   extract_value
    program define extract_value, rclass
qui {
    syntax, var(string) cols(string)

    * Get the number of rows
    qui count
    local count_meta = `r(N)'

    * Search on full variable name
    forvalues i = 1/`count_meta' {
      if ("`var'" == "`=varname[`i']'") {
        foreach col of local cols {
          return local `col' "`=`col'[`i']'"
        }
        return local success "true"
        exit
      }
    }

    * Get part before __ and search on that, get the meta data
    local prefix = substr("`var'",1,strpos("`var'","__")-1)
    if !missing("`prefix'") {
      //noi di "{pstd}Second search for `var' with prefix `prefix'.{p_end}"
      forvalues i = 1/`count_meta' {
        if ("`prefix'" == "`=varname[`i']'") {
          foreach col of local cols {
            return local `col' "`=`col'[`i']'"
          }
          return local success "true"
          exit
        }
      }
    }

    * compile lists of system-generated variables
    local id_vars "interview__key interview__id assignment__id"
    local oth_vars "sssys_irnd has__error interview__status"

    * Set the char of SuSo's system-generated variables
    forvalues i = 1/`count_meta' {
      
      * determine whether variable is any of the system-generated types
      local is_id_var : list var in id_vars
      local is_oth_sys_var : list var in oth_vars
      local is_roster_id_var = (`is_id_var' == 0) & ustrregexm("`var'", "__id$")
      
      if (`is_id_var' == 1) {
        * label, manually reproducing labels used in export data
        if ("`var'" == "interview__key") {
          return local variable_label "Interview key (identifier in XX-XX-XX-XX format)"
        }
        else if ("`var'" == "interview__id") {
          return local variable_label "Unique 32-character long identifier of the interview"
        }
        else if ("`var'" == "assignment__id") {
          return local variable_label "Assignment id (identifier in numeric format)"
        }
        * type
        return local type "System-generated ID variable"
        * success
        return local success "true"
        exit
      }
      else if (`is_oth_sys_var' == 1) {
        * label, manually reproducing labels used in export data
        if ("`var'" == "sssys_irnd") {
          return local variable_label "Random number in the range 0..1 associated with interview"
        }
        else if ("`var'" == "has__error") {
          return local variable_label "Errors count in the interview"
        }
        else if ("`var'" == "interview__status") {
          return local variable_label "Status of the interview"
        }
        * type
        return local type "System-generated"
        * success
        return local success "true"
        exit
      }
      else if (`is_roster_id_var' == 1) {
        return local variable_label "Roster ID variable"
        return local type "System-generated ID variable"
        return local success "true"
        exit
      }

    }

    * If code ends up here, then the varname was not found
    return local success "false"

}
end
