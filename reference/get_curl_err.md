# Extract curl errors from httr2 error objects

Extract curl errors from httr2 error objects

## Usage

``` r
get_curl_err(e, returnfiller = FALSE)
```

## Arguments

- e:

  An error object.

- returnfiller:

  If true return filler message if no curl message is present.

## Value

the curl error message (if present) or NULL (or a filler message).
