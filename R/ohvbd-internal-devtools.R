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
#'
.precompute_vignettes <- function(d = "vignettes", cores = 8, pkgpath = ".", onlymodified = TRUE, fileext = ".orig") {
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
    }, error = function(e) {
      cli::cli_abort(c("x" = "Failed for some reason (try with {.arg {cores = 1}})"), parent = e)
    }, finally = {
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

#' @title Find the functions called in an R file
#'
#' @param f An R file to parse.
#' @param packagepath The path of the package which contains these files (or `NULL`).
#' @param excludebase Whether to exclude base packages (defaults to `TRUE`).
#' @param call The env from which this was called (defaults to the direct calling environment).
#'
#' @note The path in `packagepath` should contain the NAMESPACE file of the package.
#'
#' If it is not provided, then functions specifically imported will show as belonging to the package rather than their origin.
#'
#' @returns A data.frame containing all functions called in the file (**funcs**),
#' the package these functions originate from (**package**),
#' and the function within `f` that called them (**caller**).
#'
#' @examples
#' .parse_file_function_calls("./R/ohvbd-internal-devtools.R", packagepath = ".")
#'
.parse_file_function_calls <- function(f, packagepath = NULL, excludebase = TRUE, call = rlang::caller_env()) {
  if (!file.exists(f)) {
    cli::cli_abort(c("x" = "File {.path {f}} does not exist!"), call = call)
  }

  f_data <- getParseData(parse(f, keep.source = TRUE))

  # Find specific function definitions within the file
  # (to do this, find where token == FUNCTION), then for each check if the thing 2 before it is a left assign.
  # For each of these, find line1 col1 and line2 col2 of the expr one before the FUNCTION. These are the start and end points of the function. Add the name of the function (the index of the parent of this expr + 1)

  max_colsize <- max(max(f_data$col1), max(f_data$col2))
  f_data$l1pos <- (f_data$line1-1)*max_colsize + f_data$col1
  f_data$l2pos <- (f_data$line2-1)*max_colsize + f_data$col2

  func_ids <- which(f_data$token == "FUNCTION")
  func_rows <- f_data[func_ids-1,]

  if(nrow(func_rows) < 1) {
    cli::cli_alert_warning(cli::col_yellow("No functions found in file {.path {f}}!"))
    outdf <- data.frame(
      func = character(),
      package = character(),
      caller = character()
    )
    return(outdf)
  }

  # If func_rows == 1, skip the next bit
  if (nrow(func_rows) > 1) {
    # Now pare down this list so no function is wholly within another function
    func_rows_tokeep <- rlang::rep_along(func_rows$id, TRUE)
    cart_prod <- expand.grid(seq_along(func_rows$id), seq_along(func_rows$id))
    cart_prod <- cart_prod[which(cart_prod$Var1 != cart_prod$Var2),]

    for (i in 1:nrow(cart_prod)) {
      # Skip if we've already done it.
      if (func_rows_tokeep[cart_prod$Var1[i]]) {
        # Row which we are testing
        testrow <- func_rows[cart_prod$Var1[i], ]
        # Row which we are seeing whether the above is fully within
        withinrow <- func_rows[cart_prod$Var2[i], ]

        # If we start after and end before then we are enclosed
        if (testrow$l1pos > withinrow$l1pos && testrow$l2pos < withinrow$l2pos) {
          func_rows_tokeep[cart_prod$Var1[i]] <- FALSE
        }
      }
    }
    # Filter out functions that are within other functions
    func_rows <- func_rows[func_rows_tokeep,]
    # Do the same for ids to keep track
    func_ids <- func_ids[func_rows_tokeep]
  }

  # Find the name of the functions (always 4 indices before the func itself because R)
  func_rows$name <- f_data$text[func_ids-4]

  # Filter to only SYMBOL_FUNCTION_CALL
  symbol_func_call_ids <- which(f_data$token %in% c("SYMBOL_FUNCTION_CALL", "SPECIAL"))
  symbol_func_calls <- f_data[symbol_func_call_ids,]
  # add col of index in f_data
  symbol_func_calls$idx <- symbol_func_call_ids
  # Find which function each SYMBOL_FUNCTION_CALL is in.
  symbol_func_calls$calling_function <- apply(
    # Only use the appropriate columns to make sure everything comes through as numeric
    symbol_func_calls[,c("l1pos", "l2pos")],
    MARGIN = 1,
    \(x, r) {
      calling_function <- NA
      for (i in 1:nrow(r)) {
        if (x["l1pos"] >= r[i,"l1pos"] && x["l2pos"] <= r[i,"l2pos"]) {
          calling_function <- r[i, "name"]
          break
        }
      }
      calling_function
    }, r = func_rows)

  # Get unique function names to check
  called_func_names <- unique(symbol_func_calls$text)
  # Find functions in current environment
  # Extra wrapper around find to handle function overloading.
  called_func_packages <- gsub("package:", "", as.vector(sapply(called_func_names, \(x){find(x)[1]})))
  names(called_func_packages) <- called_func_names
  called_func_packages[called_func_packages == "character(0)"] <- NA

  # Match up funcs with their packages from the current environment
  symbol_func_calls$package <- called_func_packages[symbol_func_calls$text]

  # Find double-dotted function calls and resolve those
  potential_package_names <- f_data[symbol_func_calls[which(is.na(symbol_func_calls$package)),"idx"] - 2, "text"]
  not_doublecoloned <- f_data[symbol_func_calls[which(is.na(symbol_func_calls$package)),"idx"] - 1, "text"] != "::"
  # Remove any potential package names that do not have a :: after
  potential_package_names[not_doublecoloned] <- NA
  symbol_func_calls[which(is.na(symbol_func_calls$package)),"package"] <- potential_package_names

  # Package up for return
  outdf <- data.frame(
    func = symbol_func_calls$text,
    package = symbol_func_calls$package,
    caller = symbol_func_calls$calling_function
  )

  if (excludebase) {
    outdf <- outdf[which(outdf$package != "base"),]
  }

  # If namespace file is present, overlay package names as appropriate
  if (!is.null(packagepath) && nrow(outdf) >= 1) {
    outdf$package <- tryCatch(
      {
        ns_data <- data.table::rbindlist(pkgload::parse_ns_file(file.path(packagepath, "NAMESPACE"))[["imports"]])
        colnames(ns_data) <- c("package", "func")
        refined_packages <- as.character(
          unlist(
            apply(
              outdf,
              MARGIN = 1,
              \(x, ns) {
                in_ns <- x["func"] == ns[,"func"]
                if (any(in_ns)) {
                  return(ns[which(in_ns),"package"])
                }
                x["package"]
              },
              ns = ns_data
            )
          )
        )
        refined_packages
      }, error = function(e) {
        cli::cli_warn(c("!" = "Could not parse NAMESPACE!", "i" = "Function packages may not be the root origin (if loaded using {.arg @importFrom})."))
        outdf$package
      }
    )
  }
  rownames(outdf) <- NULL
  outdf
}

#' @title Find the functions called in a folder of R files
#'
#' @param folder An folder of R files to parse.
#' @param packagepath The path of the package which contains these files (or `NULL`).
#' @param returndistinct Whether to return only distinct calls from one func to another (defaults to `TRUE`).
#' @param excludebase Whether to exclude base packages (defaults to `TRUE`).
#'
#' @note The path in `packagepath` should contain the NAMESPACE file of the package.
#'
#' If it is not provided, then functions specifically imported will show as belonging to the package rather than their origin.
#'
#' @returns A data.frame containing all functions called in the folder (**funcs**),
#' the package these functions originate from (**package**),
#' and the function within files of `folder` that called them (**caller**).
#'
#' @examples
#' .parse_folder_function_calls("./R", packagepath = ".")
#'
.parse_folder_function_calls <- function(folder, packagepath = NULL, returndistinct = TRUE, excludebase = TRUE) {
  toparse <- list.files(folder, pattern = "*.R", full.names = TRUE)
  outlist <- list()
  x <- ""
  cli::cli_progress_bar(format = "Parsing files {cli::pb_bar} [{cli::pb_current}/{cli::pb_total}] ETA:{cli::pb_eta}", total = length(toparse))
  for (x in toparse) {
    cli::cli_progress_update()
    funcs <- .parse_file_function_calls(x, packagepath, excludebase)
    outlist <- append(outlist, list(funcs))
    cli::cli_alert_success("Parsed {.path {x}}")
  }
  cli::cli_progress_done()

  outdf <- data.table::rbindlist(outlist)
  # Consider maybe another function that extends this list by incorporating the list of all functions within the package itself.
  if (returndistinct) {
    outdf <- dplyr::distinct(outdf)
  }
  return(outdf)
}

#' @title Find the functions that a given function depends upon
#'
#' @param name The name of a function in `func_calls` to evaluate.
#' @param func_calls A data.frame of functions called, the packages these functions are from, and the caller (as created by `.parse_folder_function_calls()`)
#'
#' @returns a data.frame of packages and functions called by the named function (and by its called functions, recursively).
#'
#' @examples
#' func_calls <- .parse_folder_function_calls("./R", packagepath = ".")
#' .find_function_deps("glean_vt", func_calls)
.find_function_deps <- function(name, func_calls) {
  if (!(name %in% func_calls$caller)) {
    cli::cli_abort(c("x" = "Function not found or does not call anything else."))
  }
  called_funcs <- func_calls$func[which(func_calls$caller == name)]
  new_called_funcs <- called_funcs
  while (length(new_called_funcs) >= 1) {
    new_called_funcs <- func_calls$func[which(func_calls$caller %in% new_called_funcs)]
    new_called_funcs <- setdiff(new_called_funcs, called_funcs)
    called_funcs <- union(new_called_funcs, called_funcs)
  }
  pkgs <- func_calls$package[match(called_funcs, func_calls$func)]
  outdf <- data.frame(package = pkgs, func = called_funcs)
  outdf <- outdf |> dplyr::arrange(package, func)
  return(outdf)
}

#' @title Find the functions that depend upon a given function
#'
#' @param name The name of a function in `func_calls` to evaluate.
#' @param func_calls A data.frame of functions called, the packages these functions are from, and the caller (as created by `.parse_folder_function_calls()`)
#'
#' @returns A vector of package functions that depend directly or indirectly on `name`.
#'
#' @examples
#' func_calls <- .parse_folder_function_calls("./R", packagepath = ".")
#' .find_function_revdeps("get_default_ohvbd_cache", func_calls)
.find_function_revdeps <- function(name, func_calls) {
  if (!(name %in% func_calls$func)) {
    cli::cli_abort(c("x" = "Function not called by anything."))
  }

  calling_funcs <- func_calls$caller[which(func_calls$func == name)]
  new_calling_funcs <- calling_funcs

  while (length(new_calling_funcs) >= 1) {
    new_calling_funcs <- func_calls$caller[which(func_calls$func %in% new_calling_funcs)]
    new_calling_funcs <- setdiff(new_calling_funcs, calling_funcs)
    calling_funcs <- union(new_calling_funcs, calling_funcs)
  }

  return(calling_funcs)
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
