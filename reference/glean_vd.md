# Parse data from requests to VecDyn

Extract the data returned by a call to
[`fetch_vd()`](https://ohvbd.vbdhub.org/reference/fetch_vd.md), filter
columns of interest, and find unique rows if required.

## Usage

``` r
glean_vd(res, cols = NA, returnunique = FALSE)
```

## Arguments

- res:

  a list of responses from VecDyn as an `ohvbd.responses` object.

- cols:

  a character vector of columns to extract from the dataset. If
  specified, this will be adjusted to always include the "dataset_id"
  column.

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
fetch_vd(247) |>
  glean_vd(cols=c("species",
                    "sample_start_date",
                    "sample_value"),
             returnunique=TRUE)

ohvbd.ids(247, "vd") |>
  fetch() |>
  glean() # Calls glean_vd()
}
```
