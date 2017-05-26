library(XML);
library(plyr);
library(readr);

MsnSymbolHtml <- function(stockSymbol = "$INDU,$COMP,$TRAN,$UTIL,$COMPX,$OEX"){
  
  if(stockSymbol == ""){
    return(
      XML::readHTMLTable(
        doc = "Data/MsnMoneyMajorIndices.html", header = TRUE, as.data.frame = TRUE)
    );
  } else {
    stockSymbol <- trimws(stockSymbol);
    msnMoneyURL <-
      paste("http://www.msn.com/en-us/money/quoteslookup?symbol=", stockSymbol, sep = "");
    
    return(XML::htmlParse(msnMoneyURL, encoding="UTF-8"));
  }
}

MsnNodesExtract <- function(htmlText = ""){
  
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

getKeyStats_xpath <- function(symbol = "$INDU,$COMP,$TRAN,$UTIL,$COMPX,$OEX") {
  
  htmlText <- MsnSymbolHtml(symbol);
  nodes <- MsnNodesExtract(htmlText);
  
  measures <- MsnNodesValues(nodes);
  # Clean up the column name
  measures <- MsnNodesValuesClean(measures);
  
  # Remove dups
  dups <- which(duplicated(measures));
  # print(dups) 
  for(i in 1:length(dups)) 
    measures[dups[i]] = paste(measures[dups[i]], i, sep=" ");
  
  # use siblings function to get value
  values <- sapply(nodes, function(x)  xmlValue(XML::getSibling(x)));
  
  df <- data.frame(t(values))
  colnames(df) <- measures
  return(df);
}

anotherTest <- function(){
  # Read and parse HTML file
  doc.html <-
    XML::htmlTreeParse(
      "http://www.msn.com/en-us/money/quoteslookup?symbol=$INDU,$COMP,$TRAN,$UTIL,$COMPX,$OEX",
      useInternal = TRUE, encoding="UTF-8");
  # Extract all the paragraphs (HTML tag is p) from root.
  # Unlist flattens the list to create a character vector. '//p'
  doc.text <- unlist(XML::xpathApply(doc.html, "//tr", xmlValue));
  # Replace all \r by nothing
  doc.text <- gsub('\\r', '', doc.text);
  # Replace all \n by spaces
  doc.text <- gsub('\\n', '', doc.text);
  # Join all the elements of the character vector into a single
  # character string, separated by spaces
  doc.text = paste(doc.text, collapse = ' ');
}

