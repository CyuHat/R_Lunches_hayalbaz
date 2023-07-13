# Libraries----
library(RSelenium)
library(hayalbaz)
library(tictoc)
library(purrr)

# New----
# RSelenium (9.47 sec elapsed)
RSelenium_start <- function(){
  remote_driver <- rsDriver(browser = "firefox", 
                            chromever = NULL,
                            verbose = FALSE)
  
  remDr <- remote_driver$client
  remDr$open()
  
  return(remDr)
}

RSelenium_function <- function(url, remDr){
  remDr$navigate(url)
  
  result <- remDr$getPageSource()
  
  return(result)
}

# hayalbaz function (2.53 sec elapsed)
hayalbaz_start <- function(){
  driver <- puppet$new()
  
  return(driver)
}

hayalbaz_function <- function(url, driver){
  driver$goto(url)
  
  result <- driver$get_source()
  
  return(result)
}

hayalbaz_function_2 <- function(url, driver){
  driver$goto(url)
  driver$wait_on_load()
  result <- driver$get_source()
  
  return(result)
}

# test 1----
tic() # 7.2 sec elapsed
d1 <- RSelenium_start()
toc()

tic() # 1.89 sec elapsed
d2 <- hayalbaz_start()
toc()

# size----
# 688 bytes
object.size(d1)
# 344 bytes
object.size(d2)

# test 2----
urls <- c("https://en.wikipedia.org", 
          "https://www.google.com/", 
          "https://www.ricardo.ch",
          "https://www.imdb.com/",
          "https://www.accuweather.com/en")

tic() # 7.76 sec elapsed
r1 <- map(urls, RSelenium_function, d1)
toc()

tic() # 1.35 sec elapsed
r2 <- map(urls, hayalbaz_function, d2)
toc()

tic() # 3.06 sec elapsed
r2 <- map(urls, hayalbaz_function_2, d2)
toc()

# Multiple sessions----
# RSelenium
d1a <- RSelenium_start()
d1b <- RSelenium_start()

d1a$navigate("https://en.wikipedia.org")
# Selenium message:No active session with ID 213b5b22-216e-4e2e-b1e6-261ea806440a
# 
# Error: 	 Summary: NoSuchDriver
#          Detail: A session is either terminated or not started
#          Further Details: run errorDetails method

# hayalbaz No problem
d2a <- hayalbaz_start()
d2b <- hayalbaz_start()

d2a$goto("https://en.wikipedia.org")
d2b$goto("https://www.google.com/")