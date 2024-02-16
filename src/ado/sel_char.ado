*! version 1.0 20240216 LSMS Team, World Bank lsms@worldbank.org

cap program drop   sel_char
    program define sel_char, rclass

qui {

    version 14.1

    * Update the syntax. This is only a placeholder to make the command run
    syntax [anything], [VARlist(varlist)]

    if missing(`"`anything'"') {
      noi di as error "{pstd}You must provide a {it:query string}.{p_end}"
      error 198
      exit
    }
    local querystring = `"`anything'"'

    *****************************************
    * Initiate varlist

    * If no varlist is provided, use all vars in current dataset
    if missing("`varlist'") {
      qui ds
      local varlist = "`r(varlist)'"
    }

    * Start with a list of all variables in the data se
    local varcount : word count `varlist'
    * The chars used in query string
    local c_used = ""
    * List for all vars that match all chars
    local matched_vars = ""

    *****************************************
    * Parse query string

    * Tokenize the query string
    tokenize `"`querystring'"'

    * Initiate query index and loop until all query pairs
    * are exhausted
    local i = 0
    while (!missing("``++i''")) {

        * Get the first word in pair which is the char
        local c = trim("`: word 1 of ``i'''")
        * Get the rest of the pair which is the value
        local v = trim(subinstr("``i''","`c'","",1))

        * Test if char already specified, if not,
        * then add to c_used
        if (`: list posof "`c'" in c_used') {
          noi di as error "That char is already used"
          error 198
          exit
        }
        local c_used = "`c_used' `c'"

        * Add this char condition
        local `c' = "`v'"
    }

    *****************************************
    * List vars with these chars

    * Loop over each required char
    foreach c of local c_used {

      * Get a list of all vars with this char and initiate a list for matches
      qui ds, has(char `c')
      local h`c' `r(varlist)'
      local m`c' = ""

      * Get the union of the vars that has this chars
      * and all other still elegible vars
      local varlist : list varlist & h`c'
    }

    * Get the count of varaibles that has all the required chars
    local has_all_count : word count `varlist'

    *****************************************
    * Test which vars match the char

    foreach thisvar of local varlist {
      local match = 1 //Start by assuming match in all chars
      * Loop over each char
      foreach c of local c_used {
        * Test if this variable char value match the value provided
        if ("`: char `thisvar'[`c']'" == "``c''") {
          * Add to match list for this char
          local m`c' : list m`c' | thisvar
        }
        * Otherwise stop assuming match
        else local match = 0
      }
      * If still assuming match, then add to final match vars
      if (`match' == 1) local matched_vars : list matched_vars | thisvar
    }

    * Get the count of match vars, and return the count and the full list
    local match_count : word count `matched_vars'
    return local match_count `match_count'
    return local varlist `matched_vars'

    *****************************************
    * Output results for each char if multiple chars were used

    if (`: word count `c_used'' > 1 ) {
      noi di as res _n "{pstd}{ul: Results for each char:}{p_end}"

      local i = 0
      foreach c of local c_used {
        local i = `++i'
        local hl`c' : word count `h`c''
        local ml`c' : word count `m`c''

        return local match_char`i'_count `ml`c''
        return local match_char`i' `m`c''
        return local has_char`i'_count `hl`c''
        return local has_char`i' `h`c''
        return local char`i'_value "``c''"
        return local char`i' "`c'"

        noi di as text _n `"{pstd}Out of the `varcount' variables in this data set, `hl`c'' variable(s) have the char {bf:`c'}. Out of those variables, `ml`c'' variable(s) has the value {bf:"``c''"} in that char.{p_end}"'
      }
    }

    *****************************************
    * Output results for the final match

    noi di as res _n "{pstd}{ul: Results:}{p_end}"
    noi di as text _n `"{pstd}Out of the `varcount' variables in this data set, `has_all_count' variable(s) had the required char(s). Out of those variables, `match_count' variable(s) matched the value for the required char(s).{p_end}"'

}
end
