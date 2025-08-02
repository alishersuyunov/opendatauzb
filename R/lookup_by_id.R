#'  Looking up the dataset name by dataset id
#'
#'  Provides the dataset's name that matches with dataset id
#'
#' @param id A numeric or string that represents the dataset identifier
#'
#' @author Alisher Suyunov
#'
#' @import dplyr httr checkmate
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
  checkmate::assert_character(id_char, any.missing = FALSE)

  # 2) ensure at least one element is digits-only
  checkmate::assert_true(
    any(grepl("^[0-9]+$", id_char)),
    .var.name = "id",
    .var.info = "at least one element must consist only of digits"
  )

  formRequest(paste0("dataset/", id)) %>%
    GET() %>%
    content("text") %>%
    jsonlite::fromJSON(flatten = TRUE) %>% # fparse() %>%
    .[['title']] %>%
    return()
  }
