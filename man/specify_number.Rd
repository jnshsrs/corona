% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/preprocess-data.R
\name{specify_number}
\alias{specify_number}
\title{Specify the countries to include}
\usage{
specify_number(corona_data, n)
}
\arguments{
\item{corona_data}{A dataframe (tibble) imported with `read_corona`}

\item{n}{Integer, number of cases per day to include}
}
\value{
A data.frame (tibble) with the data of inclueded countries
}
\description{
Specify the countries to include
}
\examples{
\dontrun{
data <- read_corona()
data \%>\%
 specify_number(n = 100)
}
}
