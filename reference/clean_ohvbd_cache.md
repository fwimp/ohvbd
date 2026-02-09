# Delete files from ohvbd cache directories

Delete files from ohvbd cache directories

## Usage

``` r
clean_ohvbd_cache(subdir = NULL, path = NULL, dryrun = FALSE, force = FALSE)
```

## Arguments

- subdir:

  a subdirectory or list of subdirectories to clean.

- path:

  location within which to remove rda files. (Defaults to the standard
  ohvbd cache location).

- dryrun:

  if `TRUE` list files that would be deleted, but do not remove.

- force:

  do not ask for confirmation before cleaning.

## Value

No return value, called for side effects

## Author

Francis Windram

## Examples

``` r
if (FALSE) { # interactive()
clean_ad_cache()
}
```
