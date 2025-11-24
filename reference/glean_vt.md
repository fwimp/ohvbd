# Parse data from requests to VecTraits

Extract the data returned by a call to
[`fetch_vt()`](https://ohvbd.vbdhub.org/reference/fetch_vt.md), filter
columns of interest, and find unique rows if required.

## Usage

``` r
glean_vt(res, cols = NA, returnunique = FALSE)
```

## Arguments

- res:

  a list of responses from VecTraits as an `ohvbd.responses` object.

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
fetch_vt(54) |>
  glean_vt(cols=c("DatasetID",
                    "Interactor1Genus",
                    "Interactor1Species"),
             returnunique=TRUE)

ohvbd.ids(54, "vt") |>
  fetch() |>
  glean() # Calls glean_vt()
}
```
