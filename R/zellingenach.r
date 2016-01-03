#' Do all the hard work
#'
#' This should be called to build the data structures for the ultimate
#' map / HTML page production.
#'
#' This function reads in the places data, builds the base map hexgrid,
#' identifies which towns belong in which hex, assigns the colors
#' (assignment is based on a log scale of the colors vs an pre-determined
#' cutoff in the pure-javascript version) then builds a \code{list}
#' with an element for each suffix group that contains the title,
#' subtitle, ggplot2 object and count of towns.
#'
#' @param verbose tell folks what's going on
#' @return a \code{list} with an element for each suffix group that
#'   contains the title, subtitle, ggplot2 object and count of towns.
#' @export
make_maps <- function(verbose=TRUE) {

  if (verbose) message("Reading & processing towns")
  plc <- read_places()

  if (verbose) message("Creating the map hexes")
  de_hex_polys <- create_hexgrid()

  if (verbose) message("Making the gridded heat maps")

  # we'll need this for the plotting
  de_hex_map <- fortify(de_hex_polys)

  # find the hex each town is in
  plc$id <- sprintf("ID%s",
                    over(SpatialPoints(coordinates(plc[,c(3,2)]),
                                       CRS(proj4string(de_hex_polys))),
                         de_hex_polys))

  # count up all the towns in each hex (by line ending grouping)
  plc <- separate(plc, found, c("f1", "f2", "f3"), sep="\\|", fill="right")
  plc <- gather(plc, where, found, starts_with("f"))
  plc <- select(filter(plc, !is.na(found)), -where)
  de_heat <- count(plc, found, id)

  # scale the values properly
  de_heat$log <- log(de_heat$n)

  # assign colors to the mapped, scaled values
  bin_ct <- 20
  no_fill <- "#fde725"
  vir <- rev(viridis_pal()(bin_ct+1))
  vir_col <- col_bin(vir[2:length(vir)],
                     range(de_heat$log),
                     bins=bin_ct,
                     na.color=no_fill)

  de_heat$fill <- vir_col(de_heat$log)

  # we'll use a proper projection for Germany
  epsg_31468 <- "+proj=tmerc +lat_0=0 +lon_0=12 +k=1 +x_0=4500000 +y_0=0 +ellps=bessel +datum=potsdam +units=m +no_defs"

  suf_nam <- suffix_names()

  lapply(1:length(suf_nam), function(i) {

    cur_heat <- filter(de_heat, found==i)

    gg <- ggplot()
    gg <- gg + geom_map(data=de_hex_map, map=de_hex_map,
                        aes(x=long, y=lat, map_id=id),
                        size=0.6, color="#ffffff", fill=no_fill)
    gg <- gg + geom_map(data=cur_heat, map=de_hex_map,
                        aes(fill=fill, map_id=id),
                        color="#ffffff", size=0.6)
    gg <- gg + scale_fill_identity(na.value=no_fill)
    gg <- gg + coord_proj(epsg_31468)
    gg <- gg + theme_map()
    gg <- gg + theme(strip.background=element_blank())
    gg <- gg + theme(strip.text=element_blank())
    gg <- gg + theme(legend.position="right")

    list(title=sprintf("&#8209;%s", suf_nam[[i]][1]),
         subtitle=ifelse(length(suf_nam[[i]])<=1, "",
                         paste0(sprintf("&#8209;%s", suf_nam[[i]][2:length(suf_nam[[i]])]),
                                collapse=", ")),
         total=sum(cur_heat$n),
         gg=gg)

  })

}

#' Call this function to make magic happen!
#'
#' This is the function that makes the HTML page with the maps.
#'
#' It calls \code{make_maps()} if it hasn't been called before and
#' caches the resultant data, then builds the HTML page.
#'
#' @param output_file where to save the built HTML (optional)
#' @export
display_maps <- function(output_file=NULL) {

  if (!exists("syl_maps", where=.pkgenv)) {
    syl_maps <- make_maps()
    assign("syl_maps", syl_maps, envir=.pkgenv)
  } else {
    syl_maps <- .pkgenv$syl_maps;
  }

  tags$html(
    tags$head(includeHTML(system.file("alt/styles.html", package="zellingenach"))),
    tags$body(
      h1("-zell, -ingen, -ach"),
      p(HTML("An #rstats homage to <a href='http://truth-and-beauty.net/experiments/ach-ingen-zell/'>-ach, -inge, -zell</a>.<br/><br/>")),
      pblapply(1:length(syl_maps), function(i) {
        div(class="map",
            h2(class="map", HTML(syl_maps[[i]]$title)),
            h4(class="map", HTML(syl_maps[[i]]$subtitle)),
            suppressMessages(htmlSVG(print(syl_maps[[i]]$gg))),
            h3(class="map", sprintf("%s places", comma(syl_maps[[i]]$total))))
      })
    )
  ) -> the_maps

  html_print(the_maps, background="#dfdada;")

  if (!is.null(output_file)) save_html(the_maps, output_file, background="#dfdada;")

}
