
<!-- force push by editing this number: 42 -->
<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- Build with devtools::build_readme() -->

# One Health VBD Hub (ohvbd) <a href="https://fwimp.github.io/ohvbd/"><img src="man/figures/logo-3.png" align="right" width="120" alt="ohvbd website" /></a>

<!-- # One Health VBD Hub - R Package -->
<!-- badges: start -->

[![R](https://img.shields.io/badge/R%3E%3D-4.1.0-6666ff.svg?style=for-the-badge)](https://cran.r-project.org/)
[![packageversion](https://img.shields.io/badge/Package%20version-0.6.0-orange.svg?style=for-the-badge)](commits/master)
[![license](https://img.shields.io/badge/license-GPL--3-blue.svg?style=for-the-badge)](https://www.gnu.org/licenses/gpl-3.0.en.html)
[![R-CMD-check](https://github.com/fwimp/ohvbd/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/fwimp/ohvbd/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

## Introduction

`ohvbd` is an R package for retrieving (and parsing) data from a network
of disease vector data sources.

At present this package is very much in its early stages, as such the
internal API may change without warning.

This package was developed as part of the [One Health Vector-Borne Diseases Hub](https://vbdhub.org).

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

### ohvbd 0.6.0

- Internally `ohvbd` now only uses base R pipes (`|>`).
- The magrittr pipe (`%>%`) is no longer used internally, nor is it
  exported for use.
- `httr2` v1.1.1 deprecated the `pool` argument of
  `req_perform_parallel()` which broke `fetch()` commands across
  `ohvbd`.
- These have now been rewritten using the new `max_active` argument,
  which does simplify everything a bit.
- This change does bump the required version of `httr2` to be v1.1.1.

See [changelog](https://fwimp.github.io/ohvbd/news/index.html) for patch
notes for previous versions.
