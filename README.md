
<!-- force push by editing this number: 420 -->
<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- Build with devtools::build_readme() -->

# One Health VBD Hub (ohvbd) <a href="https://fwimp.github.io/ohvbd/"><img src="man/figures/logo-1.png" align="right" width="120" alt="ohvbd website" /></a>

<!-- # One Health VBD Hub - R Package -->
<!-- badges: start -->

[![R](https://img.shields.io/badge/R%3E%3D-4.0-6666ff.svg?style=for-the-badge)](https://cran.r-project.org/)
[![packageversion](https://img.shields.io/badge/Package%20version-0.4.0-orange.svg?style=for-the-badge)](commits/master)
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

### ohvbd 0.4.0

#### **Major API change**

- Major simplification of function names!
- `get_x_byid()` -\> `get_x()`
- `extract_x_data()` -\> `extract_x()`
- `assoc_x_y()` -\> `assoc_x()`
- `get_extract_x_byid_chunked()` -\> `get_extract_x_chunked()`
- This breaks ALL PREVIOUS CODE!
- Naming now follows a logical scheme of `verb_target_modifier()`.
- For example `get_x_y()` functions always retrieve data from database
  `x` with `y` specifying any special type of data.
- Similarly `extract_x()` functions always extract data.
- If a function does multiple things, it may get multiple verbs
  seperated by underscores, e.g. `get_extract_x_chunked()`
- Pipelines now internally attempt to confirm data integrity by checking
  that the correct functions are piped together.
- This means it is no longer easy to accidentally do something like
  `get_current_vd_ids() %>% get_vt()`.

See [changelog](https://fwimp.github.io/ohvbd/news/index.html) for patch
notes for previous versions.
