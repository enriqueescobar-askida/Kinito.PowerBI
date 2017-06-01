library(XML);
library(plyr);
library(readr);

MsnNodesExtractTr <- function(htmlText = ""){
  
  if(htmlText == ""){
    return(NULL);
  }else{
    # search for <tr> nodes anywhere inside <tbody><tbody/>
    return(XML::getNodeSet(htmlText, "/*//tr"));
  }
}

MsnNodesValues <- function(xmlNodes = NULL){
  
  if(is.null(xmlNodes)){
    return(NULL);
  }
  else{
    return(sapply(xmlNodes, xmlValue));
  }
}

MsnNodesValuesClean <- function(xmlValues = NULL){
  
  if(is.null(xmlValues)){
    return(NULL);
  }
  else{
    return(gsub(" *[0-9]*:", "", gsub(" \\(.*?\\)[0-9]*:","", xmlValues)));
  }
}

MsnSymbolHtml <- function(stockSymbol = "$INDU,$COMP,$TRAN,$UTIL,$COMPX,$OEX"){
  
  if(stockSymbol != ""){
    #   return(
    #     XML::readHTMLTable(
    #       doc = "Data/MsnMoneyMajorIndices.html", header = TRUE, as.data.frame = TRUE)
    #   );
    # } else {
    stockSymbol <- trimws(stockSymbol);
    msnMoneyURL <-
      paste("http://www.msn.com/en-us/money/quoteslookup?symbol=", stockSymbol, sep = "");
    
    return(XML::htmlParse(msnMoneyURL, encoding="UTF-8"));
  } else {
    return(NULL);
  }
}

MsnSymbolHtmlTree <- function(stockSymbol = "$INDU,$COMP,$TRAN,$UTIL,$COMPX,$OEX"){
  
  if(stockSymbol != ""){
    stockSymbol <- trimws(stockSymbol);
    msnMoneyURL <-
      paste("http://www.msn.com/en-us/money/quoteslookup?symbol=", stockSymbol, sep = "");
    
    return(XML::htmlTreeParse(msnMoneyURL, useInternal = TRUE, encoding="UTF-8"));
  } else {
    return(NULL);
  }
}

MsnHtmlTreeExtractTrList <- function(htmlText = NULL){
  
  if(is.null(htmlText)){
    return(NULL);
  } else {
    # search for <tr> nodes anywhere inside <tbody></tbody>
    trList <- XML::xpathApply(htmlText, "//tr", xmlValue);
    headerList <- c(1, 2);
    footerList <- seq((length(trList)-8), length(trList));
    trList <- trList[-headerList];
    trList <- trList[-footerList];
    
    trList <- trimws(trList);
    aText <- trList[[1]];
    aText <- sub("^\\s+", "", aText);
    aText <- sub("\r\n                            ", "", aText);
    aText <- sub("\r\n                           ", "", aText);
    trList[[1]] <- aText;
    rm(aText);
    
    return(trList);
  }
}

GetMsnMoneyColNames <- function(aList = list(NULL)){
  
  if(is.null(unlist(aList))){
    
    return(NULL);
  } else {
    aText <- aList[[1]];
    
    if(aText == ""){
      
      return(NULL);
    } else {
      
      return(unlist(strsplit(aText, split="\n")));
    }
  }
}

GetMsnMoneyRowNames <- function(aList = list(NULL)){
  
  if(is.null(unlist(aList))){
    
    return(NULL);
  } else {
    aList <- aList[-1];
    rowList <- NULL;
    
    for (l in aList) {
      rowList <- c(rowList, sub("\r\n.+", "", l));
    }
    
    return(rowList);
  }
}

GetMsnMoneyDataFrame <- function(aList = list(NULL)){
  
  if(is.null(unlist(aList))){
    
    return(NULL);
  } else {
    colNames <- GetMsnMoneyColNames(aList);
    rowNames <- GetMsnMoneyRowNames(aList);
    aList <- aList[-1];
    aDataFrame <- NULL;
    
    for (l in aList) {
      l <- sub("^.+News\n\n\n", "", l);
      l <- gsub("\r\n\r\n", "\r\n", l);
      l <- gsub(" ", "", l);
      l <- gsub("\r\n", "\n", l);
      l <- gsub(",", "", l);
      l <- gsub("N/A", "NA", l);
      rowList <- unlist(strsplit(l, split="\n\n"));
      print(rowList);
      aDataFrame <- rbind(aDataFrame, as.numeric(rowList));
    }
    
    colnames(aDataFrame) <- colNames;
    row.names(aDataFrame) <- rowNames;
    
    return(tibble::as_tibble(as.data.frame(aDataFrame)));
  }
}

# getKeyStats_xpath <- function(symbol = "$INDU,$COMP,$TRAN,$UTIL,$COMPX,$OEX") {
#   
#   htmlText <- MsnSymbolHtml(symbol);
#   nodes <- MsnNodesExtract(htmlText);
#   
#   measures <- MsnNodesValues(nodes);
#   # Clean up the column name
#   measures <- MsnNodesValuesClean(measures);
#   
#   # Remove dups
#   dups <- which(duplicated(measures));
#   # print(dups) 
#   for(i in 1:length(dups)) 
#     measures[dups[i]] = paste(measures[dups[i]], i, sep=" ");
#   
#   # use siblings function to get value
#   values <- sapply(nodes, function(x)  xmlValue(XML::getSibling(x)));
#   
#   df <- data.frame(t(values))
#   colnames(df) <- measures
#   return(df);
# }
