#'  Downloads a full list of registered securities with ISIN and CFI codes
#'
#'  Returns a data frame with the list of securities from the Central Securities Depository (\url{www.deponet.uz}) database
#'
#' @author Alisher Suyunov
#'
#' @import dplyr tidyr
#' @importFrom xml2 read_html
#' @importFrom rvest xml_nodes html_table
#'
#' @return Returns a data frame
#' @export
#'
#' @examples
#'  \dontrun{
#'  RegisteredSecurities()}
RegisteredSecurities <- function(){
  xml2::read_html("http://www.deponet.uz/cgi-bin/asb_all.cgi") %>%
    rvest::xml_nodes("table") %>%
    .[7] %>%
    rvest::html_table() %>%
    .[[1]] %>%
    `colnames<-`(c("Issuer", "SecurityCode", "ISIN", "CFI", "last_update")) %>%
    mutate(last_update = as.Date(last_update, format = "%d-%m-%Y")) %>%
    return()
}
