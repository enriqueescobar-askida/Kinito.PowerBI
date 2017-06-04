source("Lib/DataAccess.Utils.R");


source("Lib/RSQLite.Utils.R");


source("Lib/readr.Utils.R");
GDP <- GDPcsvToTibble("Data/GDP.csv");
GDP <- RemoveNaColsFromTibble(GDP);
head(GDP, 1);
rm(GDP);

source("Lib/readxl.Utils.R");
MedianAge <- MedianAgeXlsToTibble("Data/MedianAge.xlsx");
MedianAge <- RemoveNaColsFromTibble(MedianAge);
MedianAge <- RemoveNaRowsFromTibble(MedianAge);
head(MedianAge, 1);
rm(MedianAge);

source("Lib/MsnMoney.Utils.R");
# Read and parse HTML file
MsnMoneyHtml <- MsnSymbolHtmlTree("$INDU,$COMP,$TRAN,$UTIL,$COMPX,$OEX");
# Extract all the paragraphs (HTML tag is p) from root.
MsnMoneyTrList <- MsnHtmlTreeExtractTrList(MsnMoneyHtml);
rm(MsnMoneyHtml);
# fetch data frme
MsnMoneyDataFrame <- GetMsnMoneyDataFrame(MsnMoneyTrList);
rm(MsnMoneyDataFrame);
# Unlist flattens the list to create a character vector. '//p'
MsnMoneyText <- unlist(MsnMoneyTrList);
rm(MsnMoneyTrList);
# character string, separated by spaces
MsnMoneyText <- paste(MsnMoneyText, collapse = "\r\n");
write(MsnMoneyText, "Data/MsnMoney.txt", sep = "\r\n");
rm(MsnMoneyText);

# source("Lib/YahooFinance.Utils.R");
# yahooFinanceSymbols <- c("IBM", "LNKD");
# yahooFinanceSymbolURLs <- YahooFinanceSymbolsToURL(yahooFinanceSymbols);
# yahoos <- YahooFinanceURLToDataFrames(yahooFinanceSymbolURLs);
# ggplot(ibm,aes(Date,Close)) + 
#   geom_line(aes(color="ibm")) +
#   geom_line(data=lnkd,aes(color="lnkd")) +
#   labs(color="Legend") +
#   scale_colour_manual("", breaks = c("ibm", "lnkd"), values = c("blue", "brown")) +
#   ggtitle("Closing Stock Prices: IBM & Linkedin") + 
#   theme(plot.title = element_text(lineheight=.7, face="bold"));
# yahooStockData <-
#   read.csv(getYahooStockUrl("sbux", "2008-1-1", "2008-12-31"),
#            stringsAsFactors = FALSE);
# sbux_monthly <- yahooStockData[order(yahooStockData$Date),
#                                c('Date', 'Adj.Close')];

