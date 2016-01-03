#' Retrieve suffix list as end-matching regexes
#'
#' A slightly modified version of the suffix group list from Moritz's post
#' is included with this package. You can find it at
#' \code{system.file("alt/suffixlist.js", package="zellingenach")} and it is
#' read in using the \code{V8} package since it was left as a javascript
#' data structure.
#'
#' @return A character vector of regular expressions
#' @export
suffix_regex <- function() {
  sprintf("(%s)$", sapply(.pkgenv$ct$get("suffixList"), paste0, collapse="|"))
}

#' Retrieve suffix list as a list of vectors with suffix names
#'
#' A slightly modified version of the suffix group list from Moritz's post
#' is included with this package. You can find it at
#' \code{system.file("alt/suffixlist.js", package="zellingenach")} and it is
#' read in using the \code{V8} package since it was left as a javascript
#' data structure.
#'
#' @return A list of suffix character vectors
#' @export
suffix_names <- function() {
  .pkgenv$ct$get("suffixList")
}
