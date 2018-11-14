

library(shiny)
library(pdftools) # reads pdfs
library(officer)  # reads word docs

# Define server logic 
shinyServer(function(input, output) {
  # stop app when done 
 
  
  
  resume.load <- eventReactive(input$load.the.resumes,{ 
       
  
      # inFile is a dataframe of: name | size | type | datapath  # separate pdfs and word docs 
      inFile <- input$load.the.resumes
      
      # create a table of the following:    filename | content
       content.table <- load.doc.or.pdf(inFile$datapath)
       content.table$document <- inFile$name  
       content.table
    
    })
       
     
  resume.search <- eventReactive(input$search.the.resumes, {  # when search is pressed
                                  
      # identify the keywords and split them by commas, while also putting them to lowercase 
      keywords <- input$keywords.to.search
      keywords <- tolower(unlist(strsplit(keywords, ",")))  
                                  
      # now to search and add the columns  | keyword1 | keyword2 | ... keywordN 
      # where keyword_ is a 1 or 0 for if the keyword is in the content 
      
      tbl <- resume.load()
      
      for(i in keywords){              # initially, create each column as all NAs. 
        tbl[i] <- rep(NA,nrow(tbl)) 
        for(j in 1:nrow(tbl)){         # then go and replace each NA with a 1 or 0 
          tbl[j,i] <- as.numeric(ifelse(test = grepl(i,tbl[j,2], fixed = TRUE),1,0))
        }
      }
           # get the sum of the numeric columns       
      tbl$total <- apply(X = tbl[,-c(1,2)],
                       MARGIN = 1,
                       FUN = sum)
      tbl <- tbl[order(tbl$total, decreasing = TRUE),]
      tbl
                                  })
  
 output$top.resumes <- renderTable({  
   

                       resume.search()[,-2] # don't show the content column 
                
   }, digits = 0) 
  
 # Duplicate stop app when done. Not sure why the !interactive() did not work. 
 
})



################################ Keyword finder 

load.doc.or.pdf <- function(documents.filepath){
  # this function takes a vector of filepaths
  # and reads its content (whether pdf or word doc)
  # it then combines them into a dataframe of:   document | content 
  
y <- NULL

for(i in documents.filepath){
x <- NULL
temp. <- NULL
doc.type <- ifelse(test = grepl(".pdf",i,fixed = TRUE),"pdf","docx")

if(doc.type == "pdf"){
    temp. <- pdf_text(i)
    temp. <- paste(temp., collapse = " ")
    temp. <- gsub("\\n|\\r"," ",temp.)
}
else if(doc.type == "docx"){
    temp. <- docx_summary(read_docx(i))
    temp. <- paste(temp.$text,collapse = " ")
}
  temp. <- tolower(temp.)
  x <- cbind.data.frame(i, temp., stringsAsFactors = FALSE)
  colnames(x) <- c("document","contents")
  y <- rbind.data.frame(y,x, stringsAsFactors = FALSE)
  
}
return(y)
}
