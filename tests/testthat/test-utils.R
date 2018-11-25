context("test-utils")

test_that("require arguments", {
  x <- "text"
  expect_silent(check_required_args(x, "character"))
  expect_error(check_required_args(x, "numeric"))
  expect_error(check_required_args(x, "a"))
})
