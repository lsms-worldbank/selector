*! version 1.0 20231206 LSMS Team, World Bank lsms@worldbank.org

cap program drop   selector
    program define selector, rclass

qui {

version 14.1

    * UPDATE THESE LOCALS FOR EACH NEW VERSION PUBLISHED
  	local version "1.0"
  	local versionDate "05NOV2023"

  	syntax [anything]

    * Command is used used to return version info
      * Prepare returned locals
      return local versiondate     "`versionDate'"
      return local version		      = `version'

      * Display output
      noi di ""
      local cmd    "selector"
      local vtitle "This version of {inp:`cmd'} installed is version:"
      local btitle "This version of {inp:`cmd'} was released on:"
      local col2 = max(strlen("`vtitle'"),strlen("`btitle'"))
      noi di as text _col(4) "`vtitle'" _col(`col2')"`version'"
      noi di as text _col(4) "`btitle'" _col(`col2')"`versionDate'"

}
end
