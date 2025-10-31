#' @title Search vbdhub.org
#' @description Retrieve the IDs for any datasets matching the given search parameters.
#'
#' @author Francis Windram
#'
#' @param query a search string.
#' @param db the databases to search.
#' @param fromdate the date from which to search (ISO format: yyyy-mm-dd).
#' @param todate the date up to which to search (ISO format: yyyy-mm-dd).
#' @param locationpoly a polygon or set of polygons in `terra::SpatVector` or WKT MULTIPOLYGON format within which to search.
#' @param exact whether to return exact matches only.
#' @param withoutpublished whether to return results without a publishing date when filtering by date.
#' @param returnlist return the raw output list rather than a formatted dataframe.
#' @param simplify if only a single database was searched, return an `ohvbd.ids` object instead (defaults to `TRUE`).
#' @param connections the number of connections to use to parallelise queries.
#'
#' @return an `ohvbd.hub.search` dataframe, an `ohvbd.ids` vector (if `returnlist=TRUE` and `length(db) == 1`) a list (if `returnlist=TRUE`) containing the search results.
#'
#' @examplesIf interactive()
#' search_hub("Ixodes ricinus")
#'
#' @concept hub
#'
#' @export
#'

search_hub <- function(
  query,
  db = c("vt", "vd", "gbif", "px"),
  fromdate = NULL,
  todate = NULL,
  locationpoly = NULL,
  exact = FALSE,
  withoutpublished = TRUE,
  returnlist = FALSE,
  simplify = TRUE,
  connections = 8
) {
  db_canon <- c("vt", "vd", "gbif", "px")
  select_dbs <- intersect(db_canon, db)
  incorrect_dbs <- setdiff(db, db_canon)
  if (length(incorrect_dbs) > 0) {
    cli::cli_warn(
      c(
        "!" = "Unknown database{?s} specified: {.val {incorrect_dbs}}",
        "v" = "Recognised databases: {.val {db_canon}}"
      )
    )
  }
  if (length(select_dbs) == 0) {
    cli::cli_abort(c("x" = "No valid database selected!"))
  }
  select_dbs <- paste(select_dbs, collapse = ",")
  # date parsing
  fromdate <- coercedate(fromdate, return_iso = TRUE, nulliferror = TRUE)
  todate <- coercedate(todate, return_iso = TRUE, nulliferror = TRUE)
  withoutpublished_str <- tolower(as.character(withoutpublished)) # Needed until the API supports arbitrary capitalisation of bools
  exact_str <- tolower(as.character(exact))

  # Parse location
  # TODO: Check that WKT is well-formatted
  if (!(is.null(locationpoly))) {
    if (inherits(locationpoly, "SpatVector")) {
      locationpoly <- spatvect_to_hubwkt(locationpoly)
    } else if (is.character(locationpoly)) {
      locationpoly <- force_multipolygon(locationpoly)
    } else {
      cli::cli_alert_warning(
        "{.arg locationpoly} must be of class {.cls SpatVector}... ignoring."
      )
      locationpoly <- NULL
    }
  }

  cli::cli_progress_step("Finding number of results...")

  # Find num of results
  basereq <- request("https://api.vbdhub.org") |> req_user_agent("ROHVBD")
  searchreq <- basereq |> req_url_path_append("search")

  req <- searchreq |>
    req_url_query(query = query, database = select_dbs, limit = 1, page = 1)
  if (!(is.null(fromdate))) {
    req <- req |> req_url_query(publishedFrom = fromdate)
  }
  if (!(is.null(todate))) {
    req <- req |> req_url_query(publishedTo = todate)
  }
  if (withoutpublished) {
    req <- req |> req_url_query(withoutPublished = withoutpublished_str)
  }
  if (exact) {
    req <- req |> req_url_query(exact = exact_str)
  }
  if (!(is.null(locationpoly))) {
    req <- req |> req_url_query(geometry = locationpoly)
  }

  if (getOption("ohvbd_dryrun", default = FALSE)) {
    cli::cli_alert_warning("Debug option {.val ohvbd_dryrun} is TRUE.")
    cli::cli_alert_info("Returning request object...")
    return(req)
  }

  resp <- req |> req_perform()

  resp <- resp |> resp_body_json()
  results <- resp$count

  if (results == 0) {
    cli::cli_alert_warning("No results found!")
    return()
  }
  # Calculate number of pages to retrieve
  pages <- seq(1, ceiling(results / 50))

  reqs <- pages |>
    lapply(\(pagenum) {
      req <- searchreq |>
        req_url_query(
          query = query,
          database = select_dbs,
          limit = 50,
          page = pagenum
        )
      if (!(is.null(fromdate))) {
        req <- req |> req_url_query(publishedFrom = fromdate)
      }
      if (!(is.null(todate))) {
        req <- req |> req_url_query(publishedTo = todate)
      }
      if (withoutpublished) {
        req <- req |> req_url_query(withoutPublished = withoutpublished_str)
      }
      if (exact) {
        req <- req |> req_url_query(exact = exact_str)
      }
      if (!(is.null(locationpoly))) {
        req <- req |> req_url_query(geometry = locationpoly)
      }
      req
    })

  cli::cli_progress_step("Retrieving {results} result{?s}")

  resps <- reqs |>
    req_perform_parallel(
      on_error = "continue",
      max_active = connections,
      progress = TRUE
    )

  hits <- resps |>
    resps_successes() |>
    resps_data(\(resp) resp_body_json(resp)$hits)

  if (returnlist) {
    return(hits)
  } else {
    hub_search <- new_ohvbd.hub.search(
      hits,
      query = query,
      searchparams = list(fromdate = fromdate, todate = todate, exact = exact)
    )
    if (simplify && length(db) == 1) {
      return(filter_db(hub_search, db[1]))
    } else {
      return(hub_search)
    }
  }
}


