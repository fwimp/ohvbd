# Set the default ohvbd cache location

Set the default ohvbd cache location

## Usage

``` r
set_default_ohvbd_cache(d = NULL)
```

## Arguments

- d:

  The directory to set the cache path to (or NULL to use a default
  location).

## Value

The path of the cache (invisibly)

## Note

To permanently set a path to use, add the following to your `.Rprofile`
file:

    options(ohvbd_cache = "path/to/directory")

Where `path/to/directory` is the directory in which you wish to cache
ohvbd files.

You can find a good default path by running `set_default_ohvbd_cache()`
with no arguments.

## Author

Francis Windram

## Examples

``` r
set_default_ohvbd_cache()
#> ✔ Set `ohvbd_cache` option to /home/runner/.cache/R/ohvbd.
#> 
#> ────────────────────────────────────────────────────────────────────────────────
#> ℹ To set this permanently, add the following code to your .Rprofile file:
#> 
#> options(ohvbd_cache = "/home/runner/.cache/R/ohvbd")
```
