

* Kristoffer's root path
if "`c(username)'" == "wb462869" {
    global clone "C:\Users\wb462869\github\selector"
}
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
* Set up the test data to test on
use "${data_fldr}\dta/meta_PERSONS.dta", clear
sel_add_metadata using "${data_fldr}\csv/question_metadata.dta"


***********************************
* Tests for sel_char

* Combine a type match with a custom query
local query `""variable_label Roster ID variable" "'
sel_char `query'
return list

* Combine a type match with a custom query
local query `" "variable_label Has the household paid for [NAME] to have [ITEM] in the past 12 months?" "yes_no_view 1" "'
sel_char "variable_label Has the household paid for [NAME] to have [ITEM] in the past 12 months?" "yes_no_view 1"
return list
