library("RODBC") #load package
db <- file.path("E:/Disk_X/Kinito.PowerBI/DataAccess/Data/ContosoSales.accdb") #connect database.
#Note the UNIX style slash (/). "\" is "escape character" so all "\"you should replace either with "/" or "\\"
channel <- odbcConnectAccess2007(db) #internal RODBC function
dataSetName <- sqlFetch(channel, "TableName") #read particular table from Access database file.
close(channel) #do not forget this, otherwise you lock access database from editing.