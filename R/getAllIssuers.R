#'  Downloads a full list of issuers
#'
#'  Returns a data frame with the list of issuers from the Central Securities Depository (\url{uzcsd.uz}) database
#'
#' @author Alisher Suyunov
#'
#' @import dplyr tidyr httr jsonlite
#'
#' @return Returns a data frame with the list of issuers
#' @export
#'
#' @examples
#'  \dontrun{
#'  getAllIssuers()}
getAllIssuers <- function() {
  url <- "https://web.uzcsd.uz/api/Security/GetAllIssuersInformation"

  # Fetch & parse JSON, with error handling
  data <- tryCatch(
    jsonlite::fromJSON(url, simplifyDataFrame = TRUE),
    error = function(e) {
      stop("Failed to fetch or parse UZCSD securities JSON: ", e$message)
    }
  )

  return(data)
}
