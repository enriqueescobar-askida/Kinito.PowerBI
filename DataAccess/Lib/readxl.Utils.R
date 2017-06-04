library(readxl);

MedianAgeXlsToTibble <- function(aXlsPath = ""){
  
  MedianAgeXls <- read_excel(aXlsPath, na = "NA");
  
  return(MedianAgeXls);
}

