
<!-- force push by editing this number: 42 -->

<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- Build with devtools::build_readme() -->

# One Health VBD Hub (ohvbd) <a href="https://ohvbd.vbdhub.org"><img src="man/figures/logo-0.png" align="right" width="120" alt="ohvbd website" /></a>

<!-- # One Health VBD Hub - R Package -->

<!-- badges: start -->

[![R](https://img.shields.io/badge/R%3E%3D-4.1.0-6666ff.svg?style=for-the-badge)](https://cran.r-project.org/)
[![packageversion](https://img.shields.io/badge/Package%20version-1.0.1-orange.svg?style=for-the-badge)](https://github.com/fwimp/ohvbd/commits/master/)
[![license](https://img.shields.io/badge/license-GPL--3-blue.svg?style=for-the-badge)](https://www.gnu.org/licenses/gpl-3.0.en.html)
[![R-CMD-check](https://github.com/fwimp/ohvbd/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/fwimp/ohvbd/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

## Introduction

`ohvbd` is an R package for retrieving (and parsing) data from a network
of disease vector data sources.

This package was developed as part of the [One Health Vector-Borne
Diseases Hub](https://vbdhub.org).

## Databases

`ohvbd` allows for searching and the retrieval of data from the
following data sources:

- [vbdhub](https://vbdhub.org) (search only)
- [VecTraits](https://vectorbyte.crc.nd.edu/vectraits-explorer)
- [VecDyn](https://vectorbyte.crc.nd.edu/vecdyn-datasets)
- [GBIF](https://www.gbif.org)
- [AreaData](https://pearselab.github.io/areadata/)

## Installation

You can install the stable version of ohvbd from CRAN:

``` r
install.packages("ohvbd")
```

You can alternatively install the development version of ohvbd from
[GitHub](https://github.com/fwimp/ohvbd) including any new or
experimental features:

``` r
# install.packages("devtools")
devtools::install_github("fwimp/ohvbd")
```

The vignettes are all available online, but if you would like to build
them locally, add `build_vignettes = TRUE` into your `install_github()`
command. However, we do not recommend doing this due to the number of
extra R packages utilised in the vignettes.

## Basic usage

`ohvbd` has been designed to make finding and retrieving data on disease
vectors simple and straightforward.

Typically it uses a “piped”-style approach to find, get, and filter data
from the supported databases, however it aims to provide the data to you
“as-is”, leaving further downstream analysis and filtering down to you.

A basic pipeline for finding and retrieving data on *Ixodes ricinus*
from the VecTraits database looks something like this:

``` r
library(ohvbd)

df <- search_hub("Ixodes ricinus") |>
  filter_db("vt") |>
  fetch() |>
  glean()
```

## Latest release patch notes

<!-- These are auto-pulled from NEWS.md  -->

### ohvbd 1.0.1

- `ohvbd` now explicitly depends on `generics` (as it does anyway via
  `lubridate`). This should stop issues loading the package after
  install.
- `search_hub()` now correctly interfaces with the output of
  `match_countries()` even when `onlywkt` is not provided.

See [changelog](https://ohvbd.vbdhub.org/news/index.html) for patch
notes for all versions.
