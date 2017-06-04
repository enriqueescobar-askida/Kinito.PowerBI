
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
db <- file.path("/Data/ContosoSales.accdb");
# internal RODBC function
# channel <- odbcConnectAccess(db);
# Error in odbcConnectAccess(db) : odbcConnectAccess is only usable with 32-bit Windows
# data <- sqlQuery(channel , paste ("select * from Name_of_table_in_my_database"));
# dataSetName <- sqlFetch(channel, "DimProducts");
# channel <- odbcDriverConnect(db);
# channel <- odbcDriverConnect("Driver={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=E:/Disk_X/Kinito.PowerBI/DataAccess/Data/ContosoSales.accdb")
# Error
# odbcConnect
# Error
# odbcDriverConnect
# read particular table from Access database file
# do not forget this, otherwise you lock access database from editing
#close(channel);


