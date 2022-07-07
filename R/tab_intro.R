#' This is the user interface for the intro pages bfore testing
#'
#' It looks a little crazy, but is relatively straightforward.
#'
#'
#' @export
intro_tab_div <- function() {
         fluidRow(column(
           width = 12,
           tabsetPanel(id = "intropage",type = "hidden",
             tabPanelBody(
               value = "intro1",
               column(width = 8, offset = 2,
                 div(align = "center",
                     h3("Aphasia Communication Outcome Measure")
                 ),
                 div(align = "center",
                     div(style = "display: inline-block; text-align: left;margin-top:30px;",
                         div(title = tooltip,
                             numericInput("test", label = "Test length (number of items)",
                             min = 12, max = 59, step = 1, value = 59)
                             ),
                         textInput("participant", "Participant ID"),
                         textInput("examiner", "Examiner ID")
                     )),br(),
                 div(align = "center",
                     actionButton("next1", "Next")
                 ),
                 div(align = "center",
                   tags$div(funding, style = "color:black; font-size:0.7rem;font-style:italic;padding:32px 80px;")
                 )
               )
             ),
             tabPanelBody(value = "intro2",
                          column(width = 8, offset = 2,
                            div(style = "font-size:1.2rem;margin-top:20px;margin-bottom:30px;",
                                includeMarkdown(system.file("app/www/instructions1.md", package = "acom"))),
                            div(align = "center",
                                actionButton("back2", "Back"), actionButton("next2", "Next"))
                          )),
             tabPanelBody(
               value = "intro3",
               column(width = 8, offset = 2, align = "center",
                 tags$h4("You will rate how effectively you perform tasks using the following categories:"),
                 tags$img(src="assets/acom_scale_radio_q.png", style="width:90%;"),
                 div(align = "center",actionButton("back3", "Back"), actionButton("next3", "Next"))
               )
             ),
             tabPanelBody(
               value = "intro4",
               column(width = 8, offset = 2,
                 div(style = "font-size:1.2rem;padding:50px;", includeMarkdown(system.file("app/www/instructions3.md",
                                                                                         package = "acom"))),
                 br(), br(), br(), br(),
                 div(align = "center",actionButton("back4", "Back"), actionButton("start", "Start"))
               )
             )
           )
         ))
}
