#' ohvbd: One Health VBD Hub
#'
#' Interface with the One Health VBD Hub and related repositories directly.
#'
#' @rdname ohvbd-package
#' @name ohvbd-package
#' @keywords internal
#' @aliases ohvbd-package ohvbd
#'
#' @section Introduction:
#' ohvbd is a data location and ingestion package focused around a series of
#' vector-borne disease databases. It aims to make it quick and easy to
#' repeatably download data from a variety of sources without having to navigate
#' online tools and pages.
#'
#' @section Searching:
#' ohvbd can be used to search a multitude of databases using the `search_*` family of functions.
#'
#' Most prominent of these is the [search_hub()] function, which leverages the
#' <vbdhub.org> search functionality to provide enhanced searches across databases.
#'
#' ```
#' # Search hub for the Castor Bean Tick
#' search_hub("Ixodes ricinus")
#' ```
#'
#' Other dedicated search functionality is available for select databases (e.g. [search_vt_smart()]).
#'
#' @section Downloading:
#' Once relevant data has been identified, these can be downloaded using the [fetch()] function.
#'
#' This is typically performed using a piped approach:
#'
#' ```
#' # Find and retrieve tick data from VecTraits
#' ixodes_results <- search_hub("Ixodes ricinus", db = "vt") |>
#'                     fetch()
#' ```
#'
#' @section Parsing & Filtering:
#' Downloaded data is simply stored as the responses from the website.
#'
#' To use the information itself we must use [glean()] to extract the relevant data:
#'
#' ```
#' # Find and retrieve tick data from VecTraits
#' ixodes_data <- search_hub("Ixodes ricinus", db = "vt") |>
#'                  fetch() |>
#'                  glean()
#' ```
#'
#' @section Associating with other data:
#' Downloaded data can be associated with climatic variables from AREAData using the `assoc_*` functions.
#'
#' ```
#' ixodes_data <- search_hub("Ixodes ricinus", "vt") |>
#'   tail(20) |>
#'   fetch() |>
#'   glean(cols = c(
#'     "DatasetID",
#'     "Latitude",
#'     "Longitude",
#'     "Interactor1Genus",
#'     "Interactor1Species"
#'   ), returnunique = TRUE)
#' areadata <- fetch_ad(metric="temp", gid=0, use_cache=TRUE)
#' ad_extract_working <- assoc_ad(ixodes_data, areadata,
#'                                targetdate = c("2021-08-04"),
#'                                enddate=c("2021-08-06"),
#'                                gid=0,
#'                                lonlat_names = c("Longitude", "Latitude"))
#'
#' ```
#'
#' @section Further information:
#'   The ohvbd homepage is at <https://ohvbd.vbdhub.org>.
#'   See especially the documentation section. Join the discussion forum at
#'   <https://forum.vbdhub.org/c/ohvbd-r-package/> if you have questions or comments.
"_PACKAGE"

## usethis namespace: start
#' @importFrom dplyr all_of
#' @importFrom dplyr any_of
#' @importFrom dplyr any_vars
#' @importFrom dplyr bind_cols
#' @importFrom dplyr distinct
#' @importFrom dplyr filter_all
#' @importFrom dplyr left_join
#' @importFrom dplyr mutate_all
#' @importFrom dplyr one_of
#' @importFrom dplyr rename_with
#' @importFrom dplyr select
#' @importFrom dplyr starts_with
#' @importFrom httr2 last_response
#' @importFrom httr2 req_error
#' @importFrom httr2 req_headers
#' @importFrom httr2 req_options
#' @importFrom httr2 req_perform
#' @importFrom httr2 req_perform_parallel
#' @importFrom httr2 req_perform_sequential
#' @importFrom httr2 req_throttle
#' @importFrom httr2 req_url_path_append
#' @importFrom httr2 req_url_query
#' @importFrom httr2 req_user_agent
#' @importFrom httr2 request
#' @importFrom httr2 resp_body_json
#' @importFrom httr2 resps_data
#' @importFrom httr2 resps_successes
#' @importFrom lubridate %within%
#' @importFrom lubridate as.duration
#' @importFrom lubridate as_date
#' @importFrom lubridate days
#' @importFrom lubridate interval
#' @importFrom lubridate period
# %||% is base R as of 4.4.0, however until that's more commonly used, we should import from rlang
#' @importFrom rlang %||%
#' @importFrom rlang .data
#' @importFrom rlang is_bool
#' @importFrom stats na.omit
#' @importFrom tibble rownames_to_column
#' @importFrom utils head
#' @importFrom utils tail
## usethis namespace: end
NULL
