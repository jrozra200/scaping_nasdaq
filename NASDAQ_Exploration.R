## LOAD LIBRARIES
library(prophet) # FACEBOOK'S TIMESERIES FORECAST LIBRARY
library(purrr) # FUNCTIONAL PROGRAMMING

## READ IN THE DATA
alldat <- read.csv("alldat.csv", colClasses = "character")

# CONVERT THE DATA TO THE CORRECT TYPES
alldat$Date <- as.Date(alldat$Date, "%m/%d/%Y")
alldat$Close <- as.numeric(alldat$Close)
alldat$Open <- as.numeric(alldat$Open)
alldat$High <- as.numeric(alldat$High)
alldat$Low <- as.numeric(alldat$Low)
alldat$Volume <- gsub(",", "", alldat$Volume)
alldat$Volume <- as.numeric(alldat$Volume)

# FEATURE CREATION - TURN DATE INTO A NUMBER
alldat$num <- as.numeric(alldat$Date - as.Date("2019-04-12", "%Y-%m-%d")) + 1

## USING PROPHET TO FORECAST SPECIFIC STOCK
m <- prophet(data.frame(ds = alldat[alldat$symbol == "AMZN" & !is.na(alldat$Date), "Date"],
                        y = alldat[alldat$symbol == "AMZN" & !is.na(alldat$Date), "Close"]),
             weekly.seasonality = FALSE)

future <- make_future_dataframe(m, periods = 30)
forecast <- predict(m, future)
plot(m, forecast)             

## USING PURRR TO DETERMINE LINEAR MODEL SLOPE AND R-SQUARED

alldat$symbol <- as.character(alldat$symbol)
options(scipen=999)

# GET THE R-SQUARED VALUES
r_sq <- as.data.frame(alldat %>% 
                          split(.$symbol) %>% 
                          map(~ lm(Close ~ num, data = .)) %>% 
                          map(summary) %>% 
                          map_dbl("r.squared"))
r_sq$symbol <- rownames(r_sq)
names(r_sq) <- c("r.squared", "symbol")

# GET THE SLOPE VALUES
slope <- as.data.frame(alldat %>% 
                          split(.$symbol) %>% 
                          map(~ lm(Close ~ num, data = .)) %>% 
                          map(c("coefficients")) %>% 
                          map_dbl(2))
slope$symbol <- rownames(slope)
names(slope) <- c("slope", "symbol")

# MERGE THESE TOGETHER
dat_sum <- merge(r_sq, slope, by = "symbol")

# CHECK OUT THE RESULTS
head(dat_sum[order(dat_sum$slope, decreasing = TRUE), ], n = 20)

# FIND THE VALUE OF THE STOCKS FOR COMPARISON
close_dat <- alldat %>% 
    group_by(symbol) %>% 
    summarise(max_close = max(Close, na.rm = TRUE))

# ADD THE MAX VALUE TO THE SUMMARY DATA FRAME
dat_sum <- merge(dat_sum, close_dat, by = "symbol")








    
    