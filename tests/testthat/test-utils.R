context("test-utils")

test_that("require arguments", {
  expect_error(require_args("id"), "id")
  expect_error(require_args(c("id", "view")), "id, view")
})

test_that("assert correct type", {
  expect_silent(assert_type("a", type = "character"))
  expect_silent(assert_type(c(1, 2), type = "numeric"))

  expect_error(assert_type(1L, type = "data.frame"))
  expect_error(assert_type(1L, type = c("numeric", "integer")))
})
