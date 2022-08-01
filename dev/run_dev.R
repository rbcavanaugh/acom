# Set options here
options(golem.app.prod = FALSE) # TRUE = production mode, FALSE = development mode

# Detach all loaded packages and clean your environment
golem::detach_all_attached()
# rm(list=ls(all.names = TRUE))

# Document and reload your package      
# 
golem::document_and_reload()

# Run the application
run_app()


# knitr,
# markdown,
# utils,

# stats,
# htmltools,
# pkgload



# Versioning

# change version in app_ui.R
# change version in DESCRIPTION FILE
# change version in README
# change version in CITATION x2
# change tag on github