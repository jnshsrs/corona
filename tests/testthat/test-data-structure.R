
test_that("column name of long corona data is correct", {

  data <- read_deaths(file = "~/r-projects/proj_packages/corona/data-raw/deaths-raw.csv")
  condition <- "deaths" %in% names(data)
  expect_that(condition, equals(TRUE))

})
