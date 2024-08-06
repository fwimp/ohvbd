
<!-- force push by editing this number: 42 -->
<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- Build with devtools::build_readme() -->

# One Health VBD Hub (ohvbd) <a href="https://fwimp.github.io/ohvbd/"><img src="man/figures/logo-1.png" align="right" width="120" alt="ohvbd website" /></a>

<!-- # One Health VBD Hub - R Package -->
<!-- badges: start -->

[![R](https://img.shields.io/badge/R%3E%3D-4.0-6666ff.svg?style=for-the-badge)](https://cran.r-project.org/)
[![packageversion](https://img.shields.io/badge/Package%20version-0.3.1-orange.svg?style=for-the-badge)](commits/master)
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

### ohvbd 0.3.1

- New function `format_time_overlap_bar()` allows for visually
  formatting a range of dates combined with another set of target dates
  to see where overlaps do or do not take place.
- This is mostly used in the error handling of `extract_ad_data()`
  however it can also be used independently. It was designed to fill a
  more general role within UI design using the cli package, and should
  be usable (or hackable) by others needing the same tool.
- `extract_ad_data()` now errors when all `targetdate` entries are
  outside of the range of the AREAdata dataset.
- New `assoc_ad_data()` associates arbitrary data including lon/lat
  columns with AREAdata.
- New `get_vd_columns()` provides quick reference about the currently
  present VecDyn columns. *(This is currently not possible for
  VecTraits, but the feasibility is being investigated.)*
- New `assoc_gadm_id()` function associates gadm ids at all spatial
  scales with arbitrary data that include lon/lat columns.
- Documentation now correctly displays favicons.
- Logo now rotates through a variety of colourschemes according to the
  version number.

See [changelog](https://fwimp.github.io/ohvbd/news/index.html) for patch
notes for previous versions.
