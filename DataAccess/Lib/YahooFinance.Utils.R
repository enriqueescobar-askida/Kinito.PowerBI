# Time Series Plotting
library(ggplot2);
library(xts);
library(dygraphs);

YahooFinanceSymbolsToURL <- function(aList = list(NULL)){
  
  if(is.null(unlist(aList))){
    
    return(NULL);
  } else {
    listURL <- NULL;
    header <- "http://real-chart.finance.yahoo.com/table.csv?s=";
    footer <- "&a=07&b=24&c=2010&d=07&e=24&f=2015&g=d&ignore=.csv";
    
    for (l in aList) {
      anURL <- paste0(header, l, footer);
      listURL <- c(listURL, anURL);
    }
    
    return(listURL);
  }
}

YahooFinanceURLToDataFrames <- function(aList = list(NULL)){
  
  if(is.null(unlist(aList))){
    
    return(NULL);
  } else {
    dfList <- NULL;
    
    for (l in aList) {
      dataFrame <- read.table(l, header = TRUE, sep = ",");
      cs <- dataFrame[,c(1,5)];
      cs$Date <- as.Date(as.character(cs$Date));
      dfList <- c(dfList, cs);
    }
    
    return(dfList);
  }
}

#' #' Title GetYahooData
#' #' Function to pull in stick data from Yahoo Finance.
#' #' Should work for daily as well as intraday data -is at 1 min frequency-.
#' #' Should work for any stock (India or international)
#' #' -Frequency = d, w, m
#' #' -Intraday frequency is 1 min
#' #' Function works thus:
#' #' 1. Creates the URL used to pull data by pasting relevant data like ticker, date, month, year and freq
#' #' 2. Pulls in data from URL and cleans if intraday data is requested
#' #' 3. R warnings and errors are suppressed and custom error codes are displayed
#' #' 4. Returns a data frame containing dates, open, close, high, low, volume columns
#' #' NOTE: For intraday data, the dates returned are in UNIX format
#' #' @param stock Ticker symbol of stock (as per Yahoo)
#' #' @param dateStart Window start date
#' #' @param freq Frequency of daily / weekly / monthly data
#' #' @param intraday TRUE if intraday data is needed else FALSE
#' #' @param intraLength Window length for intraday data ("1d" for one day etc)
#' #'
#' #' @return
#' #' @export
#' #'
#' #' @examples
#' GetYahooData <- function(stock = "%5ENSEI",
#'                          dateStart = "2010-01-01",
#'                          freq = "d",
#'                          intraday = FALSE,
#'                          intraLength = "5d") {
#'   # Set Options ---------------------------------------------------------------
#'   options(show.error.messages = FALSE);
#'   options(warn = -1);
#'   errorFlag <- 0;
#'   # Dates ---------------------------------------------------------------------
#'   dateStart <- as.Date(dateStart);   #  Format should be "YYYY-mm-dd"
#'   dateEnd <- Sys.Date();              #  Auto current date
#'   # If not Intraday -----------------------------------------------------------
#'   if (intraday == FALSE) {
#'     # Create URL
#'     a <- as.numeric(format(dateStart, "%d"));
#'     b <- as.numeric(format(dateStart, "%m"));
#'     c <- as.numeric(format(dateStart, "%Y"));
#'     d <- as.numeric(format(dateEnd, "%d"));
#'     e <- as.numeric(format(dateEnd, "%m"));
#'     f <- as.numeric(format(dateEnd, "%Y"));
#'     part1 <- 'http://real-chart.finance.yahoo.com/table.csv?s=';
#'     part2 <- paste0('&a=',a,"&",
#'                    'b=',b,"&",
#'                    'c=',c,"&",
#'                    'd=',d,"&",
#'                    'e=',e,"&",
#'                    'f=',f,"&",
#'                    'g=',freq,"&",
#'                    "ignore=.csv");
#'     yahooFinanceURL <- paste0(part1, stock, part2);
#'     # Simply read as csv from yahooFinanceURL
#'     yahooFinanceDataFrame <- try(read.csv(yahooFinanceURL, stringsAsFactors = FALSE), silent = TRUE);
#'     # If Error, flag it
#'     if (class(yahooFinanceDataFrame) == "try-error") {
#'       errorFlag <- 1;
#'     }
#'   }
#'   # If Intraday ---------------------------------------------------------------
#'   if (intraday == TRUE) {
#'     # Create yahooFinanceURL
#'     part1 <- "http://chartapi.finance.yahoo.com/instrument/1.0/";
#'     part2 <- paste0("/chartdata;type=quote;range=", intraLength, "/csv/");
#'     yahooFinanceURL = paste0(part1, stock, part2);
#'     # Read each line separately as text
#'     yahooFinanceDataFrame <- readLines(yahooFinanceURL);
#'     # If no error, run code
#'     if (length(yahooFinanceDataFrame) > 4) {
#'       # Get the column names
#'       n <- as.numeric(unlist(strsplit(intraLength, "d")));
#'       n <- ifelse(n == 1, 12, 12 + n);
#'       col.names <- (unlist(strsplit(yahooFinanceDataFrame[n], ":"))[2]);
#'       col.names <- unlist(strsplit(col.names, ","));
#'       # Remove the first few unnecessary rows
#'       yahooFinanceDataFrame <- yahooFinanceDataFrame[(n + 6):length(yahooFinanceDataFrame)];
#'       # Convert the vector of strings into a vector of numbers
#'       yahooFinanceDataFrame <- as.numeric(unlist(strsplit(yahooFinanceDataFrame, ",")));
#'       # Create a matrix and add column names
#'       yahooFinanceDataFrame <- matrix(yahooFinanceDataFrame, ncol = 6, byrow = TRUE);
#'       colnames(yahooFinanceDataFrame) <- col.names;
#'       # Add Row Names
#'       yahooFinanceDataFrame <- data.frame(Date = yahooFinanceDataFrame[,1], yahooFinanceDataFrame[,-1]);
#'     }
#'     else {
#'       # If error flag it
#'       errorFlag <- 1;
#'     }
#'   }
#'   # Print errors etc ----------------------------------------------------------
#'   if (errorFlag == 1) {
#'     print("Data pull unsuccessful. Check Stock Code...");
#'     yahooFinanceDataFrame <- NULL;
#'   }
#'   else {
#'     print("Data pull successful...");
#'   }
#'   # Fix options back to original ----------------------------------------------
#'   options(show.error.messages = TRUE);
#'   options(warn = 1);
#'   # Return data ---------------------------------------------------------------
#'   return(yahooFinanceDataFrame);
#' }

