# Retrieving data from VectorByte

## Introduction

The ohvbd package allows you to retrieve data from many different
databases directly.

Currently these databases include the
[VecTraits](https://vectorbyte.crc.nd.edu/vectraits-explorer) and
[VecDyn](https://vectorbyte.crc.nd.edu/vecdyn-datasets) projects from
[VectorByte](https://www.vectorbyte.org/), and [GBIF](https://gbif.org).

Let’s imagine you wanted to figure out where there is trait data for a
particular vector species - *Aedes aegypti*, for example. Here’s how
you’d use `ohvbd` to do that:

``` r
df <- search_hub("Aedes aegypti", "vt") |>
  fetch() |>
  glean(
    cols = c("Interactor1Genus", "Interactor1Species", "Latitude", "Longitude"),
    returnunique = TRUE
  )
df
```

Great, lovely. But now… what does that all mean? And how can you build
up your own data request? Read on to find out…

## A note before we begin

For users who are familiar with base R pipes (`|>`), this approach is
generally usable in ohvbd as well.

For users who are not familiar, pipes take the output of one command and
feed it forward to the next command as the first argument:

``` r
# Find mean of a vector normally
x <- c(1, 2, 3)
mean(x)
```

    ## [1] 2

``` r
# Find mean of a vector using pipes
c(1, 2, 3) |> mean()
```

    ## [1] 2

For the rest of this vignette we will be using a piped-style approach.

## Finding IDs

Datasets in VecTraits and VecDyn, and GBIF are organised by id.

You can search for ids related to a particular query using the
`vbdhub.org` (aka “the hub”) search functionality via
[`search_hub()`](https://ohvbd.vbdhub.org/reference/search_hub.md).

In this case let’s search the hub for *Aedes aegypti*, the “Yellow Fever
mosquito”:

``` r
library(ohvbd)
aedes_results <- search_hub("Aedes aegypti")
summary(aedes_results)
```

    ## Rows: 145, Query: Aedes aegypti
    ## 
    ## Split by database:
    ## gbif   px   vd   vt 
    ##   20   44   10   71

You can see here there are 20 GBIF datasets, 10 VecDyn datasets, and 71
VecTraits datasets.

However right now we only have the ids of the data, not the data
themselves. In order to get that, we must fetch the data from a given
database.

## Filtering dbs

Before fetching data, we must extract only the ids relevant to our
database from our search.

> GBIF, VecTraits, and VecDyn do not have unified ids between datasets,
> so if you attempted to get VT ids from another database you would (at
> best) get garbage.

Filtering database results from searches can be performed using the
[`filter_db()`](https://ohvbd.vbdhub.org/reference/filter_db.md)
command:

``` r
aedes_vt <- filter_db(aedes_results, "vt")
aedes_vt
```

    ## <ohvbd.ids>
    ## Database: vt
    ##  [1]  474  475  148  578  556  126  142  144  285  287  169  580  577  865  863
    ## [16]  357  149  476  473  573  576  565  555  841  842  356  146  864  170  214
    ## [31]  579  359  355  143  147  564  574  575  124  125  346  553  554  354  853
    ## [46]  286  825  826  901  145  906  892  893  358  854  855  911  860  828  910
    ## [61]  572  557  558  571 1506 1510 1511 1512 1507 1508 1509

If you only searched the hub for one database, by default
[`search_hub()`](https://ohvbd.vbdhub.org/reference/search_hub.md) will
automatically perform the
[`filter_db()`](https://ohvbd.vbdhub.org/reference/filter_db.md)
operation for you!

``` r
search_hub("Aedes aegypti", db = "vt")
```

    ## <ohvbd.ids>
    ## Database: vt
    ##  [1]  474  475  148  578  556  126  142  144  285  287  169  580  577  865  863
    ## [16]  357  149  476  473  573  576  565  555  841  842  356  146  864  170  214
    ## [31]  579  359  355  143  147  564  574  575  124  125  346  553  554  354  853
    ## [46]  286  825  826  901  145  906  892  893  358  854  855  911  860  828  910
    ## [61]  572  557  558  571 1506 1510 1511 1512 1507 1508 1509

## Getting data

Now you have a vector of datasets from vectraits, we need to actually
retrieve the data of these datasets through the API.

To do this we can use the
[`fetch()`](https://ohvbd.vbdhub.org/reference/fetch.md) function. In
this case let’s get the first 5 *Aedes aegypti* datasets:

``` r
aedes_vt <- aedes_vt |> head(5)
aedes_responses <- aedes_vt |> fetch()
aedes_responses[[1]]
```

    ## <httr2_response>
    ## GET https://vectorbyte.crc.nd.edu/portal/api/vectraits-dataset/474/?format=json
    ## Status: 200 OK
    ## Content-Type: application/json
    ## Body: In memory (52292 bytes)

The [`fetch()`](https://ohvbd.vbdhub.org/reference/fetch.md) function
returns a list of the data in the form of the original `httr2`
responses. These are useful if you want to know specifics about how the
server sent data back, but for most usecases it is more useful to
extract the data into a dataframe.

### Specific fetch functions

[`fetch()`](https://ohvbd.vbdhub.org/reference/fetch.md) retrieves data
from the appropriate database for your data. Under the hood it farms out
this work to the `fetch_x()` series of functions.

You can use these yourself for extra piece of mind, though we do not
really recommend it.

So the above code could also be written as:

``` r
aedes_responses <- aedes_vt |> fetch_vt()
```

## Extracting data

Now we have a list of responses, we can extract the relevant data from
them using the [`glean()`](https://ohvbd.vbdhub.org/reference/glean.md)
function.

``` r
aedes_data <- aedes_responses |> glean()
cat("Data dimensions: ", ncol(aedes_data), " cols x ", nrow(aedes_data), " rows")
```

    ## Data dimensions:  157  cols x  874  rows

This dataset is a bit too large to print here, and often you may only
want a few columns of data rather than the whole dataset.

Fortunately the `cols` argument allows us to filter this data out
easily. We can also use the argument `returnunique` to instruct ohvbd to
return only unique rows.

So let’s get just the unique locations and trait name combinations from
our data using the same command as before:

``` r
aedes_data_filtered <- aedes_responses |>
  glean(
    cols = c("Location", "OriginalTraitName"),
    returnunique = TRUE
  )
aedes_data_filtered
```

    ## <ohvbd.data.frame>
    ## Database: vt
    ##   DatasetID                      Location OriginalTraitName
    ## 1       474                Marilia Brazil    fecundity rate
    ## 2       475                Marilia Brazil         longevity
    ## 3       148      Unversity of Georgia USA  glycogen content
    ## 4       578            Fort Myers Florida  development time
    ## 5       556 Guadeloupe French West Indies gonotrophic cycle

### Specific glean functions

Like [`fetch()`](https://ohvbd.vbdhub.org/reference/fetch.md),
[`glean()`](https://ohvbd.vbdhub.org/reference/glean.md) has
database-specific variants:

``` r
aedes_data <- aedes_responses |> glean_vt()
```

## Putting it all together

In day-to-day use, you will mostly find yourself using all these
functions together to create small pipelines.

A typical pipeline would likely only contain a few lines of code:

``` r
df <- search_hub("Aedes aegypti") |>
  filter_db("vt") |>
  head(5) |>
  fetch() |>
  glean(
    cols = c("Interactor1Genus", "Interactor1Species", "Latitude", "Longitude"),
    returnunique = TRUE
  )
head(df)
```

    ## <ohvbd.data.frame>
    ## Database: vt
    ##   DatasetID Interactor1Genus Interactor1Species  Latitude Longitude
    ## 1       474            Aedes            aegypti -22.21389 -49.94583
    ## 2       475            Aedes            aegypti -22.21389 -49.94583
    ## 3       148            Aedes            aegypti        NA        NA
    ## 4       578            Aedes            aegypti  26.61667 -81.83333
    ## 5       556            Aedes            aegypti  16.25000 -61.58333

A similar pipeline taking advantage of the autofiltering in
[`search_hub()`](https://ohvbd.vbdhub.org/reference/search_hub.md) might
look like this:

``` r
df <- search_hub("Aedes aegypti", db = "vt") |>
  head(5) |>
  fetch() |>
  glean(
    cols = c("Interactor1Genus", "Interactor1Species", "Latitude", "Longitude"),
    returnunique = TRUE
  )
```

## Smart searching of VectorByte databases

One subtlety of VectorByte (in particular) is to do with field
collisions.

Let’s imagine that we are looking for traits of whitefly species
(*Bemisia*). We can just construct a query to investigate this as
follows:

``` r
df <- search_hub("Bemisia", "vt") |>
  head(6) |>
  fetch() |>
  glean(
    cols = c(
      "DatasetID",
      "Interactor1Genus",
      "Interactor1Species",
      "Interactor2Genus",
      "Interactor2Species"
      )
    )
```

Now we would expect this to be traits of *Bemisia* spp, however when we
look at the `Interactor1Genus` column we see something a touch odd:

``` r
unique(df$Interactor1Genus)
```

    ## [1] "Axinoscymnus" "Bemisia"

*Axinoscymnus* is a ladybird, but why is it appearing? Let’s look at
only rows containing *Axinoscymnus*:

``` r
df |> dplyr::filter(Interactor1Genus == "Axinoscymnus") |> head()
```

    ## <ohvbd.data.frame>
    ## Database: vt
    ##   DatasetID Interactor1Genus Interactor1Species Interactor2Genus
    ## 1       160     Axinoscymnus         cardilobus          Bemisia
    ## 2       160     Axinoscymnus         cardilobus          Bemisia
    ## 3       160     Axinoscymnus         cardilobus          Bemisia
    ## 4       160     Axinoscymnus         cardilobus          Bemisia
    ## 5       160     Axinoscymnus         cardilobus          Bemisia
    ## 6       160     Axinoscymnus         cardilobus          Bemisia
    ##   Interactor2Species
    ## 1             tabaci
    ## 2             tabaci
    ## 3             tabaci
    ## 4             tabaci
    ## 5             tabaci
    ## 6             tabaci

In this scenario, *Bemisia* is present in the dataset, but it is as the
“target” rather than the animal that the trait is referring to.

As such we might want to be more specific about precisely which data to
retrieve. Enter the `search_x_smart()` family of functions.

These allow you to construct a more specific search.

So let’s construct the same search as we were wanting to do before, but
with the smart search.

``` r
df <- search_vt_smart("Interactor1Genus", "contains", "Bemisia") |>
  head(6) |>
  fetch() |>
  glean(
    cols = c(
      "DatasetID",
      "Interactor1Genus",
      "Interactor1Species",
      "Interactor2Genus",
      "Interactor2Species"
      )
    )
unique(df$Interactor1Genus)
```

    ## [1] "Bemisia"

Here we have made sure to only search the `Interactor1Genus` column. As
such we have only gotten back *Bemisia* traits!

This same sort of collision is particularly common in the “Citation”
column, where papers may mention multiple trait names.

The `search_x_smart()` functions have many different operators and
columns that they can work upon. For full details, run
[`?search_vt_smart`](https://ohvbd.vbdhub.org/reference/search_vt_smart.md)
or
[`?search_vd_smart`](https://ohvbd.vbdhub.org/reference/search_vd_smart.md)
in your console.

In general it is always worthwhile inspecting the data you retrieve to
make sure that your query returned the data that you thought it did.

## Futher steps

From here you now have all the data you might need for further analysis,
so now it’s down to you!

One final note to end on: it can be advisable to save any output data in
a csv or parquet format so that you do not need to re-download it every
time you run your script. This is as easy as running
[`write.csv()`](https://rdrr.io/r/utils/write.table.html) on your
dataframe, then reading it in later with
[`read.csv()`](https://rdrr.io/r/utils/read.table.html)

Built in 5.1081655s
