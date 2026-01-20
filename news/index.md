# Changelog

## ohvbd (development version)

**Major API change**

- `extract_` functions are now `glean_`.
  - This means that if `tidyverse` is loaded after `ohvbd`, there are no
    direct namespace collisions.

Full list of function name changes:

- [`extract()`](https://ohvbd.vbdhub.org/reference/extract.md) -\>
  [`glean()`](https://ohvbd.vbdhub.org/reference/glean.md)
- `extract_ad()` -\>
  [`glean_ad()`](https://ohvbd.vbdhub.org/reference/glean_ad.md)
- `extract_gbif()` -\>
  [`glean_gbif()`](https://ohvbd.vbdhub.org/reference/glean_gbif.md)
- `extract_vd()` -\>
  [`glean_vd()`](https://ohvbd.vbdhub.org/reference/glean_vd.md)
- `extract_vt()` -\>
  [`glean_vt()`](https://ohvbd.vbdhub.org/reference/glean_vt.md)
- `fetch_extract_vd_chunked()` -\>
  [`fetch_glean_vd_chunked()`](https://ohvbd.vbdhub.org/reference/fetch_glean_vd_chunked.md)
- `fetch_extract_vt_chunked()` -\>
  [`fetch_glean_vt_chunked()`](https://ohvbd.vbdhub.org/reference/fetch_glean_vt_chunked.md)

New functions & arguments:

- `ohvbd` now interfaces with GBIF for occurrence data.
  - New `*_gbif` functions
    (e.g. [`fetch_gbif()`](https://ohvbd.vbdhub.org/reference/fetch_gbif.md))
    allow for retrieving and extracting data from GBIF.
  - A GBIF account and the `rgbif` package are required to retrieve data
    from GBIF.
  - The account details must also be set up as shown in [the rgbif
    documentation](https://docs.ropensci.org/rgbif/articles/gbif_credentials.html).
- New [`tee()`](https://ohvbd.vbdhub.org/reference/tee.md) command
  allows one to extract data from the middle of a pipeline and save it
  to an environment.
  - This is definitely not only useful for `ohvbd` workflows, and can be
    used in any base R pipeline (`|>`). It has not been tested in
    magrittr pipelines but should work as-is.
- New [`filter_db()`](https://ohvbd.vbdhub.org/reference/filter_db.md)
  command allows for filtering out of only one database’s results from
  hub searches.
- [`check_db_status()`](https://ohvbd.vbdhub.org/reference/check_db_status.md)
  now returns (invisibly) whether all databases are up or not.
- New `fetch_citation()` and `fetch_citation_*` commands provide an
  interface to attempt to retrieve citations from a vectorbyte dataset.
  - This will (by default) possibly redownload parts or all of the data
    if the columns are not currently present.
- New [`force_db()`](https://ohvbd.vbdhub.org/reference/force_db.md)
  function enables one to force `ohvbd` to consider a particular object
  as having a particular provenance.
- New `simplify` argument to
  [`search_hub()`](https://ohvbd.vbdhub.org/reference/search_hub.md)
  makes hub searches return an `ohvbd.ids` object if only one database
  was searched for. This behaviour is on by default.
  - To match this,
    [`filter_db()`](https://ohvbd.vbdhub.org/reference/filter_db.md)
    will now transparently return `ohvbd.ids` objects if it gets them.
- New `taxonomy` argument to
  [`search_hub()`](https://ohvbd.vbdhub.org/reference/search_hub.md)
  allows for filtering searches by GBIF backbone IDs.
- New
  [`match_species()`](https://ohvbd.vbdhub.org/reference/match_species.md)
  function allows for quick and flexible matching of species names to
  their GBIF backbone IDs.
- New `match_country()` function allows for matching of country names to
  WKT polygons via naturalearth.
- New [`ohvbd_db()`](https://ohvbd.vbdhub.org/reference/ohvbd_db.md),
  [`has_db()`](https://ohvbd.vbdhub.org/reference/has_db.md), and
  [`is_from()`](https://ohvbd.vbdhub.org/reference/is_from.md) functions
  allow for quick testing of object provenance (according to `ohvbd`).
- New
  [`get_default_ohvbd_cache()`](https://ohvbd.vbdhub.org/reference/get_default_ohvbd_cache.md)
  function allows for custom functions that interface with cached
  `ohvbd` data files.
- New
  [`list_ohvbd_cache()`](https://ohvbd.vbdhub.org/reference/list_ohvbd_cache.md)
  and
  [`clean_ohvbd_cache()`](https://ohvbd.vbdhub.org/reference/clean_ohvbd_cache.md)
  functions enable better interactive cache management.
  - As a result,
    [`clean_ad_cache()`](https://ohvbd.vbdhub.org/reference/clean_ad_cache.md)
    has been removed as it is now unnecessary.
- `search_x_smart()` functions can now take `"tags"` as a search field,
  enabling support for tagged datasets.

Other:

- Entire code base is now continuously formatted using Air v0.7.1.
- Examples are no longer wrapped in `\dontrun{}` so they should be
  runnable from an installed version of the package.
- A good chunk of the functional logic of `ohvbd` is now covered with
  unit tests (using the `vcr` package).
- [`fetch_vd()`](https://ohvbd.vbdhub.org/reference/fetch_vd.md) no
  longer tries to retrieve ids with no pages of data.
- Functions that interface with vectorbyte databases no longer recommend
  using
  [`set_ohvbd_compat()`](https://ohvbd.vbdhub.org/reference/set_ohvbd_compat.md)
  as *unexpected* SSL errors **should** break pipelines by default.
  - These errors are no longer *expected* to occur when interfacing with
    vectorbyte.
- Running [`fetch()`](https://ohvbd.vbdhub.org/reference/fetch.md) on an
  `ohvbd.hub.search` or
  [`glean()`](https://ohvbd.vbdhub.org/reference/glean.md) on an
  `ohvbd.ids` object now provides a hint that you may have forgotten
  something.
  - Occasionally users would use forget a
    [`fetch()`](https://ohvbd.vbdhub.org/reference/fetch.md) command and
    run `search_hub() |> glean()` which didn’t previously give an
    interpretable error.
- Vignettes now use `vcr` to massively reduce their build time. This
  should only matter to developers of `ohvbd`, or users who download
  from github and build the vignettes themselves.
- [`ohvbd.ids()`](https://ohvbd.vbdhub.org/reference/ohvbd.ids.md) now
  warns you and fixes the problem if you provide ids with duplicate
  values.
- [`glean_vt()`](https://ohvbd.vbdhub.org/reference/glean_vt.md) and
  [`glean_vd()`](https://ohvbd.vbdhub.org/reference/glean_vd.md) now
  force the inclusion of the dataset ID when filtering columns (using
  the `cols` argument).
  - This is intended to encourage you to preserve at least one means of
    retrieving citation data later.
- WKT parsing and formatting is now significantly more robust.
- Cached AREAData now includes the cache timestamp as an attribute
  rather than a separate variable in the cache file.
- [`glean_ad()`](https://ohvbd.vbdhub.org/reference/glean_ad.md) now
  correctly returns a matrix even when there is only 1 row or column.
- gadm spatial files are now cached as GeoPackage rather than
  [shapefiles](http://switchfromshapefile.org/), leading to a \>50%
  speedup in loading! (Thanks to
  [@josiah.rs](https://bsky.app/profile/josiah.rs) on bluesky for the
  suggestion!)
- [`fetch_vd_counts()`](https://ohvbd.vbdhub.org/reference/fetch_vd_counts.md)
  is now significantly faster, more robust, and temporarily caches data.
  - You will see particular improvements if you are trying to retrieve
    more than about 10 ids in one go or if you are repeatedly running
    the same download code in the same day.
  - This speedup also applies to
    [`fetch_vd()`](https://ohvbd.vbdhub.org/reference/fetch_vd.md) under
    the hood, particularly if you are running it multiple times in a
    day.
- Explicit term checking (such as in
  [`fetch_ad()`](https://ohvbd.vbdhub.org/reference/fetch_ad.md) for
  metrics and
  [`search_vt_smart()`](https://ohvbd.vbdhub.org/reference/search_vt_smart.md)
  for operators and fields) is now fuzzy, allowing for a small amount of
  deviation from the actual term name.
- [`assoc_ad()`](https://ohvbd.vbdhub.org/reference/assoc_ad.md) now
  tries to guess LatLong column names if none (or the wrong ones) are
  provided.
- Errors in internal functions now make it more clear which user-facing
  functions they originate from.

## ohvbd 0.6.1

- New [`search_hub()`](https://ohvbd.vbdhub.org/reference/search_hub.md)
  function enables searching across multiple databases at once via
  [vbdhub](https://vbdhub.org).
  - This includes new functionality for specifying searches using
    spatial extent polygons and generally more intelligent search
    behaviour.
- New function
  [`generate_vt_template()`](https://ohvbd.vbdhub.org/reference/generate_vt_template.md)
  which quickly generates a VecTraits template for later upload.

## ohvbd 0.6.0

- Internally `ohvbd` now only uses base R pipes (`|>`).
- The magrittr pipe (`%>%`) is no longer used internally, nor is it
  exported for use.
- `httr2` v1.1.1 deprecated the `pool` argument of
  `req_perform_parallel()` which broke
  [`fetch()`](https://ohvbd.vbdhub.org/reference/fetch.md) commands
  across `ohvbd`.
  - These have now been rewritten using the new `max_active` argument,
    which does simplify everything a bit.
  - This change does bump the required version of `httr2` to be v1.1.1.

## ohvbd 0.5.2

- [`fetch_ad()`](https://ohvbd.vbdhub.org/reference/fetch_ad.md) now
  searches for and retrieves the most up-to-date GID2 files from
  AREAdata.
- New `timeout` parameter of
  [`fetch_ad()`](https://ohvbd.vbdhub.org/reference/fetch_ad.md) to
  control timeouts of AD downloads. Defaults to 4 minutes.
- [`assoc_ad()`](https://ohvbd.vbdhub.org/reference/assoc_ad.md) now
  correctly extracts data (this functionality regressed in 0.5.0 as a
  consequence of the new dynamic method dispatch approach to data
  retrieval).
- [`assoc_ad()`](https://ohvbd.vbdhub.org/reference/assoc_ad.md) also
  gives now consistent output even when a 1-dimensional output is
  returned from `extract_ad()`
- All `fetch_` functions now have a default `connections` argument of 2,
  leading to faster retrieval across the board.
- `check_src` argument has been removed from all functions. It no longer
  serves much of a purpose due to the sanity checking changes
  implemented in 0.5.0.

## ohvbd 0.5.1

- [`fetch_vd()`](https://ohvbd.vbdhub.org/reference/fetch_vd.md) now
  correctly returns all data from datasets over 50 rows.
- [`fetch_vd()`](https://ohvbd.vbdhub.org/reference/fetch_vd.md) also
  now tells you how much data you are retrieving and a *coarse* estimate
  of how long this will take.
- New function
  [`fetch_vd_counts()`](https://ohvbd.vbdhub.org/reference/fetch_vd_counts.md)
  allows for quick checking of dataset sizes. This is very important as
  some datasets in VecDyn are over 40,000 rows long!
- All `fetch_` functions (and thus also
  [`fetch()`](https://ohvbd.vbdhub.org/reference/fetch.md)) now use
  parallel data retrieval, even when only 1 connection is used. This
  seems to lead to a 20% gain in download speed for no cost.

## ohvbd 0.5.0

### **Major API change**

- `get_` functions have been split into two new types of function, based
  upon exact usage.
  - `find_` functions retrieve metadata such as column definitions and
    ids.
  - `fetch_` functions retrieve actual datasets.
- New set of S3 classes (`ohvbd.ids`, `ohvbd.responses`,
  `ohvbd.data.frame`, `ohvbd.ad.matrix`) to allow for nicer checks of
  data integrity.
  - This has the side effect of no longer falsely triggering the data
    continuity checks of `fetch_` functions when indexing the output of
    `find_x_ids()` functions.
- New convenience functions
  [`fetch()`](https://ohvbd.vbdhub.org/reference/fetch.md) and
  [`extract()`](https://ohvbd.vbdhub.org/reference/extract.md) leverage
  dynamic method dispatch along with the above classes to infer the
  correct underlying `fetch_` and `extract_` functions to use.
  - As such you can now write code such as
    `find_vt_ids() |> fetch() |> extract()` without having to remember
    the correct extractor to use.
  - You can still use the specific extractor functions as before should
    you desire.
- All major functions interfacing with AD, VD, and VT output one of
  these classes.
- Cached data from AD now contains an attribute to signify that it is
  cached.
- New classes are subclassed from other base R classes, and so mostly
  behave in the same way (i.e. you can subset an `ohvbd.data.frame` in
  the same way as just subsetting a normal df).
- New function
  [`ohvbd.ids()`](https://ohvbd.vbdhub.org/reference/ohvbd.ids.md)
  allows users to create objects of the same S3 class as output by the
  `find_` and `search_` functions.
- New [`is_cached()`](https://ohvbd.vbdhub.org/reference/is_cached.md)
  function enables a simple check to see if an object has been loaded
  from the cache by `ohvbd`.

### Full list of function name changes:

- `get_ad()` -\>
  [`fetch_ad()`](https://ohvbd.vbdhub.org/reference/fetch_ad.md)
- `get_extract_vd_chunked()` -\> `fetch_extract_vd_chunked()`
- `get_extract_vt_chunked()` -\> `fetch_extract_vt_chunked()`
- `get_gadm_sfs()` -\>
  [`fetch_gadm_sfs()`](https://ohvbd.vbdhub.org/reference/fetch_gadm_sfs.md)
- `get_vd()` -\>
  [`fetch_vd()`](https://ohvbd.vbdhub.org/reference/fetch_vd.md)
- `get_vt()` -\>
  [`fetch_vt()`](https://ohvbd.vbdhub.org/reference/fetch_vt.md)
- `get_vd_columns()` -\>
  [`find_vd_columns()`](https://ohvbd.vbdhub.org/reference/find_vd_columns.md)
- `get_vd_current_ids()` -\>
  [`find_vd_ids()`](https://ohvbd.vbdhub.org/reference/find_vd_ids.md)
- `get_vt_current_ids()` -\>
  [`find_vt_ids()`](https://ohvbd.vbdhub.org/reference/find_vt_ids.md)

## ohvbd 0.4.4

- New function
  [`check_ohvbd_config()`](https://ohvbd.vbdhub.org/reference/check_ohvbd_config.md)
  allows easy printing of the current status of ohvbd’s options.
- New
  [`clean_ad_cache()`](https://ohvbd.vbdhub.org/reference/clean_ad_cache.md)
  function enables users to clean their cached AREAdata files easily.
- Build timings now appear in all vignettes.
- Cli outputs are now suppressed when running vignettes in
  non-interactive mode (e.g. while knitting).
- Default cache path is now in the user directory (obtained from
  [`tools::R_user_dir()`](https://rdrr.io/r/tools/userdir.html)).
- `use-areadata` vignette now has part of its content complete.
- Generally this update is setting the stage for another major API
  overhaul in 0.5.0.

## ohvbd 0.4.3

- Large changes to all vb `get_` and `search_` function error handling
- All of these functions now check automatically for SSL issues, and
  recommend
  [`set_ohvbd_compat()`](https://ohvbd.vbdhub.org/reference/set_ohvbd_compat.md)
  if these are detected.
- All `get_` calls requesting more than 10 ids run a pre-flight ssl
  check before attempting the whole thing.
- `get_vd()` and `get_vt()` now also return a list of ids that were
  missing and any curl errors that were found in the process of trying
  to get data.

## ohvbd 0.4.2

- [`set_ohvbd_compat()`](https://ohvbd.vbdhub.org/reference/set_ohvbd_compat.md)
  now asks for user confirmation in interactive mode. This makes running
  on linux a little annoying, but is worth it due to the seriousness of
  disabling SSL identity verification.
- This is not asked if the R session is running in batch mode, under
  knittr, or under testthat.
- `retrieving-data` vignette now only enables compatibility mode if
  running under linux. Generally it is best to keep package usage of
  [`set_ohvbd_compat()`](https://ohvbd.vbdhub.org/reference/set_ohvbd_compat.md)
  to an *absolute minimum*.
- Copyright holder now listed in DESCRIPTION

## ohvbd 0.4.1

- New parallel downloading options for `get_x()` and `get_extract_x()`
  functions.
- These are to be used with caution, as they put significantly more load
  on the server than a sequential run would.
- New argument `check_src` allows for toggling of id-sanity checking for
  most functions.
- `retrieving-data` vignette now contains instructions for the use of
  `search_x_smart()`.

## ohvbd 0.4.0

### **Major API change**

- Major simplification of function names!
- `get_x_byid()` -\> `get_x()`
- `extract_x_data()` -\> `extract_x()`
- `assoc_x_y()` -\> `assoc_x()`
- `get_extract_x_byid_chunked()` -\> `get_extract_x_chunked()`
- This breaks ALL PREVIOUS CODE!
- Naming now follows a logical scheme of `verb_target_modifier()`.
- For example `get_x_y()` functions always retrieve data from database
  `x` with `y` specifying any special type of data.
- Similarly `extract_x()` functions always extract data.
- If a function does multiple things, it may get multiple verbs
  separated by underscores, e.g. `get_extract_x_chunked()`
- Pipelines now internally attempt to confirm data integrity by checking
  that the correct functions are piped together.
- This means it is no longer easy to accidentally do something like
  `get_vd_current_ids() |> get_vt()`.

## ohvbd 0.3.1

- New function
  [`format_time_overlap_bar()`](https://ohvbd.vbdhub.org/reference/format_time_overlap_bar.md)
  allows for visually formatting a range of dates combined with another
  set of target dates to see where overlaps do or do not take place.
- This is mostly used in the error handling of `extract_ad()` however it
  can also be used independently. It was designed to fill a more general
  role within UI design using the cli package, and should be usable (or
  hackable) by others needing the same tool.
- `extract_ad()` now errors when all `targetdate` entries are outside of
  the range of the AREAdata dataset.
- New [`assoc_ad()`](https://ohvbd.vbdhub.org/reference/assoc_ad.md)
  associates arbitrary data including lon/lat columns with AREAdata.
- New `get_vd_columns()` provides quick reference about the currently
  present VecDyn columns. *(This is currently not possible for
  VecTraits, but the feasibility is being investigated.)*
- New [`assoc_gadm()`](https://ohvbd.vbdhub.org/reference/assoc_gadm.md)
  function associates gadm ids at all spatial scales with arbitrary data
  that include lon/lat columns.
- Documentation now correctly displays favicons.
- Logo now rotates through a variety of colourschemes according to the
  version number.

## ohvbd 0.3.0

### **Major API change**

- `*_basereq()` calls are no longer required as the first argument for
  functions.
- As such, data downloads no longer need to start with
  `vb_basereq() |>`.
- Basereq can now be overridden by providing an alternative basereq to
  the `basereq` argument of these functions, which can be generated
  using
  [`vb_basereq()`](https://ohvbd.vbdhub.org/reference/vb_basereq.md).
- This is usually only needed if using the argument `unsafe = TRUE` for
  [`vb_basereq()`](https://ohvbd.vbdhub.org/reference/vb_basereq.md).
- It is also possible to set ohvbd to use compatability-mode ssl calls
  using
  [`set_ohvbd_compat()`](https://ohvbd.vbdhub.org/reference/set_ohvbd_compat.md).
- This change breaks any code written prior to this version, and so
  major rewrites may be required.

## ohvbd 0.2.5

- `extract_ad()` now allows `targetdate` to be specified as a vector of
  full dates, e.g. `c("2023-08-04", "2023-09-21")`.

## ohvbd 0.2.4

- VecTraits & VecDyn search functions no longer return stale responses
  if the search fails.

## ohvbd 0.2.3

- VecTraits functions now use the `cli` package to provide a nicer cli
  interface.
- VecDyn functions now use the `cli` package to provide a nicer cli
  interface.

## ohvbd 0.2.2

- AREAdata functions now use the `cli` package to provide a nicer cli
  interface.
- `retrieving-data` vignette now builds significantly quicker.

## ohvbd 0.2.1

- `get_ad()` now caches data from AREAdata to reduce extraneous data
  downloading and speed up re-execution and development.
- This requires the new argument `use_cache=TRUE` and caches by default
  in the user directory.

## ohvbd 0.2.0

- Install instructions now include the correct command for building
  vignettes when installing from GitHub.
- New
  [`check_db_status()`](https://ohvbd.vbdhub.org/reference/check_db_status.md)
  allows for easy checking of the online status of various data
  providers.
- `ohvbd` now interfaces with the AREAdata repository for historical
  climate data.
- This includes functions to get and filter AREAdata datasets at
  different spatial scales.

## ohvbd 0.1.4

- Small framing change in `retrieving-data` vignette (courtesy of
  [@willpearse](https://github.com/willpearse)).

## ohvbd 0.1.3

- New `retrieving-data` vignette to explain the basic process of
  downloading and extracting data from Vectraits and VecDyn.

## ohvbd 0.1.2

- New [`search_vd()`](https://ohvbd.vbdhub.org/reference/search_vd.md)
  and
  [`search_vd_smart()`](https://ohvbd.vbdhub.org/reference/search_vd_smart.md)
  now allow for searching of VecDyn in the same manner as for VecTraits.

## ohvbd 0.1.1

- `get_vb_basereq()` renamed to
  [`vb_basereq()`](https://ohvbd.vbdhub.org/reference/vb_basereq.md) for
  ease of writing.

## ohvbd 0.1.0

- Chunked retrieval now correctly uses the chunksize argument.
- `ohvbd` now interfaces with the VecDyn database for vector population
  dynamic data.
- This includes functions to get ids, get datasets, and to extract data
  from the responses.
- These functions use the same api structure as for VecTraits data
  download, but with `vd` replacing `vt` in the function names
  (e.g. `get_vd()`)

## ohvbd 0.0.5

- New [`search_vt()`](https://ohvbd.vbdhub.org/reference/search_vt.md)
  allows for keyword-based searching of VecTraits.
- `get_vt_current_ids()` now handles 404 responses gracefully.

## ohvbd 0.0.4

- New
  [`search_vt_smart()`](https://ohvbd.vbdhub.org/reference/search_vt_smart.md)
  allows for field-based searching of VecTraits.

## ohvbd 0.0.3

- `get_vt()` now leverages
  [`httr2::req_perform_sequential()`](https://httr2.r-lib.org/reference/req_perform_sequential.html)
  for more efficient dataset retrieval.

## ohvbd 0.0.2

- Add documentation for all current functions.

## ohvbd 0.0.1

- Initial commit.
