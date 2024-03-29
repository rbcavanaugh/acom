
#' Shows the user interface for the practice slides. 
#'
#' @param values values
#' @export
acom_tab_div <- function(values){
       div(
         shiny::fluidRow(style="height:0px;",
                         column(align = "left", width = 6,
                                shiny::uiOutput("item_number_slides")),
                         column(align = "right", width = 6,
                                actionButton("help", icon =  shiny::icon("circle-info"), label = uiOutput("item_info"),
                                                             style = "font-size: 1rem;background-color:#fff; border:0px;",
                                                             class = "ttip"))
         ),
         shiny::fluidRow(
           column(width = 10,offset = 1,align = "center",
           uiOutput("questionText"),
         )),
         shiny::fluidRow(style = "min-height:510px;",
             shiny::column(width = 8, offset = 4,
               div(id = "stim",
                   div(class = "container",
                      tags$img(src = "assets/acom_scale_radio.png", style = "height:500px;position:absolute;"),
                       radioButtons("select",label = NULL, inline = TRUE, selected = character(0),
                                   choices = c(
                                     "Doesn't apply to me",
                                     "Not very",
                                     "Somewhat",
                                     "Mostly",
                                     "Completely"
                                   ))
                               ))
                         )),
         shiny::fluidRow(
           shiny::column(width = 10,offset = 1,align = "center",
             actionButton("enter", "Enter")
           )))
}