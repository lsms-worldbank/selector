  if "`c(username)'" == "wb462869" {
      global clone "C:/Users/wb462869/github/selector"
  }
  else if "`c(username)'" == "wb393438" {
      global clone "C:\Users\wb393438\stata_funs\selector"
  }

  cap ado uninstall adodown
  net install   adodown, from("C:\Users\wb462869\github\adodown\src") replace
  
  ad_publish , adf("${clone}") ssczip
  
  
