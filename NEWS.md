# ohvbd 0.4.4

* New function `check_ohvbd_config()` allows easy printing of the current status of ohvbd's options.
* New `clean_ad_cache()` function enables users to clean their cached AREAdata files easily.
* Build timings now appear in all vignettes.
* Cli outputs are now suppressed when running vignettes in non-interactive mode (e.g. while knitting).
* Default cache path is now in the user directory (obtained from `tools::R_user_dir()`).
* `use-areadata` vignette now has part of its content complete.
* Generally this update is setting the stage for another major API overhaul in 0.5.0.

# ohvbd 0.4.3

* Large changes to all vb `get_` and `search_` function error handling
* All of these functions now check automatically for SSL issues, and recommend `set_ohvbd_compat()` if these are detected.
* All `get_` calls requesting more than 10 ids run a pre-flight ssl check before attempting the whole thing.
* `get_vd()` and `get_vt()` now also return a list of ids that were missing and any curl errors that were found in the process of trying to get data.

# ohvbd 0.4.2

* `set_ohvbd_compat()` now asks for user confirmation in interactive mode. This makes running on linux a little annoying, but is worth it due to the seriousness of disabling SSL identity verification.
* This is not asked if the R session is running in batch mode, under knittr, or under testthat.
* `retrieving-data` vignette now only enables compatibility mode if running under linux. Generally it is best to keep package usage of `set_ohvbd_compat()` to an *absolute minimum*.
* Copyright holder now listed in DESCRIPTION

# ohvbd 0.4.1

* New parallel downloading options for `get_x()` and `get_extract_x()` functions.
* These are to be used with caution, as they put significantly more load on the server than a sequential run would.
* New argument `check_src` allows for toggling of id-sanity checking for most functions.
* `retrieving-data` vignette now contains instructions for the use of `search_x_smart()`.

# ohvbd 0.4.0
## **Major API change**
* Major simplification of function names!
* `get_x_byid()` -> `get_x()`
* `extract_x_data()` -> `extract_x()`
* `assoc_x_y()` -> `assoc_x()`
* `get_extract_x_byid_chunked()` -> `get_extract_x_chunked()`
* This breaks ALL PREVIOUS CODE!
* Naming now follows a logical scheme of `verb_target_modifier()`.
* For example `get_x_y()` functions always retrieve data from database `x` with `y` specifying any special type of data.
* Similarly `extract_x()` functions always extract data.
* If a function does multiple things, it may get multiple verbs separated by underscores, e.g. `get_extract_x_chunked()`
* Pipelines now internally attempt to confirm data integrity by checking that the correct functions are piped together.
* This means it is no longer easy to accidentally do something like `get_vd_current_ids() %>% get_vt()`.

# ohvbd 0.3.1

* New function `format_time_overlap_bar()` allows for visually formatting a range of dates combined with another set of target dates to see where overlaps do or do not take place.
* This is mostly used in the error handling of `extract_ad()` however it can also be used independently. It was designed to fill a more general role within UI design using the cli package, and should be usable (or hackable) by others needing the same tool.
* `extract_ad()` now errors when all `targetdate` entries are outside of the range of the AREAdata dataset.
* New `assoc_ad()` associates arbitrary data including lon/lat columns with AREAdata.
* New `get_vd_columns()` provides quick reference about the currently present VecDyn columns. *(This is currently not possible for VecTraits, but the feasibility is being investigated.)*
* New `assoc_gadm()` function associates gadm ids at all spatial scales with arbitrary data that include lon/lat columns.
* Documentation now correctly displays favicons.
* Logo now rotates through a variety of colourschemes according to the version number.

# ohvbd 0.3.0

## **Major API change**
* `*_basereq()` calls are no longer required as the first argument for functions.
* As such, data downloads no longer need to start with `vb_basereq() %>%`.
* Basereq can now be overridden by providing an alternative basereq to the `basereq` argument of these functions, which can be generated using `vb_basereq()`.
* This is usually only needed if using the argument `unsafe = TRUE` for `vb_basereq()`.
* It is also possible to set ohvbd to use compatability-mode ssl calls using `set_ohvbd_compat()`.
* This change breaks any code written prior to this version, and so major rewrites may be required.

# ohvbd 0.2.5

* `extract_ad()` now allows `targetdate` to be specified as a vector of full dates, e.g. `c("2023-08-04", "2023-09-21")`.

# ohvbd 0.2.4

* VecTraits & VecDyn search functions no longer return stale responses if the search fails.

# ohvbd 0.2.3

* VecTraits functions now use the `cli` package to provide a nicer cli interface.
* VecDyn functions now use the `cli` package to provide a nicer cli interface.

# ohvbd 0.2.2

* AREAdata functions now use the `cli` package to provide a nicer cli interface.
* `retrieving-data` vignette now builds significantly quicker.

# ohvbd 0.2.1

* `get_ad()` now caches data from AREAdata to reduce extraneous data downloading and speed up re-execution and development.
* This requires the new argument `use_cache=TRUE` and caches by default in the user directory.

# ohvbd 0.2.0

* Install instructions now include the correct command for building vignettes when installing from GitHub.
* New `check_db_status()` allows for easy checking of the online status of various data providers.
* `ohvbd` now interfaces with the AREAdata repository for historical climate data.
* This includes functions to get and filter AREAdata datasets at different spatial scales.

# ohvbd 0.1.4

* Small framing change in `retrieving-data` vignette (courtesy of @willpearse).

# ohvbd 0.1.3

* New `retrieving-data` vignette to explain the basic process of downloading and extracting data from Vectraits and VecDyn.

# ohvbd 0.1.2

* New `search_vd()` and `search_vd_smart()` now allow for searching of VecDyn in the same manner as for VecTraits.

# ohvbd 0.1.1

* `get_vb_basereq()` renamed to `vb_basereq()` for ease of writing.

# ohvbd 0.1.0

* Chunked retrieval now correctly uses the chunksize argument.
* `ohvbd` now interfaces with the VecDyn database for vector population dynamic data.
* This includes functions to get ids, get datasets, and to extract data from the responses.
* These functions use the same api structure as for VecTraits data download, but with `vd` replacing `vt` in the function names (e.g. `get_vd()`)

# ohvbd 0.0.5

* New `search_vt()` allows for keyword-based searching of VecTraits.
* `get_vt_current_ids()` now handles 404 responses gracefully.

# ohvbd 0.0.4

* New `search_vt_smart()` allows for field-based searching of VecTraits.

# ohvbd 0.0.3

* `get_vt()` now leverages `httr2::req_perform_sequential()` for more efficient dataset retrieval.

# ohvbd 0.0.2

* Add documentation for all current functions.

# ohvbd 0.0.1

* Initial commit.
