#'  Downloads a full list of registered securities with ISIN and CFI codes
#'
#'  Returns a data frame with the list of securities from the Central Securities Depository (\url{www.deponet.uz}) database
#'
#' @author Alisher Suyunov
#'
#' @import httr readxl rvest dplyr glue lubridate tidyr stringr jsonlite assertive xml2
#' @return Returns a data frame
#' @export
#'
#' @examples
#'  \dontrun{
#'  RegisteredSecurities()}
RegisteredSecurities <- function(){
  read_html("http://www.deponet.uz/cgi-bin/asb_all.cgi") %>%
    xml_nodes("table") %>%
    .[7] %>%
    html_table() %>%
    .[[1]] %>%
    return()
}
