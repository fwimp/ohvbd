#' @title Retrieve and format error message from failed vt calls
#' @param resp An errored response to format
#' @return error string
#' @keywords internal
#'

vt_error_body <- function(resp) {
  paste("Error retrieving VT ID", resp$request$headers$ohvbd)
}

#' @title Retrieve and format error message from failed vd calls
#' @param resp An errored response to format
#' @return error string
#' @keywords internal
#'

vd_error_body <- function(resp) {
  paste("Error retrieving VD ID", resp$request$headers$ohvbd)
}

#' @title collapse a list of character strings to a JS space-separated single string
#' @param v a vector to format
#' @return collapsed string
#' @keywords internal
#'

space_collapse <- function(v){
  paste(v, collapse = "%20")
}

#' @title Extract a single vd response, including consistent data
#' @param resp A response to extract from
#' @return dataframe of all relevant data in the response
#' @keywords internal
#'

vd_extraction_helper <- function(resp, cols=NA){
  resp_parse <- resp %>% resp_body_json()
  df <- rbindlist(resp_parse$results)
  df2 <- as.data.frame(resp_parse$consistent_data)
  df_out <- bind_cols(df2, df)
  if (resp_parse$count > 0){
    df_out$dataset_id <- resp$request$headers$ohvbd
  }
  if (!any(is.na(cols))){
    # Filter cols from each sublist
    df_out <- df_out %>%  select(any_of(cols))
  }
  return(df_out)
}

#' @title Convert a vector of place names to their equivalent at a different gid level
#' @param places A vector of places
#' @return vector of converted place names or gid codes
#' @keywords internal
#'

convert_place_togid <- function(places, gid=0){
  returncolumn <- c("NAME_0", "GID_1", "GID_2")[gid+1]
  # .data$. is required to silence R CMD build notes about undefined globals.
  out_places <- gidtable %>% filter_all(any_vars(.data$. %in% places))%>% select(returncolumn)
  return(unique(out_places[[1]]))
}


# Only used for internal testing and doesnt need to be checked.
#
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
#   r_deps <- db %>%
#     dplyr::filter(Package %in% v) %>%
#     # We exclude recommended pkgs as they're always shown as depending on R-devel
#     dplyr::filter(is.na(Priority) | Priority != "recommended") %>%
#     dplyr::pull(Depends) %>%
#     strsplit(split = ",") %>%
#     purrr::map(~ grep("^R ", .x, value = TRUE)) %>%
#     unlist()
#
#   r_vers <- trimws(gsub("^R \\(>=?\\s(.+)\\)", "\\1", r_deps))
#   return(as.character(max(package_version(r_vers))))
# }
