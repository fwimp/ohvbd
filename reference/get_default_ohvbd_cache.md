# Get ohvbd cache locations

Get ohvbd cache locations

## Usage

``` r
get_default_ohvbd_cache(subdir = NULL, create = TRUE)
```

## Arguments

- subdir:

  The subdirectory within the cache to find/create (optional).

- create:

  Whether to create the cache location if it does not already exist
  (defaults to TRUE).

## Value

ohvbd cache path as a string

## Author

Francis Windram

## Examples

``` r
if (FALSE) { # interactive()
get_default_ohvbd_cache()
}
```
