.onAttach <- function(...) {

  packageStartupMessage(oha_check("gagglr", suppress_success = TRUE))

  needed <- core[!is_attached(core)]
  available <- core[vapply(needed, requireNamespace, quietly = TRUE, FUN.VALUE = logical(1))]

  if (length(available) == 0) return()

  crayon::num_colors(TRUE)
  packageStartupMessage(oha_attach())
}

is_attached <- function(x) {
  paste0("package:", x) %in% search()
}
