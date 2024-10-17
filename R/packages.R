#' Core OHA tools
#' @keywords internal
core <- c("gophr",
          "glamr",
          "glitr",
          "gisr"
          )

#' List all OHA Packages
#'
#' @param include_self Include gagglr in the list?
#' @export
#' @examples
#' oha_packages()
oha_packages <- function(include_self = TRUE) {
  raw <- utils::packageDescription("gagglr")$Remotes
  imports <- strsplit(raw, ",")[[1]]
  parsed <- gsub("^\\s+|\\s+$", "", imports)
  sans_repo <- gsub("USAID-OHA-SI\\/", "", parsed)
  names <- vapply(strsplit(sans_repo, "\\s+"), "[[", 1, FUN.VALUE = character(1))

  if (include_self) {
    names <- c(names, "gagglr")
    names <- sort(names)
  }

  names
}
