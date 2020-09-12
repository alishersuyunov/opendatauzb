library("opendatauzb")
context("Downloaded Data and Data Structure checks")

# test_that("Data", {
#   expect_equal(TRUE, TRUE)
# })

test_that("Stock Data Sample", {
  testthat::expect_identical(getTicker("UZ7025770007", from = "01.01.2020", to = "01.02.2020"),
                             readRDS("sample_dataset_KVTS.RDS"))
})

test_that("Stock Data Structure", {
  testthat::expect_identical(colnames(getTicker("UZ7025770007", from = "01.01.2020", to = "01.02.2020")),
                             colnames(readRDS("sample_dataset_KVTS.RDS")))
})

# test_that("Securities Structure", {
#   testthat::expect_identical(colnames(getSecurities()),
#                              c("Type", "SecurityCode", "Ticker", "Issuer"))
# })
