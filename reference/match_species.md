# Match species names to their GBIF backbone ids

Match species names to their GBIF backbone ids using
[`rgbif::name_backbone_checklist()`](https://docs.ropensci.org/rgbif/reference/name_backbone_checklist.html).

## Usage

``` r
match_species(speciesnames, exact = FALSE, returnids = TRUE, omit = TRUE)
```

## Arguments

- speciesnames:

  a vector of species names to match to the GBIF backbone.

- exact:

  whether to only return exact *species* matches.

- returnids:

  return the GBIF taxon ids only (otherwise return the full lookup
  dataframe).

- omit:

  omit missing taxon ids (inactive when `returnids = FALSE`).

## Value

The GBIF taxonids associated with `speciesnames` or the full GBIF lookup
dataframe if `returnids = TRUE`.

## Note

If `exact = TRUE` and you search for a genus name, this will not be
returned. If you want more control over id filtering, use
`returnids = FALSE` to get the source dataframe.

## Author

Francis Windram

## Examples

``` r
match_species(c("Araneus diadematus", "Aedes aegypti"))
#> Araneus diadematus      Aedes aegypti 
#>          "2160133"          "1651891" 
```
