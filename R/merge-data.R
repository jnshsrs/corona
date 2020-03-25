
#' Merge Infection, Death and Recover datasets
#'
#' @return A dataframe with columns infections, deaths, recoveries (plus the constant columns state, country, lat, long, and date)
#'
#' @examples \dontrun{
#' data <- merge_data()
#' head(data)
#' }
merge_data <- function() {

  # Read dataframes from github
  deaths <- read_deaths()
  infections <- read_infections()
  recoveries <- read_recoveries()

  # Create list to apply functional programming (from purrr)
  lst <- list(deaths, infections, recoveries)

  # Join all three dataframes (new dataframe contains the infections, deaths, and recoveries column)
  data <- purrr::reduce(lst, .f = dplyr::full_join)

}
