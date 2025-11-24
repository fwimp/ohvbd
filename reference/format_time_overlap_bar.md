# Format and print date overlaps

Format and output to the terminal a visualisation of the overlaps
between a given period and another set of dates. This is mostly used in
the error handling of
[`glean_ad()`](https://ohvbd.vbdhub.org/reference/glean_ad.md) however
it can also be used independently. It was designed to fill a more
general role within UI design using the cli package, and should be
usable (or hackable) by others needing the same tool.

## Usage

``` r
format_time_overlap_bar(
  start,
  end,
  targets,
  targetrange = FALSE,
  twobar = FALSE,
  width = NA,
  style = list()
)
```

## Arguments

- start:

  the date that the reference period begins (as Date object).

- end:

  the date that the reference period ends (as Date object).

- targets:

  a vector of dates.

- targetrange:

  is the target a range? If so this will treat the first two elements of
  `targets` as the start and end of the range.

- twobar:

  whether to render as two bars or as one with different colours for
  overlaps.

- width:

  the width of the bars in characters. Defaults to 0.5 \* console width.

- style:

  a style from
  [`cli::cli_progress_styles()`](https://cli.r-lib.org/reference/cli_progress_styles.html)
  to use as a format.

## Author

Francis Windram

## Examples

``` r
format_time_overlap_bar(
  start = as.Date("2022-08-04"),
  end = as.Date("2022-08-11"),
  targets = c(as.Date("2022-08-05"), as.Date("2022-08-12")),
  targetrange = TRUE, twobar=TRUE
)
#>     2022-08-04                                 2022-08-13
#>          |                                          |
#>    Data: | ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■     |
#> Targets: |     ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ |
#> 

```
