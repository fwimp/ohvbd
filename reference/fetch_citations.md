# Try to find the relevant citations for a dataset

This tries to extract and simplify the citations from a dataset
downloaded using `ohvbd`.

## Usage

``` r
fetch_citations(dataset, ...)
```

## Arguments

- dataset:

  An object of type `ohvbd.data.frame` (generated from
  [`glean()`](https://ohvbd.vbdhub.org/reference/glean.md), preferred)
  or of type `ohvbd.ids` and containing data from one of the supported
  databases.

- ...:

  Any arguments to be passed to the underlying funcs.

## Value

The extracted data, either as an `ohvbd.data.frame` or `ohvbd.ad.matrix`
object.

## Author

Francis Windram

## Examples

``` r
if (FALSE) { # interactive()
search_hub("Ixodes", "vt") |>
  fetch() |>
  glean() |>
  fetch_citations()
}
```
