# Force a polygon WKT into multipolygon form

Force a polygon WKT into multipolygon form

## Usage

``` r
force_multipolygon(wkt, call = rlang::caller_env())
```

## Arguments

- wkt:

  The WKT to convert into a multipolygon.

- call:

  The env from which this was called (defaults to the direct calling
  environment).

## Value

The multipolygon equivalent of wkt.
