
################################## UI ##########################################
# ------------------------------------------------------------------------------
################################################################################

app_ui <- function(request) {
  shinyUI(
  tagList(
  
################################### SETUP ######################################

                keys::useKeys(),
                shinyjs::useShinyjs(),
                waiter::use_waiter(),
                waiter::waiter_preloader(html = waiter::spin_plus()),
                keys::keysInput("keys", response_keys),
                keys::keysInput("enter_key", enter),
                keys::keysInput("end_test", end_test_key),
                includeCSS("www/style.css"),
      
################################### layout starts here ######################### 
      
        navbarPage(title = pagetitle(),
                   id = "mainpage",
                   footer = tags$div(
                    id = "footer_id",
                    class = "footer",
                    footer_div()
                   ),
                   theme = minimal_theme(),

        ############################ Instructions ############################## 
        
        tabPanelBody(value = "Home",
                  shiny.pwa::pwa("https://rb-cavanaugh.shinyapps.io/pnt-cat/",
                                 output = "www",
                                 title = "shinyCAT",
                                 icon = "www/cat.png"),
                  tags$audio(id = "audio",
                             src = "click.wav",
                             type = "audio/wav",
                             style = "display:none;"),
                  intro_tab_div()
         ),
        
        ############################ Practice ##################################
        
        tabPanelBody(value = "Practice", 
                 uiOutput("practice_tab")
                 ),
         
        ############################ Assessment ################################
        
        tabPanelBody(value = "Assessment", 
                  uiOutput("slides_tab")
                  ),
        
        ############################ Results ###################################
        
        tabPanelBody(value = "Results", 
                     results_tab_div()
                 )
        
        ########################################################################
        
    # close navbar page
    ),
     
    # adjusting for footer. 
    br(), br(), br(), br(), br(), 
#end of UI   
    )
  )
}