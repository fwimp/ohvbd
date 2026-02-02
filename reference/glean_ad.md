# Extract data from AREAdata datasets

Extract the data returned by a call to
[`fetch_ad()`](https://ohvbd.vbdhub.org/reference/fetch_ad.md), filter
columns of interest and by dates of interest.

Currently this does not handle Population Density or Forecast matrices,
however the other 5 metrics are handled natively.

## Usage

``` r
glean_ad(
  ad_matrix,
  targetdate = NA,
  enddate = NA,
  places = NULL,
  gid = NULL,
  printbars = TRUE
)
```

## Arguments

- ad_matrix:

  A matrix or `ohvbd.ad.matrix` of data from AREAdata.

- targetdate:

  **ONE OF** the following:

  - The date to search for in ISO 8601 (e.g. "2020", "2021-09", or
    "2022-09-21").

  - The start date for a range of dates.

  - A character vector of fully specified dates to search for (i.e.
    "yyyy-mm-dd")

- enddate:

  The (exclusive) end of the range of dates to search for. If this is
  unfilled, only the `targetdate` is searched for.

- places:

  A character vector or single string describing what locality to search
  for in the dataset.

- gid:

  The spatial scale of the AREAdata matrix (this is not needed if the
  matrix has been supplied by
  [`fetch_ad()`](https://ohvbd.vbdhub.org/reference/fetch_ad.md)).

- printbars:

  Whether to print time overlap bars in the case of dates outside the
  data range.

## Value

An `ohvbd.ad.matrix` or a named vector containing the extracted data.

## Place matching

This function attempts to intelligently infer place selections based
upon the provided gid and place names.

So if you have an AREAdata dataset at `gid=1`, and provide country
names, the function will attempt to match those country names and
retrieve any GID1-level data that is present.

Occasionally (such as in the case of "Albania", the municipality in La
Guajira, Columbia) the name of a place may occur in locations other than
those expected by the researcher.

Unfortunately this is not an easy problem to mitigate, and as such it is
worthwhile checking the output of this function to make sure it is as
you expect.

## Date ranges

The date range is a partially open interval. That is to say the lower
bound (`targetdate`) is inclusive, but the upper bound (`enddate`) is
exclusive.

For example a date range of "2020-08-04" - "2020-08-12" will return the
7 days from the 4th through to the 11th of August, but *not* the 12th.

## Date inference

In cases where a full date is not provided, the earliest date possible
with the available data is chosen.

So "2020-04" will internally become "2020-04-01".

If an incomplete date is specified as the `targetdate` and no `enddate`
is specified, the range to search is inferred from the minimum temporal
scale provided in `targetdate`.

For example "2020-04" will be taken to mean the month of April in 2020,
and the `enddate` will internally be set to "2020-05-01".

## Author

Francis Windram

## Examples

``` r
if (FALSE) { # interactive()
# All dates in August 2022
fetch_ad("temp", gid=0) |>
  glean_ad(
    targetdate = "2022-08",
    places = c("Albania", "Thailand")
  )

# 4th, 5th, and 6th of August 2022 (remember the enddate is EXCLUSIVE)
fetch_ad("temp", gid=0) |>
  glean_ad(
    targetdate = "2022-08-04", enddate="2022-08-07",
    places = c("Albania", "Thailand")
  )

# 4th of August 2022 and 1st of August 2023
fetch_ad("temp", gid=0) |>
  glean_ad(
    targetdate = c("2022-08-04", "2023-08-01"),
    places = c("Albania", "Thailand")
  )
}
```
