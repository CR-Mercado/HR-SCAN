# HR App Schemes 

#' input files 
#' identify which are pdfs .pdf
#' identify which are word docs .doc .docx 
#' read them into a named list of their contents 
#' 
#'  accept keywords 
#'  search the list for which resumes have the key words 
#'  return table of:  resume name | keyword(s) | sum 
#'  sorted by sum. 
#'  
#'   


library(shiny)


# Define UI for application 
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Resume Scan"),
  
  # Sidebar 
  sidebarLayout(
    sidebarPanel(
       h4("Search for Keywords"),
       h6("Identify the key words and phrases you would like to scan for."),
       textAreaInput(inputId = "keywords.to.search", label = "Keywords", value = " R , Programmer,"),
       actionButton(inputId = "search.the.resumes", label = "Scan Resumes"),
       
       h4("Upload PDF and Word files to Search"),
       h6("Accepts the following file types:  .pdf, .docx"),
       fileInput(inputId = "load.the.resumes", label = "Load Resumes to Search", 
                 multiple = TRUE, 
                 accept = c(".pdf",".docx"),
                 buttonLabel = "Browse")
       
    ),
    
    # Show 
    mainPanel(
      tabsetPanel(
        tabPanel(title = "Scan Results", 
                 tableOutput("top.resumes")),
       tabPanel(title = "Descriptions", 
                h6("Consider splitting up phrases into singular words, so SAS, programming, instead of SAS programming."),
                h6("Use spaces creatively for special words like R programming, e.g. BA , R , programming to ensure it is 
                   it's own word. Otherwise Bachelor of Arts searched as \"BA\" would come up with 'bad' 'barge' 
                   and 'band', search \" BA \", instead"),
       tabPanel(title = "Helpful Terms to Copy",
                h6("Resumes are hard to parse in general. The app automatically removes punctuation, but some people type the same thing
                   in different ways. Consider copy/pasting the following for gathering education: "),
                h6("phd, ph.d, ms , ma , m.s.,m.a., 
                   master of science, master of arts, mba , m.b.a, m.p.h, mph, msph, ba , bs , bachelor of arts, bachelor of science,pmp,p.m.p."))
      
    )
  )
))))
