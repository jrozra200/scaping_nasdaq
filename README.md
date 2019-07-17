# SCRAPING NASDAQ

Just a quick repo outlining some work I did to scrape NASDAQ using the 
[rvest pacakge for R](https://github.com/tidyverse/rvest). I wanted to 
memorialize that work here.

Also - I did some forecasting of the stocks using 
[Facebook's Prophet package](https://facebook.github.io/prophet/). I picked 
which stocks to forecast by fitting a simple linear model to each stock and 
looking at which had the most positive slope (increasing fastest) and the most 
linear trend (highest R-Squared value). To do that quickly, I used 
[purrr](https://purrr.tidyverse.org/).
