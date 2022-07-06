#' Shows the user interface for the results page. 
#' 
#' @export
results_tab_div <- function(){
  fluidRow(
  column(width = 10,offset = 1, br(),
         tabsetPanel(tabPanel("Summary",
                        
                          uiOutput("results_summary")
                        
                     ),
                     tabPanel("Data", 
                              DT::DTOutput("responses")
                     ),
                     tabPanel("About", 
                              div(style = "font-size:0.8rem;margin-top:30px;margin-bottom:30px;",
                                  includeMarkdown(system.file("app/www/about.md", package = "acom"))),
                     )
         )
      )
    )
}