# # Plotly chart 
# library(plotly);
# mat <-  data.frame(Date = AAPL$Date, 
#                    AAPL = round(AAPL$Adj.Close,2),
#                    IBM = round(IBM$Adj.Close,2));
# p <- mat %>% 
#   plot_ly(x = Date, y = AAPL, fill = "tozeroy", name = "Microsoft") %>% 
#   add_trace(y = IBM, fill = "tonexty", name = "IBM") %>% 
#   layout(title = "Stock Prices", 
#          xaxis = list(title = "Time"),
#          yaxis = list(title = "Stock Prices"));
# p  # Thats it !

# # Revision: 2013-01-09 12:34:09 -0600
# getYahooStockUrl <- function(symbol, start, end, type="m") {
#   # Creates a Yahoo URL for fetching historical stock data
#   # Args:
#   #   symbol - the stock symbol for which to fetch data
#   #   start - the date (CCYY-MM-DD) to start fetching data
#   #   end - the date (CCYY-MM-DD) to finish fetching data
#   #   type - daily/monthly data indicator ("d" or "m")
#   # Returns:
#   #   A Yahoo URL string for fetching historical stock data
#   start <- as.Date(start);
#   end <- as.Date(end);
#   url <- "http://ichart.finance.yahoo.com/table.csv?s=%s&a=%d&b=%s&c=%s&d=%d&e=%s&f=%s&g=%s&ignore=.csv";
#   yahooStockURL <- sprintf(url,
#                            toupper(symbol),
#                            as.integer(format(start, "%m")) - 1,
#                            format(start, "%d"),
#                            format(start, "%Y"),
#                            as.integer(format(end, "%m")) - 1,
#                            format(end, "%d"),
#                            format(end, "%Y"),
#                            type);
#   return(yahooStockURL);
# }
