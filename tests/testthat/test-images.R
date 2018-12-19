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

with_mock_api({
  test_that("list recommended images", {
    img <- listRecommendedImages(id = c("620154782", "620154770"), max_items = 5)
    expect_equal(length(img[["data"]]), 5L)
  })
})

with_mock_api({
  test_that("get image details", {
    img <- getImageDetails(id = "620154782")
    expect_equal(names(img[["assets"]]),
                 c("medium_jpg", "huge_tiff", "small_jpg", "huge_jpg", "preview",
                   "small_thumb", "large_thumb", "huge_thumb"))
    expect_equal(img[["description"]], "Woman bikes along windmill")
  })
})

