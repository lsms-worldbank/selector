* Kristoffer's root path
if "`c(username)'" == "wb462869" {
    global clone "C:\Users\wb462869\github\selector"
}
* Arthur's root path
else if "`c(username)'" == "wb393438" {
    global clone "C:\Users\wb393438\stata_funs\selector"
}

* Set global to ado_fldr
global src_fldr  "${clone}/src"
global test_fldr "${src_fldr}/tests"
global data_fldr "${test_fldr}/testdata"

* Install the version of this package in
* the plus-ado folder in the test folder
cap mkdir "${test_fldr}/plus-ado"
repado , adopath("${test_fldr}/plus-ado") mode(strict)

cap net uninstall selector
net install selector, from("${src_fldr}") replace

* output version of this package
selector

* =============================================================================
* Selects variables
* =============================================================================

* create sets of variables
#delim ;
local test_vars "
housing_unit
s01q01_quantity
s01q01_unit
s01q02_quantity
s01q02_unit
s01q03_quantity
s01q03_unit
s01q03_quantity
s01q03_unit
";
#delim cr

foreach test_var of local test_vars {
    capture gen `test_var' = .
}

* select variables that end in `_unit` for questions 02 and 03
sel_matches_regex "0[23]_unit$"
local unit_vars = r(varlist)
local unit_vars : list clean unit_vars

* test
capture assert "`unit_vars'" == "s01q02_unit s01q03_unit"
if _rc != 0 {
    di as error "Test failed"
    error 0
}
else {
    di as result "Test passed"
}

* tear-down
drop `test_vars' 

* =============================================================================
* Selects complement of selection
* =============================================================================

#delim ;
local test_vars2 = "
s01q01
s01q02
s01_q03
s01q04
S01q04
s01q05a
s01q05_unit
";
#delim cr

foreach test_var of local test_vars2 {
    capture gen `test_var' = .
}

* identify variables that do NOT follow the pattern
sel_matches_regex "s01q0[0-9][a-z]*$", negate
local not_matching_vars = r(varlist)
local not_matching_vars : list clean not_matching_vars

* test
capture assert "`not_matching_vars'" == "s01_q03 S01q04 s01q05_unit"
if _rc != 0 {
    di as error "Test failed"
    error 0
}
else {
    di as result "Test passed"
}

* tear-down
drop `test_vars2'

* =============================================================================
* Test `varlist` option. Narrows the scope of search
* =============================================================================

* setup
#delim ;
local test_vars3 "
var1
var1a
var1b
var2
var2a
var2b
var3
var4
var5
";
#delim cr

foreach test_var of local test_vars3 {
    capture gen `test_var' = .
}

* test
sel_matches_regex "var[0-9][a-z]", varlist(var2 - var3)
local matches_in_scope = r(varlist)
local matches_in_scope : list clean matches_in_scope

capture assert "`matches_in_scope'" == "var2a var2b"
if _rc != 0 {
    di as error "Test failed"
    error 0
}
else {
    di as result "Test passed"
}

* tear-down
drop `test_vars3'
