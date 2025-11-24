# Force an object to appear to come from a specific database

Force an object to appear to come from a specific database

## Usage

``` r
force_db(x, db)
```

## Arguments

- x:

  Object to force.

- db:

  Database to apply to `x`.

## Value

Object with the "db" attribute set to `db`

## Note

**DO NOT** use this function to create ids to feed into
[`fetch()`](https://ohvbd.vbdhub.org/reference/fetch.md)!

Objects created in this way may lack vital underlying data required
later. Instead use
[`ohvbd.ids()`](https://ohvbd.vbdhub.org/reference/ohvbd.ids.md) for
this purpose.

## Author

Francis Windram

## Examples

``` r
force_db(c(1,2,3), "vt")
#> [1] 1 2 3
#> attr(,"db")
#> [1] "vt"
```
