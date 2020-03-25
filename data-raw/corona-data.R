## Overwrite data?
ovrwrt = TRUE

## code to prepare `corona-infections` dataset goes here
corona_infections <- read_infections()
usethis::use_data(corona_infections, overwrite = ovrwrt)

## code to prepare `corona-recoveries` dataset goes here
corona_recoveries <- corona::read_recoveries()
usethis::use_data(corona_recoveries, overwrite = ovrwrt)

## code to prepare `deaths` dataset goes here
corona_deaths <- corona::read_deaths()
usethis::use_data(corona_deaths, overwrite = ovrwrt)


