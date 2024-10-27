# nolint start: object_name_linter
new_ohvbd.ids <- function(v, db = NULL) {
  if (is.null(attr(v, "db"))) {
    stopifnot(is.character(db))
    attr(v, "db") <- db
  }
  structure(v, class = c("ohvbd.ids", "numeric"))
}

#' Create a new ohvbd ID vector
#'
#' @description
#' When retrieving data from previous searches (or saved lists of IDs), it can
#' be useful to package these data up in the form that ohvbd would expect to
#' come out of a search.
#'
#' To do this, create an `ohvbd.ids` object, specifying the db that the ids refer to.
#'
#' @author Francis Windram
#'
#' @param ids A numeric vector of ids referring to datasets within the specified database.
#' @param db A string specifying the db that these ids refer to.
#' @returns An id vector: an S3 vector with class `ohvbd.ids`.
#' @export
#' @examples
#' \dontrun{
#' ohvbd.ids(c(1,2,3,4,5), db="vt")
#' }

ohvbd.ids <- function(ids, db) {
  allowed_dbs <- c("vt", "vd")
  if (!is.numeric(ids)) {
    cli::cli_abort("IDs must be numeric!")
  }
  if (!(db %in% allowed_dbs)) {
    cli::cli_abort("DB must be one of {.val {allowed_dbs}}")
  }
  new_ohvbd.ids(ids, db)
}

new_ohvbd.responses <- function(l, db = NULL) {
  if (is.null(attr(l, "db"))) {
    stopifnot(is.character(db))
    attr(l, "db") <- db
  }
  structure(l, class = c("ohvbd.responses", "list"))
}

new_ohvbd.data.frame <- function(df, db = NULL) {
  if (is.null(attr(df, "db"))) {
    stopifnot(is.character(db))
    attr(df, "db") <- db
  }
  structure(df, class = c("ohvbd.data.frame", "data.frame"))
}

new_ohvbd.ad.matrix <- function(m, metric = NULL, gid = NULL, cached = NULL, db = NULL) {
  if (is.null(attr(m, "metric"))) {
    stopifnot(is.character(metric))
    attr(m, "metric") <- metric
  }
  if (is.null(attr(m, "gid"))) {
    stopifnot(is.numeric(gid))
    attr(m, "gid") <- gid
  }
  if (is.null(attr(m, "cached"))) {
    stopifnot(rlang::is_bool(cached))
    attr(m, "cached") <- cached
  }
  if (is.null(attr(m, "db"))) {
    stopifnot(is.character(db))
    attr(m, "db") <- db
  }
  structure(m, class = c("ohvbd.ad.matrix", class(m)))
}
# nolint end
