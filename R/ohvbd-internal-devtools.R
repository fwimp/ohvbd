# Internal dev functions

#' @title Precompute package vignettes (INTERNAL ONLY)
#'
#' @description
#' Precompute all ".orig" package vignettes within the vignettes folder.
#'
#' @param d Directory of vignettes.
#' @param cores Number of cores to use in parallel mode.
#' @param pkgpath The path of the package (if not in the current dir).
#' @param onlynodified Only re-compute modified readmes (defaults to TRUE).
#' @param fileext The file extension of the file (with the ".", defaults to .orig).
#'
#' @note
#' This is only useful when developing `ohvbd` (or other packages I suppose).
#'
#' This function also requires the following packages:
#'
#' - rlang
#' - cli
#' - stringr
#' - knitr
#' - doParallel
#' - foreach
#' - parallel
#' - devtools
#' - withr
#'
#' @author Francis Windram
#'
#' @examplesIf interactive()
#' .precompute_vignettes("vignettes")


.precompute_vignettes <- function(d, cores = 8, pkgpath = ".", onlymodified = TRUE, fileext = ".orig") {
  rlang::check_installed(c("cli", "withr", "devtools", "knitr"))
  parmode <- rlang::is_installed(c("stringr", "knitr", "doParallel", "foreach", "parallel"))
  if (!getOption("ohvbd_devmode", default = FALSE)) {
    cli::cli_alert_warning("This function is only intended to be used for development and should not be used otherwise!")
  }
  local_knit <- function(inpath, outpath, pkg) {
    # Force packages to be built in their own local env
    withr::local_environment(new.env())
    # Triple dots are generally very bad form, but this is only for dev work
    devtools:::local_install(pkg, quiet = TRUE)
    knitr::knit(inpath, output = outpath, quiet = TRUE)
  }

  # Set up for run
  pkg <- devtools::as.package(pkgpath)
  vs <- list.files("vignettes", pattern = paste0("*", fileext), full.names = TRUE)
  outfiles <- stringr::str_replace(vs, stringr::fixed(fileext), ".Rmd")

  # Check for a lack of files!
  if (length(vs) < 1) {
    cli::cli_abort(c("x" = 'No "{fileext}" files detected in {.path {d}}!'))
  }

  if (onlymodified) {
    tokeep <- rlang::rep_along(vs, FALSE)
    for (i in 1:length(vs)) {
      if (file.exists(outfiles[i])) {
        if (file.mtime(vs[i]) > file.mtime(outfiles[i])) {
          # If orig is newer than Rmd
          tokeep[i] <- TRUE
        }
      } else {
        # If there is no Rmd file
        tokeep[i] <- TRUE
      }
    }
    vs <- vs[tokeep]
    outfiles <- outfiles[tokeep]
  }

  # Check for a lack of files again!
  if (length(vs) < 1) {
    cli::cli_alert_success('No modified "{fileext}" files detected in {.path {d}}!')
    return(invisible(NULL))
  }

  cli::cli_alert("{length(vs)} vignette{?s} to render!")

  if (parmode && (cores > 1) && (length(vs) > 1)) {
    # Set up parallel cluster
    n_cores <- parallel::detectCores()
    n_jobs <- length(vs)
    max_cores <- min(cores, n_cores - 1)
    req_cores <- min(n_jobs, max_cores)
    cluster <- parallel::makeCluster(req_cores)
    doParallel::registerDoParallel(cluster)
    cli::cli_progress_step('Rendering {length(vs)} "{fileext}" {cli::qty(vs)}vignette{?s} in parallel on {req_cores} cores.')

    # Run job in parallel
    done <- tryCatch({
      foreach::`%dopar%`(foreach::foreach(i=1:length(vs), .combine = c), {
        local_knit(vs[i], outfiles[i], pkg)
      })
    }, error = function(e) {cli::cli_abort(c("x" = "Failed for some reason (try with {.arg {cores = 1}})"), parent = e)}, finally = {
      # Always tear down cluster afterwards
      parallel::stopCluster(cl = cluster)
      cli::cli_progress_done()
      # Just in case this is turned off in the session and escapes the parallelism
      options("cli.default_handler" = NULL)
    })
  } else {
    for (i in 1:length(vs)) {
      withr::with_environment(new.env(), {
        knitr::knit(vs[i], output = outfiles[i], quiet = TRUE)
        # Just in case this is turned off in the session
        options("cli.default_handler" = NULL)
      })
      cli::cli_alert_success("Rendered {.path {outfiles[i]}}.")
    }
    cli::cli_progress_done()
  }
  cli::cli_alert_success("Rendered {length(vs)} vignette{?s}.")
  invisible(NULL)
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
