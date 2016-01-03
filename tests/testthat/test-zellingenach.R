context("suffixes")
test_that("suffix data has been processed correctly", {

  expect_that(suffix_regex(), is_a("character"))
  expect_that(length(suffix_regex()), equals(52))
  expect_that(suffix_regex()[3], equals("(ate|te|nit|net)$"))

  expect_that(suffix_names(), is_a("list"))
  expect_that(length(suffix_names()), equals(52))
  expect_that(suffix_names()[3], equals(list(c("ate", "te", "nit", "net"))))

})

context("places")
test_that("places data has been processed correctly", {

  expect_that(read_places(), is_a("data.frame"))
  expect_that(read_places()[5, "found"], equals("4|19"))
  expect_that(nrow(read_places()), equals(53361))

})

context("spatial")
test_that("hexgrid is built correctly", {

  hg <- create_hexgrid()
  expect_that(hg, is_a("SpatialPolygons"))
  expect_that(length(hg), equals(1473))

})
