# holding place for things we want to keep around but not visible
.pkgenv <- new.env(parent=emptyenv())

.onAttach <- function(...) {

  # read in the suffixes using V8
  ct <- v8()
  assign("ct", ct, envir=.pkgenv)

  ct$source(system.file("alt/suffixlist.js", package="zellingenach"))

  if (interactive()) {
    packageStartupMessage("Call display_maps() to see the visualization.")
  }

}

# solely for the pkg check warnings
found <- id <- aes <- long <- lat <- fill <- suf <- where <- starts_with <- NULL
