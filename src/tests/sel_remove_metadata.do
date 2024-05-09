
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
  cap mkdir    "${test_fldr}/dev-env"
  repado using "${test_fldr}/dev-env"

  cap net uninstall selector
  net install selector, from("${src_fldr}") replace

  * output version of this package
  selector

  * ============================================================================
  * Test that removes all SuSo metadata
  * ============================================================================

  * Set up the test data to test on
  use "${data_fldr}/labeled/lbl_dataset.dta", clear

  * Add custom char
  char age[test] "test"

  * remove metadata
  sel_remove_metadata

  * Rest removal dataset char
  assert missing("`: char _dta[selector_chars]'")

  * Test some random variables
  assert missing("`: char n4100[is_timestamp]'")
  assert missing("`: char SleepHour[type]'")
  assert missing("`: char v518_1[is_integer]'")
  assert missing("`: char v560b__17[variable_label]'")

  * Make sure custom char is still there
  assert "`: char age[test]'" == "test"


  * ============================================================================
  * Test that removes specified char(s)
  * ============================================================================

  * Set up the test data to test on
  use "${data_fldr}/labeled/lbl_dataset.dta", clear

  * Add custom char
  char age[test] "test"

  sel_remove_metadata, char("test")

  * Rest removal dataset char
  assert missing("`: char _dta[selector_chars]'")

  * Test some random variables
  assert missing("`: char n4100[is_timestamp]'")
  assert missing("`: char SleepHour[type]'")
  assert missing("`: char v518_1[is_integer]'")
  assert missing("`: char v560b__17[variable_label]'")

  * Make sure custom char is now removed
  assert missing("`: char age[test]'")


  * ============================================================================
  * Test that misscharok works
  * ============================================================================

  * ----------------------------------------------------------------------------
  * Setup
  * ----------------------------------------------------------------------------

  * Set up the test data to test on
  use "${data_fldr}/labeled/lbl_dataset.dta", clear

  * ----------------------------------------------------------------------------
  * Test
  * ----------------------------------------------------------------------------

  * remove all SuSo chars
  sel_remove_metadata

  * check that errors if try to remove non-existing chars
  capture sel_remove_metadata
  * Make sure error is thrown if sel_remove_metadata is used without char()
  * when the selector chars are already removed
  assert _rc == 99

  * check that misscharok suppresses error if try to remove non-existing chars
  sel_remove_metadata, misscharsok

  * ============================================================================
  * Test that error arises if user specifies non-existant char
  * ============================================================================

  * ----------------------------------------------------------------------------
  * Setup
  * ----------------------------------------------------------------------------

  * Set up the test data to test on
  use "${data_fldr}/labeled/lbl_dataset.dta", clear

  * ----------------------------------------------------------------------------
  * Test
  * ----------------------------------------------------------------------------

  capture sel_remove_metadata, chars(foo)
  assert _rc == 99
