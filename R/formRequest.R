api_key <- "46b7bb492f5379d5a464dc73476e4316"
formRequest <- function(request, format = "json") {
  glue::glue("https://data.gov.uz/ru/api/v1/{format}/{request}?access_key={api_key}")
}
