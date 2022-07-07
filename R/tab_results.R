#' Shows the user interface for the results page. 
#' 
#' @export
results_tab_div <- function(){
  fluidRow(style = "margin-bottom:100px;",
  column(width = 10,offset = 1, br(),
         tabsetPanel(tabPanel("Summary",
                        
                          uiOutput("results_summary")
                        
                     ),
                     tabPanel("Data", 
                              DT::DTOutput("responses")
                     )
         )
      )
    )
}