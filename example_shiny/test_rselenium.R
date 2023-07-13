# library----
# Install JDK
library(RSelenium)
library(wdman)

# Install all the web drivers----
wdman::selenium()

# Starting----
# Know the chrome version
binman::list_versions("chromedriver")

# Creating the driver Chrome (take 5 seconds)
remote_drive <- rsDriver(browser = "chrome",
                         chromever = "112.0.5615.28",
                         verbose = FALSE, # optional
                         )

remote_drive$server$stop()

# Creating the driver Firefox
remote_drive <- rsDriver(browser = "firefox",
                         chromever = NULL,
                         verbose = FALSE # optional
                         ) # Then close the web browser

# To do before navigating
remDr <- remote_drive$client
remDr$open()

# Navigating
remDr$navigate("https://www.ebay.com/")

# Find element
## class name / css selector / id / name / link text / partial link tet / tag name / xpath
image_result <- remDr$findElement(using = "css selector",
                  "img")

# Get attibute
image_result$getElementAttribute("src")

# Click an element
remDr$click()
image_result$clickElement()

# go back
remDr$goBack()

# TO get source page
remDr$getPageSource()

image_result$getPageSource()

# Stop the connexion
remote_drive$server$stop()
