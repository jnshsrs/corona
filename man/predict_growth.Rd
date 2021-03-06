% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/model-data.R
\name{predict_growth}
\alias{predict_growth}
\title{Estimate and Predict cases based on a corona growth model}
\usage{
predict_growth(corona_data)
}
\arguments{
\item{corona_data}{dataset with columns country, day, date, statistic}
}
\value{
The input data (tibble) with an additional int column named
predicted_cases
}
\description{
Estimate and Predict cases based on a corona growth model
}
\examples{
\dontrun{
data <- read_corona()
data \%>\%
preprocess_corona_data(
 statistic = "infections", # Focus on infections
 countries = "Italy", # Focus on Italy
 n = 100) \%>\% # Include days where the death toll exceeded 100 cases)
predict_growth()

}

}
