#' @title Retrieve citations for vectraits data
#' @description
#' Retrieve citations for vectraits data either directly from the dataset or by
#' redownloading the appropriate data.
#'
#' @author Francis Windram
#'
#' @param dataset The dataset from which you wish to retrieve citations.
#' @param redownload Redownload data if citation columns are missing.
#' @param minimise Whether to return one row per citation (rather than one per dataset ID).
#'
#' @returns `ohvbd.data.frame` of citation data
#'
#' @concept vectraits
#' @export
#'

fetch_citations_vt <- function(dataset, redownload = TRUE, minimise=FALSE) {
  if (!has_db(dataset)) {
    cli::cli_alert_warning("IDs not necessarily from VecTraits.")
  } else if (!is_from(dataset, "vt")) {
    cli::cli_abort(c(
      "x" = "IDs not from VecTraits, Please use the {.fn fetch_citations_{ohvbd_db(dataset)}} function.",
      "!" = "Detected database = {.val {ohvbd_db(dataset)}}"
    ))
  }

  if (missing(redownload)) {
    redownload <- TRUE
  }

  cite_cols <- c(
    "Citation",
    "CuratedByCitation",
    "CuratedByDOI",
    "DOI",
    "SubmittedBy",
    "ContributorEmail"
  )
  missing_cols <- setdiff(cite_cols, colnames(dataset))
  present_cols <- setdiff(cite_cols, missing_cols)
  if (length(missing_cols) > 0) {
    if (redownload) {
      if ("DatasetID" %in% colnames(dataset)) {
        cli::cli_alert_warning(
          "Dataset is missing {.val {length(missing_cols)}} citation column{?s}:"
        )
        cli::cli_ul(missing_cols)
        cli::cli_alert_info("Redownloading data to get these cols.")
        # Redownload data
        citations <- ohvbd.ids(unique(dataset$DatasetID), "vt") |>
          fetch() |>
          glean(cols = c("DatasetID", cite_cols))
      } else {
        cli::cli_abort(c(
          "x" = "Cannot retrieve citation",
          "!" = "Dataset is missing {.val {length(missing_cols)}} citation column{?s}: {.val {missing_cols}}",
          "!" = "Dataset is further missing {.val DatasetID} column, which is required for redownloading"
        ))
      }
    } else if (length(missing_cols) == length(cite_cols)) {
      cli::cli_abort(c(
        "x" = "Cannot retrieve citation",
        "!" = "Dataset is missing all {.val {length(missing_cols)}} citation column{?s}: {.val {missing_cols}}",
        "!" = "{.arg redownload} is {.val {FALSE}}"
      ))
    } else {
      cli::cli_warn(c(
        "!" = "Dataset is missing {.val {length(missing_cols)}} citation column{?s}: {.val {missing_cols}}",
        "i" = "Returning only the present columns as {.arg redownload} is {.val {FALSE}}."
      ))
      # Return present citation columns
      citations <- dataset[, c("DatasetID", present_cols)]
    }
  } else {
    # Just get citation columns
    citations <- dataset[, c("DatasetID", cite_cols)]
  }
  if (minimise) {
    outcites <- citations |> dplyr::select(-c("DatasetID")) |> dplyr::distinct()
  } else {
    outcites <- dplyr::distinct(citations)
  }
  return(new_ohvbd.data.frame(outcites, "vt"))
}

#' @title Retrieve citations for vecdyn data
#' @description
#' Retrieve citations for vecdyn data either directly from the dataset or by
#' redownloading the appropriate data.
#'
#' @author Francis Windram
#'
#' @param dataset The dataset from which you wish to retrieve citations.
#' @param redownload Redownload data if citation columns are missing.
#' @param minimise Whether to return one row per citation (rather than one per dataset ID).
#'
#' @returns `ohvbd.data.frame` of citation data
#'
#' @concept vecdyn
#' @export
#'

fetch_citations_vd <- function(dataset, redownload = TRUE, minimise = FALSE) {
  if (!has_db(dataset)) {
    cli::cli_alert_warning("IDs not necessarily from VecDyn.")
  } else if (!is_from(dataset, "vd")) {
    cli::cli_abort(c(
      "x" = "IDs not from VecDyn, Please use the {.fn fetch_citations_{ohvbd_db(dataset)}} function.",
      "!" = "Detected database = {.val {ohvbd_db(dataset)}}"
    ))
  }

  cite_cols <- c(
    "contact_name",
    "contributoremail",
    "submittedby",
    "citation",
    "collection_author_name",
    "contact_affiliation",
    "curatedbycitation",
    "curatedbydoi",
    "data_rights",
    "dataset_license",
    "doi",
    "email"
  )

  missing_cols <- setdiff(cite_cols, colnames(dataset))
  present_cols <- setdiff(cite_cols, missing_cols)
  if (length(missing_cols) > 0) {
    if (redownload) {
      if ("dataset_id" %in% colnames(dataset)) {
        cli::cli_alert_warning(
          "Dataset is missing {.val {length(missing_cols)}} citation column{?s}:"
        )
        cli::cli_ul(missing_cols)
        cli::cli_alert_info(
          "Redownloading data to get these cols (if they exist)."
        )
        # Redownload data
        citations_resps <- ohvbd.ids(unique(dataset$dataset_id), "vd") |>
          fetch_vd_meta(pb_name = "VecDyn citations")

        resp_parsed <- citations_resps |>
          lapply(\(resp) {
            resp_data <- resp_body_json(resp)$consistent_data
            present_cols <- intersect(cite_cols, names(resp_data))
            resp_data[present_cols]
          })

        citations <- cbind(
          data.frame(dataset_id = unique(dataset$dataset_id)),
          rbindlist(resp_parsed, fill = TRUE)
        )
      } else {
        cli::cli_abort(c(
          "x" = "Cannot retrieve citation",
          "!" = "Dataset is missing {.val {length(missing_cols)}} citation column{?s}: {.val {missing_cols}}",
          "!" = "Dataset is further missing {.val dataset_id} column, which is required for redownloading"
        ))
      }
    } else if (length(missing_cols) == length(cite_cols)) {
      cli::cli_abort(c(
        "x" = "Cannot retrieve citation",
        "!" = "Dataset is missing all {.val {length(missing_cols)}} citation column{?s}: {.val {missing_cols}}",
        "!" = "{.arg redownload} is {.val {FALSE}}"
      ))
    } else {
      cli::cli_warn(c(
        "!" = "Dataset is missing {.val {length(missing_cols)}} citation column{?s}: {.val {missing_cols}}",
        "i" = "Returning only the present columns as {.arg redownload} is {.val {FALSE}}."
      ))
      # Return present citation columns
      citations <- dataset[, c("dataset_id", present_cols)]
    }
  } else {
    # Just get citation columns
    citations <- dataset[, c("dataset_id", cite_cols)]
  }

  if (minimise) {
    outcites <- citations |> dplyr::select(-c("dataset_id")) |> dplyr::distinct()
  } else {
    outcites <- dplyr::distinct(citations)
  }

  return(new_ohvbd.data.frame(outcites, "vd"))
}
