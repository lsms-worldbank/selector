capture program drop sel_matches_regex
program define sel_matches_regex, rclass

qui {
    syntax anything (name=pattern), [negate]

    d, varlist
    local vars = r(varlist)

    * initialize matching vars to be an empty set
    local matching_vars ""

    * loop over variables
    foreach var of local vars {

        * check whether variable matches
        local var_matches = ustrregexm("`var'", `pattern')

        * if so, add that variable to the list of matches
        if (`var_matches' == 1) {
            local matching_vars "`matching_vars' `var'"
        }
        * otherwises, leave the list unchanged:w
        else if (`var_matches' == 0) {
            local matching_vars "`matching_vars'"
        }

    }

    * handle `negate` flag, if present
    if ("`negate'" != "") {
        local not_matching_vars : list vars - matching_vars
        noi di "`not_matching_vars'"
        local matching_vars = "`not_matching_vars'"
    }

    * return list
    return local matching_vars =  "`matching_vars'"

    * message about outcome
    local n_matches : list sizeof matching_vars
    if (`n_matches' >= 1) {
        noi di as result "Matches found (`n_matches' variables) :"
        noi di as text "`matching_vars'"
    }
    else if (`n_matches' == 0) {
        noi di as error "No matching variables found"
        noi di as result "If this result is unexpected, please check the regular expression provided."
    }
}
end
