#' Update OHA packages
#'
#' This will check to see if all your OHA packages are up-to-date, and will
#' install after an interactive confirmation. The versions may match between
#' GitHub and your local environment, but may still be behind on recent commits
#' that do not merit a full version update.
#'
#' @export
#' @examples
#' \dontrun{
#' oha_update()
#' }
oha_update <- function() {

  df_pkg <- oha_tbl()
  behind <- dplyr::filter(df_pkg, behind)

  if (nrow(behind) == 0) {
    cli::cat_line("All OHA packages up-to-date")
    return(invisible())
  }

  cli::cat_line(cli::pluralize(
    "The following {cli::qty(nrow(behind))}package{?s} {?is/are} out of date:"
  ))
  cli::cat_line()
  cli::cat_bullet(format(behind$package), " (", behind$version, ")")

  cli::cat_line()
  cli::cat_line("Start a clean R session then run:")

  gh_pkgs <-paste0("USAID-OHA-SI/", behind$package)
  gh_pkgs_str <- paste0(deparse(gh_pkgs), collapse = "\n")
  cli::cat_line("remotes::install_github(", gh_pkgs_str, ")")

  invisible()
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
#'
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
