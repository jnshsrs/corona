
<!-- README.md is generated from README.Rmd. Please edit that file -->

# corona

<!-- badges: start -->

<!-- badges: end -->

The goal of corona is to …

## Installation

You can install the released version of corona from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("corona")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(corona)

# Import the corona death numbers as a dataframe
read_deaths()
#> Parsed with column specification:
#> cols(
#>   .default = col_double(),
#>   `Province/State` = col_character(),
#>   `Country/Region` = col_character()
#> )
#> See spec(...) for full column specifications.
#> # A tibble: 31,062 x 6
#>    state country    Lat  Long date       value
#>    <chr> <chr>    <dbl> <dbl> <date>     <dbl>
#>  1 <NA>  Thailand    15   101 2020-01-22     0
#>  2 <NA>  Thailand    15   101 2020-01-23     0
#>  3 <NA>  Thailand    15   101 2020-01-24     0
#>  4 <NA>  Thailand    15   101 2020-01-25     0
#>  5 <NA>  Thailand    15   101 2020-01-26     0
#>  6 <NA>  Thailand    15   101 2020-01-27     0
#>  7 <NA>  Thailand    15   101 2020-01-28     0
#>  8 <NA>  Thailand    15   101 2020-01-29     0
#>  9 <NA>  Thailand    15   101 2020-01-30     0
#> 10 <NA>  Thailand    15   101 2020-01-31     0
#> # … with 31,052 more rows

# Import the corona infection numbers as a dataframe
read_infections()
#> Parsed with column specification:
#> cols(
#>   .default = col_double(),
#>   `Province/State` = col_character(),
#>   `Country/Region` = col_character()
#> )
#> See spec(...) for full column specifications.
#> # A tibble: 29,707 x 6
#>    state country    Lat  Long date       value
#>    <chr> <chr>    <dbl> <dbl> <date>     <dbl>
#>  1 <NA>  Thailand    15   101 2020-01-22     2
#>  2 <NA>  Thailand    15   101 2020-01-23     3
#>  3 <NA>  Thailand    15   101 2020-01-24     5
#>  4 <NA>  Thailand    15   101 2020-01-25     7
#>  5 <NA>  Thailand    15   101 2020-01-26     8
#>  6 <NA>  Thailand    15   101 2020-01-27     8
#>  7 <NA>  Thailand    15   101 2020-01-28    14
#>  8 <NA>  Thailand    15   101 2020-01-29    14
#>  9 <NA>  Thailand    15   101 2020-01-30    14
#> 10 <NA>  Thailand    15   101 2020-01-31    19
#> # … with 29,697 more rows
```

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

``` r
summary(cars)
#>      speed           dist       
#>  Min.   : 4.0   Min.   :  2.00  
#>  1st Qu.:12.0   1st Qu.: 26.00  
#>  Median :15.0   Median : 36.00  
#>  Mean   :15.4   Mean   : 42.98  
#>  3rd Qu.:19.0   3rd Qu.: 56.00  
#>  Max.   :25.0   Max.   :120.00
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date.

You can also embed plots, for example:

<img src="man/figures/README-pressure-1.png" width="100%" />

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub\!
