#' Retrieve town names and determine which suffix bucket they belong in
#'
#' The CSV file that Mortiz used is bundled with this package. You can find
#' it at \code{system.file("extdata/placenames_de.tsv", package="zellingenach")}
#'
#' It reads the names, determines which suffix group a town belongs in and
#' then filters out all the ones that weren't found.
#'
#' @param suf list of regular expressions to match suffixes
#' @return \code{data.frame} of enriched places
#' @note My version is more inclusive than Moritz's (if a town matches more
#'       than one suffix it will be counted in more than one suffix group).
#' @export
read_places <- function(suf=suffix_regex()) {

  plc <- read.csv(system.file("extdata/placenames_de.tsv", package="zellingenach"),
           stringsAsFactors=FALSE)

  lapply(suf, function(regex) {
    which(stri_detect_regex(plc$name, regex))
  }) -> matched_endings

  plc$found <- ""

  for(i in 1:length(matched_endings)) {
    where_found <- matched_endings[[i]]
    plc$found[where_found] <-
      paste0(plc$found[where_found], sprintf("%d|", i))
  }

  dplyr::mutate(dplyr::filter(plc, found != ""), found=sub("\\|$", "", found))

}
