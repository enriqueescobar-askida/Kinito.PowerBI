# Load the SQLite library
library("RSQLite");
# Assign the sqlite datbase and full path to a variable
dbPath <- "SQLite/Products.sqlite3";
# Instantiate the dbDriver to a convenient object
# sqlite = dbDriver("SQLite");
# Assign the connection string to a connection object
db <- RSQLite::dbConnect(SQLite(), dbname = dbPath);
# Request a list of tables using the connection object
RSQLite::dbListTables(db);
# Request a list of fields on a table using the connection object
RSQLite::dbListFields(db, "DimProduct");
# Assign the results of a SQL query to an object
# results = dbSendQuery(mydb, "SELECT * FROM DimProduct");
# Return results from a custom object to a data.frame
# data = fetch(results);
dbData <- RSQLite::dbGetQuery(db, "SELECT * FROM DimProduct");
dbData$ProductLabel <- as.integer(dbData$ProductLabel);
dbData$BrandName <- as.factor(dbData$BrandName);
dbData$ClassID <- as.integer(dbData$ClassID);
dbData$ClassName <- as.factor(dbData$ClassName);
dbData$StyleID <- as.integer(dbData$StyleID);
dbData$ColorID <- as.integer(dbData$ColorID);
dbData$ColorName <- as.factor(dbData$ColorName);
dbData$BrandName <- as.factor(dbData$BrandName);
dbData$WeightUnitMeasureID <- as.factor(dbData$WeightUnitMeasureID);
dbData$UnitOfMeasureID <- as.integer(dbData$UnitOfMeasureID);
dbData$UnitOfMeasureName <- as.factor(dbData$UnitOfMeasureName);
dbData$AvailableForSaleDate <- as.character(dbData$AvailableForSaleDate);
dbData$StockTypeID <- as.integer(dbData$StockTypeID);
dbData$StockTypeName <- as.factor(dbData$StockTypeName);
dbData$Status <- as.factor(dbData$Status);
dbData$LoadDate <- as.character(dbData$LoadDate);
dbData$UpdateDate <- as.character(dbData$UpdateDate);
dbData <- tibble::as_tibble(dbData);

RSQLite::dbDisconnect(db);

