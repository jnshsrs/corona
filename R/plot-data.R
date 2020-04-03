
#' Plot the growth curve
#'
#' @param data A dataframe (or tibble) imported using \code{read_corona()}
#'
#' @return A ggplot object
#' @export
#'
#'
#' @examples \dontrun{
#' data(corona_data, statstisitic = "infections")
#' plot_growth(corona_data)
#' }
plot_growth <- function(data) {

  # Check if one country in dataset
  n_countries <- data %>%
    dplyr::pull("country") %>%
    base::unique() %>%
    length


  data <- data %>%
    dplyr::ungroup() %>%
    dplyr::filter(!is.na(.data$statistic))

  # compute the max day (the latest day with data plus 20 days)
  max_date <- max(data$date) + lubridate::days(20)
  x_breaks = seq(min(data$date), max_date, by = "2 days")


  y_limits <- c(min(data$statistic), (max(data$statistic) + (max(data$statistic) * .1)))

  data %>%
    ggplot2::ggplot(aes(x = .data$date, y = .data$statistic, col = .data$country, group = .data$country)) +
    ggplot2::geom_point(size = .8) +
    ggplot2::geom_line(size = .5) +
    ggplot2::geom_line(aes(x = .data$date, y = .data$predicted_cases, group = .data$country),
                       size = .5,
                       alpha = .5,
                       inherit.aes = FALSE) +
    # geom_line(aes(x = date, y = , col = doubling_time),
    #           data = dates,
    #           inherit.aes = FALSE,
    #           size = .7, linetype = 2) +
    ggplot2::scale_y_continuous(limits = y_limits) +
                                # breaks = ybreaks,
                                # labels = ylabels,
                                # trans = NULL) +
    ggplot2::scale_x_date(limits = c(min(data$date), max_date),
                          breaks = x_breaks,
                          labels = scales::date_format(format = "%b-%d")) +
    ggplot2::theme_minimal() +
    ggplot2::theme(axis.title = ggplot2::element_blank(),
                   legend.position = "right",
                   legend.direction = "vertical",
                   axis.text.x = ggplot2::element_text(angle = 90))
}


#' Plot the development in a single country
#'
#' @param data Preprocessed data containing data for one country
#' @param show_model Logical, Should the predicted values be displayed
#'
#' @return A ggplot2 obj
#' @export
#'
#' @examples
#' \dontrun{
#' data %>%
#'  preprocess_corona_data(statistic = "deaths",
#'                         countries = "Italy",
#'                         n = 10) %>%
#'  predict_growth() %>%
#'  plot_country(show_model = TRUE) +
#'  ggplot2::ggtitle("Corona  Death Growth Curve in Italy",
#'                   subtitle = "Starte date is the first day with > 10 deaths")
#' }
plot_country <- function(data, show_model = TRUE) {

  # Check if more than one country
  n_countries <- length(unique(data$country))

  if (n_countries > 1) {
    statement1 <- "This dataframe contains information about more than 2 countries."
    statement2 <- "Please provide a dataframe with only one country."
    stop(glue::glue("{statement1}\n{statement2}"))
  }

  # prepare data (keep non-NAs)
  data <- data %>%
    dplyr::ungroup() %>%
    dplyr::filter(!is.na(.data$statistic))

  # Check if predicted cases can be plotted

  pred_in_col <- "predicted_cases" %in% colnames(data)

  if (show_model & !pred_in_col) {
    warning("No predicted cases available. Plotting only observed cases")
  }

  plot_model <- pred_in_col

  # X AXIS
  # compute the max day (the latest day with data plus 20 days)
  max_date <- max(data$date) + lubridate::days(20)
  min_date <- min(data$date)
  x_limits <- c(min_date, max_date)
  x_breaks = seq(min(data$date), max_date, by = "2 days")

  # Y AXIS
  y_min <- min(data$statistic) - (min(data$statistic) * .1)
  y_max <- max(data$statistic) + (max(data$statistic) * .1)
  y_limits <- c(y_min, y_max)

  # Basic Plot
  p <- data %>%
    ggplot2::ggplot(aes(x = .data$date, y = .data$statistic)) +
    ggplot2::geom_point(size = .8) +
    ggplot2::geom_line(size = .5)

  # coord_cartesian(ylim=c(0,300))
  if (plot_model) {
    p <- p +
      ggplot2::geom_line(aes(x = .data$date, y = .data$predicted_cases),
                         size = .5,
                         alpha = .5,
                         inherit.aes = FALSE)
  }

  # Set axis
  p <- p +
    ggplot2::coord_cartesian(ylim = y_limits) +
    ggplot2::scale_x_date(limits = x_limits,
                          breaks = x_breaks,
                          labels = scales::date_format(format = "%b-%d")) +
    ggplot2::theme_minimal() +
    ggplot2::theme(axis.title = ggplot2::element_blank(),
                   legend.position = "right",
                   legend.direction = "vertical",
                   axis.text.x = ggplot2::element_text(angle = 90))

  # Plot doubling times
  doubling_data <- create_doubling(data)

  p <- p +
    ggplot2::geom_line(aes(x = date,
                  y = .data$value,
                  group = .data$name,
                  col = .data$name),
                  linetype = 2,
                  size = .8,
              data = doubling_data,
              inherit.aes = FALSE) +
    ggplot2::scale_color_brewer("Doubling Rate", palette = "Set1", aesthetics = "colour")

  # Show plot
  p

}

