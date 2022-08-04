#' Minimially adapted from tidyverse
#' https://github.com/tidyverse/tidyverse/blob/main/R/attach.R


#' Load packages at start up
#'
oha_attach <- function(){
  to_load <- core_unloaded()
  if (length(to_load) == 0)
    return(invisible())

  message(
    cli::rule(
      left = crayon::bold("Attaching packages"),
      right = paste0("OHA tools ", utils::packageVersion("gagglr"))
    ))

  versions <- vapply(to_load, package_version, character(1))

  update_needed <- suppressMessages(suppressWarnings(
    vapply(core, check_updates, character(1))
  ))

  packages <- paste0(
    crayon::green(cli::symbol$tick), " ", crayon::blue(format(to_load)), " ",
    crayon::col_align(versions, max(crayon::col_nchar(versions))), " ",
    crayon::col_align(update_needed, max(crayon::col_nchar(update_needed)))
  )
  packages_missing <- paste0(
    crayon::red(cli::symbol$cross), " ", crayon::silver(format(setdiff(core, to_load))))

  packages_all <- c(packages, packages_missing)
  message(paste(packages_all, collapse = "\n"))

  suppressPackageStartupMessages(
    lapply(to_load, load_pkg)
  )

  invisible()
}

core_unloaded <- function() {
  core_instlld <- core[vapply(core, requireNamespace, quietly = TRUE, FUN.VALUE = logical(1))]
  core_pkgs <- paste0("package:", core_instlld)
  core_instlld[!core_pkgs %in% search()]
}

load_pkg <- function(pkg){
  do.call(
    "library",
    list(pkg, character.only = TRUE, warn.conflicts = FALSE)
  )
}

package_version <- function(x) {
  version <- as.character(unclass(utils::packageVersion(x))[[1]])

  if (length(version) > 3) {
    version[4:length(version)] <- crayon::red(as.character(version[4:length(version)]))
  }
  paste0(version, collapse = ".")
}
