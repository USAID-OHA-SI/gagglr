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
#' check_updates("gophr")
#' check_updates("glamr")

check_updates <- function(name, url = "https://github.com/USAID-OHA-SI", suppress_success = FALSE) {

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
    usethis::ui_warn("[{name}] status: UNINSTALLED - unable to identify/locate package")
    return(invisible("^"))
  }

  # Package built locally
  if (src %in% c("local", "load_all()")) {
    usethis::ui_warn("[{name}] status: UNKNOWN - unable to identify status (via sha code) for package built locally")
    return(invisible("?"))
  }

  # CRAN Packages
  if (stringr::str_detect(src, "CRAN")) {
    usethis::ui_warn("[{name}] status: UNKNOWN - unable to identify status (via sha code) for CRAN package")
    return(invisible("?"))
  }

  # Extract local SHA Code
  if (stringr::str_detect(src, "Github")) {
    #package installed
    local_sha <- stringr::str_extract(src, "(?<=\\@).*(?=\\))")
  }

  # Check for valid github sha
  if(!is.null(local_sha) & (is.na(local_sha) | local_sha == "")) {
    usethis::ui_warn("[{name}] status: UNKNOWN - unable to identify status (via sha code) for this Github package")
    return(invisible("?"))
  }

  # Compare local to remote SHA
  new_updates = remote_sha != local_sha
  msg <- glue::glue("Package [{org}/{name}] has{ifelse(new_updates == TRUE, '', ' no')} new updates")


  if (!is.null(local_sha) & new_updates) {
    usethis::ui_warn("[{name}] status: OUT OF DATE - local version of package is behind the latest release on GitHub")
    return(invisible("*"))
  }

  if (!is.null(local_sha) & remote_sha == local_sha & !suppress_success) {
    usethis::ui_info("[{name}] status: UP TO DATE - local version of package matches the latest release on GitHub")
  }

  if (!is.null(local_sha) & remote_sha == local_sha) {
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
