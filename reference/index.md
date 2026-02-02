# Package index

## Hub

Functions for interfacing with vbdhub.

- [`filter_db()`](https://ohvbd.vbdhub.org/reference/filter_db.md) :
  Filter hub search results by database
- [`search_hub()`](https://ohvbd.vbdhub.org/reference/search_hub.md) :
  Search vbdhub.org

## VecTraits

Functions for interfacing with VecTraits.

- [`fetch_citations_vt()`](https://ohvbd.vbdhub.org/reference/fetch_citations_vt.md)
  : Retrieve citations for vectraits data
- [`fetch_glean_vt_chunked()`](https://ohvbd.vbdhub.org/reference/fetch_glean_vt_chunked.md)
  : Get and parse multiple VecTraits datasets by ID in chunks
- [`fetch_vt()`](https://ohvbd.vbdhub.org/reference/fetch_vt.md) : Fetch
  VecTraits dataset/s by ID
- [`find_vt_ids()`](https://ohvbd.vbdhub.org/reference/find_vt_ids.md) :
  Get current IDs in VecTraits
- [`generate_vt_template()`](https://ohvbd.vbdhub.org/reference/generate_vt_template.md)
  : Generate a vectraits template from a short set of survey responses
- [`glean_vt()`](https://ohvbd.vbdhub.org/reference/glean_vt.md) : Parse
  data from requests to VecTraits
- [`search_vt()`](https://ohvbd.vbdhub.org/reference/search_vt.md) :
  Search VecTraits by keyword
- [`search_vt_smart()`](https://ohvbd.vbdhub.org/reference/search_vt_smart.md)
  : Search VecTraits using the explorer's filters

## VecDyn

Functions for interfacing with VecDyn.

- [`fetch_citations_vd()`](https://ohvbd.vbdhub.org/reference/fetch_citations_vd.md)
  : Retrieve citations for vecdyn data
- [`fetch_glean_vd_chunked()`](https://ohvbd.vbdhub.org/reference/fetch_glean_vd_chunked.md)
  : Fetch and parse multiple VecDyn datasets by ID in chunks
- [`fetch_vd()`](https://ohvbd.vbdhub.org/reference/fetch_vd.md) : Fetch
  VecDyn dataset/s by ID
- [`fetch_vd_counts()`](https://ohvbd.vbdhub.org/reference/fetch_vd_counts.md)
  : Fetch VecDyn dataset length by ID
- [`find_vd_columns()`](https://ohvbd.vbdhub.org/reference/find_vd_columns.md)
  : Get current columns in VecDyn datasets
- [`find_vd_ids()`](https://ohvbd.vbdhub.org/reference/find_vd_ids.md) :
  Get current IDs in VecDyn
- [`glean_vd()`](https://ohvbd.vbdhub.org/reference/glean_vd.md) : Parse
  data from requests to VecDyn
- [`search_vd()`](https://ohvbd.vbdhub.org/reference/search_vd.md) :
  Search VecDyn by keyword
- [`search_vd_smart()`](https://ohvbd.vbdhub.org/reference/search_vd_smart.md)
  : Search VecDyn using the explorer's filters

## GBIF

Functions for interfacing with GBIF.

- [`fetch_gbif()`](https://ohvbd.vbdhub.org/reference/fetch_gbif.md) :
  Fetch GBIF dataset/s by ID
- [`glean_gbif()`](https://ohvbd.vbdhub.org/reference/glean_gbif.md) :
  Parse data from requests to GBIF

## AREAdata

Functions for interfacing with AREAdata.

- [`assoc_ad()`](https://ohvbd.vbdhub.org/reference/assoc_ad.md) :
  Associate other data sources with AREAdata data
- [`fetch_ad()`](https://ohvbd.vbdhub.org/reference/fetch_ad.md) : Fetch
  AREAdata dataset
- [`fetch_gadm_sfs()`](https://ohvbd.vbdhub.org/reference/fetch_gadm_sfs.md)
  : Fetch gadm mapping shapefiles
- [`glean_ad()`](https://ohvbd.vbdhub.org/reference/glean_ad.md) :
  Extract data from AREAdata datasets

## Convenience

Convenient generalised functions for working with a range of data.

- [`fetch()`](https://ohvbd.vbdhub.org/reference/fetch.md) : Fetch
  specified data from a set of ids
- [`fetch_citations()`](https://ohvbd.vbdhub.org/reference/fetch_citations.md)
  : Try to find the relevant citations for a dataset
- [`force_db()`](https://ohvbd.vbdhub.org/reference/force_db.md) : Force
  an object to appear to come from a specific database
- [`glean()`](https://ohvbd.vbdhub.org/reference/glean.md) : Extract
  specified data from a set of responses
- [`has_db()`](https://ohvbd.vbdhub.org/reference/has_db.md) : Test
  whether an object has provenance information
- [`is_from()`](https://ohvbd.vbdhub.org/reference/is_from.md) : Test
  whether an object is considered to be from a particular database
- [`match_countries()`](https://ohvbd.vbdhub.org/reference/match_countries.md)
  : Match country names to their equivalent naturalearth WKT polygons
- [`match_species()`](https://ohvbd.vbdhub.org/reference/match_species.md)
  : Match species names to their GBIF backbone ids
- [`ohvbd_db()`](https://ohvbd.vbdhub.org/reference/ohvbd_db.md)
  [`` `ohvbd_db<-`() ``](https://ohvbd.vbdhub.org/reference/ohvbd_db.md)
  : Database provenance

## Deprecated

Functions that are deprecated and will be removed in future versions.

- [`clean_ad_cache()`](https://ohvbd.vbdhub.org/reference/clean_ad_cache.md)
  : Delete all rda files from ohvbd AREAdata cache (Deprecated)
- [`extract()`](https://ohvbd.vbdhub.org/reference/extract.md) : Extract
  specified data from a set of responses (Deprecated)

## Other

Miscellaneous functions.

- [`assoc_gadm()`](https://ohvbd.vbdhub.org/reference/assoc_gadm.md) :
  Associate other data sources with gadm IDs
- [`check_db_status()`](https://ohvbd.vbdhub.org/reference/check_db_status.md)
  : Check whether databases are currently online
- [`check_ohvbd_config()`](https://ohvbd.vbdhub.org/reference/check_ohvbd_config.md)
  : Print current ohvbd configuration variables
- [`clean_ohvbd_cache()`](https://ohvbd.vbdhub.org/reference/clean_ohvbd_cache.md)
  : Delete files from ohvbd cache directories
- [`fetch_vd_meta()`](https://ohvbd.vbdhub.org/reference/fetch_vd_meta.md)
  : Fetch VecDyn metadata table
- [`format_time_overlap_bar()`](https://ohvbd.vbdhub.org/reference/format_time_overlap_bar.md)
  : Format and print date overlaps
- [`get_default_ohvbd_cache()`](https://ohvbd.vbdhub.org/reference/get_default_ohvbd_cache.md)
  : Get ohvbd cache locations
- [`is_cached()`](https://ohvbd.vbdhub.org/reference/is_cached.md) :
  Check whether an object has been loaded from cache by ohvbd
- [`list_ohvbd_cache()`](https://ohvbd.vbdhub.org/reference/list_ohvbd_cache.md)
  : List all ohvbd cached files
- [`ohvbd.ids()`](https://ohvbd.vbdhub.org/reference/ohvbd.ids.md) :
  Create a new ohvbd ID vector
- [`ohvbd_attrs`](https://ohvbd.vbdhub.org/reference/ohvbd_attrs.md) :
  Internal attributes
- [`ohvbd_dryrun`](https://ohvbd.vbdhub.org/reference/ohvbd_dryrun.md) :
  Option: dry runs of ohvbd searches
- [`set_ohvbd_compat()`](https://ohvbd.vbdhub.org/reference/set_ohvbd_compat.md)
  : Set ohvbd compatability mode to TRUE
- [`tee()`](https://ohvbd.vbdhub.org/reference/tee.md) : Tee a pipeline
  to extract the data at a given point

### Base requests

Functions for modifying the basic targets of data API requests

- [`ad_basereq()`](https://ohvbd.vbdhub.org/reference/ad_basereq.md) :
  Generate a base request string for the AREAdata database
- [`vb_basereq()`](https://ohvbd.vbdhub.org/reference/vb_basereq.md) :
  Generate a base request object for the vectorbyte databases
