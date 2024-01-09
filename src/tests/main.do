    
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
    confirm number `r(version)'
    assert  !missing("`r(version)'")
    assert  !missing("`r(versiondate)'")
    assert  strlen("`r(versiondate)'") == 9

    ********************************
    * Test each command
    
    * Test sel_add_metadata command
    clear
    qui do "${test_fldr}/sel_add_metadata.do"
    
    * Test sel_vars command
    clear
    qui do "${test_fldr}/sel_vars.do"
    
    * Test sel_matches_regex command
    clear
    qui do "${test_fldr}/sel_matches_regex.do"
    
    * Test sel_char command
    clear
    qui do "${test_fldr}/sel_char.do"
    
    * Test sel_remove_metadata command
    clear
    qui do "${test_fldr}/sel_remove_metadata.do"