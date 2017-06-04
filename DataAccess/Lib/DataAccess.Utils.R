
RemoveNaColsFromTibble <- function(aTibble = tibble::as_tibble(NULL)){
  
  aTibble <- aTibble[colSums(!is.na(aTibble)) > 0];
  
  return(aTibble);
}

RemoveNaRowsFromTibble <- function(aTibble = tibble::as_tibble(NULL)){
  
  aTibble <- aTibble[-which(apply(aTibble,1,function(x)all(is.na(x)))),];
  
  return(aTibble);
}

# load package
library("RODBC");
# connect database
# Note the UNIX style slash (/). "\" is "escape character"
# so all "\" you should replace either with "/" or "\\"
db <- file.path("E:/Disk_X/Kinito.PowerBI/DataAccess/Data/ContosoSales.accdb");
# internal RODBC function
channel <- odbcConnectAccess2007(db); # odbcConnect odbcDriverConnect
# read particular table from Access database file
dataSetName <- sqlFetch(channel, "TableName");
# do not forget this, otherwise you lock access database from editing
close(channel);



