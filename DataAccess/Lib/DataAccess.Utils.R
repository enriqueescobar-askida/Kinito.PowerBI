
RemoveNaColsFromTibble <- function(aTibble = tibble::as_tibble(NULL)){
  
  aTibble <- aTibble[colSums(!is.na(aTibble)) > 0];
  
  return(aTibble);
}

RemoveNaRowsFromTibble <- function(aTibble = tibble::as_tibble(NULL)){
  
  aTibble <- aTibble[-which(apply(aTibble,1,function(x)all(is.na(x)))),];
  
  return(aTibble);
}

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
row.names(MsnMoneyDataFrame);
# Unlist flattens the list to create a character vector. '//p'
MsnMoneyText <- unlist(MsnMoneyTrList);
rm(MsnMoneyTrList);
# Replace all \r by nothing
#MsnMoneyText <- gsub('\\r', '', MsnMoneyText);
# Replace all \n by spaces
#MsnMoneyText <- gsub('\\n', '', MsnMoneyText);
# Join all the elements of the character vector into a single
# character string, separated by spaces
MsnMoneyText <- paste(MsnMoneyText, collapse = "\r\n");
write(MsnMoneyText, "Data/MsnMoney.txt", sep = "\r\n");
rm(MsnMoneyText);

