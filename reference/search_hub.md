# Search vbdhub.org

Retrieve the IDs for any datasets matching the given search parameters.

## Usage

``` r
search_hub(
  query = "",
  db = c("vt", "vd", "gbif", "px"),
  fromdate = NULL,
  todate = NULL,
  locationpoly = NULL,
  taxonomy = NULL,
  exact = FALSE,
  withoutpublished = TRUE,
  returnlist = FALSE,
  simplify = TRUE,
  connections = 8
)
```

## Arguments

- query:

  a search string.

- db:

  the databases to search.

- fromdate:

  the date from which to search (ISO format: yyyy-mm-dd).

- todate:

  the date up to which to search (ISO format: yyyy-mm-dd).

- locationpoly:

  a polygon or set of polygons in
  [`terra::SpatVector`](https://rspatial.github.io/terra/reference/SpatVector-class.html)
  or WKT MULTIPOLYGON format within which to search. Easily generated
  using
  [`match_countries()`](https://ohvbd.vbdhub.org/reference/match_countries.md)

- taxonomy:

  a numeric vector containing the gbif ids of taxa to search for (found
  using
  [`match_species()`](https://ohvbd.vbdhub.org/reference/match_species.md)
  or similar functions).

- exact:

  whether to return exact matches only.

- withoutpublished:

  whether to return results without a publishing date when filtering by
  date.

- returnlist:

  return the raw output list rather than a formatted dataframe.

- simplify:

  if only a single database was searched, return an `ohvbd.ids` object
  instead (defaults to `TRUE`).

- connections:

  the number of connections to use to parallelise queries.

## Value

an `ohvbd.hub.search` dataframe, an `ohvbd.ids` vector (if
`returnlist=TRUE` and `length(db) == 1`) a list (if `returnlist=TRUE`)
containing the search results.

## Author

Francis Windram

## Examples

``` r
if (FALSE) { # interactive()
search_hub("Ixodes ricinus")
}
```
