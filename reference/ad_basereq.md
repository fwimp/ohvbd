# Generate a base request string for the AREAdata database

This string is used as the basis for all calls to AREAdata. It does not
contain any tokens or session ids, and thus can be regenerated at any
time.

## Usage

``` r
ad_basereq()
```

## Value

Returns a string containing the root address of the AREAdata dataset.

## Author

Francis Windram

## Examples

``` r
basereq <- ad_basereq()
```
