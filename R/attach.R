#Lightly adapted from tidyverse
#https://github.com/tidyverse/tidyverse/blob/main/R/attach.R

#' Core OHA tools
core <- c("gisr",
          "glamr",
          "glitr",
          "gophr")

#' Additional OHA tools
addtl <- c("COVIDutilities",
           "mindthegap",
           "selfdestructin5",
           "tameDP",
           "Wavelength")



attach_oha <- function(){
  to_load <- core_unloaded()
  if (length(to_load) == 0)
    return(invisible())

  message(
    cli::rule(
      left = crayon::bold("Attaching packages"),
      right = paste0("OHA tools ", utils::packageVersion("gagglr"))
    )
  )

  versions <- vapply(to_load, package_version, character(1))

  packages <- paste0(
    crayon::green(cli::symbol$tick), " ", crayon::blue(format(to_load)), " ",
    crayon::col_align(versions, max(crayon::col_nchar(versions)))
  )

  message(paste(packages, collapse = "\n"))

  suppressPackageStartupMessages(
    lapply(to_load, load_pkg)
  )
}

core_unloaded <- function() {
  core_pkgs <- paste0("package:", core)
  core[!core_pkgs %in% search()]
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

