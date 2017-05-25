library(readxl);

MedianAgeXlsToTibble <- function(aXlsPath = ""){
  
  MedianAgeXls <-
    read_excel("E:/Disk_X/Kinito.PowerBI/DataAccess/Data/MedianAge.xlsx", na = "NA");
  
  return(MedianAgeXls);
}

