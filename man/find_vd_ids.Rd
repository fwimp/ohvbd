% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/find_vd_ids.R
\name{find_vd_ids}
\alias{find_vd_ids}
\title{Get current IDs in VecDyn}
\usage{
find_vd_ids(basereq = NA)
}
\arguments{
\item{basereq}{an \link[httr2:request]{httr2 request} object, as generated by \code{\link[=vb_basereq]{vb_basereq()}}. If \code{NA}, uses the default request.}
}
\value{
An \code{ohvbd.ids} vector of VecDyn dataset IDs.
}
\description{
Get all the current dataset IDs in VecDyn, as a numeric vector.
}
\examples{
\dontrun{
find_vd_ids()
}

}
\author{
Francis Windram
}
\concept{vecdyn}
