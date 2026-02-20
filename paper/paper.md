---
title: 'ohvbd: Finding and Retrieving Vector-Borne Disease Data'
tags:
  - R
  - vector-borne disease
  - data retrieval
authors:
  - name: Francis A. Windram
    orcid: 0000-0002-2129-826X
    corresponding: true
    affiliation: 1 # (Multiple affiliations must be quoted)
  - name: Robert T. Jones
    orcid: 0000-0001-6421-0881 
    affiliation: 2
  - name: Stanislav Modrak
    orcid: 0009-0008-9485-9399
    affiliation: 1
  - name: Samraat Pawar
    orcid: 0000-0001-8375-5684
    affiliation: 1
  - name: William D. Pearse
    orcid: 0000-0002-6241-3164
    affiliation: 1
  - name: Marta S. Shocket
    orcid: 0000-0002-8995-4446
    affiliation: 3
  - name: Steven M. White
    orcid: 0000-0002-3192-9969
    affiliation: 4
  - name: Lauren J. Cator
    orcid: 0000-0002-6627-1490
    affiliation: 1
affiliations:
 - name: Department of Life Sciences, Imperial College London, Silwood Park, Berkshire, UK
   index: 1
   ror: 041kmwe10
 - name: Department of Disease Control, London School of Hygiene & Tropical Medicine, Keppel Street, London WC1E 7HT
   index: 2
   ror: 00a0jsq62
 - name: Lancaster Environment Centre, Lancaster University, Bailrigg, Lancaster, Lancashire, UK
   index: 3
   ror: 04f2nsd36
 - name: UK Centre for Ecology & Hydrology, Benson Lane, Wallingford, Oxfordshire, UK
   index: 4
   ror: 00pggkr55
date: 16 January 2026
bibliography: paper.bib
---

# Summary

