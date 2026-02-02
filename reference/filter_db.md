# Filter hub search results by database

Retrieve the IDs for any datasets matching the given database.

## Usage

``` r
filter_db(ids, db)
```

## Arguments

- ids:

  an `ohvbd.hub.search` search result from
  [`search_hub()`](https://ohvbd.vbdhub.org/reference/search_hub.md).

- db:

  a database name as a string. One of `"vt"`, `"vd"`, `"gbif"`, `"px"`.

## Value

An `ohvbd.ids` vector of dataset IDs.

## Note

If `filter_db()` recieves an `ohvbd.ids` object by mistake, it will
transparently return it if the source database matches `db`.

## Author

Francis Windram

## Examples

``` r
if (FALSE) { # interactive()
search_hub("Ixodes ricinus")

search_hub("Ixodes ricinus") |>
  filter_db("vt") |>
  fetch() |>
  glean()
}
```
