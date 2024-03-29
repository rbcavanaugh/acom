
#' Returns the page title for the navbar
#' 
#' Reveals keys for testing inputs during tests (not permitted by keys).
#' Code for download buttons, start-over, help, and github link
#'
#' @export
pagetitle <- function(){
  
     title = div(
       div(
           shinyjs::hidden(
             downloadReportUI(id = "download_report")
           ),
           shinyjs::hidden(
             downloadResultsUI(id = "download_results")
           ),
         shinyjs::hidden(
           actionButton("offline_test", "Score offline test",
                        style = "background-color:#f8f9fa; border:0px;")
           ),
         shinyjs::hidden(
           actionButton("end_test", "End Test",
                        style = "background-color:#f8f9fa; border:0px;")
         ),
           shinyjs::hidden(
             actionButton("start_over",
                          "Start Over",
                          style = "background-color:#f8f9fa; border:0px;")
           ),
         shinyjs::hidden(
           actionButton("instructions",
                        label = "Instructions",
                        style = "font-size: 1rem;background-color:#f8f9fa; border:0px;")
         ),
         actionButton("info", icon =  shiny::icon("file-alt"), label = NULL,
                      style = "font-size: 1rem;background-color:#f8f9fa; border:0px;")
     )
     )
  return(title)
}