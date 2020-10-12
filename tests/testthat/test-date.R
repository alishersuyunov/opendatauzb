library("opendatauzb")
context("Date and Class checks")

test_that("Date is processed properly", {
  expect_error(getTicker("UZ7011340005",
                         from = "2020-01-01",
                         to = "30.06.2020"))
  expect_error(getMarketIndex("finance",
                              from = "2020-01-01",
                              to = "30.06.2020"))
  expect_error(get_FX("USD",
                     from = "2020-01-01",
                     to = "30.06.2020"))
})

test_that("Returned objects are correct", {
  expect_s3_class(getMarketIndex("finance",
                                    from = "01.06.2020",
                                    to = "30.06.2020"), "data.frame")
  expect_s3_class(getTicker("UZ7011340005",
                               from = "01.06.2020",
                               to = "30.06.2020"), "data.frame")

  expect_s3_class(currentBidsAsks(), "data.frame")
  expect_s3_class(ipo(), "data.frame")
  expect_s3_class(get_FX("USD", from = "01-10-2020", to = "12-10-2020"), "data.frame")
})
