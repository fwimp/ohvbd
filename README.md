
<!-- force push by editing this number: 41 -->

<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- Build with devtools::build_readme() -->

# One Health VBD Hub (ohvbd) <a href="https://ohvbd.vbdhub.org"><img src="man/figures/logo-0.png" align="right" width="120" alt="ohvbd website" /></a>

<!-- # One Health VBD Hub - R Package -->

<!-- badges: start -->

[![R](https://img.shields.io/badge/R%3E%3D-4.1.0-6666ff.svg?style=for-the-badge)](https://cran.r-project.org/)
[![packageversion](https://img.shields.io/badge/Package%20version-1.0.0-orange.svg?style=for-the-badge)](https://github.com/fwimp/ohvbd/commits/master/)
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

### ohvbd 1.0.0

**Major API change**

- `extract_` functions are now `glean_`.
  - This means that if `tidyverse` is loaded after `ohvbd`, there are no
    direct namespace collisions.

Full list of function name changes:

- `extract()` -\> `glean()`
- `extract_ad()` -\> `glean_ad()`
- `extract_gbif()` -\> `glean_gbif()`
- `extract_vd()` -\> `glean_vd()`
- `extract_vt()` -\> `glean_vt()`
- `fetch_extract_vd_chunked()` -\> `fetch_glean_vd_chunked()`
- `fetch_extract_vt_chunked()` -\> `fetch_glean_vt_chunked()`

New functions & arguments:

- `ohvbd` now interfaces with GBIF for occurrence data.
  - New `*_gbif` functions (e.g. `fetch_gbif()`) allow for retrieving
    and extracting data from GBIF.
  - A GBIF account and the `rgbif` package are required to retrieve data
    from GBIF.
  - The account details must also be set up as shown in [the rgbif
    documentation](https://docs.ropensci.org/rgbif/articles/gbif_credentials.html).
- New `tee()` command allows one to extract data from the middle of a
  pipeline and save it to an environment.
  - This is definitely not only useful for `ohvbd` workflows, and can be
    used in any base R pipeline (`|>`). It has not been tested in
    magrittr pipelines but should work as-is.
- New `filter_db()` command allows for filtering out of only one
  database’s results from hub searches.
- `check_db_status()` now returns (invisibly) whether all databases are
  up or not.
- New `fetch_citation()` and `fetch_citation_*` commands provide an
  interface to attempt to retrieve citations from a vectorbyte dataset.
  - This will (by default) possibly redownload parts or all of the data
    if the columns are not currently present.
- New `force_db()` function enables one to force `ohvbd` to consider a
  particular object as having a particular provenance.
- New `simplify` argument to `search_hub()` makes hub searches return an
  `ohvbd.ids` object if only one database was searched for. This
  behaviour is on by default.
  - To match this, `filter_db()` will now transparently return
    `ohvbd.ids` objects if it gets them.
- New `taxonomy` argument to `search_hub()` allows for filtering
  searches by GBIF backbone IDs.
- New `match_species()` function allows for quick and flexible matching
  of species names to their GBIF backbone IDs.
- New `match_country()` function allows for matching of country names to
  WKT polygons via naturalearth.
- New `ohvbd_db()`, `has_db()`, and `is_from()` functions allow for
  quick testing of object provenance (according to `ohvbd`).
- New `get_default_ohvbd_cache()` function allows for custom functions
  that interface with cached `ohvbd` data files.
- New `list_ohvbd_cache()` and `clean_ohvbd_cache()` functions enable
  better interactive cache management.
  - As a result, `clean_ad_cache()` has been removed as it is now
    unnecessary.
- `search_x_smart()` functions can now take `"tags"` as a search field,
  enabling support for tagged datasets.

Other:

- Entire code base is now continuously formatted using Air v0.7.1.
- Examples are no longer wrapped in `\dontrun{}` so they should be
  runnable from an installed version of the package.
- A good chunk of the functional logic of `ohvbd` is now covered with
  unit tests (using the `vcr` package).
- `fetch_vd()` no longer tries to retrieve ids with no pages of data.
- Functions that interface with vectorbyte databases no longer recommend
  using `set_ohvbd_compat()` as *unexpected* SSL errors **should** break
  pipelines by default.
  - These errors are no longer *expected* to occur when interfacing with
    vectorbyte.
- Running `fetch()` on an `ohvbd.hub.search` or `glean()` on an
  `ohvbd.ids` object now provides a hint that you may have forgotten
  something.
  - Occasionally users would use forget a `fetch()` command and run
    `search_hub() |> glean()` which didn’t previously give an
    interpretable error.
- Vignettes now use `vcr` to massively reduce their build time. This
  should only matter to developers of `ohvbd`, or users who download
  from github and build the vignettes themselves.
- `ohvbd.ids()` now warns you and fixes the problem if you provide ids
  with duplicate values.
- `glean_vt()` and `glean_vd()` now force the inclusion of the dataset
  ID when filtering columns (using the `cols` argument).
  - This is intended to encourage you to preserve at least one means of
    retrieving citation data later.
- WKT parsing and formatting is now significantly more robust.
- Cached AREAData now includes the cache timestamp as an attribute
  rather than a separate variable in the cache file.
- `glean_ad()` now correctly returns a matrix even when there is only 1
  row or column.
- gadm spatial files are now cached as GeoPackage rather than
  [shapefiles](http://switchfromshapefile.org/), leading to a \>50%
  speedup in loading! (Thanks to
  [@josiah.rs](https://bsky.app/profile/josiah.rs) on bluesky for the
  suggestion!)
- `fetch_vd_counts()` is now significantly faster, more robust, and
  temporarily caches data.
  - You will see particular improvements if you are trying to retrieve
    more than about 10 ids in one go or if you are repeatedly running
    the same download code in the same day.
  - This speedup also applies to `fetch_vd()` under the hood,
    particularly if you are running it multiple times in a day.
- Explicit term checking (such as in `fetch_ad()` for metrics and
  `search_vt_smart()` for operators and fields) is now fuzzy, allowing
  for a small amount of deviation from the actual term name.
- `assoc_ad()` now tries to guess LatLong column names if none (or the
  wrong ones) are provided.
- Errors in internal functions now make it more clear which user-facing
  functions they originate from.
- Multiple functions now default to `NULL` rather than `NA` for default
  missing values (except date arguments to AD-related functions, where
  NA is more reasonable in the grand scheme).
- `fetch_ad()` now caches and tries to read from cache by default.
  - Generally speaking unless exceedingly up-to-date data is required,
    this will be the best for most people.
  - If you *do* require guaranteed new data, it’s worth setting
    `refresh_cache = TRUE` or `use_cache = FALSE` (depending on if you
    want to replace your existing cache or not).
- All downloaders that can potentially cache data also attach the
  download time if not loading from cache.

See [changelog](https://ohvbd.vbdhub.org/news/index.html) for patch
notes for all versions.
