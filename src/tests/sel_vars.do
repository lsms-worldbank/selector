
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
  use "${data_fldr}/labeled/lbl_dataset.dta", clear

  ***********************************
  * Tests for sel_vars

  sel_vars is_single_select

  assert "`r(varlist)'" == "v102 v105a v105b v106b n4100 v400e1 v400e2 v400e v401_month v403 v433 v500e v500f v501 v504 v505 v502b v520 v521 v522 v523 v524 v526 v527 v529 v530a v531 v532 v533 v534a v534b v534c v534d v534e v535 v536 v537 v539a_1 v562 v566 n6100 n6101 v6100d v6101_month v6103 v6105m v6106m v6105f v6106f v6107 v6311 v6605 v79200c_0 v79201_0_unit v79203_0 v79206_0 v79200c_1 v79201_unit_1 v79201_cond_1 v79201_wet_1 v79203_1 v79206_1 v405 v4_n1 v4_n2 V4_n3_weight_comments V4_n4_height_comments v4_n5_any_anthro_comments v5_n1 v5_n2 person_confirm v5_n4 v517_1 v517_2 weight_comments height_comments any_anthro_comments v6602 v103m v103f N1041 v109 v111 v110 N113 N114 N115 N116 N118 N119 v201n v208n v210n"

  sel_vars is_numeric
  assert "`r(varlist)'" == "v104 v106 v401_year v402 v502c v502a v507 v508 v528 v530 v534 v539_2 v563 v6101_year v6102 v79201_0 v79202_0 v79204_0 v79201_1 v79202_1 v79204_1 v406_1 v407_1 v406_2 v407_2 v406_3 v407_3 v516_1 v518_1 v516_2 v518_2 v516_3 v518_3 v111b N113b N115b N117 N119bt N119a N119b N119c N119d N119e N119f N119g N119h N119i N119j v202n v203n v204n v205n v206n v207n v209n v211n v212n v214n v215n v216n"

  sel_vars has_decimals
  assert "`r(varlist)'" == "v79201_0 v79202_0 v79204_0 v79201_1 v79202_1 v79204_1 v406_1 v407_1 v406_2 v407_2 v406_3 v407_3 v516_1 v518_1 v516_2 v518_2 v516_3 v518_3"

  sel_vars is_text
  assert "`r(varlist)'" == "v433_os v566_os v6605_os v79201_os_0 v79203_os_0 v79206_os_0 v79201_os_1 v79203_os_1 v79206_os_1 v4_N2_os v4_n6_anthro_comment v5_n2_os anthro_comment TU1 TU2 v103m_os v103f_os N118_os"

  sel_vars follows_pattern
  assert "`r(varlist)'" == "TU1 TU2"

  sel_vars is_list
  assert "`r(varlist)'" == "v101 v430_os__0 v430_os__1 v430_os__2 v430_os__3 v430_os__4 v430_os__5 v430_os__6 v430_os__7 v430_os__8 v430_os__9 v430_os__10 v430_os__11 v430_os__12 v430_os__13 v430_os__14 v430_os__15 v430_os__16 v430_os__17 v430_os__18 v430_os__19 v560b__0 v560b__1 v560b__2 v560b__3 v560b__4 v560b__5 v560b__6 v560b__7 v560b__8 v560b__9 v560b__10 v560b__11 v560b__12 v560b__13 v560b__14 v560b__15 v560b__16 v560b__17 v560b__18 v560b__19"

  sel_vars is_multi_select
  assert "`r(varlist)'" == "v409a__409 v409a__410 v409a__411 v409a__4111 v409a__412 v409a__413 v409a__414 v409a__415 v409a__416 v409a__417 v409a__418 v409a__419 v409a__420 v409a__421 v409a__422 v409a__423 v409a__424 v409a__425 v409a__4251 v409a__4252 v409a__4253 v409a__426 v409a__427 v409a__428 v409a__429 v409a__430 v539a__539 v539a__540 v539a__541 v539a__5411 v539a__542 v539a__543 v539a__544 v539a__545 v539a__546 v539a__547 v539a__548 v539a__549 v539a__5491 v539a__550 v539a__551 v539a__552 v539a__553 v539a__554 v539a__555 v539a__556 v539a__557 v539a__5571 v539a__558 v539a__559 v539a__560 v6100e__1 v6100e__2 v6100e__3 v6100e__4 v213n__1 v213n__2 v213n__3"

  sel_vars is_multi_ordered
  assert "`r(varlist)'" == ""

  sel_vars is_multi_yn
  assert "`r(varlist)'" == "v409a__409 v409a__410 v409a__411 v409a__4111 v409a__412 v409a__413 v409a__414 v409a__415 v409a__416 v409a__417 v409a__418 v409a__419 v409a__420 v409a__421 v409a__422 v409a__423 v409a__424 v409a__425 v409a__4251 v409a__4252 v409a__4253 v409a__426 v409a__427 v409a__428 v409a__429 v409a__430 v539a__539 v539a__540 v539a__541 v539a__5411 v539a__542 v539a__543 v539a__544 v539a__545 v539a__546 v539a__547 v539a__548 v539a__549 v539a__5491 v539a__550 v539a__551 v539a__552 v539a__553 v539a__554 v539a__555 v539a__556 v539a__557 v539a__5571 v539a__558 v539a__559 v539a__560 v213n__1 v213n__2 v213n__3"

  sel_vars is_multi_checkbox
  assert "`r(varlist)'" == "v6100e__1 v6100e__2 v6100e__3 v6100e__4"

  sel_vars is_linked
  assert "`r(varlist)'" == "v400e2 v500e v79200c_0 v79200c_1 N1041"

  sel_vars is_date
  assert "`r(varlist)'" == "v400a v431 v500a v506 v564 v6100a v6604 v79200a_0 v79205_0 v79200a_1 v79205_1 v400aa v400an v500aa v500an tu_start tu_end"

  sel_vars is_calendar_date
  assert "`r(varlist)'" == "v506"

  sel_vars is_timestamp
  assert "`r(varlist)'" == "v400a v431 v500a v564 v6100a v6604 v79200a_0 v79205_0 v79200a_1 v79205_1 v400aa v400an v500aa v500an tu_start tu_end"

  sel_vars is_gps
  assert "`r(varlist)'" == ""

  sel_vars is_variable
  assert "`r(varlist)'" == "age v107 v108 w_mob v404 v503 v503a Calculated_Age_year Calculated_Age_BD_year age_n Calculated_Age_BD year_of_birth month_of_birth year_of_int month_of_int day_of_int v510a v510b v510 v511a v511b v511 v512 v513 v519 v561 em_mob v6104 n_plotwcrop_0 n_unitwsize_0 n_cond_0 auto_totqty_0 tot_qty_0 tot_unit_code_0 tot_unit_str_0 tot_size_code_0 after_sales_qty_0 sales_text_0 n_plotwcrop_1 n_unitwsize_1 n_cond_1 auto_totqty_1 tot_qty_1 tot_cond_1 tot_unit_code_1 tot_unit_str_1 after_sales_qty_1 sales_text_1 w_bmi1 w_bmi2 v4_n11_weight_diff12 v4_n12_height_diff12 w_bmi3 v4_n7_weight_diff13 v4_n8_weight_diff23 v4_n9_height_diff13 v4_n10_height_diff23 w_weight w_height w_bmi age_months additional_months sexboo weight_diff12 height_diff12 weight_diff13 weight_diff23 height_diff13 height_diff23 weight height hfa wfa wfh WakeHour WakeQ SleepHour SleepQ educ_exp"

  sel_vars is_picture 
  assert "`r(varlist)'" == "nutrition_femme nutrition_enfant"

  sel_vars is_barcode
  assert "`r(varlist)'" == ""
    