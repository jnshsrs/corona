#' The number of infections with the corresponsing country/ state and date
#'
#' This dataset is downloaded from the John Hopkins University github account.
#'
#' @format A data frame with  variables:
#' \describe{
#'   \item{state}{the state, e.g. US states like California or chines provinces such as Hubai}
#'   \item{country}{the country, e.g. Germany}
#'   \item{Lat}{Latitude, geodata for the country}
#'   \item{Long}{Longitude, geodata for the country}
#'   \item{date}{The day when the data was observed (infection, death, recoveries)}
#'   \item{infections}{The absolut number of infections in a country/state on the given date}
#'   \item{deaths}{The absolut number of deaths in a country/state on the given date}
#'   \item{recoveries}{The absolut number of recoveries in a country/state on the given date}
#' }
#' @source \url{https://github.com/CSSEGISandData/COVID-19}
"corona_data"
