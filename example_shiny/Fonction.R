# Libraries----
library(rvest)
library(purrr)

# Connexion----
connexion <- function(url){
  page <- read_html(url)
  return(page)
}

# links.list ----
links.list <- function(url){
  page <- connexion(url)
  
  links_list <- 
    page %>% 
    html_elements("a.link.link-text") %>% 
    html_attr("href") %>% 
    url_absolute("https://www.letemps.ch")
  
  return(links_list)
}

# get.text----
get.text <- function(page){
  text <- 
    page %>% 
    html_elements("h1, h2, h3, h4, p") %>% 
    html_text2() %>% 
    paste(collapse=" ")
  return(text)
}

# get.author----
get.author <- function(page){
  author <- 
    page %>% 
    html_elements("div.author-name-locality") %>% 
    html_text2()
  return(author)
}

# get.date----
get.date <- function(page){
  date <- 
    page %>% 
    html_elements("div.date") %>% 
    html_text2()
  return(date)
}

# get.title----
get.title <- function(page){
  title <- 
    page %>% 
    html_elements("title") %>% 
    html_text2()
  return(title)
}

# get.max.page----
get.max.page <- function(page){
  page %>% 
    html_elements("li.pager__item--last > a") %>% 
    html_attr("href") %>% 
    url_absolute("https://www.letemps.ch") %>% 
    regmatches(regexpr("\\d{1,4}$",.)) %>% 
    as.numeric()
}

# get.info----
get.info <- function(url){
  message <- "Debut de la collecte des infos du lien:"
  
  print(paste(message, url))
  
  page <- connexion(url)
  
  title <- get.title(page)
  author <- get.author(page)
  date <- get.date(page)
  text <- get.text(page)
  
  infos <- c(title=title,
             author=author,
             date=date,
             text=text,
             url=url)
  
  print("Fin, veuillez patienter...")
  print("")
  
  Sys.sleep(3)
  
  return(infos)
}

# my.search----
my.search <- function(text){
  
  # text <- gsub(" ","+", text)
  
  base <- paste0("https://www.letemps.ch/search?keywords=",
         text,
         "&section=All&sort_by=search_api_relevance&sort_order=DESC&page=")
  
  page <- connexion(paste0(base,0))
  
  num <- get.max.page(page)
  
  print(paste("Nombre de pages:", num))
  
  attente <- num * 10 * 3
  
  print(paste("Temps d'attente maximum estimé à", hms::as_hms(attente)))
  
  page_urls <- paste0(base, 0:num)
  
  return(page_urls)
}

collect <- function(text){
  page_urls <- my.search(text)
  
  # links_list <- map(page_urls, links.list)
  
  links_list <- links.list(page_urls[1])
  
  # links_list <- flatten(links_list)
  
  infos <<- map_dfr(links_list, get.info)
  return(infos)
}

clean.date <- function(df){
  df <- 
    df %>% 
    tidyr::separate(date, c("publication", "modification"), sep="\n") %>% 
    mutate(publication = gsub("Publié ", "", publication),
           modification = gsub("Modifié ", "", modification))
  return(df)
}