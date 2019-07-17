## SCRAPE HISTORICAL DATA FROM NASDAQ SITE

# THIS LIBRARY ALLOWS FOR SCRAPING WEBPAGES
library(rvest)

# ALL OF THE COMPANIES LISTED ON NASDAQ: 
# https://www.nasdaq.com/screening/companies-by-name.aspx?letter=0&exchange=nasdaq&render=download
comp <- read.csv("~/Downloads/companylist.csv")

alldat <- data.frame() # CREATE A DATA FRAME FOR ALL OF THE DATA
error <- data.frame() # CREATE A DATA FRAME TO TRACK ANY ERRORS

## LOOP THROUGH ALL OF THE COMPANIES IN THE LIST
for(i in 1:dim(comp)[1]){
    # CREATE THE URL TO SCRAPE
    url <- paste0(as.character(comp$Summary.Quote[i]), "/historical")
    
    # GRAB THE HTML DATA
    webpage <- read_html(url)
    
    # ZERO IN ON THE TABLE OF HISTORICAL DATA
    tab_dat <- webpage  %>%
        html_nodes("table") %>% 
        html_table()
    
    # GRAB THE TABLE SPECIFCALLY
    tab_ <- tab_dat[[3]]
    
    # IF THERE IS DATA, RENAME THE COLUMNS
    if(dim(tab_)[1] > 1){
        names(tab_) <- c("Date", "Open", "High", "Low", "Close", "Volume")
        tab_ <- cbind(symbol = comp$Symbol[i],
                      tab_)
        
        alldat <- rbind(alldat, tab_)
    } else { # IF THERE IS AN ERROR, ADD IT TO THE ERROR LIST
        tab_ <- data.frame(error = comp$Symbol[i])
        
        error <- rbind(error, tab_)
    }
}

## WRITE THE RESULTS TO A CSV FOR POSTERITY
write.csv(alldat, "~/Documents/project pig/alldat.csv", row.names = FALSE)