#'  Looking up the dataset name by dataset id
#'
#'  Provides the dataset's name that matches with dataset id
#'
#' @param id A numeric or string that represents the dataset identifier
#'
#' @author Alisher Suyunov
#'
#' @import dplyr jsonlite httr assertive RcppSimdJson
#' @return Returns a character
#' @export
#'
#' @examples
#'  \dontrun{
#'  lookup_by_id(7)}
# lookup_by_id <- function(id){
#   assert_any_are_numeric_strings(id, severity = "stop")
#   formRequest(paste0("dataset/", id)) %>%
#     fromJSON(flatten = TRUE) %>%
#     .[['title']] %>%
#     return() }

lookup_by_id <- function(id){
  assert_any_are_numeric_strings(id, severity = "stop")
  formRequest(paste0("dataset/", id)) %>%
    GET() %>%
    content("text") %>%
    fparse() %>%
    .[['title']] %>%
    return() }
