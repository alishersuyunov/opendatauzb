#'  Available Datasets
#'
#'  Obtains the list of available datasets from the \url{data.gov.uz}
#'
#' @author Alisher Suyunov
#'
#' @param id Numeric or String Numeric. An identifier of the organisation/authority providing the dataset
#'
#' @import dplyr httr checkmate
#'
#' @importFrom glue glue
#' @importFrom rlist list.extract
#' @importFrom jsonlite fromJSON
#'
#' @return Returns a data frame
#' @export
#'
#' @seealso \code{\link{getData}} to download available datasets by their \code{id}
#' @name availableDatasets
#' @examples
#' \dontrun{
#'  availableDatasets()
#'  availableDataSources()
#'  availableDatasets_by_source(143) }
availableDatasets <- function(pagelimit = 1000000) {
  limit <-
  # formRequest("dataset") %>%
    GET("https://data.egov.uz/apiClient/main/gettable?limit=10000") %>%
    content("text") %>%
    jsonlite::fromJSON(flatten = TRUE) %>% rlist::list.extract("result") %>%
    return()

}

#' @describeIn availableDatasets Obtains the list of available datasets published by particular organisation/authority
#' @export
availableDatasets_by_source <- function(id) {
  id <- as.character(id)
  checkmate::assert_character(id, any.missing = FALSE)

  # ensure at least one element of `id` is a numeric‐only string
  checkmate::assert_true(
    any(grepl("^[0-9]+$", id)),
    .var.name = "id",
    .var.info = "at least one element must consist of digits only"
  )

  df_sources <- glue::glue("https://data.egov.uz/apiClient/main/gettable?orgId={id}") %>%
    #formRequest() %>%
    GET() %>%
    content("text") %>%
    jsonlite::fromJSON(flatten = TRUE) %>% rlist::list.extract("result")

  crayon::green(paste(df_sources$count, "datasets have been found.")) %>% message()
  return(df_sources$data)
}

#' @describeIn availableDatasets Obtains the list of available datasources - organisations
#' @export
availableDataSources <- function() {
  #formRequest("organization") %>%
  df_sources <- GET("https://data.egov.uz/apiClient/Ref/OrgList") %>%
    content("text") %>%
    jsonlite::fromJSON(flatten = TRUE) %>% rlist::list.extract("result")

  crayon::green(paste(nrow(df_sources), "organisations have been found.")) %>% message()
  return(df_sources)
}
