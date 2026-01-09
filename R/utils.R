#' @title Check whether an object is from a given database and complete appropriate messaging
#' @param obj The object to check.
#' @param db The database which the object should be from.
#' @param altfunc The function name stub (e.g. "fetch", used for messaging). If `NULL`, suppresses alternate function suggestion.
#' @param altfunc_suffix The function name suffix (e.g. "chunked", used for messaging).
#' @param objtype The type of object (used for messaging).
#' @param call The env from which this was called (defaults to the direct caller).
#' @return NULL
#' @keywords internal
#'
check_provenance <- function(obj, db, altfunc="fetch", altfunc_suffix = NULL, objtype = "IDs", call = rlang::caller_env()) {

  db_lookup <- c(
    "vt" = "VecTraits",
    "vd" = "VecDyn",
    "ad" = "AREAdata",
    "gbif" = "GBIF"
  )

  if (!(db %in% names(db_lookup))) {
    cli::cli_abort("{.val {db}} is not a known database!", .internal = TRUE, call = call)
  }

  db_fullname <- db_lookup[db]

  if (!has_db(obj)) {
    # TODO: Should this be a real warning signal?
    cli::cli_alert_warning(paste(objtype, "not necessarily from {db_fullname}."))
  } else if (!is_from(obj, db)) {
    if (is.null(altfunc_suffix)) {
      altfunc_suffix <- ""
    } else {
      altfunc_suffix <- paste0("_", altfunc_suffix)
    }
    # Check if the alternative suggestion exists
    altfunc_present <- tryCatch({
      paste0(altfunc, "_", ohvbd_db(obj), altfunc_suffix) %in% ls("package:ohvbd")
      }, error = \(e) {
        FALSE
      })

    if (is.null(altfunc) || !altfunc_present) {
      altfunc_suggestion <- "!"
    } else {
      altfunc_suggestion <- ", Please use the {.fn ohvbd::{altfunc}_{ohvbd_db(obj)}{altfunc_suffix}} function."
    }
    cli::cli_abort(c(
      "x" = paste0(objtype, " not from {db_fullname}", altfunc_suggestion),
      "!" = "Detected database = {.val {ohvbd_db(obj)}}"
    ), call = call)
  }

  invisible(NULL)
}

#' @title Extract request ids from httr2 response objects
#' @param r A response object.
#' @return the id requested from the call.
#' @keywords internal
#'

.get_vb_req_id <- function(r) {
  return(r$request$headers$ohvbd)
}

#' @title Extract curl errors from httr2 error objects
#' @param e An error object.
#' @param returnfiller If true return filler message if no curl message is present.
#' @return the curl error message (if present) or NULL (or a filler message).
#' @keywords internal
#'

get_curl_err <- function(e, returnfiller = FALSE) {
  out <- e$parent$message
  if (is.null(out) && returnfiller) {
    # Makes it possible to force get_curl_err to return SOMETHING.
    return("Unknown (no curl error present).")
  } else {
    return(out)
  }
}

#' @title Retrieve and format error message from failed vt calls
#' @param resp An errored response to format.
#' @return error string.
#' @keywords internal
#'

vt_error_body <- function(resp) {
  paste("Error retrieving VT ID", .get_vb_req_id(resp))
}

#' @title Retrieve and format error message from failed vd calls
#' @param resp An errored response to format.
#' @return error string.
#' @keywords internal
#'

vd_error_body <- function(resp) {
  paste("Error retrieving VD ID", .get_vb_req_id(resp))
}

#' @title Create a query for a given VD id at a given page
#' @param id ID of the vecdyn dataset.
#' @param pagenum page to retrieve.
#' @param rate rate limit for requests.
#' @param url the base url for the vectorbyte API.
#' @param useragent the user agent string used when contacting vectorbyte.
#' @param unsafe disable ssl verification (should only ever be required on Linux, **do not enable this by default**).
#'
#' @return [httr2 request][httr2::request()] containing the requisite call to retrieve the data.
#' @keywords internal
#'

vd_make_req <- function(
  id,
  pagenum,
  rate,
  url = "",
  useragent = "",
  unsafe = FALSE
) {
  # Rebuild basereq and generate final request
  return(
    vb_basereq(baseurl = url, useragent = useragent, unsafe = unsafe) |>
      req_url_path_append("vecdyncsv") |>
      req_url_query("format" = "json", "page" = pagenum, "piids" = id) |>
      req_error(body = vd_error_body) |>
      req_headers(ohvbd = id) |> # Add additional header just so we can nicely handle failures
      req_throttle(5)
  )
}

