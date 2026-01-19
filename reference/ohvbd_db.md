# Database provenance

Retrieve or set the provenance information expected by `ohvbd`.

## Usage

``` r
ohvbd_db(x)

ohvbd_db(x) <- value
```

## Arguments

- x:

  An object.

- value:

  The value to set the db to.

## Value

The database identifier associated with an object (or `NULL` if
missing).

## See also

[Internal attributes](https://ohvbd.vbdhub.org/reference/ohvbd_attrs.md)

## Author

Francis Windram

## Examples

``` r
ids <- ohvbd.ids(c(1,2,3), "vd")
ohvbd_db(ids)
#> [1] "vd"

ohvbd_db(ids) <- "vt"
ohvbd_db(ids)
#> [1] "vt"
```
