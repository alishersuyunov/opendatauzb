#'  Looking up the dataset name by dataset id
#'
#'  Provides the dataset's name that matches with dataset id
#'
#' @param id A numeric or string that represents the dataset identifier
#'
#' @author Alisher Suyunov
#'
#' @import dplyr httr
#'
#' @importFrom assertive assert_any_are_numeric_strings
#' @importFrom jsonlite fromJSON
#'
#' @return Returns a character
#' @export
#'
#' @examples
#'  \dontrun{
#'  lookup_by_id(7)}

lookup_by_id <- function(id){
  id <- as.character(id)
  assertive::assert_any_are_numeric_strings(as.character(id), severity = "stop")
  formRequest(paste0("dataset/", id)) %>%
    GET() %>%
    content("text") %>%
    jsonlite::fromJSON(flatten = TRUE) %>% # fparse() %>%
    .[['title']] %>%
    return()
  }
