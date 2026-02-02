# ohvbd: One Health VBD Hub

Interface with the One Health VBD Hub and related repositories directly.

## Introduction

ohvbd is a data location and ingestion package focused around a series
of vector-borne disease databases. It aims to make it quick and easy to
repeatably download data from a variety of sources without having to
navigate online tools and pages.

## Searching

ohvbd can be used to search a multitude of databases using the
`search_*` family of functions.

Most prominent of these is the
[`search_hub()`](https://ohvbd.vbdhub.org/reference/search_hub.md)
function, which leverages the \<vbdhub.org\> search functionality to
provide enhanced searches across databases.

    # Search hub for the Castor Bean Tick
    search_hub("Ixodes ricinus")

Other dedicated search functionality is available for select databases
(e.g.
[`search_vt_smart()`](https://ohvbd.vbdhub.org/reference/search_vt_smart.md)).

## Downloading

Once relevant data has been identified, these can be downloaded using
the [`fetch()`](https://ohvbd.vbdhub.org/reference/fetch.md) function.

This is typically performed using a piped approach:

    # Find and retrieve tick data from VecTraits
    ixodes_results <- search_hub("Ixodes ricinus", db = "vt") |>
                        fetch()

## Parsing & Filtering

Downloaded data is simply stored as the responses from the website.

To use the information itself we must use
[`glean()`](https://ohvbd.vbdhub.org/reference/glean.md) to extract the
relevant data:

    # Find and retrieve tick data from VecTraits
    ixodes_data <- search_hub("Ixodes ricinus", db = "vt") |>
                     fetch() |>
                     glean()

## Associating with other data

Downloaded data can be associated with climatic variables from AREAData
using the `assoc_*` functions.

    ixodes_data <- search_hub("Ixodes ricinus", "vt") |>
      tail(20) |>
      fetch() |>
      glean(cols = c(
        "DatasetID",
        "Latitude",
        "Longitude",
        "Interactor1Genus",
        "Interactor1Species"
      ), returnunique = TRUE)
    areadata <- fetch_ad(metric="temp", gid=0, use_cache=TRUE)
    ad_extract_working <- assoc_ad(ixodes_data, areadata,
                                   targetdate = c("2021-08-04"),
                                   enddate=c("2021-08-06"),
                                   gid=0,
                                   lonlat_names = c("Longitude", "Latitude"))

## Further information

The ohvbd homepage is at <https://ohvbd.vbdhub.org>. See especially the
documentation section. Join the discussion forum at
<https://forum.vbdhub.org/c/ohvbd-r-package/> if you have questions or
comments.

## See also

Useful links:

- <https://github.com/fwimp/ohvbd>

- <https://ohvbd.vbdhub.org>

- Report bugs at <https://github.com/fwimp/ohvbd/issues>

## Author

**Maintainer**: Francis Windram <francis.windram17@imperial.ac.uk>
([ORCID](https://orcid.org/0000-0002-2129-826X)) \[copyright holder\]
