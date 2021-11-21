library(xml2)
library(rvest)
library(stringr)
library(jsonlite)
library(dplyr)

url <- 'https://www.amazon.com/SAMSUNG-Internal-Gaming-MZ-V8P2T0B-AM/dp/B08RK2SR23/?_encoding=UTF8&pd_rd_w=5wdQE&pf_rd_p=32bf50e6-7f6e-490c-bab4-1b724d05ad79&pf_rd_r=KD4MKCVHQMKGP1Z87T8P&pd_rd_r=f8d24e26-45bc-4124-b945-46c9ea5a5724&pd_rd_wg=h4l5l&ref_=pd_gw_exports_top_sellers_rec&th=1'
webpage <- read_html(url)
title_html <- html_nodes(webpage, 'h1#title')
title <- html_text(title_html)
title <-str_replace_all(title, "[\r\n]" , "")
prodDetails <- c("Product Name")
Product1 <- c(title)
prodDF <- data.frame(prodDetails,Product1)

price_html <- html_nodes(webpage, 'span#price_inside_buybox')
price <- html_text(price_html)
price <- str_replace_all(price, "[\r\n]" , "")
prodDetails <- c("Price")
Product1 <- c(price)
prodDF[nrow(prodDF) + 1,] <- c(prodDetails,Product1)

desc_html <- html_nodes(webpage, 'div#productDescription')
desc <- html_text(desc_html)
desc <- str_replace_all(desc, "[\r\n\t]" , "")
desc <- str_trim(desc)
prodDetails <- c("Description")
Product1 <- c(desc)
prodDF[nrow(prodDF) + 1,] <- c(prodDetails,Product1)

rate_html <- html_nodes(webpage, 'span[data-hook=rating-out-of-text]')
rate <- html_text(rate_html)
rate <- str_replace_all(rate, "[\r\n]" , "")
rate <- str_trim(rate)
prodDetails <- c("Rating")
Product1 <- c(rate)
prodDF[nrow(prodDF) + 1,] <- c(prodDetails,Product1)

prodDetails_html <- html_nodes(webpage, 'table#productDetails_techSpec_section_2 th.prodDetSectionEntry')
Product1_html <- html_nodes(webpage, 'table#productDetails_techSpec_section_2 td.prodDetAttrValue')
prodDetails <- html_text(prodDetails_html)
Product1 <- html_text(Product1_html)
prodDetails <- str_replace_all(prodDetails, "[\r\n\t]" , "")
Product1 <- str_replace_all(Product1, "[\r\n\t]" , "")
prodDetails <- str_trim(prodDetails)
Product1 <- str_trim(Product1)
prodDF <- rbind(prodDF,data.frame(prodDetails,Product1))

prodDetails_html <- html_nodes(webpage, 'div[data-a-expander-name="product_overview"] td.a-span3')
Product1_html <- html_nodes(webpage, 'div[data-a-expander-name="product_overview"] td.a-span9')
prodDetails <- html_text(prodDetails_html)
Product1 <- html_text(Product1_html)
prodDetails <- str_replace_all(prodDetails, "[\r\n]" , "")
Product1 <- str_replace_all(Product1, "[\r\n]" , "")
prodDetails <- str_trim(prodDetails)
Product1 <- str_trim(Product1)
prodDF <- rbind(prodDF,data.frame(prodDetails,Product1))

prodDF <-distinct(prodDF,prodDetails,.keep_all = TRUE)

row.names(prodDF) <- prodDF[,1]
prodDF <- prodDF[-c(1)]

prodDF <- as.data.frame(t(prodDF))

json_data <- toJSON(prodDF,dataframe = 'row', pretty = T)
cat(json_data)


