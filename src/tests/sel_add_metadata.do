
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
    cap mkdir    "${test_fldr}/dev-env"
    repado using "${test_fldr}/dev-env"

    cap net uninstall selector
    net install selector, from("${src_fldr}") replace

    * output version of this package
    selector

    ***********************************
    * Tests for sel_add_metadata

    * Load a dataset in
    use "${data_fldr}/raw/dataset.dta", clear
    sel_add_metadata using "${data_fldr}/raw/metadata.dta"

    * See output
    char list

    * Test some random variables
    assert "`: char n4100[is_timestamp]'"       == "0"
    assert "`: char n4100[variable_label]'"     == "IS [NAME] AVAILABLE TO BE INTERVIEWED?"
    assert "`: char n4100[type]'"               == "SingleQuestion"

    assert "`: char v560b__17[is_timestamp]'"   == "0"
    assert "`: char v560b__17[variable_label]'" == "PLEASE WRITE DOWN ANY OTHER FOODS THAT [NAME] ATE"
    assert "`: char v560b__17[type]'"           == "TextListQuestion"

    assert "`: char SleepHour[type]'"           == "Variable"

    assert "`: char v518_1[is_timestamp]'"      == "0"
    assert "`: char v518_1[is_integer]'"        == "0"
    assert "`: char v518_1[variable_label]'"    == "V518_1. WEIGHT OF [NAME] IN KILOGRAMS"
    assert "`: char v518_1[type]'"              == "NumericQuestion"
    
    
    * Testing MultyOptionsQuestion chars
    
    assert "`: char v213n__1[answer_text]'" == "Vaccination"
    * Testing that all MultyOptionsQuestion got this char
    ds, has(char answer_text)
    foreach var in `r(varlist)' {
      assert "`: char `var'[answer_text]'" != "N/A - not found"
    }
      