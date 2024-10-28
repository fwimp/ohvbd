
<!-- force push by editing this number: 512 -->
<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- Build with devtools::build_readme() -->

# One Health VBD Hub (ohvbd) <a href="https://fwimp.github.io/ohvbd/"><img src="man/figures/logo-2.png" align="right" width="120" alt="ohvbd website" /></a>

<!-- # One Health VBD Hub - R Package -->
<!-- badges: start -->

[![R](https://img.shields.io/badge/R%3E%3D-4.0-6666ff.svg?style=for-the-badge)](https://cran.r-project.org/)
[![packageversion](https://img.shields.io/badge/Package%20version-0.5.0-orange.svg?style=for-the-badge)](commits/master)
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

### ohvbd 0.5.0

#### **Major API change**

- `get_` functions have been split into two new types of function, based
  upon exact usage.
  - `find_` functions retrieve metadata such as column definitions and
    ids.
  - `fetch_` functions retrieve actual datasets.
- New set of S3 classes (`ohvbd.ids`, `ohvbd.responses`,
  `ohvbd.data.frame`, `ohvbd.ad.matrix`) to allow for nicer checks of
  data integrity.
  - This has the side effect of no longer falsely triggering the data
    continuity checks of `fetch_` functions when indexing the output of
    `find_x_ids()` functions.
- New convenience functions `fetch()` and `extract()` leverage method
  dispatch along with the above classes to infer the correct underlying
  `fetch_` and `extract_` functions to use.
  - As such you can now write code such as
    `find_vt_ids() %>% fetch() %>% extract()` without having to remember
    the correct extractor to use.
  - You can still use the specific extractor functions as before should
    you desire.
- All major functions interfacing with AD, VD, and VT output one of
  these classes.
- Cached data from AD now contains an attribute to signify that it is
  cached.
- New classes are subclassed from other base R classes, and so mostly
  behave in the same way (i.e. you can subset an `ohvbd.data.frame` in
  the same way as just subsetting a normal df).
- New function `ohvbd.ids()` allows users to create objects of the same
  S3 class as output by the `find_` and `search_` functions.
- New `is_cached()` function enables a simple check to see if an object
  has been loaded from the cache by `ohvbd`.

#### Full list of function name changes:

- `get_ad()` -\> `fetch_ad()`
- `get_extract_vd_chunked()` -\> `fetch_extract_vd_chunked()`
- `get_extract_vt_chunked()` -\> `fetch_extract_vt_chunked()`
- `get_gadm_sfs()` -\> `fetch_gadm_sfs()`
- `get_vd()` -\> `fetch_vd()`
- `get_vt()` -\> `fetch_vt()`
- `get_vd_columns()` -\> `find_vd_columns()`
- `get_vd_current_ids()` -\> `find_vd_ids()`
- `get_vt_current_ids()` -\> `find_vt_ids()`

See [changelog](https://fwimp.github.io/ohvbd/news/index.html) for patch
notes for previous versions.
