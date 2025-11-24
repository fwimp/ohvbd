# Extract specified data from a set of responses (Deprecated)

This is a convenience method that infers and applies the correct
extractor for the input.

## Usage

``` r
extract(res, ...)
```

## Arguments

- res:

  An object of type `ohvbd.responses` or `ohvbd.ad.matrix` generated
  from [`fetch()`](https://ohvbd.vbdhub.org/reference/fetch.md) and
  containing data from one of the supported databases.

- ...:

  Any arguments to be passed to the underlying extractors (see
  [`glean_vt()`](https://ohvbd.vbdhub.org/reference/glean_vt.md) and
  [`glean_ad()`](https://ohvbd.vbdhub.org/reference/glean_ad.md) for
  specific arguments).

## Value

The extracted data, either as an `ohvbd.data.frame` or `ohvbd.ad.matrix`
object.

## Note

`extract()` is now deprecated and should not be used. Please use
[`glean()`](https://ohvbd.vbdhub.org/reference/glean.md) instead.

## Author

Francis Windram
