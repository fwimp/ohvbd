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
print(ad_df)
#> <ohvbd.ad.matrix>
#> Areadata matrix for temp at gid level 0 .
#> Cached: FALSE 
#> Dates: 2020-01-01 -> 2025-11-30 (2161)
#> Locations: 256
```

So that is quite a lot of data! Way too much to print here, given that
it’s 553216 entries, however if you want to print all the data rather
than just a summary, you can add the argument `full = TRUE` to the print
command:

``` r
print(ad_df, full = TRUE)
```

AREAdata outputs are formatted as matrices. Here the rows correspond to
locations (identified by GADM codes):

``` r
head(rownames(ad_df))
#> [1] "Aruba"       "Afghanistan" "Angola"      "Anguilla"    "Åland"      
#> [6] "Albania"
```

Meanwhile the column names correspond to the day that the data refers
to:

``` r
head(colnames(ad_df))
#> [1] "2020-01-01" "2020-01-02" "2020-01-03" "2020-01-04" "2020-01-05"
#> [6] "2020-01-06"
```

So the value at `ad_df["Angola", "2020-01-01"]` corresponds to the value
of the metric (in this case temperature) in Angola on 2020-01-01:

``` r
ad_df["Angola", "2020-01-01"]
#> [1] 29.33611
```

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

(We will not execute this, just because gid level 1 data is
significantly larger than gid level 0)

``` r
fetch_ad(metric = "relhumid", gid = 1, use_cache = TRUE)
```

## Extracting specific data

Extracting data from this matrix can be fiddly, but luckily `ohvbd` also
provides a function to aid in that:
[`glean_ad()`](https://ohvbd.vbdhub.org/reference/glean_ad.md).

So let’s again try to extract the same data as previously, the
temperature in Angola on 2020-01-01:

``` r
ad_df |> glean_ad(targetdate = "2020-01-01", places = "Angola")
#> <ohvbd.ad.matrix>
#> Areadata matrix for temp at gid level 0 .
#> Cached: FALSE 
#> Dates: 2020-01-01 -> 2020-01-01 (1)
#> Locations: 1
```

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
#> <ohvbd.ad.matrix>
#> Areadata matrix for temp at gid level 0 .
#> Cached: FALSE 
#> Dates: 2020-01-01 -> 2020-01-05 (3)
#> Locations: 1
```

``` r
ad_df |> glean_ad(targetdate = "2020-01", places = "Angola")
#> <ohvbd.ad.matrix>
#> Areadata matrix for temp at gid level 0 .
#> Cached: FALSE 
#> Dates: 2020-01-01 -> 2020-01-31 (31)
#> Locations: 1
```

``` r
# 366 days of data return as 2020 is a leap year
length(ad_df |> glean_ad(targetdate = "2020", places = "Angola"))
#> [1] 366
```

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
#> <ohvbd.ad.matrix>
#> Areadata matrix for temp at gid level 0 .
#> Cached: FALSE 
#> Dates: 2020-01-01 -> 2020-01-03 (3)
#> Locations: 1
```

### Places

Multiple places to extract data for can also be provided as a vector of
places:

``` r
ad_df |> glean_ad(
  targetdate = "2020-01-01",
  places = c("Angola", "Latvia", "United Kingdom")
)
#> <ohvbd.ad.matrix>
#> Areadata matrix for temp at gid level 0 .
#> Cached: FALSE 
#> Dates: 2020-01-01 -> 2020-01-01 (1)
#> Locations: 3
```

This can be combined with the date filters above to create a more
restrictive extraction:

``` r
ad_df |> glean_ad(
  targetdate = "2020-01-01",
  enddate = "2020-01-04",
  places = c("Angola", "Latvia", "United Kingdom")
)
#> <ohvbd.ad.matrix>
#> Areadata matrix for temp at gid level 0 .
#> Cached: FALSE 
#> Dates: 2020-01-01 -> 2020-01-03 (3)
#> Locations: 3
```

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
#> <ohvbd.ad.matrix>
#> Areadata matrix for temp at gid level 0 .
#> Cached: FALSE 
#> Dates: 2023-12-30 -> 2024-01-01 (3)
#> Locations: 2
```

## To be completed

Built in 2.147629s
