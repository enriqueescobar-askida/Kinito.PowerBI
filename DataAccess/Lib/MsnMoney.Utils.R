library(XML);
library(plyr);

MsnSymbolPath <- function(stockSymbol = "$INDU,$COMP,$TRAN,$UTIL,$COMPX,$OEX"){
  
  return(paste("http://www.msn.com/en-us/money/quoteslookup?symbol=", stockSymbol, sep = ""));
}

getKeyStats_xpath <- function(symbol = "$INDU,$COMP,$TRAN,$UTIL,$COMPX,$OEX") {
  
  msnMoneyURL <- MsnSymbolPath(trimws(symbol));
  htmlText <- XML::htmlParse(msnMoneyURL, encoding="UTF-8");
  # search for <tr> nodes anywhere inside <tbody><tbody/>
  nodes <- XML::getNodeSet(htmlText, "/*//tr");
  
  if(length(nodes) > 0 ) {
    measures <- sapply(nodes, xmlValue);
    
    # Clean up the column name
    measures <- gsub(" *[0-9]*:", "", gsub(" \\(.*?\\)[0-9]*:","", measures));
    
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
  } else {
    break;
  }
}
