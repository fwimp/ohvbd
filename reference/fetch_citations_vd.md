# Retrieve citations for vecdyn data

Retrieve citations for vecdyn data either directly from the dataset or
by redownloading the appropriate data.

## Usage

``` r
fetch_citations_vd(dataset, redownload = TRUE, minimise = FALSE)
```

## Arguments

- dataset:

  The dataset from which you wish to retrieve citations.

- redownload:

  Redownload data if citation columns are missing.

- minimise:

  Whether to return one row per citation (rather than one per dataset
  ID).

## Value

`ohvbd.data.frame` of citation data

## Author

Francis Windram
