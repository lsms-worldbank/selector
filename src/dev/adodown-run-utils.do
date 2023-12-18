  if "`c(username)'" == "wb462869" {
      global clone "C:/Users/wb462869/github/selector"
  }

//   ad_setup, adf("${clone}")  ///
//       name("selector")             ///
//       description("Load SuSo meta data into chars and utilities using them.")      ///
//       author("LSMS Worldbank")           ///
//       contact("lsms@worldbank.org")          ///
//       url("https://github.com/lsms-worldbank/selector") ///
//       github

  //ad_command create sel_remove_metadata, adf("${clone}") pkg("selector")

  ad_sthlp, adf("${clone}")
