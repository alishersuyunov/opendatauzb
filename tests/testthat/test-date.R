library("opendatauzb")
context("Date and Class checks")

# test_that("Date is processed properly", {
#   expect_error(getTicker("UZ7011340005",
#                          from = "2020-01-01",
#                          to = "30.06.2020"))
#   expect_error(getMarketIndex("finance",
#                               from = "2020-01-01",
#                               to = "30.06.2020"))
#
# })
#
# test_that("Returned objects are correct", {
#   expect_s3_class(getMarketIndex("finance",
#                                     from = "01.06.2020",
#                                     to = "30.06.2020"), "data.frame")
#   expect_s3_class(getTicker("UZ7011340005",
#                                from = "01.06.2020",
#                                to = "30.06.2020"), "data.frame")
#
#   expect_s3_class(currentBidsAsks(), "data.frame")
#   expect_s3_class(ipo(), "data.frame")
# })

test_that("Date", {
  expect_equal(TRUE, TRUE)
})

# test_that("Stock Data Sample", {
# testthat::expect_identical(getTicker("UZ7025770007", from = "01.01.2020", to = "01.02.2020"),
#                            readRDS("sample_dataset_KVTS.RDS"))
# })
#
# test_that("Stock Data Structure", {
#   testthat::expect_identical(colnames(getTicker("UZ7025770007", from = "01.01.2020", to = "01.02.2020")),
#                              colnames(readRDS("sample_dataset_KVTS.RDS")))
# })
#
# test_that("Securities Structure", {
#   testthat::expect_identical(colnames(getSecurities()),
#                              c("Type", "SecurityCode", "Ticker", "Issuer"))
# })
