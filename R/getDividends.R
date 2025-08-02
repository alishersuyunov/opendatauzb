#'  Downloads a calendar of dividends
#'
#'  Returns a data frame with the calendar of dividends from the Central Securities Depository (\url{uzcsd.uz}) database
#'
#' @author Alisher Suyunov
#'
#' @import dplyr tidyr httr jsonlite glue
#'
#' @return Returns a data frame
#' @export
#'
#' @examples
#'  \dontrun{
#'  getDividends()}
getDividends <- function(stockType = c("", "privileged", "simple", "bond")) {
  url <- glue("https://new-api.openinfo.uz/api/v2/disclosure/dividend-calendar/?page_size=10000&&stock_type={stockType}")

  # Fetch & parse JSON, with error handling
  data <- tryCatch(
    jsonlite::fromJSON(url, simplifyDataFrame = TRUE),
    error = function(e) {
      stop("Failed to fetch or parse UZCSD securities JSON: ", e$message)
    }
  )
  return(data$results)
}
