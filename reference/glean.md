# Extract specified data from a set of responses

This is a convenience method that infers and applies the correct
extractor for the input

## Usage

``` r
glean(res, ...)
```

## Arguments

- res:

  An object of type `ohvbd.responses` or `ohvbd.ad.matrix` generated
  from [`fetch()`](https://ohvbd.vbdhub.org/reference/fetch.md) and
  containing data from one of the supported databases.

- ...:

  Any arguments to be passed to the underlying extractors (unused).

## Value

The extracted data, either as an `ohvbd.data.frame` or `ohvbd.ad.matrix`
object.

## Author

Francis Windram

## Examples

``` r
if (FALSE) { # interactive()
search_hub("Ixodes", "vt") |> fetch() |> glean(cols=c("Interactor1Species"))
fetch_ad(use_cache=TRUE) |> glean(targetdate="2020-08-04")
}
```
