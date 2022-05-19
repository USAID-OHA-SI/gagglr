#' Check for OHA package updates
#'
#' This function compares the local version of the package against what is
#' stored on GitHub to flag whether or not you have the latest version.
#'
#' @param name package name
#' @param url user/organization url, default = "https://github.com/USAID-OHA-SI/"
#'
#' @return message if there is a newer package on GH than local
#' @export
#'
#' @examplesIf FALSE
#' check_updates("gophr")
#' check_updates("glamr")

check_updates <- function(name, url = "https://github.com/USAID-OHA-SI/") {

  # Extract remote SHA Code
  remote_sha <- url %>%
    paste(name, sep = "/") %>%
    git2r::remote_ls() %>%
    tibble::as_tibble() %>%
    dplyr::pull(value) %>%
    dplyr::first()

  # Notification
  msg_yes <- base::paste0("Package [USAID-OHA-SI/",
                          name,
                          "] has new updates - ",
                          remote_sha)

  msg_noo <- base::paste0("Package [USAID-OHA-SI/",
                          name,
                          "] has no new updates - ",
                          remote_sha)

  # Local SHA Code
  local_sha <- NULL

  pkgs <- devtools::package_info(pkgs = "installed") %>%
    tibble::as_tibble()

  local <- dplyr::filter(pkgs, package == name)

  # package not installed or built locally
  if(is.null(local)) {
    base::message(paste0("Unable to identify package [", name, "]"))
    return(NULL)
  }

  # Get source
  src <- local %>%
    dplyr::pull(source) %>%
    dplyr::first()

  # Package built locally
  if (src == "local") {
    base::message(paste0("Unable to identify sha code for package built locally [", name, "]"))
    return(TRUE)
  }

  # CRAN Packages
  if (str_detect(src, "CRAN")) {
    base::message(paste0("Unable to identify sha code for CRAN package [", name, "]"))
    return(NULL)
  }

  # Extract local SHA Code
  if (str_detect(src, "Github")) {
    #package installed
    local_sha <- stringr::str_extract(src, "(?<=\\@).*(?=\\))")
  }

  # Check for valid github sha
  if(!is.null(local_sha) & (is.na(local_sha) | local_sha == "")) {
    base::message(paste0("Unable to identify sha code for Github package [", name, "]"))
    return(NULL)
  }

  # Compare local to remote SHA
  new_updates = remote_sha != local_sha

  if (!is.null(local_sha) & new_updates) {
    usethis::ui_warn(msg_yes)
  }

  if (!is.null(local_sha) & remote_sha == local_sha) {
    usethis::ui_info(msg_noo)
  }

  return(new_updates)
}
