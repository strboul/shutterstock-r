
context("testing environment variables")

test_that("variables return something", {
  expect_length(sstk_id(), 1L)
  expect_length(sstk_secret(), 1L)
})
