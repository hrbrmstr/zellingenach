#' -zell, -ingen, -ach
#'
#' A package to (mostly) replicate Moritz Stefaner's inaugural 2016 post
#' \url{http://truth-and-beauty.net/experiments/ach-ingen-zell/}
#'
#' To see the maps, call \code{display_maps()}
#'
#' Moritz's inaugural 2016 post is a visual exploration of the spatial
#' patterns in the endings of German town and village names.
#'
#' He picked the most interesting suffixes from
#' \url{https://de.wikipedia.org/wiki/Ortsname} and cross-referenced them with
#' a list of place names from \href{http://www.geonames.org/export/}{geonames}.
#' (Note: The approach is not 100%% scientific, as he only match the letters at
#' the end of the string, not actual syllables.)
#'
#' He did his in javascript (\url{http://github.com/moritzstefaner/ach-ingen-zell}).
#'
#' @name zellingenach
#' @docType package
#' @author Bob Rudis (@@hrbrmstr)
#' @importFrom V8 v8
#' @importFrom tidyr gather separate
#' @importFrom dplyr filter count group_by mutate select
#' @importFrom stringi stri_detect_regex
#' @importFrom sp HexPoints2SpatialPolygons SpatialPoints
#' @importFrom sp spsample over coordinates proj4string CRS
#' @importFrom rgeos gSimplify
#' @importFrom raster getData
#' @importFrom ggplot2 geom_map ggplot theme facet_wrap fortify
#' @importFrom ggplot2 scale_fill_identity element_blank aes
#' @importFrom ggthemes theme_map
#' @importFrom scales col_bin comma
#' @importFrom viridis viridis_pal
#' @importFrom ggalt coord_proj
#' @importFrom pbapply pblapply
#' @import htmltools
#' @import svglite
NULL
