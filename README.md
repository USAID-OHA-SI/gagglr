# gagglr <img src="man/figures/logo.png" align="right" height="120" />

Corralling our gaggle of OHA R utility packages

<!-- badges: start -->
[![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![R-CMD-check](https://github.com/USAID-OHA-SI/gagglr/workflows/R-CMD-check/badge.svg)](https://github.com/USAID-OHA-SI/gagglr/actions)
<!-- badges: end -->

The goal of gagglr is to provide a check to users to ensure they are using the latest versions of the [core OHA utility packages](https://usaid-oha-si.github.io/tools/) since they are not updated on regular intervals.

## Installation

`gagglr` is not on CRAN, so you will have to install it directly from GitHub using `remotes`.

If you do not have `remotes` installed, you will have to run the `install.packages("remotes")` line in the code below as well.

``` r
## SETUP

  #install package with vignettes
    install.packages("remotes")
    remotes::install_github("USAID-OHA-SI/gagglr", build_vignettes = TRUE)
    
  #load the package
    library(gagglr)

## LIST TYPES OF STYLES INCLUDED WITH PACKAGE
  ls("package:gagglr")
```


---

*Disclaimer: The findings, interpretation, and conclusions expressed herein are those of the authors and do not necessarily reflect the views of United States Agency for International Development. All errors remain our own.*

