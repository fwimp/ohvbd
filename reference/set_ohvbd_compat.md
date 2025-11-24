# Set ohvbd compatability mode to TRUE

Set ohvbd to disable ssl verification for calls to external APIs. This
should not be needed (and not be performed) unless you are otherwise
experiencing SSL issues when using the package!

When in interactive mode, checks with you to make sure you want to do
this. Does not check when run in a script.

## Usage

``` r
set_ohvbd_compat(value = TRUE)
```

## Arguments

- value:

  The boolean value to set ohvbd_compat to.

## Author

Francis Windram

## Examples

``` r
if (FALSE) { # interactive()
set_ohvbd_compat()
}
```