Modelling the dynamics and risks of vector-borne diseases requires large volumes of diverse data. These data are often stored in disparate databases that lack programmatic access, leading to complex, time-consuming and error-prone manual data discovery. The `ohvbd` package (alongside its companion web portal, the [One Health VBD Hub](https://vbdhub.org)) provides tools for searching for, retrieving, and filtering data from vector-borne disease databases and other relevant data repositories.

# Statement of need

Worldwide, vector-borne diseases (VBDs) cause over 700,000 human deaths annually [@who_fact_2024] and are a significant veterinary health and economic concern [@day_one_2011; @newbrook_clinical_2025]. Reducing VBD burden is a major international health policy goal, which demands both empirical study and theoretical modelling. Modelling the dynamics and risks of VBDs is a data-hungry process. However, the data required by these models are spread across disparate databases, many of which lack programmatic access. As disease modellers and data generators push toward FAIR (findable, accessible, interoperable, reusable) data [@edmunds_publishing_2022; @wilkinson_fair_2016], it is imperative that data searching and loading are programmable.

`ohvbd` is an R package for searching and downloading data from VBD databases and other related data sources. R is the most widely used statistical programming language in biology and provides a variety of tools for data processing. `ohvbd` was designed to support disease vector data workflows that are compatible with the `tidyverse` [@wickham_welcome_2019]. It leverages recent web request packages, multi-session downloading, and the One Health VBD Hub multi-database search aggregator ([@cator_vbd_2026], \autoref{fig:dataflow}) to provide quick and repeatable access to the VectorByte databases (VecTraits and VecDyn, [@johnson_vectraits_2023; @rund_vecdyn_2023]). Additionally, it provides access to an aggregated climate data store (AREAdata, [@smith_areadata_2022]) to enable rapid association of climatic variables with spatially explicit data, and to the Global Biodiversity Information Facility (GBIF) for vector occurrence mapping (via the `rgbif` package).

![Figure 1: `ohvbd` interfaces with key databases through the vbdhub.org search API. The contents of each database are regularly indexed by vbdhub.org and can be queried on demand via ohvbd. This returns a list of dataset identifiers (IDs) that match the query, which can then be parsed using `ohvbd` and requested from the relevant databases.\label{fig:dataflow}](figures/fig1.svg){ width=90% }

# State of the field

The VectorByte databases (VecTraits and VecDyn) are increasingly being adopted as the standard repositories for vector trait and population dynamics data, and predominantly accessed through a flexible web interface. APIs for these databases are available, and there are R packages to access some of the data (e.g., `BayesTPC`, [@sorek_bayestpc_2025]), but there is no single R package that allows for search and download across these resources. `BayesTPC` provides VecTraits access as a secondary feature rather than its primary purpose (Bayesian fitting of thermal performance curves). As such, extended data access functionality fits better in its own separate package rather than overexpanding the scope of BayesTPC.

`ohvbd` was built out of a need to interface with these databases and associate them with climate data during modelling research. We designed `ohvbd` to be intuitive for users familiar with the “piped” approach to API design common in R [@wickham_welcome_2019], and to provide user-friendly messaging and error handling throughout use. It is intended to minimise repeated data downloading by caching invariant data and using dedicated metadata endpoints. It can also speed up data download through the use of parallel and batched downloads. The package provides a unified search interface (via the vbdhub.org API, [@cator_vbd_2026]) to discover data across a variety of data platforms (\autoref{fig:dataflow}), and allows for easy association of climatic variables to spatial data through integration with the AREAdata aggregation project [@smith_areadata_2022].


# Software design

The design and implementation of `ohvbd` is based on several key tenets:

1. Usage should be intuitive, informative, and quick.
2. Users should need to remember the fewest functions possible.
3. Data should not be downloaded more than necessary.
4. All major actions should be scriptable and repeatable.

In R, many packages employ a “piped” approach, where the output of one function can be transferred to the first argument of another through the pipe operator (`|>`). `ohvbd` makes use of this design pattern, alongside the S3 method dispatch system, to allow for simple pipelines to be concisely defined. For example, a data download pipeline in `ohvbd` to retrieve all data on the castor bean tick (_Ixodes ricinus_) from the VecTraits database is as follows:

``` r
search_hub("Ixodes ricinus", db = "vt") |>
  fetch() |>
  glean()
```

To switch to searching the VecDyn database, all that needs to be changed in a script is the `db =` argument. The `fetch()` and `glean()` functions are generic, and infer the required downloader and extractor from the internal metadata of the original search. The underlying download and extraction methods for a given database detect and reject data from incompatible databases, reducing the risk of accidentally downloading incorrect data.

Similarly, merging spatially explicit data (here represented by the variable `latlong`) with two days of temperature data requires only a few extra commands:

``` r
addata <- fetch_ad("temp", gid = 0)
assoc_ad(latlong, addata, targetdate = "2022-08-04", enddate = "2022-08-06")
```

Data from VectorByte-related databases are requested using multiple (up to 8) simultaneous http connections, reducing the download time for exceptionally large datasets significantly. Downloads from GBIF use a rewritten version of the `occ_wait()` function from `rgbif` which provides additional information to the user upon download. All data that are expected to remain predominantly unchanged are timestamped and cached after the initial download, speeding up iterative workflows where the same data is requested multiple times.

Messages are provided by `ohvbd` through the `cli` and `rlang` packages to ensure they are formatted and coloured where necessary, making it as easy as possible for users to detect errors and modify their code accordingly.

`ohvbd` also contains several small tools that are helpful both while using the package and in other contexts. For example, the `tee()` function provides a method to extract data from the middle of any larger tidyverse-style pipeline, enabling users to inspect and debug pipelines without having to rewrite significant chunks of code temporarily. The `match_countries()` and `match_species()` functions enable users to quickly match country names and species names (respectively) to ground-truth data provided by GBIF [@gbif_the_global_biodiversity_information_facility_what_2026] and Natural Earth [@massicotte_rnaturalearth_2017].

## Citation retrieval

Often, data can lose its associated citations during data analysis. This can make it hard or impossible to cite data generators appropriately. `ohvbd` uses a combination of automated metadata retrieval and coding guardrails to ensure that citations can be rediscovered using the minimum possible source data. Citation columns are automatically added to data filtering operations within `ohvbd`, and provenance data is kept within attributes of internal data structures to ensure that citations can be retrieved when required.

## Tradeoffs and choices

A common issue during R package development is namespace collision: where two functions from different packages share the same name or generic. During the testing of early versions of `ohvbd`, the `glean()` family of functions was originally named `extract()`. This sometimes led to significant issues when other packages were loaded after `ohvbd`. The extract generic function could be overloaded by various packages (particularly `tidyr`, a commonly used data manipulation package), which led to major parts of `ohvbd` becoming nonfunctional. Given that it is not possible (or desirable) to control the order in which a user loads a package, we chose to rename the function to an alternative: `glean()`.

Similarly, when piping between functions it is hard to know the class and state of the data being passed. Ideally a user should not need to worry about this, but sometimes reasonable pipelines can be internally incompatible. For example, if a user retrieves data from only one database using `search_hub()` it returns the same object as a direct search to that database, rather than a hub search result that can contain multiple databases. During testing, if the user then passed this result to `filter_db()`, it caused an error as you should never need to filter a set of ids from only one database. To the user, however, filtering a set of data with only one database to contain only the results from that same database should simply leave the object unchanged. This difference between the mental model of the user and the internal data structures meant that we modified the function to add a warning that they were doing an unnecessary procedure, while also passing the data through as expected. Generally speaking, in situations such as these, we prioritise providing feedback to train users naturally on how to use the package more efficiently, while also predicting and accommodating their expected outcomes.

# Research impact statement

Since its initial development releases, `ohvbd` has been used both in retrieving data for research projects at UK universities, and for bespoke training provided by the One Health VBD Hub. This exposure to the wider research community led to multiple changes to the early internal API, and to increased hardening and sanity-checking throughout the package.

In the future, research that aims to interface with any of the supported databases can leverage the programmatic nature of `ohvbd` to minimise the risk of manual-input errors and increase reproducibility at the data-searching and retrieval stage of modelling tasks.

# AI usage disclosure

No generative AI tools were used in the development of this software, the writing of this manuscript, or the preparation of supporting materials.


<!--
# Figures

Figures can be included like this:
![Caption for example figure.\label{fig:example}](figure.png)
and referenced from text using \autoref{fig:example}.

Figure sizes can be customized by adding an optional second parameter:
![Caption for example figure.](figure.png){ width=20% }
-->

# Acknowledgements

We would like to acknowledge the other members of the One Health VBD Hub team (Sarah Kelly, Marion England, Hannah Vineer, & Christopher Sanders) for their feedback on both the paper and package, the steering committee (Helen Roberts, Simon Smith, Jolyon Medlock, Samuel Rund, George Christophides, Frederik Seelig, & Marieta Braks), the One Health Approaches to Vector-Borne Disease Research Consortia and the wider One Health VBD Hub community for their input, advice, and testing throughout the development of ohvbd. Finally, we would like to recognise the funding provided by BBSRC and Defra (BB/Y008766/1).

# Data availability statement

No new data were created during the development of this package. All code is available at https://www.github.com/fwimp/ohvbd.

# References
