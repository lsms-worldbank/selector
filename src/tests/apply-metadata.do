
    * Kristoffer's root path
    if "`c(username)'" == "wb462869" {
        global clone "C:\Users\wb462869\github\selector"
    }
    if "`c(username)'" == "wb393438" {
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
    
    * Load a dataset in 
    use "${data_fldr}\dta/meta_PERSONS.dta", clear

    local metadatafile "${data_fldr}\csv/question_metadata.dta"
    sel_add_metadata using `metadatafile'
    
    * See output
    char list