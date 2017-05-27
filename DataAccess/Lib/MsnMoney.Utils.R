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
    # search for <tr> nodes anywhere inside <tbody><tbody/>
    return(XML::xpathApply(htmlText, "//tr", xmlValue));
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
