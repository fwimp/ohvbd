#' @title Check whether databases are currently online
#' @description Attempt to access all presently supported databases and report if they were accessible.
#'
#' @author Francis Windram
#'
#' @return NULL
#'
#' @examples
#' \dontrun{
#'   check_db_status()
#' }
#'
#' @export
#'

check_db_status <- function(){
  db_list <- c(
    VectorByte="https://vectorbyte.crc.nd.edu/portal/api/",
    Areadata="https://github.com/pearselab/areadata/raw/main/output/"
  )

  for (i in seq_along(db_list)){
    statuscode <- tryCatch({
      out <- request(db_list[i]) %>% req_user_agent("ROHVBD") %>% req_perform()
      out$status_code
    }, error = function(cnd) {
      out <- last_response()
      out$status_code
    }
    )
    if (200 <= statuscode & statuscode < 300) {
      cat(paste0("\n",names(db_list)[i], ": UP"))
    } else {
      cat(paste0("\n",names(db_list)[i], ": DOWN"))
    }
  }

}
