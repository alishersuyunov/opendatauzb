#'  Obtaining current Bids and Asks for stocks
#'
#'  Returns current bid and ask prices on the Republican Stock Exchange "Toshkent"
#'
#' @param security_type A string that indicates the type of the security: "STK" for stocks, "BND" for bonds, "RPO" for Repeat Public Offering, "FCT" for
#' @param security_code A unique identifier of the security (e.g. UZ7011340005). Note: Don't confuse with ISIN code
#'
#' @author Alisher Suyunov
#'
#' @import httr dplyr lubridate tidyr textclean
#'
#' @importFrom rvest html_table
#' @importFrom purrr map_df
#' @importFrom glue glue
#' @importFrom stringr str_trim
#' @importFrom xml2 read_html
#'
#' @return Returns a data frame
#' @export
#'
#' @seealso \code{\link{getSecurities}} or \code{\link{RegisteredSecurities}} to see the complete list of available securities
#' @seealso \code{\link{getTicker}} to download stock prices of the certain stock
#'
#' @examples
#'  \dontrun{
#'  currentBidsAsks()}
currentBidsAsks <- function(security_code = "", security_type = "STK") {
  security_type <- stringr::str_trim(security_type)
  security_code <- stringr::str_trim(security_code)

  glue::glue('https://uzse.uz/asking_prices?ord_dd={today() %>% format(format = "%d.%m.%Y")}&mkt_id={security_type}&isu_cd={security_code}') %>%
    GET() %>%
    content(type = "text", encoding = "UTF-8") %>%
    xml2::read_html() %>%
    rvest::html_table() %>% .[[1]] %>%
    purrr::map_df(replace_html) %>%
    purrr::map_df(replace_white) %>%
    return()
}
