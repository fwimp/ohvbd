#' @title Extract request ids from httr2 response objects
#' @param r A response object
#' @return the id requested from the call
#' @keywords internal
#'

.get_vb_req_id <- function(r) {
  return(r$request$headers$ohvbd)
}

#' @title Extract curl errors from httr2 error objects
#' @param e An error object
#' @param returnfiller If true return filler message if no curl message is present.
#' @return the curl error message (if present) or NULL (or a filler message)
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
#' @param resp An errored response to format
#' @return error string
#' @keywords internal
#'

vt_error_body <- function(resp) {
  paste("Error retrieving VT ID", .get_vb_req_id(resp))
}

#' @title Retrieve and format error message from failed vd calls
#' @param resp An errored response to format
#' @return error string
#' @keywords internal
#'

vd_error_body <- function(resp) {
  paste("Error retrieving VD ID", .get_vb_req_id(resp))
}

#' @title Create a query for a given VD id at a given page
#' @param id ID of the vecdyn dataser
#' @param pagenum page to retrieve
#' @param rate rate limit for requests
#' @param url the base url for the vectorbyte API
#' @param useragent the user agent string used when contacting vectorbyte
#' @param unsafe disable ssl verification (should only ever be required on Linux, **do not enable this by default**)
#'
#' @return [httr2 request][httr2::request()] containing the requisite call to retrieve the data
#' @keywords internal
#'

vd_make_req <- function(id, pagenum, rate, url = "", useragent = "", unsafe = FALSE) {
  # Rebuild basereq and generate final request
  return(vb_basereq(baseurl = url, useragent = useragent, unsafe = unsafe) |>
           req_url_path_append("vecdyncsv") |>
           req_url_query("format" = "json", "page" = pagenum, "piids" = id) |>
           req_error(body = vd_error_body) |>
           req_headers(ohvbd = id) |>  # Add additional header just so we can nicely handle failures
           req_throttle(5))
}

#' @title collapse a list of character strings to a JS space-separated single string
#' @param v a vector to format
#' @return collapsed string
#' @keywords internal
#'

space_collapse <- function(v) {
  paste(v, collapse = "%20")
}

#' @title Extract a single vd response, including consistent data
#' @param resp A response to extract from
#' @return dataframe of all relevant data in the response
#' @keywords internal
#'

vd_extraction_helper <- function(resp, cols = NA) {
  df_out <- tryCatch({
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
      df_out <- df_out |>  select(any_of(cols))
    }
    df_out
  }, error = function(e) {
    cli_abort("Error in vd extraction of ID {(.get_vb_req_id(resp))}", parent = e)
  })

  return(df_out)
}

#' @title Convert a vector of place names to their equivalent at a different gid level
#' @param places A vector of places
#' @return vector of converted place names or gid codes
#' @keywords internal
#'

convert_place_togid <- function(places, gid = 0) {
  returncolumn <- c("NAME_0", "GID_1", "GID_2")[gid + 1]
  # .data$. is required to silence R CMD build notes about undefined globals.
  out_places <- gidtable |> filter_all(any_vars(.data$. %in% places)) |> select(returncolumn)
  return(unique(out_places[[1]]))
}

#' @title Find the ids of any resps that contain 404 errors from a list of them.
#' @param l A list of httr2 error objects
#' @return the ids from those found objects
#' @keywords internal
#'

find_vb_404s <- function(l) {
  l_filtered <- l[unlist(lapply(l, inherits, what = "httr2_http_404"))]
  return(unlist(lapply(l_filtered, .get_vb_req_id)))
}


#' @title Find the ids of any resps that contain a count of 0 list of them.
#' @param l A list of httr2 error objects
#' @return the ids from those found objects
#' @keywords internal
#'

find_vd_missing <- function(l) {
  l_filtered <- l[unlist(lapply(l, function(x) {
    resp_body_json(x)$count == 0
  }))]
  return(unlist(lapply(l_filtered, .get_vb_req_id)))
}

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
