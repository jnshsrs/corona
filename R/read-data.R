#' Reads a csv with JHU corona data
#'
#' This function is mainly a helper function to read more
#' specific datasets (infections, deaths, recoveries)
#'
#' @param file The file path to data (in the main function it refers to the JHU github site)
#'
#' @return A tibble containing the JHU corona data
#'
#' @importFrom rlang .data
#'
#' @examples \dontrun{
#' file <- "URL"
#' read_corona_data(file)
#' }
#'
read_raw_corona <- function(file) {

  readr::read_csv(file,
                  col_types = readr::cols(
                    `Province/State` = readr::col_character(),
                    `Country/Region` = readr::col_character(),
                    Lat = readr::col_double(),
                    Long = readr::col_double()
                  )) %>%
    rename_corona_data() %>%
    pivot_longer_by_date()

}

#' Read Corona Death Numbers
#'
#' @param file The file path to load from. Do not specify it, to load from
#' JHU github repository (which is recommended)
#'
#' @param file The file path to load from. Do not specify it, to load from
#' JHU github repository (which is recommended)
#'
#' @return A tibble containing country, state, date, number of recoveries
#'
#' @export
#'
#' @examples \dontrun{
#' read_deaths()
#' }
read_deaths <- function(file = NULL) {

  if (is.null(file)) {
    file <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv"
  }

  read_raw_corona(file) %>% dplyr::rename(deaths = .data$value)

}


#' Read Corona Infection Numbers
#'
#'
#' @param file The file path to load from. Do not specify it, to load from
#' JHU github repository (which is recommended)
#'
#' @return A tibble containing country, state, date, number of infections
#'
#' @export
#'
#' @examples \dontrun{
#' read_infections()
#' }
read_infections <- function(file = NULL) {

  if (is.null(file)) {
    file <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv"
  }

  read_raw_corona(file) %>% dplyr::rename(infections = .data$value)

}

#' Read Corona Recovered Numbers
#'
#' @param file The file path to load from. Do not specify it, to load from
#' JHU github repository (which is recommended)
#'
#' @return A tibble containing country, state, date, number of recoveries
#'
#' @export
#'
#' @examples \dontrun{
#' read_recoveries()
#' }
read_recoveries <- function(file = NULL) {

  if (is.null(file)) {
    file <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv"
  }

  read_raw_corona(file) %>% dplyr::rename(recoveries = .data$value)

}

#' Read the corona data
#'
#' Returns a dataframe (tibble) with state, country, lat, long,
#' date and poll numbers (infections, deaths and recoveries).
#' The returned dataframe is a unified version of three
#' distinct datasets, each containing infection, deaths, recover data.
#'
#' @return A tibble with
#'
#' @export
#'
#' @examples \dontrun{
#' read_corona()
#' }
read_corona <- function() {

  # read each single dataframe
  infections <- read_infections()
  deaths <- read_deaths()
  recoveries <- read_recoveries()

  # create a list to use it to join all three dataframes in one line (purrr)
  lst <- list(infections, deaths, recoveries)
  # join/merge datasets
  lst %>% purrr::reduce(.f = dplyr::full_join, by = c("state", "country", "Lat", "Long", "date"))


}


