# Citing data retrieved using ohvbd

## Citations

Naturally, when performing scientific research, citation is an important
part of the process. It is important that data generators (and curators)
recieve appropriate citation for their work, upon which future work is
based.

Often, however, the lifecycle of external data within a project can lead
to times when data becomes somewhat divorced from its origins.

For example if a dataset was downloaded from a data source, then
transformed and the minimal essential columns joined onto another
dataset, it may no longer be straightforward to work out where the data
originated.

## `ohvbd` citation tools

The `ohvbd` package provides certain tools to make it easier to derive
the sources of data used in one’s analysis, provided that certain
columns are retained.

### A basic example

As a simple example, let’s imagine that previously we downloaded data
from vectraits with the following code:

``` r
library(ohvbd)

df <- search_hub("Aedes aegypti") |>
  filter_db("vt") |>
  head(5) |>
  fetch() |>
  glean()
unique(df$DatasetID)
```

    ## [1] 474 475 148 578 126

Given that we have not filtered any columns out, this dataset contains
all the citation columns as-is.

As such we can simply extract these columns as is using the
[`fetch_citations()`](https://ohvbd.vbdhub.org/reference/fetch_citations.md)
function. This is by far the simplest scenario.

``` r
df |> fetch_citations()
```

    ## <ohvbd.data.frame>
    ## Database: vt
    ##   DatasetID                                                                                                                                                                               Citation
    ## 1       474                                           Yang et al. 2009. Assessing the effects of temperature on the population of Aedes aegypti the vector of dengue. Epidemiology & Infection 137
    ## 2       475                                           Yang et al. 2009. Assessing the effects of temperature on the population of Aedes aegypti the vector of dengue. Epidemiology & Infection 137
    ## 3       148                                                   Gulia-Nuss et al. 2015. Multiple factors contribute to anautogenous reproduction by the mosquito Aedes aegypti. J Insect Physiol. 82
    ## 4       578                                         Huxley et al. 2022. Competition and resource depletion shape the thermal response of population fitness in Aedes aegypti. Commun. Biol. 5: 66.
    ## 5       126 Goindin et al. 2015. Parity and longevity of Aedes aegypti according to temperatures in controlled conditions and consequences on dengue transmission risks. PLoS ONE 10(8): e0135489.
    ##                                                                                                                                                                                           CuratedByCitation
    ## 1 Pawar, S., Huxley, P.J., Smallwood, T.R.C. et al. Variation in temperature of peak trait performance constrains adaptation of arthropod populations to climatic warming. Nat Ecol Evol 8, 500–510 (2024).
    ## 2 Pawar, S., Huxley, P.J., Smallwood, T.R.C. et al. Variation in temperature of peak trait performance constrains adaptation of arthropod populations to climatic warming. Nat Ecol Evol 8, 500–510 (2024).
    ## 3 Pawar, S., Huxley, P.J., Smallwood, T.R.C. et al. Variation in temperature of peak trait performance constrains adaptation of arthropod populations to climatic warming. Nat Ecol Evol 8, 500–510 (2024).
    ## 4                                                                                                                                                                                                      <NA>
    ## 5                                                                                                                                                                                                      <NA>
    ##                 CuratedByDOI                            DOI SubmittedBy ContributorEmail
    ## 1 10.1038/s41559-023-02301-8      10.1017/S0950268809002040 Paul Huxley phuxly@gmail.com
    ## 2 10.1038/s41559-023-02301-8      10.1017/S0950268809002040 Paul Huxley phuxly@gmail.com
    ## 3 10.1038/s41559-023-02301-8 10.1016/j.jinsphys.2015.08.001 Paul Huxley phuxly@gmail.com
    ## 4                       <NA>     10.1038/s42003-022-03030-7 Paul Huxley phuxly@gmail.com
    ## 5                       <NA>   10.1371/journal.pone.0135489 Paul Huxley phuxly@gmail.com

If you look closely at the output, you should see that a couple of these
datasets are derived from the same paper.

You may only want a list of all the citations present in your dataset,
in which case the `minimise` argument to
[`fetch_citations()`](https://ohvbd.vbdhub.org/reference/fetch_citations.md)
can be used:

``` r
df |> fetch_citations(minimise = TRUE)
```

    ## <ohvbd.data.frame>
    ## Database: vt
    ##                                                                                                                                                                                 Citation
    ## 1                                           Yang et al. 2009. Assessing the effects of temperature on the population of Aedes aegypti the vector of dengue. Epidemiology & Infection 137
    ## 2                                                   Gulia-Nuss et al. 2015. Multiple factors contribute to anautogenous reproduction by the mosquito Aedes aegypti. J Insect Physiol. 82
    ## 3                                         Huxley et al. 2022. Competition and resource depletion shape the thermal response of population fitness in Aedes aegypti. Commun. Biol. 5: 66.
    ## 4 Goindin et al. 2015. Parity and longevity of Aedes aegypti according to temperatures in controlled conditions and consequences on dengue transmission risks. PLoS ONE 10(8): e0135489.
    ##                                                                                                                                                                                           CuratedByCitation
    ## 1 Pawar, S., Huxley, P.J., Smallwood, T.R.C. et al. Variation in temperature of peak trait performance constrains adaptation of arthropod populations to climatic warming. Nat Ecol Evol 8, 500–510 (2024).
    ## 2 Pawar, S., Huxley, P.J., Smallwood, T.R.C. et al. Variation in temperature of peak trait performance constrains adaptation of arthropod populations to climatic warming. Nat Ecol Evol 8, 500–510 (2024).
    ## 3                                                                                                                                                                                                      <NA>
    ## 4                                                                                                                                                                                                      <NA>
    ##                 CuratedByDOI                            DOI SubmittedBy ContributorEmail
    ## 1 10.1038/s41559-023-02301-8      10.1017/S0950268809002040 Paul Huxley phuxly@gmail.com
    ## 2 10.1038/s41559-023-02301-8 10.1016/j.jinsphys.2015.08.001 Paul Huxley phuxly@gmail.com
    ## 3                       <NA>     10.1038/s42003-022-03030-7 Paul Huxley phuxly@gmail.com
    ## 4                       <NA>   10.1371/journal.pone.0135489 Paul Huxley phuxly@gmail.com

### Missing columns

At some point during the download process, or during later steps, you
may have filtered out some of the citation columns:

``` r
df2 <- search_hub("Aedes aegypti") |>
  filter_db("vt") |>
  head(5) |>
  fetch() |>
  glean(cols = c(
    "DatasetID",
    "Interactor1",
    "OriginalTraitName",
    "OriginalTraitValue"
    ))
head(df2)
```

    ## <ohvbd.data.frame>
    ## Database: vt
    ##   DatasetID   Interactor1 OriginalTraitName OriginalTraitValue
    ## 1       474 Aedes aegypti    fecundity rate               0.00
    ## 2       474 Aedes aegypti    fecundity rate               0.00
    ## 3       474 Aedes aegypti    fecundity rate               0.35
    ## 4       474 Aedes aegypti    fecundity rate               1.12
    ## 5       474 Aedes aegypti    fecundity rate               3.37
    ## 6       474 Aedes aegypti    fecundity rate               3.59

Here we don’t have the citation columns to hand, however because we have
the *“DatasetID”* column intact, `ohvbd` can use this to retrieve the
citations again!

``` r
df2 |> fetch_citations(minimise = TRUE)
```

    ## <ohvbd.data.frame>
    ## Database: vt
    ##                                                                                                                                                                                 Citation
    ## 1                                           Yang et al. 2009. Assessing the effects of temperature on the population of Aedes aegypti the vector of dengue. Epidemiology & Infection 137
    ## 2                                                   Gulia-Nuss et al. 2015. Multiple factors contribute to anautogenous reproduction by the mosquito Aedes aegypti. J Insect Physiol. 82
    ## 3                                         Huxley et al. 2022. Competition and resource depletion shape the thermal response of population fitness in Aedes aegypti. Commun. Biol. 5: 66.
    ## 4 Goindin et al. 2015. Parity and longevity of Aedes aegypti according to temperatures in controlled conditions and consequences on dengue transmission risks. PLoS ONE 10(8): e0135489.
    ##                                                                                                                                                                                           CuratedByCitation
    ## 1 Pawar, S., Huxley, P.J., Smallwood, T.R.C. et al. Variation in temperature of peak trait performance constrains adaptation of arthropod populations to climatic warming. Nat Ecol Evol 8, 500–510 (2024).
    ## 2 Pawar, S., Huxley, P.J., Smallwood, T.R.C. et al. Variation in temperature of peak trait performance constrains adaptation of arthropod populations to climatic warming. Nat Ecol Evol 8, 500–510 (2024).
    ## 3                                                                                                                                                                                                      <NA>
    ## 4                                                                                                                                                                                                      <NA>
    ##                 CuratedByDOI                            DOI SubmittedBy ContributorEmail
    ## 1 10.1038/s41559-023-02301-8      10.1017/S0950268809002040 Paul Huxley phuxly@gmail.com
    ## 2 10.1038/s41559-023-02301-8 10.1016/j.jinsphys.2015.08.001 Paul Huxley phuxly@gmail.com
    ## 3                       <NA>     10.1038/s42003-022-03030-7 Paul Huxley phuxly@gmail.com
    ## 4                       <NA>   10.1371/journal.pone.0135489 Paul Huxley phuxly@gmail.com

### Orphaned data

If you perform certain actions on your dataset (such as saving to and
retrieving from a csv, or some data filtering processes) you may end up
losing the attribute that internally tells `ohvbd` where the data came
from.

For example, let’s take a our `df` dataset and run the select function
from dplyr on it:

``` r
df_filtered <- df |>
  dplyr::select(c(
    "DatasetID",
    "Interactor1",
    "OriginalTraitName",
    "OriginalTraitValue"
    ))
head(df_filtered)
```

    ## <ohvbd.data.frame>
    ## Database: 
    ##   DatasetID   Interactor1 OriginalTraitName OriginalTraitValue
    ## 1       474 Aedes aegypti    fecundity rate               0.00
    ## 2       474 Aedes aegypti    fecundity rate               0.00
    ## 3       474 Aedes aegypti    fecundity rate               0.35
    ## 4       474 Aedes aegypti    fecundity rate               1.12
    ## 5       474 Aedes aegypti    fecundity rate               3.37
    ## 6       474 Aedes aegypti    fecundity rate               3.59

If we inspect the resultant object using the
[`has_db()`](https://ohvbd.vbdhub.org/reference/has_db.md) function, we
can see that it has lost its database marker:

``` r
has_db(df)
```

    ## [1] TRUE

``` r
has_db(df_filtered)
```

    ## [1] FALSE

There are a few ways we can clear this up.

The first option would be to just redownload the specific datasets as
they were downloaded before:

``` r
ohvbd.ids(unique(df_filtered$DatasetID), "vt") |>
  fetch() |>
  glean() |>
  fetch_citations() |>
  head(5)
```

    ## <ohvbd.data.frame>
    ## Database: vt
    ##   DatasetID                                                                                                                                                                               Citation
    ## 1       474                                           Yang et al. 2009. Assessing the effects of temperature on the population of Aedes aegypti the vector of dengue. Epidemiology & Infection 137
    ## 2       475                                           Yang et al. 2009. Assessing the effects of temperature on the population of Aedes aegypti the vector of dengue. Epidemiology & Infection 137
    ## 3       148                                                   Gulia-Nuss et al. 2015. Multiple factors contribute to anautogenous reproduction by the mosquito Aedes aegypti. J Insect Physiol. 82
    ## 4       578                                         Huxley et al. 2022. Competition and resource depletion shape the thermal response of population fitness in Aedes aegypti. Commun. Biol. 5: 66.
    ## 5       126 Goindin et al. 2015. Parity and longevity of Aedes aegypti according to temperatures in controlled conditions and consequences on dengue transmission risks. PLoS ONE 10(8): e0135489.
    ##                                                                                                                                                                                           CuratedByCitation
    ## 1 Pawar, S., Huxley, P.J., Smallwood, T.R.C. et al. Variation in temperature of peak trait performance constrains adaptation of arthropod populations to climatic warming. Nat Ecol Evol 8, 500–510 (2024).
    ## 2 Pawar, S., Huxley, P.J., Smallwood, T.R.C. et al. Variation in temperature of peak trait performance constrains adaptation of arthropod populations to climatic warming. Nat Ecol Evol 8, 500–510 (2024).
    ## 3 Pawar, S., Huxley, P.J., Smallwood, T.R.C. et al. Variation in temperature of peak trait performance constrains adaptation of arthropod populations to climatic warming. Nat Ecol Evol 8, 500–510 (2024).
    ## 4                                                                                                                                                                                                      <NA>
    ## 5                                                                                                                                                                                                      <NA>
    ##                 CuratedByDOI                            DOI SubmittedBy ContributorEmail
    ## 1 10.1038/s41559-023-02301-8      10.1017/S0950268809002040 Paul Huxley phuxly@gmail.com
    ## 2 10.1038/s41559-023-02301-8      10.1017/S0950268809002040 Paul Huxley phuxly@gmail.com
    ## 3 10.1038/s41559-023-02301-8 10.1016/j.jinsphys.2015.08.001 Paul Huxley phuxly@gmail.com
    ## 4                       <NA>     10.1038/s42003-022-03030-7 Paul Huxley phuxly@gmail.com
    ## 5                       <NA>   10.1371/journal.pone.0135489 Paul Huxley phuxly@gmail.com

To make this easier,
[`fetch_citations()`](https://ohvbd.vbdhub.org/reference/fetch_citations.md)
will (grumblingly) accept an `ohvbd.ids` object:

``` r
ohvbd.ids(unique(df_filtered$DatasetID), "vt") |>
  fetch_citations() |>
  head(5)
```

    ## <ohvbd.data.frame>
    ## Database: vt
    ##   DatasetID                                                                                                                                                                               Citation
    ## 1       474                                           Yang et al. 2009. Assessing the effects of temperature on the population of Aedes aegypti the vector of dengue. Epidemiology & Infection 137
    ## 2       475                                           Yang et al. 2009. Assessing the effects of temperature on the population of Aedes aegypti the vector of dengue. Epidemiology & Infection 137
    ## 3       148                                                   Gulia-Nuss et al. 2015. Multiple factors contribute to anautogenous reproduction by the mosquito Aedes aegypti. J Insect Physiol. 82
    ## 4       578                                         Huxley et al. 2022. Competition and resource depletion shape the thermal response of population fitness in Aedes aegypti. Commun. Biol. 5: 66.
    ## 5       126 Goindin et al. 2015. Parity and longevity of Aedes aegypti according to temperatures in controlled conditions and consequences on dengue transmission risks. PLoS ONE 10(8): e0135489.
    ##                                                                                                                                                                                           CuratedByCitation
    ## 1 Pawar, S., Huxley, P.J., Smallwood, T.R.C. et al. Variation in temperature of peak trait performance constrains adaptation of arthropod populations to climatic warming. Nat Ecol Evol 8, 500–510 (2024).
    ## 2 Pawar, S., Huxley, P.J., Smallwood, T.R.C. et al. Variation in temperature of peak trait performance constrains adaptation of arthropod populations to climatic warming. Nat Ecol Evol 8, 500–510 (2024).
    ## 3 Pawar, S., Huxley, P.J., Smallwood, T.R.C. et al. Variation in temperature of peak trait performance constrains adaptation of arthropod populations to climatic warming. Nat Ecol Evol 8, 500–510 (2024).
    ## 4                                                                                                                                                                                                      <NA>
    ## 5                                                                                                                                                                                                      <NA>
    ##                 CuratedByDOI                            DOI SubmittedBy ContributorEmail
    ## 1 10.1038/s41559-023-02301-8      10.1017/S0950268809002040 Paul Huxley phuxly@gmail.com
    ## 2 10.1038/s41559-023-02301-8      10.1017/S0950268809002040 Paul Huxley phuxly@gmail.com
    ## 3 10.1038/s41559-023-02301-8 10.1016/j.jinsphys.2015.08.001 Paul Huxley phuxly@gmail.com
    ## 4                       <NA>     10.1038/s42003-022-03030-7 Paul Huxley phuxly@gmail.com
    ## 5                       <NA>   10.1371/journal.pone.0135489 Paul Huxley phuxly@gmail.com

#### Forcing the db

Alternatively, if you know the dataset is intact and has just lost its
database tag, you can force-apply that tag again using the
[`force_db()`](https://ohvbd.vbdhub.org/reference/force_db.md) function!

``` r
df_filtered |>
  force_db("vt") |>
  fetch_citations() |>
  head(5)
```

    ## <ohvbd.data.frame>
    ## Database: vt
    ##   DatasetID                                                                                                                                                                               Citation
    ## 1       474                                           Yang et al. 2009. Assessing the effects of temperature on the population of Aedes aegypti the vector of dengue. Epidemiology & Infection 137
    ## 2       475                                           Yang et al. 2009. Assessing the effects of temperature on the population of Aedes aegypti the vector of dengue. Epidemiology & Infection 137
    ## 3       148                                                   Gulia-Nuss et al. 2015. Multiple factors contribute to anautogenous reproduction by the mosquito Aedes aegypti. J Insect Physiol. 82
    ## 4       578                                         Huxley et al. 2022. Competition and resource depletion shape the thermal response of population fitness in Aedes aegypti. Commun. Biol. 5: 66.
    ## 5       126 Goindin et al. 2015. Parity and longevity of Aedes aegypti according to temperatures in controlled conditions and consequences on dengue transmission risks. PLoS ONE 10(8): e0135489.
    ##                                                                                                                                                                                           CuratedByCitation
    ## 1 Pawar, S., Huxley, P.J., Smallwood, T.R.C. et al. Variation in temperature of peak trait performance constrains adaptation of arthropod populations to climatic warming. Nat Ecol Evol 8, 500–510 (2024).
    ## 2 Pawar, S., Huxley, P.J., Smallwood, T.R.C. et al. Variation in temperature of peak trait performance constrains adaptation of arthropod populations to climatic warming. Nat Ecol Evol 8, 500–510 (2024).
    ## 3 Pawar, S., Huxley, P.J., Smallwood, T.R.C. et al. Variation in temperature of peak trait performance constrains adaptation of arthropod populations to climatic warming. Nat Ecol Evol 8, 500–510 (2024).
    ## 4                                                                                                                                                                                                      <NA>
    ## 5                                                                                                                                                                                                      <NA>
    ##                 CuratedByDOI                            DOI SubmittedBy ContributorEmail
    ## 1 10.1038/s41559-023-02301-8      10.1017/S0950268809002040 Paul Huxley phuxly@gmail.com
    ## 2 10.1038/s41559-023-02301-8      10.1017/S0950268809002040 Paul Huxley phuxly@gmail.com
    ## 3 10.1038/s41559-023-02301-8 10.1016/j.jinsphys.2015.08.001 Paul Huxley phuxly@gmail.com
    ## 4                       <NA>     10.1038/s42003-022-03030-7 Paul Huxley phuxly@gmail.com
    ## 5                       <NA>   10.1371/journal.pone.0135489 Paul Huxley phuxly@gmail.com

### Missing Dataset IDs

Unfortunately if you also removed the Dataset ID column from your data
at some point, it is very hard to easily retrieve the citations.

As such it is *highly recommended* that you build citation-retrieval
into your initial data download pipeline in some form.

## Retrieving GBIF citations

Currently
[`fetch_citations()`](https://ohvbd.vbdhub.org/reference/fetch_citations.md)
does not directly support GBIF downloads, however `ohvbd` does provide a
tool to help with using the `rgbif` citation retrieval mechanism.

To retrieve a citation from GBIF using rgbif you need to use the output
of `fetch_gibf()`. If you are piping your commands together this can
pose an issue as you need to retrieve the data from the middle of the
pipeline for later use.

This is where the [`tee()`](https://ohvbd.vbdhub.org/reference/tee.md)
command comes in handy.

It allows you intercept and extract the data from the the middle of a
pipeline for later use. In this case let’s extract the output of
[`fetch()`](https://ohvbd.vbdhub.org/reference/fetch.md) into a variable
called “gbif_cite”.

``` r
gbif_data <- search_hub("Ixodes", "gbif") |>
  head(1) |>
  fetch() |>
  tee("gbif_cite") |>
  glean()
```

Now, given that
\`[`fetch_gbif()`](https://ohvbd.vbdhub.org/reference/fetch_gbif.md)
returns a list, depending on the number of datasets returned we have
multiple options on how to proceed.

For a single dataset (which will nearly always be the case) we can just
access the first entry of the list by indexing:

``` r
library(rgbif)

rgbif::gbif_citation(gbif_cite[[1]])
```

    ## $download
    ## [1] "GBIF Occurrence Download https://doi.org/10.15468/dl.6ubuz9 Accessed from R via rgbif (https://github.com/ropensci/rgbif) on 2025-10-27"
    ##
    ## $datasets
    ## list()

Alternatively to deal with multiple datasets, we would have to use
lapply instead to run
[`gbif_citation()`](https://docs.ropensci.org/rgbif/reference/gbif_citation.html)
on every entry:

``` r
lapply(gbif_cite, rgbif::gbif_citation)
```

    ## [[1]]
    ## [[1]]$download
    ## [1] "GBIF Occurrence Download https://doi.org/10.15468/dl.6ubuz9 Accessed from R via rgbif (https://github.com/ropensci/rgbif) on 2025-10-27"
    ##
    ## [[1]]$datasets
    ## list()

Built in 15.3356099s
