library(readr);

GDPcsvToTibble <- function(aCsvPath = ""){
  
  GDPcsv <- readr::read_csv("E:/Disk_X/Kinito.PowerBI/DataAccess/Data/GDP.csv", 
            col_types = cols(Year = col_date(format = "%m/%d/%Y")), na = "NA");
  
  return(GDPcsv);
}

