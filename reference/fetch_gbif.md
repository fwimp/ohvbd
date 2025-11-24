# Fetch GBIF dataset/s by ID

Retrieve GBIF dataset/s specified by their dataset ID.

## Usage

``` r
fetch_gbif(ids, filepath = ".")
```

## Arguments

- ids:

  a string or character vector of ids (preferably in an `ohvbd.ids`
  object) indicating the particular dataset/s to download.

- filepath:

  directory to save gbif download files into.

## Value

A list of [rgbif
occ_download_get](https://docs.ropensci.org/rgbif/reference/occ_download_get.html)
objects, as an `ohvbd.responses` object.

## Note

Only 300 datasets can be requested at once (for now) due to technical
limitations originating from the GBIF server setup. It is worth
splitting longer lists of ids into a couple of chunks if you need more
than this.

If you regularly use ohvbd to download large numbers of datasets at once
and chunking is causing you other issues, please raise an issue at
https://github.com/fwimp/ohvbd/issues.

## Author

Francis Windram

## Examples

``` r
if (FALSE) { # interactive()
fetch_gbif("dbc4a3ae-680f-44e6-ab25-c70e27b38dbc")

ohvbd.ids("dbc4a3ae-680f-44e6-ab25-c70e27b38dbc", "gbif") |>
  fetch() # Calls fetch_gbif()
}
```
