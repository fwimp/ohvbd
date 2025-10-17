
<!-- force push by editing this number: 41 -->

<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- Build with devtools::build_readme() -->

# One Health VBD Hub (ohvbd) <a href="https://fwimp.github.io/ohvbd/"><img src="man/figures/logo-6.png" align="right" width="120" alt="ohvbd website" /></a>

<!-- # One Health VBD Hub - R Package -->

<!-- badges: start -->

[![R](https://img.shields.io/badge/R%3E%3D-4.1.0-6666ff.svg?style=for-the-badge)](https://cran.r-project.org/)
[![packageversion](https://img.shields.io/badge/Package%20version-0.6.1.9000-orange.svg?style=for-the-badge)](commits/master)
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
- [GBIF](https://www.gbif.org/)
- [AreaData](https://pearselab.github.io/areadata/)

## Installation

You can install the development version of ohvbd from
[GitHub](https://github.com/fwimp/ohvbd) with:

``` r
# install.packages("devtools")
devtools::install_github("fwimp/ohvbd")
```

The vignettes are all available online, but if you would like to build
them locally, add `build_vignettes` = TRUE into your `install_github()`
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

### ohvbd 0.6.1

- New `search_hub()` function enables searching across multiple
  databases at once via [vbdhub](https://vbdhub.org).
  - This includes new functionality for specifying searches using
    spatial extent polygons and generally more intelligent search
    behaviour.
- New function `generate_vt_template()` which quickly generates a
  VecTraits template for later upload.

See [changelog](https://fwimp.github.io/ohvbd/news/index.html) for patch
notes for all versions.
