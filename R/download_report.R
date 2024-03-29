
#' download report button module UI
#'
#' @param id 
#'
#' @export
downloadReportUI <- function(id) {
  ns <- NS(id)
  
  downloadButton(ns("report_download"),
                 label = "Download Report",
                 style = "background-color:#f8f9fa; border:0px;")
}

#' Download report module
#'
#' @param id 
#' @param v 
#'
#' @export
downloadReportServer <- function(id, v, dt) {
  
  moduleServer(id, function(input, output, session){
      output$report_download <- downloadHandler(
        
        # For PDF output, change this to "report.pdf"
        filename = paste(as.character(Sys.Date()),
                         unique(v$results$participant), "acom.pdf", sep = "_"
        ),
        content = function(file) {
          withProgress(message = 'Rendering, please wait!', {
            tempReport <- system.file("report.Rmd", package = "acom")
            file.copy(paste(as.character(Sys.Date()),
                            unique(v$results$participant), "acom.pdf", sep = "_"
            ), tempReport, overwrite = TRUE)
            
            # Set up parameters to pass to Rmd document
            params <- list(
              v = v,
              dt = dt
            )
            
            rmarkdown::render(tempReport, output_file = file,
                              params = params,
                              envir = new.env(parent = globalenv())
            )
            
          })
        }
      )
  })
}

