*! version 1.0 20231206 LSMS Team, World Bank lsms@worldbank.org

cap program drop   sel_vars
    program define sel_vars, rclass

qui {

    version 14.1

    * Update the syntax. This is only a placeholder to make the command run
    syntax anything, [ VARlist(varlist) NEGate]

    if missing("`anything'") {
      noi di as error "{pstd}You must provide a sub-command.{p_end}"
      error 198
      exit
    }
    local subcommand = "`anything'"

    *****************************************
    * initiate locals

    * If no varlist is provided, use all vars in current dataset
    if missing("`varlist'") {
      qui ds
      local varlist = "`r(varlist)'"
    }
    local varcount : word count `varlist'

    *****************************************
    * Loop over all subcommands

    if ("`subcommand'" == "is_single_select" ) {
      filter_vars , varlist("`varlist'") type("SingleQuestion")
    }
    else if ("`subcommand'" == "is_numeric" ) {
      filter_vars , varlist("`varlist'") type("NumericQuestion")
    }
    else if ("`subcommand'" == "has_decimals" ) {
      filter_vars , varlist("`varlist'") type("NumericQuestion") is_integer("0")
    }
    else if ("`subcommand'" == "is_text" ) {
      filter_vars , varlist("`varlist'") type("TextQuestion")
    }
    else if ("`subcommand'" == "follows_pattern" ) {
      filter_vars , varlist("`varlist'") type("TextQuestion") mask
    }
    else if ("`subcommand'" == "is_list" ) {
      filter_vars , varlist("`varlist'") type("TextListQuestion")
    }
    else if ("`subcommand'" == "is_multi_select" ) {
      filter_vars , varlist("`varlist'") type("MultyOptionsQuestion")
    }
    else if ("`subcommand'" == "is_multi_ordered" ) {
      filter_vars , varlist("`varlist'") type("MultyOptionsQuestion") are_answers_ordered("1")
    }
    else if ("`subcommand'" == "is_multi_yn" ) {
      filter_vars , varlist("`varlist'") type("MultyOptionsQuestion") yes_no_view("1")
    }
    else if ("`subcommand'" == "is_multi_checkbox" ) {
      filter_vars , varlist("`varlist'") type("MultyOptionsQuestion") yes_no_view("0")
    }
    else if ("`subcommand'" == "is_linked" ) {
      * linked to a roster ID
      filter_vars , varlist("`varlist'") linked_to_roster_id
      local linked_to_roster "`r(varlist)'"
      * linked to a (list) question
      filter_vars , varlist("`varlist'") linked_to_question_id
      local linked_to_question "`r(varlist)'"
      * combine both sets of linked questions
      combine_varlists, union(`linked_to_roster' `linked_to_question')
    }
    else if ("`subcommand'" == "is_date" ) {
      filter_vars , varlist("`varlist'") type("DateTimeQuestion")
    }
    else if ("`subcommand'" == "is_calendar_date" ) {
      filter_vars , varlist("`varlist'") type("DateTimeQuestion") is_timestamp("0")
    }
    else if ("`subcommand'" == "is_timestamp" ) {
      filter_vars , varlist("`varlist'") type("DateTimeQuestion") is_timestamp("1")
    }
    else if ("`subcommand'" == "is_gps" ) {
      filter_vars , varlist("`varlist'") type("GpsCoordinateQuestion")
    }
    else if ("`subcommand'" == "is_variable" ) {
      filter_vars , varlist("`varlist'") type("Variable")
    }
    else if ("`subcommand'" == "is_picture" ) {
      filter_vars , varlist("`varlist'") type("MultimediaQuestion")
    }
    else if ("`subcommand'" == "is_barcode" ) {
      filter_vars , varlist("`varlist'") type("QRBarcodeQuestion")
    }

    * Incorrect subcommand used
    else {
      noi di as error "{pstd}Invalid subcommand [`subcommand']. See helpfile for valid sub-commands.{p_end}"
      error 99
      exit
    }

    * Store returned values from filter_vars in locals
    local matched_vars "`r(varlist)'"
    local has_all_count "`r(has_all_count)'"

    * Apply negate if used
    if !missing("`negate'") local matched_vars : list varlist - matched_vars

    * Get the count of match vars, and return the count and the full list
    local match_count : word count `matched_vars'
    return local match_count `match_count'
    return local varlist `matched_vars'

    *****************************************
    * Output results for the final match

    noi di as res _n "{pstd}{ul: Results:}{p_end}"
    noi di as text _n `"{pstd}Out of the `varcount' variables in this data set, `has_all_count' variable(s) had the required char(s). Out of those variables, `match_count' variable(s) matched the value for the required char(s).{p_end}"'

}
end

cap program drop   filter_vars
    program define filter_vars, rclass

    syntax , varlist(string) [ ///
      type(string) is_integer(string) ///
      are_answers_ordered(string) ///
      yes_no_view(string) is_timestamp(string) ///
      linked_to_roster_id linked_to_question_id mask ///
      negate ///
    ]

    *Var list to filter on variables with the correct char
    local fvarlist = "`varlist'"

    * List the chars
    local value_chars "type is_integer are_answers_ordered yes_no_view is_timestamp"
    local exist_chars "linked_to_roster_id linked_to_question_id mask"
    local chars "`value_chars' `exist_chars'"

    * Get the list of variables that has all the relevant chars
    foreach char of local chars {
      if !missing("``char''") {
        * Keep only the vars in the varlist that has this char
        qui ds, has(char `char')
        local this_varlist `r(varlist)'
        local fvarlist : list fvarlist & this_varlist
      }
    }

    * Return number of varaibles that has the relevant chars
    return local has_all_count : word count `fvarlist'

    * Copy filter varlist to a varlist for matched vars
    local mvarlist "`fvarlist'"

    foreach thisvar of local fvarlist {
      local match = 1 //Start by assuming match in all chars
      * Loop over each char

      foreach char of local value_chars {
        if !missing("``char''") {
          if ("`: char `thisvar'[`char']'" != "``char''") {
            local match = 0
          }
        }
      }

      * If not a match, remove from match list
      if (`match' == 0) local mvarlist : list mvarlist - thisvar
    }

    if missing("`negate'") return local varlist "`mvarlist'"
    else return local varlist : list varlist - mvarlist

end

cap program drop   combine_varlists
    program define combine_varlists, rclass

    syntax, union(varlist) [remove(varlist)]

    * Allows multiple varlists to be combined to one
    local varlist : list uniq union
    * Allows to remove specific variables
    local varlist : list varlist - remove

    * Return on the format r(varlist)
    return local varlist "`varlist'"
end
