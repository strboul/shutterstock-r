context("test-images")

with_mock_api({
  test_that("search images", {
    expect_is(searchImages(query = "farmer"), "list")
  })
})

with_mock_api({
  test_that("list image categories", {
    cats <- listImageCategories()
    expect_equal(names(cats), "data")
    expect_equal(length(cats[["data"]]), 25L)
    expect_equal(cats[["data"]][[1]][["name"]], "Abstract")
    expect_equal(cats[["data"]][[25]][["name"]], "Vintage")
  })
})

with_mock_api({
  test_that("list similar images", {
    img <- listSimilarImages(id = "620154782")
    expect_equal(
      names(img),
      c("page", "per_page", "total_count", "search_id", "data")
    )
  })
})
