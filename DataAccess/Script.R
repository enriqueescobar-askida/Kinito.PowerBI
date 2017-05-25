#library("RODBC") #load package
#db <- file.path("E:/Disk_X/Kinito.PowerBI/DataAccess/Data/ContosoSales.accdb") #connect database.
#Note the UNIX style slash (/). "\" is "escape character" so all "\"you should replace either with "/" or "\\"
#channel <- odbcConnectAccess2007(db) #internal RODBC function
#dataSetName <- sqlFetch(channel, "TableName") #read particular table from Access database file.
#close(channel) #do not forget this, otherwise you lock access database from editing.

###

# modify this path to you local repository
# Windows machines have a environment variable SystemDrive=C:
# I use my own for working directory as DataDrive & REPO_DIR
localRepository <- Sys.getenv("DataDrive");
localRepository <- paste0(localRepository, "/", Sys.getenv("REPO_DIR"));
write(paste0(c("Repository ...\t", localRepository), sep = "", collapse = ""), stdout());
# solution is the folder containing the project
projectSolution <- "Kinito.PowerBI";
write(paste0(c("Solution .....\t", projectSolution), sep = "", collapse = ""), stdout());
# project is the project's name
projectName <- "DataAccess";
write(paste0(c("Project ......\t", projectName), sep = "", collapse = ""), stdout());
# namespace
projectNamespace <- "DataAccess";
projectNamespace <- if (projectSolution == projectName) projectSolution else paste0(projectSolution, ".", projectName);
write(paste0(c("Namespace ....\t", projectNamespace), sep = "", collapse = ""), stdout());
# common
projectCommon <- "RCommon";
write(paste0(c("Common .......\t", projectCommon), sep = "", collapse = ""), stdout());
# path
projectPath <- "";
projectPath <- if (projectSolution == projectName) projectSolution else paste0(projectSolution, "/", projectName);
write(paste0(c("Path .........\t", projectPath), sep = "", collapse = ""), stdout());
projectPath <- paste0(localRepository, "/", projectPath);
write(paste0(c("Path old .....\t", getwd()), sep = "", collapse = ""), stderr());
write(paste0(c("Path new .....\t", projectPath), sep = "", collapse = ""), stdout());
setwd(projectPath);
# clean
rm(localRepository);
# options
options(scipen = 100);
# session info
sessionInfo();
# attached
search();
# Create a listing of all objects in the "global environment".
ls();
