% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/check_updates.R
\name{extract_local_sha}
\alias{extract_local_sha}
\title{Extract Local SHA}
\usage{
extract_local_sha(name)
}
\arguments{
\item{name}{package name}
}
\value{
40 character SHA hash vector
}
\description{
Pulls the latest SHA (commit ID) from Package Info or uses rOpenSci API
}
\keyword{internal}
