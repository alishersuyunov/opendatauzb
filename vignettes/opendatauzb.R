## ----setup, include = FALSE, warning=FALSE------------------------------------
library(rmarkdown)
library(quantmod)
library(tidyverse)
library(PerformanceAnalytics)
library(tidyquant)
library(opendatauzb)
library(knitr)
library(kableExtra)
library(formattable)

## ---- include = TRUE, eval=FALSE, warning=FALSE-------------------------------
#  RegisteredSecurities()

## ---- echo = FALSE, include = TRUE, warning=FALSE-----------------------------
RegisteredSecurities() %>% head(10) %>% kable()

## ---- include = TRUE, warning=FALSE, eval=FALSE-------------------------------
#  getSecurities()