#' @title collapse a list of character strings to a JS space-separated single string
#' @param v a vector to format.
#' @return collapsed string.
#' @keywords internal
#'

space_collapse <- function(v) {
  paste(v, collapse = "%20")
}

#' @title Extract a single vd response, including consistent data
#' @param resp A response to extract from.
#' @return dataframe of all relevant data in the response.
#' @keywords internal
#'

vd_extraction_helper <- function(resp, cols = NA) {
  df_out <- tryCatch(
    {
      resp_parse <- resp |> resp_body_json()
      df <- suppressWarnings(rbindlist(resp_parse$results))
      df2 <- as.data.frame(resp_parse$consistent_data)

      # Handle missing data in results (or consistent data, not that it's missing often)
      if (nrow(df) == 0) {
        df_out <- df2
      } else if (nrow(df2) == 0) {
        df_out <- df
      } else {
        df_out <- bind_cols(df2, df)
      }

      if (resp_parse$count > 0) {
        df_out$dataset_id <- .get_vb_req_id(resp)
      }
      if (!any(is.na(cols))) {
        # Filter cols from each sublist
        df_out <- df_out |> select(any_of(cols))
      }
      df_out
    },
    error = function(e) {
      cli::cli_abort(
        "Error in vd extraction of ID {(.get_vb_req_id(resp))}",
        parent = e
      )
    }
  )

  return(df_out)
}

#' @title Convert a vector of place names to their equivalent at a different gid level
#' @param places A vector of places.
#' @return vector of converted place names or gid codes.
#' @keywords internal
#'

convert_place_togid <- function(places, gid = 0) {
  returncolumn <- c("NAME_0", "GID_1", "GID_2")[gid + 1]
  # .data$. is required to silence R CMD build notes about undefined globals.
  out_places <- gidtable |>
    filter_all(any_vars(.data$. %in% places)) |>
    select(returncolumn)
  return(unique(out_places[[1]]))
}

#' @title Find the ids of any resps that contain 404 errors from a list of them
#' @param l A list of httr2 error objects.
#' @return the ids from those found objects.
#' @keywords internal
#'

find_vb_404s <- function(l) {
  l_filtered <- l[unlist(lapply(l, inherits, what = "httr2_http_404"))]
  return(unlist(lapply(l_filtered, .get_vb_req_id)))
}


#' @title Find the ids of any resps that contain a count of 0 list of them
#' @param l A list of httr2 error objects.
#' @return the ids from those found objects.
#' @keywords internal
#'

find_vd_missing <- function(l) {
  l_filtered <- l[unlist(lapply(l, function(x) {
    resp_body_json(x)$count == 0
  }))]
  return(unlist(lapply(l_filtered, .get_vb_req_id)))
}

#' @title Try to coerce a date even when bits are missing
#' @param dates The date/s to try and coerce.
#' @return Coerced dates.
#' @keywords internal

coercedate <- function(dates, return_iso = FALSE, nulliferror = FALSE) {
  if (all(is.null(dates))) {
    return(NULL)
  }
  dates <- as.character(dates)
  # Fromdate reparse attempt
  suppressWarnings(dates_final <- as_date(dates))
  if (any(is.na(dates_final))) {
    # Maybe it's a YYYY-MM
    suppressWarnings(dates_final <- as_date(paste0(dates, "-01")))
    if (any(is.na(dates_final))) {
      # Maybe it's a YYYY
      suppressWarnings(dates_final <- as_date(paste0(dates, "-01-01")))
      if (any(is.na(dates_final))) {
        # Dunno, stop filtering date
        cli::cli_alert_warning(
          "Could not make {.val {cli::cli_vec(dates, list('vec-trunc' = 5))}} into a usable date."
        )
        cli::cli_alert_info("Try ISO 8601 {.val yyyy-mm-dd} format")
        if (nulliferror) {
          return(NULL)
        } else {
          return(dates)
        }
      }
    }
  }
  if (return_iso) {
    return(lubridate::format_ISO8601(lubridate::as_datetime(dates_final)))
  } else {
    return(dates_final)
  }
}

#' @title Force a polygon WKT into multipolygon form
#' @param wkt The WKT to convert into a multipolygon.
#' @return The multipolygon equivalent of wkt.
#' @keywords internal
force_multipolygon <- function(wkt) {
  # TODO: Verify wkt intergrity (using approach here: https://github.com/ropensci/rgbif/blob/ac4e2fff8a7501956ce8a1be3e7429810bb64e2b/R/check_wkt.r)
  if (toupper(substr(wkt, 1, 7)) != "POLYGON") {
    if (toupper(substr(wkt, 1, 12)) == "MULTIPOLYGON") {
      return(wkt)
    } else {
      cli::cli_abort(c(
        "x" = "Must be a POLYGON wkt! Got {toupper(substr(wkt, 1, 7))}"
      ))
    }
  }
  return(paste0(gsub("POLYGON", "MULTIPOLYGON(", wkt), ")"))
}

