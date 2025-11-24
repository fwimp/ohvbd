# Test whether an object has provenance information

This function tests whether an object has the provenance information
expected by `ohvbd`.

## Usage

``` r
has_db(x, ...)
```

## Arguments

- x:

  An object to test.

- ...:

  Any arguments to be passed to the underlying functions (unused).

## Value

Whether the data has a provenance tag (as a boolean).

## Author

Francis Windram

## Examples

``` r
ids <- ohvbd.ids(c(1,2,3), "vd")
has_db(ids)
#> [1] TRUE
```
