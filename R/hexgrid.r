#' Make a uniform hexgrid version of a GADM Germany shapefile
#'
#' This reads in an Admin 0 shapefile of Germany using \code{getData}
#' then turns that into a hexgrid map using built-in spatial routines.
#'
#' @return a SpatialPolygons hex grid
#' @export
create_hexgrid <- function() {

  de_shp <- getData("GADM", country="DEU", level=0, path=tempdir())

  de_hex_pts <- spsample(de_shp, type="hexagonal", n=10000, cellsize=0.19,
                         offset=c(0.5, 0.5), pretty=TRUE)

  HexPoints2SpatialPolygons(de_hex_pts)

}
