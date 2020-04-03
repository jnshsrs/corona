#' Create a growth model
#'
#' Build a growth model using the number of cases,
#' deaths or recoveries as dependent variable and
#' days,e.g. date as independent variable
#'
#' The Intercept of the fitted model expresses the logarithmic base rate (log10)
#' and the coefficient represents the logarithmic growth rate (log10)
#'
#' @param corona_data A dataframe (tibble) from \code{read_corona()}
#'
#' @return A tibble containing country, r squared, intercept, slope, base- and growth-rate
#' @export
#'
lm_corona <- function(corona_data) {

  data <- corona_data %>%
    tidyr::nest(data = c(.data$Lat, .data$Long, .data$date, .data$statistic, .data$day)) %>%
    dplyr::mutate(models = data %>% purrr::map(function(data) stats::lm(log10(statistic) ~ day, data = data))) %>%
    dplyr::mutate(r_sq = purrr::map_dbl(.data$models, function(data) summary(data) %>%
                                          purrr::pluck("r.squared"))) %>%
    dplyr::mutate(coef = purrr::map(.x = .data$models,
                                    .f = function(data) {
                                      data %>%
                                        purrr::pluck("coefficients")})) %>%
    dplyr::mutate(coef = purrr::map(.x = .data$coef, .f = function(x) tibble::enframe(x))) %>%
    tidyr::unnest(.data$coef)

  suppressMessages(
    data <- data %>%
      tidyr::pivot_wider(names_from = .data$name,
                         values_from = .data$value,
                         names_repair = function(x) base::tolower(base::gsub(x = x, pattern = "\\(|\\)", replace = ""))) %>%
      dplyr::select(-.data$data)
  )

  data %>%
    dplyr::mutate(base_rate = 10^.data$intercept, growth_rate = 10^.data$day) %>%
    dplyr::rename(lm_intercept = .data$intercept, lm_slope = .data$day)

}


#' Create the doubling rates
#'
#' Creates a sequence of the number events given that the
#' doubling rate is t dates
#'
#' @param corona_data A dataframe imported with `read_corona`
#'
#' @return A numeric vector (representing) the number of cases given that the doubling rate is d days)
#' @export
#'
create_doubling <- function(corona_data) {

  cmpt_dbl <- function(days, base_rate, doubling_time) {
    base_rate * `^`(2, (1/doubling_time * days))
  }

  dbl_int <- c("1 day" = 1,
               "2 days" = 2,
               "3 days" = 3,
               "4 days" = 4,
               "1 week" = 7)
  n_days <- 50
  doubl_rates <- purrr::map_df(.x = dbl_int,
                               .f = function(x) cmpt_dbl(days = seq(n_days),
                                                         base_rate = min(corona_data$statistic),
                                                         doubling_time = x)) %>%
    dplyr::mutate(dseq = seq(n_days)) %>%
    dplyr::mutate(date = min(corona_data$date) + lubridate::days(.data$dseq - 1)) %>%
    tidyr::pivot_longer(cols = dplyr::matches("day|week")) %>%
    dplyr::rename(day = .data$dseq) %>%
    dplyr::mutate_at("name", function(x) factor(x = x,
                                                levels = unique(x),
                                                labels = names(dbl_int),
                                                ordered = TRUE))

}

#' Estimate and Predict cases based on a corona growth model
#'
#' @param corona_data dataset with columns country, day, date, statistic
#'
#' @return The input data (tibble) with an additional int column named
#' predicted_cases
#' @export
#'
#' @examples
#' \dontrun{
#' data <- read_corona()
#' data %>%
#' preprocess_corona_data(
#'  statistic = "infections", # Focus on infections
#'  countries = "Italy", # Focus on Italy
#'  n = 100 # Include days where the death toll exceeded 100 cases) %>%
#' predict_growth()
#'
#' }
#'
predict_growth <- function(corona_data) {

  growth_model <- corona_data %>% lm_corona()

  predicted_cases <- growth_model %>%
    dplyr::mutate(day = list(1:40)) %>%
    dplyr::select(.data$country, .data$base_rate, .data$growth_rate, .data$day) %>%
    tidyr::unnest(.data$day) %>%
    dplyr::mutate(predicted_cases = .data$base_rate * (.data$growth_rate^.data$day)) %>%
    dplyr::select(.data$country, .data$day, .data$predicted_cases)

  corona_data %>%
    dplyr::full_join(predicted_cases, by = c("country", "day")) %>%
    dplyr::group_by(.data$country) %>%
    dplyr::mutate(date = min(date, na.rm = T) + lubridate::days(.data$day - 1))

}
