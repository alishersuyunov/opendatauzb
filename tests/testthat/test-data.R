library("opendatauzb")
context("Downloaded Data and Data Structure checks")

test_that("Stock Data Sample", {
  testthat::expect_identical(getTicker("UZ7025770007", from = "01.01.2020", to = "01.02.2020"),
                             readRDS("sample_dataset_KVTS.RDS"))
})

test_that("Multiple Stock Data", {
  testthat::expect_identical(getTicker(c("UZ7025770007", "UZ7015030008"), from = "01.01.2019", to = "01.02.2019")["symbol"] %>% unique(),
                             tibble(symbol = c("UZ7025770007", "UZ7015030008")))
})

test_that("Multiple Stock Data (symbol) - Character vector", {
  testthat::expect_identical(getTicker(c("KVTS", "MSBU"), from = "01.01.2019", to = "01.02.2019")["symbol"] %>% unique(),
                             tibble(symbol = c("UZ7025770007", "UZ7015030008")))
})

test_that("Multiple Stock Data (symbol) - List", {
  testthat::expect_identical(getTicker(list("KVTS", "MSBU"), from = "01.01.2019", to = "01.02.2019")["symbol"] %>% unique(),
                             tibble(symbol = c("UZ7025770007", "UZ7015030008")))
})

test_that("Stock Data Structure", {
  testthat::expect_identical(colnames(getTicker("UZ7025770007", from = "01.01.2020", to = "01.02.2020")),
                             colnames(readRDS("sample_dataset_KVTS.RDS")))
})

test_that("Stock Data Sample (Symbol)", {
  testthat::expect_identical(getTicker("KVTS", from = "01.01.2020", to = "01.02.2020"),
                             readRDS("sample_dataset_KVTS.RDS"))
})

test_that("Stock Data Structure (Symbol)", {
  testthat::expect_identical(colnames(getTicker("KVTS", from = "01.01.2020", to = "01.02.2020")),
                             colnames(readRDS("sample_dataset_KVTS.RDS")))
})

test_that("Stock Data Structure (Lowercase Symbol)", {
  testthat::expect_identical(colnames(getTicker("kvts", from = "01.01.2020", to = "01.02.2020")),
                             colnames(readRDS("sample_dataset_KVTS.RDS")))
})

test_that("Securities Structure", {
  testthat::expect_identical(colnames(getSecurities()),
                             c("Type", "SecurityCode", "Ticker", "Issuer"))
})

test_that("Symbol resolution", {
  testthat::expect_identical(requestTicker("UZ7025770007"),
                             "KVTS")
})

test_that("Security Code resolution", {
  testthat::expect_identical(requestSecurityCode("KVTS"),
                             "UZ7025770007")
})
