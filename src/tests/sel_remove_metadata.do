
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

* ==============================================================================
* Test that removes all SuSo metadata
* ==============================================================================

* ------------------------------------------------------------------------------
* Setup
* ------------------------------------------------------------------------------

* Load a dataset in 
use "${data_fldr}\dta/meta_PERSONS.dta", clear

* add metadata
local metadatafile "${data_fldr}\csv/question_metadata.dta"
sel_add_metadata using `metadatafile'

* ------------------------------------------------------------------------------
* Test
* ------------------------------------------------------------------------------

* remove metadata
sel_remove_metadata
char list

* ------------------------------------------------------------------------------
* Teardown
* ------------------------------------------------------------------------------

clear

* ==============================================================================
* Test that removes specified char(s)
* ==============================================================================

* ------------------------------------------------------------------------------
* Setup
* ------------------------------------------------------------------------------

* Load a dataset in 
use "${data_fldr}\dta/meta_PERSONS.dta", clear

* add metadata
local metadatafile "${data_fldr}\csv/question_metadata.dta"
sel_add_metadata using `metadatafile'

* ------------------------------------------------------------------------------
* Test
* ------------------------------------------------------------------------------

sel_remove_metadata, char(variable_label)

* ------------------------------------------------------------------------------
* Teardown
* ------------------------------------------------------------------------------

clear

* ==============================================================================
* Test that misscharok works
* ==============================================================================

* ------------------------------------------------------------------------------
* Setup
* ------------------------------------------------------------------------------

* Load a dataset in 
use "${data_fldr}\dta/meta_PERSONS.dta", clear

* add metadata
local metadatafile "${data_fldr}\csv/question_metadata.dta"
sel_add_metadata using `metadatafile'

* ------------------------------------------------------------------------------
* Test
* ------------------------------------------------------------------------------

* remove all SuSo chars
sel_remove_metadata

* check that errors if try to remove non-existing chars
capture sel_remove_metadata
if !_rc {
    di as error "Test failed - Expected rc 0 got rc:"
    di _rc
    di as result "sel_remove_metadata errors if no chars found"
}


* check that misscharok suppresses error if try to remove non-existing chars
capture sel_remove_metadata, misscharsok
if _rc {
    di as error "Test failed - Expected rc 99 got rc:"
    di _rc
    di as result "misscharok suppresses error if try to remove non-existing chars"
}
