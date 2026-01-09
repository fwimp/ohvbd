# Generate a base request object for the vectorbyte databases

This request is used as the basis for all calls to the vectorbyte API.
It does not contain any tokens or session ids, and thus can be
regenerated at any time.

## Usage

``` r
vb_basereq(
  baseurl = "https://vectorbyte.crc.nd.edu/portal/api/",
  useragent = "ROHVBD",
  unsafe = FALSE,
  .qa = FALSE
)
```

## Arguments

- baseurl:

  the base url for the vectorbyte API.

- useragent:

  the user agent string used when contacting vectorbyte.

- unsafe:

  disable ssl verification (shouldn't ever be required unless you are
  otherwise experiencing SSL issues!)

- .qa:

  switch to the vb qa server (only useful for testing).

## Value

Returns an httr2 request object, pointing at baseurl using useragent.

## Author

Francis Windram

## Examples

``` r
basereq <- vb_basereq(
  baseurl="https://vectorbyte.crc.nd.edu/portal/api/",
  useragent="ROHVBD")
```
