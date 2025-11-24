# Create a new ohvbd ID vector

When retrieving data from previous searches (or saved lists of IDs), it
can be useful to package these data up in the form that ohvbd would
expect to come out of a search.

To do this, create an `ohvbd.ids` object, specifying the database that
the ids refer to.

## Usage

``` r
ohvbd.ids(ids, db)
```

## Arguments

- ids:

  A numeric vector of ids referring to datasets within the specified
  database.

- db:

  A string specifying the database that these ids refer to.

## Value

An id vector: an S3 vector with class `ohvbd.ids`.

## Author

Francis Windram

## Examples

``` r
ohvbd.ids(c(1,2,3,4,5), db="vt")
#> <ohvbd.ids>
#> Database: vt
#> [1] 1 2 3 4 5

ohvbd.ids(c(1,2,3,4,5), db="vd")
#> <ohvbd.ids>
#> Database: vd
#> [1] 1 2 3 4 5

ohvbd.ids(
  c(
    "dbc4a3ae-680f-44e6-ab25-c70e27b38dbc",
    "fac87892-68c8-444a-9ae9-46273fdff724"
    ),
  db="gbif"
)
#> <ohvbd.ids>
#> Database: gbif
#> [1] "dbc4a3ae-680f-44e6-ab25-c70e27b38dbc"
#> [2] "fac87892-68c8-444a-9ae9-46273fdff724"
```
