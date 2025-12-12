# Delete files from ohvbd cache directories

Delete files from ohvbd cache directories

## Usage

``` r
clean_ohvbd_cache(cache_location = NULL, subdir = NULL, dryrun = FALSE)
```

## Arguments

- cache_location:

  location within which to remove rda files. (Defaults to the standard
  ohvbd cache location).

- subdir:

  a subdirectory or list of subdirectories to clean.

- dryrun:

  if `TRUE` list files that would be deleted, but do not remove.

## Author

Francis Windram

## Examples

``` r
if (FALSE) { # interactive()
clean_ad_cache()
}
```
