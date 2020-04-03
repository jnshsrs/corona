## code to prepare `corona_data`
corona_data <- corona::read_corona()
usethis::use_data(corona_data, overwrite = TRUE)

