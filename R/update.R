#' Update OHA packages
#'
#' This will check to see if all your OHA packages are up-to-date, and will
#' install after an interactive confirmation. The versions may match between
#' GitHub and your local environment, but may still be behind on recent commits
#' that do not merit a full version update.
#'
#' @param install do you want to install or just print the status, default =
#'   FALSE
#' @param core_only only check/install core OHA package? default = FALSE
#'
#' @export
#' @examples
#' \dontrun{
#' #list of what packages are out of date/non installed w/ code to install
#' oha_update()
#'
#' #interactively install core packages
#' oha_update(install = TRUE, core_only = TRUE)
#'
#' #automatically install all OHA packages
#' oha_update(install = TRUE)
#' }
oha_update <- function(install = FALSE, core_only = FALSE) {

  behind <- oha_outdated(core_only)

  if(nrow(behind) == 0) {
    cli::cat_line("All OHA packages up-to-date")
    return(invisible())
  }

  if(install == FALSE){
    cli::cat_line(cli::pluralize(
      "The following {cli::qty(nrow(behind))}package{?s} {?is/are} out of date:"
    ))
    cli::cat_line()
    cli::cat_bullet(format(behind$package), " (", behind$version, ")")
    cli::cat_line()
    cli::cat_line("Start a clean R session then run:")
    gh_pkgs_str <- paste0(deparse(behind$package_gh), collapse = "\n")
    cli::cat_line("pak::pak(", gh_pkgs_str, ")")
  } else if(core_only == TRUE) {
    rstudioapi::restartSession("gagglr:::oha_install_outdated(core_only = TRUE)")
  } else {
    rstudioapi::restartSession("gagglr:::oha_install_outdated()")
  }

  invisible()
}


#' Identify Outdated OHA packages
#'
#' @inheritParams oha_update
#'
#' @keywords internal
#' @return df of outdated or missing packages
oha_outdated <- function(core_only = FALSE){

  df_pkg <- oha_tbl()
  behind <- dplyr::filter(df_pkg, behind)

  if(core_only)
    behind <- dplyr::filter(behind, core == TRUE | package == "gagglr")

  behind <- behind %>%
    dplyr::mutate(package_gh = paste0("USAID-OHA-SI/", package))

  return(behind)

}

#' Install Outdated or Missing OHA Packages
#'
#' Used to automatically install any missing or outdated OHA packages from
#' GitHub. Ideally running with just core packages and other packages should
#' be installed individually using `pak::pak("USAID-OHA-SI/[name]")`.
#'
#' @inheritParams oha_update
#'
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' oha_install_outdated()
#' }
oha_install_outdated <- function(core_only = FALSE){
  gh_pkgs <- oha_outdated(core_only)$package_gh

  if(length(gh_pkgs) == 0) {
    cli::cat_line("All OHA packages up-to-date")
    return(invisible())
  }

  pak::pak(gh_pkgs)
}

#' Get a situation report on OHA packages
#'
#' This function gives a quick overview of the versions of R and RStudio as
#' well as all OHA packages. It's primarily designed to help you get
#' a quick idea of what's going on when you're helping someone else debug
#' a problem.
#'
#' @export
oha_sitrep <- function() {
  cli::cat_rule("R & RStudio")
  if (rstudioapi::isAvailable()) {
    cli::cat_bullet("RStudio: ", rstudioapi::getVersion())
  }
  cli::cat_bullet("R: ", getRversion())

  df_pkg <- oha_tbl()

  package_pad <- format(df_pkg$package)
  version_pad <- format(df_pkg$version)

  packages <- dplyr::case_when(
    df_pkg$status_code == "?" ~ paste0(cli::col_grey(package_pad), " (", version_pad, ")", cli::col_grey(" [", df_pkg$date, ", local build]")),
    df_pkg$behind ~ paste0(cli::col_yellow(cli::style_bold(package_pad)), " (", version_pad, ")", cli::col_grey(" [", df_pkg$date, "]")),
    TRUE ~ paste0(package_pad, " (", version_pad, ")")
  )

  cli::cat_rule("Core packages")
  cli::cat_bullet(packages[df_pkg$package %in% core])
  cli::cat_rule("Non-core packages")
  cli::cat_bullet(packages[!df_pkg$package %in% core])
}


#' List all OHA functions and versions as a table
#' @keywords internal
oha_tbl <- function() {

  pkgs <- oha_packages()

  update_needed <- suppressMessages(suppressWarnings(
    vapply(pkgs, oha_check, character(1))
  ))

  versions <- sessioninfo::package_info(pkgs, dependencies = FALSE) %>%
    dplyr::select(package, version = ondiskversion, date)


  tibble::tibble(package = pkgs,
                 core = package %in% core,
                 status_code = update_needed,
                 status_desc = dplyr::case_when(status_code == "*" ~ "Newer commit exist on GitHub",
                                                status_code == "" ~ "Up to date",
                                                status_code == "?" ~ "Unknown status: package built locally",
                                                status_code == "^" ~ "Package not installed"),
                 behind = status_desc != "Up to date") %>%
    dplyr::left_join(versions, by = "package") %>%
    dplyr::mutate(date = ifelse(is.na(date), "Not installed", date))
}