#' @title Filter hub search results by database
#' @description Retrieve the IDs for any datasets matching the given database.
#'
#' @author Francis Windram
#'
#' @param ids an `ohvbd.hub.search` search result from [search_hub()].
#' @param db a database name as a string. One of `"vt"`, `"vd"`, `"gbif"`, `"px"`.
#'
#' @note
#' If [filter_db()] recieves an `ohvbd.ids` object by mistake, it will transparently return it if the source database matches `db`.
#'
#' @return An `ohvbd.ids` vector of dataset IDs.
#'
#' @examplesIf interactive()
#' search_hub("Ixodes ricinus")
#'
#' search_hub("Ixodes ricinus") |>
#'   filter_db("vt") |>
#'   fetch() |>
#'   extract()
#'
#' @concept hub
#'
#' @export
filter_db <- function(ids, db) {
  # If filter_db recieves an ohvbd.ids object, return as is.
  if (inherits(ids, "ohvbd.ids")) {
    if (!is_from(ids, db)) {
      cli::cli_warn(c(
        "!" = "{.arg ids} is an {.cls ohvbd.ids} object from {.val {ohvbd_db(ids)}}, not {.val {db}}!",
        "i" = "Leaving {.arg ids} unchanged."
      ))
    }
    return(ids)
  }

  if (length(db) > 1) {
    db <- db[1]
    cli::cli_warn(c(
      "!" = "{.fn filter_db} only supports filtering one database at once.",
      "i" = "Only returning results from {.val {db}}"
    ))
  }

  database <- db # Just to keep the subset happy, but also to keep the API consistent
  selectedids <- subset(ids, ids$db == database)

  if (database %in% c("vt", "vd")) {
    return(ohvbd.ids(as.numeric(selectedids$id), db = database))
  } else if (db == "gbif") {
    return(ohvbd.ids(selectedids$id, db = database))
  } else {
    return(selectedids$id)
  }
}
