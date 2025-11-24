# Create a query for a given VD id at a given page

Create a query for a given VD id at a given page

## Usage

``` r
vd_make_req(id, pagenum, rate, url = "", useragent = "", unsafe = FALSE)
```

## Arguments

- id:

  ID of the vecdyn dataset.

- pagenum:

  page to retrieve.

- rate:

  rate limit for requests.

- url:

  the base url for the vectorbyte API.

- useragent:

  the user agent string used when contacting vectorbyte.

- unsafe:

  disable ssl verification (should only ever be required on Linux, **do
  not enable this by default**).

## Value

[httr2 request](https://httr2.r-lib.org/reference/request.html)
containing the requisite call to retrieve the data.
