One Health VBD Hub - R Package
================

<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- Build with devtools::build_readme() -->
<!-- # One Health VBD Hub - R Package -->
<!-- badges: start -->

[![R](https://img.shields.io/badge/R%3E%3D-4.0-6666ff.svg?style=for-the-badge)](https://cran.r-project.org/)
[![packageversion](https://img.shields.io/badge/Package%20version-0.3.0-orange.svg?style=for-the-badge)](commits/master)
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

### ohvbd 0.3.0

#### **Major API change**

- `*_basereq()` calls are no longer required as the first argument for
  functions.
- As such, data downloads no longer need to start with
  `vb_basereq() %>%`.
- Basereq can now be overridden by providing an alternative basereq to
  the `basereq` argument of these functions, which can be generated
  using `vb_basereq()`.
- This is usually only needed if using the argument `unsafe = TRUE` for
  `vb_basereq()`.
- It is also possible to set ohvbd to use compatability-mode ssl calls
  using `set_ohvbd_compat()`.
- This change breaks any code written prior to this version, and so
  major rewrites may be required.

See [NEWS.md](NEWS.md) for patch notes for previous versions.
