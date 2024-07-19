# ohvbd 0.3.0

## **Major API change**
* `*_basereq()` calls are no longer required as the first argument for functions.
* As such, data downloads no longer need to start with `vb_basereq() %>%`.
* Basereq can now be overridden by providing an alternative basereq to the `basereq` argument of these functions, which can be generated using `vb_basereq()`.
* This is usually only needed if using the argument `unsafe = TRUE` for `vb_basereq()`.
* It is also possible to set ohvbd to use less safe ssl calls using `set_ohvbd_compat()`.
* This change breaks any code written prior to this version, and so major rewrites may be required.

# ohvbd 0.2.5

* `extract_ad_data()` now allows `targetdate` to be specified as a vector of full dates, e.g. `c("2023-08-04", "2023-09-21")`.

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
* This requires the new argument `use_cache=TRUE` and caches by default in the directory `./.adcache`.

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
* These functions use the same api structure as for VecTraits data download, but with `vd` replacing `vt` in the function names (e.g. `get_vd_byid()`)

# ohvbd 0.0.5

* New `search_vt()` allows for keyword-based searching of VecTraits.
* `get_current_vt_ids()` now handles 404 responses gracefully.

# ohvbd 0.0.4

* New `search_vt_smart()` allows for field-based searching of VecTraits.

# ohvbd 0.0.3

* `get_vt_byid()` now leverages `httr2::req_perform_sequential()` for more efficient dataset retrieval.

# ohvbd 0.0.2

* Add documentation for all current functions.

# ohvbd 0.0.1

* Initial commit.
