
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
GDP <- RemoveNaRowsFromTibble(GDP);
head(GDP);


source("Lib/readxl.Utils.R");
MedianAge <- MedianAgeXlsToTibble("Data/MedianAge.xlsx");
MedianAge <- RemoveNaColsFromTibble(MedianAge);
MedianAge <- RemoveNaRowsFromTibble(MedianAge);
head(MedianAge);
