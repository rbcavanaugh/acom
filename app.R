# Launch the ShinyApp (Do not remove this comment)
# To deploy, run: rsconnect::deployApp()
# Or use the blue button on top of this file

pkgload::load_all(export_all = FALSE,helpers = FALSE,attach_testthat = FALSE)
options( "golem.app.prod" = TRUE, shiny.autoload.r=FALSE)
acom::run_app() # add parameters here (if any)


# install.packages(c('config', 'golem','shiny','catR','DT','here','shinyjs','tibble','tidyr','dplyr','pkgload','htmltools', 'markdown','magrittr','utils','stats','knitr'))

