# Test whether an object is considered to be from a particular database

This function tests whether an object is considered (by `ohvbd`) to be
from a given database.

This is a fairly coarse check, and so cannot "work out" data provenance
from its structure.

## Usage

``` r
is_from(x, db, ...)
```

## Arguments

- x:

  An object to test.

- db:

  The database to test against.

- ...:

  Any arguments to be passed to the underlying functions (unused).

## Value

Whether the data is from a given database (as a boolean).

## Author

Francis Windram

## Examples

``` r
ids <- ohvbd.ids(c(1,2,3), "vd")
is_from(ids, "vd")
#> [1] TRUE
```
