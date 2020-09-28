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
#library(RcppSimdJson)

## ---- include = TRUE, eval=FALSE, warning=FALSE-------------------------------
#  RegisteredSecurities()

## ---- echo = FALSE, include = TRUE, warning=FALSE-----------------------------
RegisteredSecurities() %>% head(10) %>% kable()

## ---- include = TRUE, warning=FALSE, eval=FALSE-------------------------------
#  getSecurities()

## ---- echo = FALSE, include = TRUE, warning=FALSE-----------------------------
getSecurities() %>% head(10) %>% kable() %>% kable_styling()

## ---- include = TRUE, eval = FALSE, warning = FALSE---------------------------
#  ipo()

## ---- echo = FALSE, include = TRUE, warning = FALSE---------------------------
ipo() %>% tail(10) %>% kable() %>% kable_styling()

## ---- include = TRUE, eval = FALSE, warning = FALSE---------------------------
#  currentBidsAsks()

## ---- echo = FALSE, include = TRUE, warning = FALSE---------------------------
currentBidsAsks() %>% head(10) %>% select(-5) %>% kable(results = "asis") %>% kable_styling() 

## ---- include = TRUE, eval=FALSE, warning=FALSE-------------------------------
#  getMarketIndex(sector = "all")

## ---- echo = FALSE, include = TRUE, warning=FALSE-----------------------------
getMarketIndex(sector = "all") %>% head(10) %>% kable() %>% kable_styling()

## ---- include = TRUE, eval=FALSE, warning=FALSE-------------------------------
#  getMarketIndex(sector = "finance",
#                 from = "01.01.2018",
#                 to = "30.06.2020")

## ---- echo = FALSE, include = TRUE, warning=FALSE-----------------------------
getMarketIndex(sector = "finance",
               from = "01.01.2018",
               to = "30.06.2020") %>% head(10) %>% kable() %>% kable_styling()

## ---- include = TRUE, eval=FALSE, warning=FALSE-------------------------------
#  getTicker("UZ7011340005")

## ---- echo = FALSE, include = TRUE, warning=FALSE-----------------------------
getTicker("UZ7011340005") %>% head(10) %>% select(-9, -10) %>% kable() %>% kable_styling()

## ---- include = TRUE, eval=FALSE, warning=FALSE-------------------------------
#  getTicker("UZ7011340005",
#            from = "01.01.2018",
#            to = "30.06.2020")

## ---- echo = FALSE, include = TRUE, warning=FALSE, message = FALSE------------
getTicker("UZ7011340005", 
          from = "01.01.2018", 
          to = "30.06.2020") %>% head(10) %>% select(-9, -10) %>% kable() %>% kable_styling()

## ---- include = TRUE, warning=FALSE, message=FALSE----------------------------
asset_group <- c("UZ704532K019", "UZ7045320007", "UZ7025870005", "UZ7038380000", "UZ7025770007",
                 "UZ7015030008", "UZ7043200003", "UZ703756K015", "UZ7037560008", "UZ7016400002",
                 "UZ7004510002", "UZ7023760000", "UZ703348K011", "UZ7033480003", "UZ7035340007",
                 "UZ7028090007", "UZ701134K017", "UZ7011340005", "UZ701655K011", "UZ7016550004")

assets <- asset_group %>% getTicker(from = "01.01.2019", to = "12.08.2020")

## ---- include = TRUE, warning=FALSE-------------------------------------------
Ra <- assets %>% 
  group_by(symbol) %>%
  tq_transmute(select     = "Closed Price",
               mutate_fun = periodReturn,
               period     = "monthly",
               col_rename = "Ra")

## ---- echo = FALSE, include = TRUE, warning=FALSE-----------------------------
kable(head(Ra, n = 6)) %>% 
  kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive"))

## ---- echo=TRUE, warning=FALSE------------------------------------------------
# Baseline prices
Rb <- getMarketIndex("all", from = "01.01.2019", to = "12.08.2020")  %>%
  tq_transmute(select     = price,
               mutate_fun = periodReturn,
               period     = "monthly",
               col_rename = "Rb")

## ---- echo = FALSE, include = TRUE, warning=FALSE-----------------------------
Rb %>% head(6) %>% kable() %>% kable_styling()
RaRb <- left_join(Ra, Rb, by = c("Date" = "date"))

## ---- echo=TRUE, warning=FALSE, message=FALSE---------------------------------
RaRb_capm <- RaRb %>%
  tq_performance(Ra = Ra,
                 Rb = Rb,
                 Rf = 0.15,
                 performance_fun = table.CAPM)

## ---- echo = FALSE, include = TRUE, warning=FALSE-----------------------------
RaRb_capm %>% 
  select(1:3,5, 10, 12, 13) %>%
  kable() %>% 
  kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive"))

## ---- echo=TRUE, warning=FALSE, message=FALSE---------------------------------
RaRb %>%
  tq_performance(Ra = Ra,
    Rb = NULL,
    performance_fun = SharpeRatio,
    Rf = 0.15) %>% 
  formattable(list("ESSharpe(Rf=15%,p=95%)" = formatter("span", 
                                                        style = x ~ ifelse(x >= 3, 
                                                                           style(color = "green", 
                                                                                 font.weight = "bold"), 
                                                                           NA))))

## ---- warning=FALSE, message=FALSE--------------------------------------------
wts <- c(rep(0, 5),
         0.35, #6
         rep(0, 8),
         0.65, #15
         rep(0, 5))

portfolio_returns_monthly <- Ra %>%
  tq_portfolio(assets_col   = symbol,
               returns_col  = Ra,
               weights      = wts,
               col_rename   = "Ra")

left_join(portfolio_returns_monthly, 
          Rb,
          by = c("Date"="date")) %>% 
  tq_performance(Ra = Ra, Rb = Rb, performance_fun = table.CAPM) %>% 
  gather() %>%
  kable() %>% 
  kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive"))

## ---- warning=FALSE, message=FALSE--------------------------------------------
portfolio_growth_monthly <- Ra %>%
  tq_portfolio(assets_col   = symbol,
               returns_col  = Ra,
               weights      = wts,
               col_rename   = "investment.growth",
               wealth.index = TRUE) %>%
  mutate(investment.growth = investment.growth * 100000)

## ----echo=FALSE, fig.height=5, fig.width=7, message=FALSE, , warning=FALSE----
portfolio_growth_monthly %>%
  ggplot(aes(x = Date, y = investment.growth)) +
  geom_line(size = 2, color = palette_light()[[1]]) +
  labs(title = "Portfolio growth",
       subtitle = "35% MSBU and 65% UZKB",
       caption = "",
       x = "", y = "Portfolio Value (thousand UZS)") +
  geom_smooth(method = "loess") +
  theme_tq() +
  scale_color_tq() +
  scale_y_continuous(labels = scales::unit_format(unit = "", scale = 1e-3))

