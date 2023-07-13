# Static page
url_stat <- "http://quotes.toscrape.com/"

# JavaScript generated content
url_dyn <- "http://quotes.toscrape.com/js/"

library(rvest)

page <- read_html(url_dyn)

page %>% 
  html_elements("span.text") %>% 
  html_text2()
