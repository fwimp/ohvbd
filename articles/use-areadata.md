# Sourcing climatic data from AREAdata

## Introduction

Often when presented with a set of population dynamic data, we may wish
to investigate the abiotic conditions such as temperature or humidity
that these dynamics occurred under.

Ideally this sort of data would have been collected at the same time as
the dynamics data. However with data collected for one project and then
repurposed for another, this is often not possible.

In such scenarios it is possible to link the location of the data with
other measurements of abiotic variables in the area.

These can be retrieved from raster files provided by projects such as
the ERA5 data store from the Copernicus project, however often this is a
large amount of data for a small number of datapoints.

## AREAdata

An alternative method for gathering this data is through the AREAdata
project, which provides historical and forecast data aggregated at
different spatial scales.

Let’s take a look at the format of data retrieved from AREAdata (we will
deconstruct this command properly in a bit):

``` r
library(ohvbd)

ad_df <- fetch_ad(metric = "temp", gid = 0, use_cache = TRUE)
# Display only a brief summary of the data
summary(ad_df)
```

    ## <ohvbd.ad.matrix>
    ## Areadata matrix for temp at gid level 0 .
    ## Cached: FALSE 
    ## Dates: 2020-01-01 -> 2025-12-31 (2192)
    ## Locations: 256

So that is quite a lot of data! Way too much to print here, given that
it’s 561152 entries, however if you want to print all the data rather
than just a summary, you can use the print command:

``` r
print(ad_df)
```

AREAdata outputs are formatted as matrices. Here the rows correspond to
locations (identified by GADM codes):

``` r
head(rownames(ad_df))
```

    ## [1] "Aruba"       "Afghanistan" "Angola"      "Anguilla"    "Åland"       "Albania"

Meanwhile the column names correspond to the day that the data refers
to:

``` r
head(colnames(ad_df))
```

    ## [1] "2020-01-01" "2020-01-02" "2020-01-03" "2020-01-04" "2020-01-05" "2020-01-06"

So the value at `ad_df["Angola", "2020-01-01"]` corresponds to the value
of the metric (in this case temperature) in Angola on 2020-01-01:

``` r
ad_df["Angola", "2020-01-01"]
```

    ## [1] 29.33611

## Deconstructing `fetch_ad()`

