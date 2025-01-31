
<!-- force push by editing this number: 42 -->
<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- Build with devtools::build_readme() -->

# One Health VBD Hub (ohvbd) <a href="https://fwimp.github.io/ohvbd/"><img src="man/figures/logo-4.png" align="right" width="120" alt="ohvbd website" /></a>

<!-- # One Health VBD Hub - R Package -->
<!-- badges: start -->

[![R](https://img.shields.io/badge/R%3E%3D-4.0-6666ff.svg?style=for-the-badge)](https://cran.r-project.org/)
[![packageversion](https://img.shields.io/badge/Package%20version-0.5.2-orange.svg?style=for-the-badge)](commits/master)
[![license](https://img.shields.io/badge/license-GPL--3-blue.svg?style=for-the-badge)](https://www.gnu.org/licenses/gpl-3.0.en.html)
[![R-CMD-check](https://github.com/fwimp/ohvbd/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/fwimp/ohvbd/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

## Introduction

`ohvbd` is an R package for retrieving (and parsing) data from a network
of disease vector data sources.

At present this package is very much in its early stages, as such the
internal API may change without warning.

## Databases

`ohvbd` allows for searching and the retrieval of data from the
following data sources:

- [VecTraits](https://vectorbyte.crc.nd.edu/vectraits-explorer)
- [VecDyn](https://vectorbyte.crc.nd.edu/vecdyn-datasets)
- [AreaData](https://pearselab.github.io/areadata/)

## Installation

You can install the development version of ohvbd from
[GitHub](https://github.com/fwimp/ohvbd) with:

``` r
# install.packages("devtools")
devtools::install_github("fwimp/ohvbd", build_vignettes = TRUE)
```

## Latest patch notes

<!-- These are auto-pulled from NEWS.md  -->

### ohvbd 0.5.2

- `fetch_ad()` now searches for a retrieves the most up-to-date GID2
  files from AREAdata.
- New `timeout` parameter of `fetch_ad()` to control timeouts of AD
  downloads. Defaults to 4 minutes.
- `assoc_ad()` now correctly extracts data (this functionality regressed
  in 0.5.0 as a consequence of the new method dispatch approach to data
  retrieval)
- `assoc_ad()` also gives now consistent output even when a
  1-dimensional output is returned from `extract_ad()`
- All `fetch_` functions now have a default `connections` argument of 2,
  leading to faster retrieval across the board.
- `check_src` argument has been removed from all functions. It no longer
  serves much of a purpose due to the sanity checking changes
  implemented in 0.5.0.

See [changelog](https://fwimp.github.io/ohvbd/news/index.html) for patch
notes for previous versions.
