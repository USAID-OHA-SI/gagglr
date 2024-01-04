# gagglr <img src="man/figures/logo.png" align="right" height="120" />

Corralling our gaggle of OHA R utility packages

<!-- badges: start -->
[![R-CMD-check](https://github.com/USAID-OHA-SI/gagglr/workflows/R-CMD-check/badge.svg)](https://github.com/USAID-OHA-SI/gagglr/actions)
[![gagglr status badge](https://usaid-oha-si.r-universe.dev/badges/gagglr)](https://usaid-oha-si.r-universe.dev/gagglr)
[![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![:name status badge](https://usaid-oha-si.r-universe.dev/badges/:name)](https://usaid-oha-si.r-universe.dev/)
<!-- badges: end -->

The goal of gagglr is to provide a check to users to ensure they are using the latest versions of the [core OHA utility packages](https://usaid-oha-si.github.io/tools/) since they are not updated on regular intervals.

## Installation

`gagglr` is not on CRAN, so you will have to install it directly from [rOpenSci](https://usaid-oha-si.r-universe.dev/packages) or [GitHub](https://github.com/USAID-OHA-SI/) using the code found below.

``` r
## SETUP

  #install from rOpenSci
    install.packages('gagglr', repos = c('https://usaid-oha-si.r-universe.dev', 'https://cloud.r-project.org'))
    
  #alt: install from GitHub using pak
    #install.packages("pak")
    #pak::pak("USAID-OHA-SI/gagglr")
    
  #load the package
    library(gagglr)

## LIST TYPES OF STYLES INCLUDED WITH PACKAGE
  ls("package:gagglr")
```


---

*Disclaimer: The findings, interpretation, and conclusions expressed herein are those of the authors and do not necessarily reflect the views of United States Agency for International Development. All errors remain our own.*