That call above to
[`fetch_ad()`](https://ohvbd.vbdhub.org/reference/fetch_ad.md) used some
slightly odd parameters, so let’s break that down a bit.

The arguments we provided were

1.  metric = “temp”
2.  gid = 0
3.  use_cache = TRUE
4.  cache_location = cachepath

### `metric`

The metric argument tells
[`fetch_ad()`](https://ohvbd.vbdhub.org/reference/fetch_ad.md) what type
of data it should retrieve from AREAdata.

There are many valid options for this including temperature and
humidity. (See
[AREAdata](https://pearselab.github.io/areadata/download-links/) or run
`?fetch_ad()` in the R console for a full list).

### `gid`

The gid argument tells
[`fetch_ad()`](https://ohvbd.vbdhub.org/reference/fetch_ad.md) the
spatial scale to download (with higher numbers corresponding to finer
scales, at the cost of larger download sizes).

### `use_cache` and `cache_location`

As the AREAdata files are large and monolithic, it is often advantageous
to download data at an given spatial scale only once.

We can do this by caching the files and retrieving them as needed.
Whilst you could do this manually, `ohvbd` already has the functionality
to perform this behind the scenes.

If we set `use_cache = TRUE` then instead of downloading from the
repository immediately, `ohvbd` will first try to load any cached
version that may be present.

Typically, the cache location is a folder in your user directory,
obtained from
[`tools::R_user_dir()`](https://rdrr.io/r/tools/userdir.html). However,
if you want to overwrite it (such as if you want to share the cache
between different scripts) you can provide an alternative path to save
data to.

### Example

So given the above, let’s construct another function call to download
relative humidity data at the province level (gid 1), caching in the
same folder.

``` r
temp_gid1<- fetch_ad(metric = "relhumid", gid = 1, use_cache = TRUE)
```

## Extracting specific data

Extracting data from this matrix can be fiddly, but luckily `ohvbd` also
provides a function to aid in that:
[`glean_ad()`](https://ohvbd.vbdhub.org/reference/glean_ad.md).

So let’s again try to extract the same data as previously, the
temperature in Angola on 2020-01-01:

``` r
ad_df |> glean_ad(targetdate = "2020-01-01", places = "Angola")
```

    ## <ohvbd.ad.matrix>
    ## Areadata matrix for temp at gid level 0 .
    ## Cached: FALSE 
    ## Dates: 2020-01-01 -> 2020-01-01 (1)
    ## Locations: 1 
    ## Data:
    ##        2020-01-01
    ## Angola   29.33611
    ## attr(,"metric")
    ## [1] "temp"
    ## attr(,"gid")
    ## [1] 0
    ## attr(,"cached")
    ## [1] FALSE
    ## attr(,"db")
    ## [1] "ad"
    ## attr(,"writetime")
    ## [1] "2026-02-02 15:14:51 GMT"
    ## attr(,"class")
    ## [1] "ohvbd.ad.matrix" "matrix"          "array"

*Note: ignore the `attr` part of the output, this data just allows
`ohvbd` to ensure consistency between its functions.*

Wonderful! But what if we want a range of dates, or many places? What if
the dates fall outside the dates that we have data for, or the places
are not actually present in the data?

This is where
[`glean_ad()`](https://ohvbd.vbdhub.org/reference/glean_ad.md) really
shines.

### Dates and date ranges

Let’s first look at the flexibility of the date arguments to
[`glean_ad()`](https://ohvbd.vbdhub.org/reference/glean_ad.md).

If we (for example) want not just one day, we can specify either a
vector of dates, or a less exact date as `targetdate`

``` r
ad_df |> glean_ad(
  targetdate = c("2020-01-01", "2020-01-02", "2020-01-05"),
  places = "Angola"
)
```

    ## <ohvbd.ad.matrix>
    ## Areadata matrix for temp at gid level 0 .
    ## Cached: FALSE 
    ## Dates: 2020-01-01 -> 2020-01-05 (3)
    ## Locations: 1 
    ## Data:
    ##        2020-01-01 2020-01-02 2020-01-05
    ## Angola   29.33611   28.77514   28.13407
    ## attr(,"metric")
    ## [1] "temp"
    ## attr(,"gid")
    ## [1] 0
    ## attr(,"cached")
    ## [1] FALSE
    ## attr(,"db")
    ## [1] "ad"
    ## attr(,"writetime")
    ## [1] "2026-02-02 15:14:51 GMT"
    ## attr(,"class")
    ## [1] "ohvbd.ad.matrix" "matrix"          "array"

``` r
ad_df |> glean_ad(targetdate = "2020-01", places = "Angola")
```

    ## <ohvbd.ad.matrix>
    ## Areadata matrix for temp at gid level 0 .
    ## Cached: FALSE 
    ## Dates: 2020-01-01 -> 2020-01-31 (31)
    ## Locations: 1 
    ## Data:
    ##        2020-01-01 2020-01-02 2020-01-03 2020-01-04 2020-01-05 2020-01-06 2020-01-07 2020-01-08 2020-01-09 2020-01-10 2020-01-11 2020-01-12 2020-01-13 2020-01-14 2020-01-15 2020-01-16 2020-01-17
    ## Angola   29.33611   28.77514   28.88312    27.4325   28.13407   28.64046   28.09983   28.40937   28.71222   27.21757   26.85815   28.92744    29.5375   28.88849   28.81174   29.81402   29.89741
    ##        2020-01-18 2020-01-19 2020-01-20 2020-01-21 2020-01-22 2020-01-23 2020-01-24 2020-01-25 2020-01-26 2020-01-27 2020-01-28 2020-01-29 2020-01-30 2020-01-31
    ## Angola    29.5939   29.87222   30.28832   30.18386   29.98904   29.97556   29.63855   29.53917   29.00056   28.81855   29.47186   28.44818   28.64745   28.34594
    ## attr(,"metric")
    ## [1] "temp"
    ## attr(,"gid")
    ## [1] 0
    ## attr(,"cached")
    ## [1] FALSE
    ## attr(,"db")
    ## [1] "ad"
    ## attr(,"writetime")
    ## [1] "2026-02-02 15:14:51 GMT"
    ## attr(,"class")
    ## [1] "ohvbd.ad.matrix" "matrix"          "array"

``` r
# 366 days of data return as 2020 is a leap year
length(ad_df |> glean_ad(targetdate = "2020", places = "Angola"))
```

    ## [1] 366

If we would instead like to specify a date range, we can add the
argument `enddate`.

*Note: the end date is defined **exclusively**, meaning that any date
before it (and on or after the target date) is considered to be “in”.*

``` r
ad_df |> glean_ad(
  targetdate = "2020-01-01",
  enddate = "2020-01-04",
  places = "Angola"
)
```

    ## <ohvbd.ad.matrix>
    ## Areadata matrix for temp at gid level 0 .
    ## Cached: FALSE 
    ## Dates: 2020-01-01 -> 2020-01-03 (3)
    ## Locations: 1 
    ## Data:
    ##        2020-01-01 2020-01-02 2020-01-03
    ## Angola   29.33611   28.77514   28.88312
    ## attr(,"metric")
    ## [1] "temp"
    ## attr(,"gid")
    ## [1] 0
    ## attr(,"cached")
    ## [1] FALSE
    ## attr(,"db")
    ## [1] "ad"
    ## attr(,"writetime")
    ## [1] "2026-02-02 15:14:51 GMT"
    ## attr(,"class")
    ## [1] "ohvbd.ad.matrix" "matrix"          "array"

### Places

Multiple places to extract data for can also be provided as a vector of
places:

``` r
ad_df |> glean_ad(
  targetdate = "2020-01-01",
  places = c("Angola", "Latvia", "United Kingdom")
)
```

    ## <ohvbd.ad.matrix>
    ## Areadata matrix for temp at gid level 0 .
    ## Cached: FALSE 
    ## Dates: 2020-01-01 -> 2020-01-01 (1)
    ## Locations: 3 
    ## Data:
    ##                2020-01-01
    ## Angola          29.336107
    ## Latvia           1.765062
    ## United_Kingdom   5.113141
    ## attr(,"metric")
    ## [1] "temp"
    ## attr(,"gid")
    ## [1] 0
    ## attr(,"cached")
    ## [1] FALSE
    ## attr(,"db")
    ## [1] "ad"
    ## attr(,"writetime")
    ## [1] "2026-02-02 15:14:51 GMT"
    ## attr(,"class")
    ## [1] "ohvbd.ad.matrix" "matrix"          "array"

This can be combined with the date filters above to create a more
restrictive extraction:

``` r
ad_df |> glean_ad(
  targetdate = "2020-01-01",
  enddate = "2020-01-04",
  places = c("Angola", "Latvia", "United Kingdom")
)
```

    ## <ohvbd.ad.matrix>
    ## Areadata matrix for temp at gid level 0 .
    ## Cached: FALSE 
    ## Dates: 2020-01-01 -> 2020-01-03 (3)
    ## Locations: 3 
    ## Data:
    ##                2020-01-01 2020-01-02 2020-01-03
    ## Angola          29.336107  28.775145  28.883123
    ## Latvia           1.765062   3.268600   2.733880
    ## United_Kingdom   5.113141   8.206171   6.198989
    ## attr(,"metric")
    ## [1] "temp"
    ## attr(,"gid")
    ## [1] 0
    ## attr(,"cached")
    ## [1] FALSE
    ## attr(,"db")
    ## [1] "ad"
    ## attr(,"writetime")
    ## [1] "2026-02-02 15:14:51 GMT"
    ## attr(,"class")
    ## [1] "ohvbd.ad.matrix" "matrix"          "array"

### Resiliance

The [`glean_ad()`](https://ohvbd.vbdhub.org/reference/glean_ad.md)
function is also relatively resilient to the use of dates or places that
are not in AREAdata:

``` r
ad_df |> glean_ad(
  targetdate = "2023-12-30",
  enddate = "2024-01-02",
  places = c("Atlantis", "Latvia", "United Kingdom")
)
```

    ## <ohvbd.ad.matrix>
    ## Areadata matrix for temp at gid level 0 .
    ## Cached: FALSE 
    ## Dates: 2023-12-30 -> 2024-01-01 (3)
    ## Locations: 2 
    ## Data:
    ##                2023-12-30 2023-12-31 2024-01-01
    ## United_Kingdom   7.007509   7.715774   7.124182
    ## Latvia           4.098629  -2.789258  -7.665634
    ## attr(,"metric")
    ## [1] "temp"
    ## attr(,"gid")
    ## [1] 0
    ## attr(,"cached")
    ## [1] FALSE
    ## attr(,"db")
    ## [1] "ad"
    ## attr(,"writetime")
    ## [1] "2026-02-02 15:14:51 GMT"
    ## attr(,"class")
    ## [1] "ohvbd.ad.matrix" "matrix"          "array"

## Associating AREAData climatic variables with other data

On top of providing a download interface for AREAData, `ohvbd` provides
tools for easing the process of associating your own data with data from
AREAData.

This is performed through the use of the
[`assoc_ad()`](https://ohvbd.vbdhub.org/reference/assoc_ad.md) function.

For example, let’s imagine we have some data and their associate
locations:

``` r
  lonlatdf <- data.frame(
    Country = c("UK", "DE", "US", "ES", "IT", "BG", "US"),
    Latitude = c(
      53.813727033336384, 50.94133730102917, 41.502614374776414, 37.09584576240546,
      46.190816816324634, 43.40408987260468, 34.02921305111613
    ),
    Longitude = c(
      -1.5631510640531983, 6.95792487354786, -73.96228644647785,
      -2.0967211553577694, 11.135228310071971, 28.148385835241964,
      -84.36091597146886
    ),
    count = c(6, 36, 340, 202, 802, 541, 325)
  )

lonlatdf
```

    ##   Country Latitude  Longitude count
    ## 1      UK 53.81373  -1.563151     6
    ## 2      DE 50.94134   6.957925    36
    ## 3      US 41.50261 -73.962286   340
    ## 4      ES 37.09585  -2.096721   202
    ## 5      IT 46.19082  11.135228   802
    ## 6      BG 43.40409  28.148386   541
    ## 7      US 34.02921 -84.360916   325

If we know that we collected samples between the 4th and 5th of August
2021, we can associate the temperature values from these regions on
these days at a given spatial scale.

Let’s do this at the country scale:

``` r
areadata <- fetch_ad(metric="temp", gid=0, use_cache=TRUE)
ad_extract_working <- assoc_ad(lonlatdf, areadata,
                                    targetdate = c("2021-08-04"), enddate=c("2021-08-06"),
                                    gid=0, lonlat_names = c("Longitude", "Latitude"))
# Suppress lonlat just to make the output easier to read
ad_extract_working |> dplyr::select(!c("Longitude", "Latitude"))
```

    ##   Country count temp_2021.08.04 temp_2021.08.05
    ## 1      UK     6        15.98993        16.09847
    ## 2      DE    36        17.17353        18.25541
    ## 3      US   340        26.12418        26.02746
    ## 4      ES   202        26.00963        27.42062
    ## 5      IT   802        26.21531        24.99068
    ## 6      BG   541        29.31433        31.18788
    ## 7      US   325        26.12418        26.02746

If we prefer a finer resolution (e.g. county-level), we could change the
`gid` argument to a higher number (indicating a finer scale, up to `2`):

``` r
areadata_gid2 <- fetch_ad(metric="temp", gid=2, use_cache=TRUE)
ad_extract_working_gid2 <- assoc_ad(lonlatdf, areadata_gid2,
                                    targetdate = c("2021-08-04"), enddate=c("2021-08-06"),
                                    gid=2, lonlat_names = c("Longitude", "Latitude"))
ad_extract_working_gid2 |> dplyr::select(!c("Longitude", "Latitude"))
```

    ##   Country count temp_2021.08.04 temp_2021.08.05
    ## 1      UK     6        16.35346        16.46636
    ## 2      DE    36        16.62339        18.94270
    ## 3      US   340        20.59405        20.87954
    ## 4      ES   202        29.42114        31.26401
    ## 5      IT   802        20.82837        23.16447
    ## 6      BG   541        25.01201        25.38486
    ## 7      US   325        23.69151        24.70063

We can see here that by using a finer spatial scale, the two entries
from the US now have different associated temperatures.

## Managing the AREAdata cache

Interacting with AREAdata requires the caching of a significant amount
of data.

This is generally managed by `ohvbd` itself, and in most cases you
should not need to worry about it.

However if you want to free up some space, use guaranteed new data, or
see what data `ohvbd` has currently stored on your computer, you have a
few options available to you.

### `refresh_cache` for `fetch_ad()`

The [`fetch_ad()`](https://ohvbd.vbdhub.org/reference/fetch_ad.md)
function has an argument called `refresh_cache`. If this is set to
`TRUE`, this will force a refresh of the cache at download time (and
suppress loading from said cache):

``` r
test_ad <- fetch_ad("temp", gid = 0)
attr(test_ad, "writetime")
```

    ## [1] "2026-02-02 15:14:51 GMT"

``` r
test_ad <- fetch_ad("temp", gid = 0, refresh_cache = TRUE)
attr(test_ad, "writetime")
```

    ## [1] "2026-02-02 15:15:18 GMT"

### Cache management tools

Alternatively you can use the provided tools
[`list_ohvbd_cache()`](https://ohvbd.vbdhub.org/reference/list_ohvbd_cache.md)
and
[`clean_ohvbd_cache()`](https://ohvbd.vbdhub.org/reference/clean_ohvbd_cache.md)
to explore and delete files within the ohvbd cache:

``` r
list_ohvbd_cache()
```

    ── Cached files ────────────────────────
    Cache location: ../cache/R/ohvbd

    ── <root>: 0 files ──

    none

    ── adcache: 3 files ──

    • relhumid-1.rda
    • temp-0.rda
    • temp-2.rda

    ── gadmcache: 6 files ──

    • gadm-counties.gpkg
    • gadm-countries.gpkg
    • gadm-states.gpkg

    ── vecdyn: 1 file ──

    • vd_meta_table.rds

You can filter this by subdirectory, so let’s just look at the data
downloaded from AREAdata (in `adcache`):

``` r
list_ohvbd_cache(subdir = "adcache")
```

    ── Cached files ────────────────────────
    Cache location: ../cache/R/ohvbd

    ── adcache: 3 files ────────────────────

    • relhumid-1.rda
    • temp-0.rda
    • temp-2.rda

If we wished to delete these files, we could simply run the following:

``` r
clean_ohvbd_cache(subdir = "adcache")
```

    ── Cached files  ────────────────────────
    Cache location: ../cache/R/ohvbd

    ── adcache: 3 files ──

    • relhumid-1.rda
    • temp-0.rda
    • temp-2.rda

    ! This will permanently delete files from adcache
    ℹ Are you sure? [y/N]
    >> y

    ℹ Clearing files from ../cache/R/ohvbd/adcache
    ✔ Removed 3 files

Built in 28.4432349s
