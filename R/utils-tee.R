#' @title Tee a pipeline to extract the data at a given point
#'
#' @description
#' Add a tee to a pipeline to get the data coming in through the pipe.
#'
#' This is generally a useful function for debugging pipelines, and for caching
#' data after expensive calls. It is also useful if you want the flexibility of
#' multiple calls with the convenience of a fully-piped approach.
#'
#' The name `tee` comes from the [`tee`](https://man7.org/linux/man-pages/man1/tee.1.html) shell command within unix systems.
#'
#' @author Francis Windram
#'
#' @param x The data coming in (whatever it may be).
#' @param .name The name to assign to the output within `.env`.
#' @param .env The environment within which to save the output at this point. Defaults to the caller env (i.e the env which the pipeline is in).
#'
#' @note
#' [tee()] does modify the external environment (if `.env` is not specified).
#' This can lead to unpredictable behaviour if not carefully managed, so it is generally
#' worthwhile restricting usage to interactive situations where the environment
#' can be more carefully monitored.
#'
#' @returns The value that came from the left hand side of the pipe.
#'
#' @export
#'
#' @examples
#' pipeout <- 1:5 |> exp() |> tee("teeout") |> log()
#' print(pipeout)
#' print(teeout)
#'
#' myenv <- new.env()
#' pipeout <- 1:5 |> exp() |> tee("teeout", .env = myenv) |> log()
#' print(myenv$teeout)

tee <- function(x, .name="teeout", .env=NULL) {
  if (is.null(.env)) {
    .env <- rlang::caller_env()
  }
  .env[[.name]] <- x
  return(x)
}
