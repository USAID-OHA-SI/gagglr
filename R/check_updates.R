#' Check for OHA package updates
#'
#' This function compares the local version of the package against what is
#' stored on GitHub to flag whether or not you have the latest version.
#'
#' @param name package name
#' @param url user/organization url, default = "https://github.com/USAID-OHA-SI"
#' @param suppress_success suppress message if up to date, default = FALSE
#'
#' @return message if there is a newer package on GH than local
#' @export
#'
#' @examplesIf FALSE
#' oha_check("gophr")
#' oha_check("glamr")

oha_check <- function(name, url = "https://github.com/USAID-OHA-SI", suppress_success = FALSE) {

  #if nothing specified, run against all packages
  if(missing(name))
    return(oha_sitrep())

  #identify organization
  org <- stringr::str_remove(url, "https://github.com/")

  # Extract remote SHA Code
  remote_sha <- extract_remote_sha(name, url)

  # Local SHA Code
  local_sha <- NULL

  #package source
  src <- sessioninfo::package_info(name, dependencies = FALSE)$source

  # package not installed or built locally
  if(is.na(src)) {
    cli::cli_alert_danger("{.pkg {name}} status: {cli::col_br_red('UNINSTALLED')} - unable to identify/locate package")
    return(invisible("^"))
  }

  # Package built locally
  if (src %in% c("local", "load_all()")) {
    cli::cli_alert_warning("{.pkg {name}} status: {cli::col_br_yellow('UNKNOWN')} - unable to identify status (via sha code) for package built locally")
    return(invisible("?"))
  }

  # CRAN Packages
  if (stringr::str_detect(src, "CRAN")) {
    cli::cli_alert_warning("{.pkg {name}} status: {cli::col_br_yellow('UNKNOWN')} - unable to identify status (via sha code) for CRAN package")
    return(invisible("?"))
  }

  # Extract local SHA Code
  if (stringr::str_detect(src, "Github")) {
    #package installed
    local_sha <- stringr::str_extract(src, "(?<=\\@).*(?=\\))")
  }

  # Check for valid github sha
  if(!is.null(local_sha) & (is.na(local_sha) | local_sha == "")) {
    cli::cli_alert_warning("{.pkg {name}} status: {cli::col_br_yellow('UNKNOWN')} - unable to identify status (via sha code) for this Github package")
    return(invisible("?"))
  }

  # Compare local to remote SHA
  new_updates = remote_sha != local_sha

  # Package is out of date on GitHub
  if (!is.null(local_sha) & new_updates) {
    cli::cli_alert_warning("{.pkg {name}} status: {cli::col_br_yellow('OUT OF DATE')} - local version of package is behind the latest release on GitHub")
    print_update_text(name, org)
    return(invisible("*"))
  }

  # Package is up to date on GitHub
  if (!is.null(local_sha) & !new_updates & !suppress_success) {
    cli::cli_alert_info("{.pkg {name}} status: {cli::col_br_cyan('UP TO DATE')} - local version of package matches the latest release on GitHub")
  }

  # Package is up to date on GitHub (return blank placeholder for oha_sitrep)
  if (!is.null(local_sha) & !new_updates) {
    return(invisible(""))
  }

  # return(new_updates)
}


#' Extract Remote SHA
#'
#' Pulls the latest SHA (commit ID) from GitHub
#'
#' @param name package name
#' @param url user/organization url, default = "https://github.com/USAID-OHA-SI/"
#'
#' @return 40 character SHA hash vector
#' @keywords internal
#'
extract_remote_sha <- function(name, url = "https://github.com/USAID-OHA-SI"){

  repo_url <- paste(url, name, sep = "/")

  remote_sha <- tryCatch(
     repo_url %>%
      git2r::remote_ls() %>%
      tibble::as_tibble() %>%
      dplyr::pull(value) %>%
      dplyr::first(),
    error = function(c) NULL)

  if(is.null(remote_sha)) {
    return(NULL)
  } else {
    return(remote_sha)
  }

}


#' Print info for outdated packages
#'
#' @inheritParams oha_check
#' @param org GH organization
#'
#' @keywords internal
print_update_text <- function(name, org){

  if(name %in% oha_packages()){
    new_url <- paste0("https://usaid-oha-si.github.io/", name, "/news/index.html")
    cli::cli_alert_info("See the changelog for more {.url {new_url}}")
  }

  if(!requireNamespace('pak', quietly = TRUE)){
    cli::cli_inform(c('To update {.pkg {name}}, start a clean session and run the code below:',
                      '{.code install.packages("pak")}',
                      '{.code pak::pak("{org}/{name}")}'))
  } else {
    cli::cli_inform('To update {.pkg {name}}, start a clean session and run: {.code pak::pak("{org}/{name}")}')
  }


}
