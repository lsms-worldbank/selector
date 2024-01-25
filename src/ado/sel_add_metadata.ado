*! version 1.0 05JAN2024 LSMS Team World Bank lsms@worldbank.org

cap program drop   sel_add_metadata
    program define sel_add_metadata, rclass

qui {

    version 14

    * Syntax is only reading the meta data file
    syntax using

    * Setup lists of system-generated variables
    local id_vars "interview__key interview__id assignment__id"
    local oth_vars "sssys_irnd has__error interview__status"

    * List all properties to add to char
    local cols "type variable_label linked_to_roster_id linked_to_question_id is_integer mask are_answers_ordered yes_no_view is_timestamp question_text"

    * MultyOptionsQuestion specific cols
    local cols "`cols' answer_text"

    * Add the list of chars this command creates so they can be easily removed
    char _dta[selector_chars] "`cols'"

    * Store meta data in a frame
    tempname      metadata
    frame create `metadata'
    frame        `metadata': use `using', clear

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

      * determine whether variable is any of the system-generated types
      local is_id_var : list var in id_vars
      local is_roster_id_var = (`is_id_var' == 0) & ustrregexm("`var'", "__id$")
      local is_oth_sys_var : list var in oth_vars

      * First handle system vars
      if (`is_id_var' | `is_oth_sys_var' | `is_roster_id_var') {
        * Get hardcoded meta info for system generated varaibles
        noi get_system_var_values, var("`var'") ///
          is_id_var(`is_id_var') ///
          is_roster_id_var(`is_roster_id_var') ///
          is_oth_sys_var(`is_oth_sys_var')
      }
      * Handle non-system varaibles
      else {
        * Get meta info from metafile
        frame `metadata': noi extract_meta_value, ///
          var("`var'") cols("`cols'")
      }

      * If success, apply chars
      if ("`r(success)'" == "true") {
        foreach col of local cols {
          char `var'[`col'] "`r(`col')'"
        }
      }
      * List variables that were not found
      else {
          noi di "{pstd}Var `var' not found in meta data.{p_end}"
      }
    }
}
end


* This sub-command generates the meta data for system generated variables
cap program drop   get_system_var_values
    program define get_system_var_values, rclass
qui {
    syntax, var(string) ///
      is_id_var(numlist) ///
      is_roster_id_var(numlist) ///
      is_oth_sys_var(numlist)

    * ID variables
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
      return local type "System-generated ID variable"
      return local success "true"
    }

    * Roster ID varaibles
    else if (`is_roster_id_var' == 1) {
      return local variable_label "Roster ID variable"
      return local type "System-generated ID variable"
      return local success "true"
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
      return local type "System-generated"
      return local success "true"
    }

    * Something is wrong, return this for de-bugging purposes
    else {
      return local success "false"
    }
}
end

* This sub-command generates the meta data from meta data file in using
cap program drop   extract_meta_value
    program define extract_meta_value, rclass
qui {
    syntax, var(string) cols(string)
    local success "false"

    * Remove non general cols from cols
    local multyOptionsQuestionCols "answer_text"
    local cols : list cols - multyOptionsQuestionCols

    * Get the number of rows
    qui count
    local var_n = `r(N)'

    * Search on full variable name
    forvalues i = 1/`var_n' {
      if ("`var'" == "`=varname[`i']'") {
        foreach col of local cols {
          if !(missing("`=`col'[`i']'") | "`=`col'[`i']'" == ".") {
            return local `col' "`=`col'[`i']'"
          }
        }
        local success "true"
      }
    }

    * Skip if meta data already found for this var
    if ("`success'" != "true") {
      * Get part before __ and search on that, get the meta data
      local prefix = substr("`var'",1,strpos("`var'","__")-1)
      if !missing("`prefix'") {
        //noi di "{pstd}Second search for `var' with prefix `prefix'.{p_end}"
        forvalues i = 1/`var_n' {
          if ("`prefix'" == "`=varname[`i']'") {
            foreach col of local cols {
              if !(missing("`=`col'[`i']'") | "`=`col'[`i']'" == ".") {
                return local `col' "`=`col'[`i']'"
              }
            }

            * Add answer_text char to MultyOptionsQuestion
            if ("`=type[`i']'" == "MultyOptionsQuestion") {
              *Get the code used in SuSo
              local suso_code = subinstr("`var'","`prefix'__","",1)
              * Loop over all answer_value_* vars to find the suso_code
              local j = 1
              while (`j'>0) {
                * If no more answer_text vars exit while loop and return N/A
                cap confirm variable answer_value_`j'
                if _rc {
                  return local answer_text "N/A - not found"
                  noi di "Var `var': N/A"
                  local j = -1
                }
                * More vars exists keep looking for the suso_code
                else {
                  * If suso_code found, return the corresponding answer_text
                  * and exit the while loop
                  if (`=answer_value_`j'[`i']' == `suso_code') {
                    return local answer_text "`=answer_text_`j'[`i']'"
                    local j = -1
                  }
                }
                * If loop is not exited, then move to next answer_value_* var
                local j = `j' + 1
              }
            }

            * Variable found, return success
            local success "true"
          }
        }
      }
    }

    * If code ends up here, then the varname was not found
    return local success "`success'"
}
end