#' @title Encode spatvector as WKT, and convert to multipolygon if needed
#' @param v The spatvector to format.
#' @return The formatted wkt.
#' @keywords internal
spatvect_to_multipolygon <- function(v) {
  wkt <- terra::geom(v, wkt = TRUE)
  wkt <- wkt_to_multipolygon(wkt)
  return(wkt)
}


#' @title wkt_to_multipolygon
#' @param v The WKT to convert into a multipolygon.
#' @return The multipolygon equivalent of wkt.
#' @keywords internal
wkt_to_multipolygon <- function(v) {
  if (!all(stringr::str_detect(v, pattern = stringr::fixed("POLYGON")))) {
    cli::cli_abort(c(
      "x" = "Must be a vector or single POLYGON or MULTIPOLYGON wkt!"
    ))
  }
  v_vec <- v |>
    # Replace all ((( with (( etc. to just isolate the internal array
    stringr::str_replace_all(c("\\(\\(\\("), "((") |>
    stringr::str_replace_all(c("\\)\\)\\)"), "))") |>
    # Replace add semicolons between array members for extraction later
    stringr::str_replace_all(c("\\)\\)\\,\\(\\("), "));((") |>
    # Extract everything within (())
    stringr::str_extract_all("\\(\\(([^}]+)\\)\\)") |>
    # Split any multi-poly arrays by the new delim
    stringr::str_split(stringr::fixed(";")) |>
    unlist()
  return(paste0("MULTIPOLYGON (", paste(v_vec, collapse = ","), ")"))
}


#' @title Force an object to appear to come from a specific database
#' @author Francis Windram
#' @param x Object to force.
#' @param db Database to apply to `x`.
#' @returns Object with the "db" attribute set to `db`
#'
#' @note
#' **DO NOT** use this function to create ids to feed into [fetch()]!
#'
#' Objects created in this way may lack vital underlying data required later.
#' Instead use [ohvbd.ids()] for this purpose.
#'
#' This is a synonym for `ohvbd_db(x) <- db` that's easier to work with in pipelines.
#'
#' @concept convenience
#'
#' @export
#'
#' @examples
#' force_db(c(1,2,3), "vt")
#'
force_db <- function(x, db) {
  ohvbd_db(x) <- db
  x
}

#' @title Option: dry runs of ohvbd searches
#'
#' @description
#' Set this option to make ohvbd terminate searches before execution and return the request object instead.
#'
#' @note
#' This is usually only useful when debugging, testing, or developing `ohvbd`.
#'
#' @author Francis Windram
#'
#' @examplesIf interactive()
#' options(ohvbd_dryrun = TRUE)
#' search_hub("Ixodes ricinus")
#'
#' options(ohvbd_dryrun = NULL)  # Unset dryrun
#'
#' @name ohvbd_dryrun
NULL

# Only used for internal testing and doesnt need to be checked.
#
# nolint start
# get_min_R_version <- function(pkgs=NA){
#   # Adapted from https://blog.r-hub.io/2022/09/12/r-dependency/
#   db <- tools::CRAN_package_db()
#   # Pull the imports from DESCRIPTION
#   if (any(is.na(pkgs))){
#     packages <- strsplit(as.vector(read.dcf('DESCRIPTION')[, 'Imports']), ",\n")[[1]]
#   }
#
#   # Find the reverse dependencies for all packages
#   recursive_deps <- tools::package_dependencies(
#     packages,
#     recursive = TRUE,
#     db = db
#   )
#
#   # Get a list of all imported packages
#   v <- names(recursive_deps)
#   for (x in recursive_deps){
#     v <- c(v, x)
#   }
#   v <- unique(v)
#   r_deps <- db |>
#     dplyr::filter(Package %in% v) |>
#     # We exclude recommended pkgs as they're always shown as depending on R-devel
#     dplyr::filter(is.na(Priority) | Priority != "recommended") |>
#     dplyr::pull(Depends) |>
#     strsplit(split = ",") |>
#     purrr::map(~ grep("^R ", .x, value = TRUE)) |>
#     unlist()
#
#   r_vers <- trimws(gsub("^R \\(>=?\\s(.+)\\)", "\\1", r_deps))
#   return(as.character(max(package_version(r_vers))))
# }
# nolint end
