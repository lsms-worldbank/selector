*! version 1.0 05JAN2024 LSMS Team World Bank lsms@worldbank.org

cap program drop   sel_matches_regex
    program define sel_matches_regex, rclass

qui {

    version 14

    syntax anything (name=pattern), [NEGate VARlist(varlist)]



    d `varlist', varlist
    local vars = r(varlist)

    * initiate return_vars. If negate is not used, start with empty list.
    * If it is used, start with full varlist
    local return_vars ""
    if !missing("`negate'") local return_vars "`vars'"

    * loop over variables
    foreach var of local vars {
        * check whether variable matches
        if (`=ustrregexm("`var'", `pattern')') {
          * If negate not used add to return_vars
          if missing("`negate'") local return_vars : list return_vars | var
          * If negate was used, remove var from return_vars
          else local return_vars : list return_vars - var
        }
    }

    * return the return_vars
    return local varlist =  "`return_vars'"

    * message about outcome
    local n_matches : list sizeof return_vars
    return local count_regex_matches =  "`n_matches'"
    if (`n_matches' >= 1) {
        noi di as result "Matches found (`n_matches' variables) :"
        noi di as text "`return_vars'"
    }
    else if (`n_matches' == 0) {
        noi di as error "No matching variables found"
        noi di as result "If this result is unexpected, please check the regular expression provided."
    }
}
end
