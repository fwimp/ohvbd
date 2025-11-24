# Parse data from requests to GBIF

Extract the data returned by a call to
[`fetch_gbif()`](https://ohvbd.vbdhub.org/reference/fetch_gbif.md),
filter columns of interest, and find unique rows if required.

## Usage

``` r
glean_gbif(res, cols = NA, returnunique = FALSE)
```

## Arguments

- res:

  a list of responses from GBIF as an `ohvbd.responses` object.

- cols:

  a character vector of columns to extract from the dataset.

- returnunique:

  whether to return only the unique rows within each dataset according
  to the filtered columns.

## Value

An `ohvbd.data.frame` containing the requested data.

## Author

Francis Windram

## Examples

``` r
if (FALSE) { # interactive()
fetch_gbif("dbc4a3ae-680f-44e6-ab25-c70e27b38dbc") |>
  glean_gbif()

ohvbd.ids("dbc4a3ae-680f-44e6-ab25-c70e27b38dbc", "gbif") |>
  fetch() |>
  glean() # Calls glean_gbif()
}
```
