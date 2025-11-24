# Print current ohvbd configuration variables

Access ohvbd options and configured variables, and print them to the
command line.

## Usage

``` r
check_ohvbd_config(options_list = NULL)
```

## Arguments

- options_list:

  An (optional) list of variables to search for.

## Value

`TRUE` if all desired options are set (though not necessarily turned
on), else `FALSE`.

## Author

Francis Windram

## Examples

``` r
  check_ohvbd_config()
#> ✖ ohvbd_compat: NA
```
