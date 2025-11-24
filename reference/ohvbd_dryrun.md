# Option: dry runs of ohvbd searches

Set this option to make ohvbd terminate searches before execution and
return the request object instead.

## Note

This is usually only useful when debugging, testing, or developing
`ohvbd`.

## Author

Francis Windram

## Examples

``` r
if (FALSE) { # interactive()
options(ohvbd_dryrun = TRUE)
search_hub("Ixodes ricinus")

options(ohvbd_dryrun = NULL)  # Unset dryrun
}
```
