
#`%!in%` <- Negate(`%in%`)

#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  
  ################################################################################
  ########################## Initialize reactive values ##########################
  # ------------------------------------------------------------------------------
  ################################################################################
  ################################################################################

  v = reactiveValues(
    i = 1, # controls changing stimuli. iterates with each response. also for ordering
    itnum = 1, # the item number from the ACOM items
    results = d, # table of all items parameters and response columns. loaded from sysdata.rda
    num_enters = 0, # for moving to the next item
    clarify = NA, # for holding the response to the DNA clarification question
  )

  ##############################################################################
  ##############################################################################
  ################################ VALIDATE INPUTS #############################
  ##############################################################################
  ##############################################################################
  
  # Ensure that the number of items is between 12 and 59 on page 1
  iv <- shinyvalidate::InputValidator$new()
  iv$add_rule("test", shinyvalidate::sv_between(12, 59))
  iv$enable()
  
  ##############################################################################
  ##############################################################################
  ################################ INTRO TAB NAV ###############################
  ##############################################################################
  ##############################################################################
  # Controls next and back buttons on the intro pages
  # next buttons
  observeEvent(input$next1, {
    req(iv$is_valid())
    updateTabsetPanel(session, "intropage", selected = "intro2")
  })
  observeEvent(input$next2, {
    updateTabsetPanel(session, "intropage", selected = "intro3")
  })
  observeEvent(input$next3, {
    updateTabsetPanel(session, "intropage", selected = "intro4")
  })
  #back buttons
  observeEvent(input$back2, {
    updateTabsetPanel(session, "intropage", selected = "intro1")
  })
  observeEvent(input$back3, {
    updateTabsetPanel(session, "intropage", selected = "intro2")
  })
  observeEvent(input$back4, {
    updateTabsetPanel(session, "intropage", selected = "intro3")
  })
  
  
  ##############################################################################
  ##############################################################################
  ################################ START OVER ##################################
  ##############################################################################
  ##############################################################################
  
  # Start over just refreshes the page/ app. This felt like the safest option
  # to ensure that nothing was carried over from the previous adminsitration. 

  observeEvent(input$start_over,{
    session$reload()
  })
  
  ##############################################################################
  ##############################################################################
  ######################### UI for items completed #############################
  ##############################################################################
  ##############################################################################

  output$item_number_slides <- renderUI({
    req(v$test_length) # require a test length value to display
    # numerator = number of valid responses (ignoring DNA = no)
    n = sum(!is.na(v$results$response_num))
    # denom = test length
    txt = paste0(n, "/", v$test_length)
    # UI aspect returned by the function
    column(align = "left", width = 12,
           div(txt, class = "response"))
  })

  ##############################################################################
  ##############################################################################
  ############################# START ASSESSMENT ###############################
  ##############################################################################
  ##############################################################################
  
  # When you hit the start button...
  observeEvent(input$start,{
    #shinyjs::hide("offline_test")  TBD...
    # Go to the acom testing tab (see app_ui.R)
    updateNavbarPage(session = session, "mainpage", selected = "acom") 
    # save the examiner and participant info in the d dataframe
    v$results$examiner = input$examiner
    v$results$participant = input$participant
    # save the test length
    v$test_length = input$test
    v$datetime = Sys.time()
  })
  
  

  ##############################################################################
  ##############################################################################
  ##############################################################################
  ################################ FANCY CAT STUFF #############################
  ##############################################################################
  ##############################################################################
  ##############################################################################
  
  # Everytime you hit enter
  observeEvent(input$enter, {
    # check that a response was entered. if not, show notification
    if (is.null(input$select)) {
      shiny::showNotification("Enter a response")
    }
    # don't go further without a response
    req(input$select)
    
    # If you select "Doesn't apply to me" open a modal...
    # asks for clarification for a DNA response
    if (input$select == "Doesn't apply to me") {
      showModal(
        modalDialog(
          size = "m",
          title = "Is this due to your communication difficulties or some other reason?",
          div(
            align = "center",
            style = "margin-top: 24px;",
            # yes action button. logic for clicking is below
            div(actionButton("yes",
                             tags$b("Due to my communication difficulties"),
                                    width = "100%"), style="margin:20px;"),
            # no action button. logic for clicking is below
            div(actionButton("no",
                             tags$b("Due to some other reason"),
                             width = "100%"), style="margin:20px;")
          ),
          footer = modalButton("Cancel"),
          easyClose = FALSE
        )
      )
    } else {
      # iterate on the number of times the enter button is selected
      # controls also the progression of items
      v$num_enters = v$num_enters + 1
    }
    
    
  })
  
  
  # close the modal when the no button is pressed
  observeEvent(input$no, {
    v$clarify = "no" # save a value for 'no'
    v$num_enters = v$num_enters + 1 # add to num_enters
    removeModal() # get rid of the modal
  })
  # same for yes
  observeEvent(input$yes, {
    v$clarify = "yes"
    v$num_enters = v$num_enters + 1
    removeModal()
  })
  
  # saving the responsedata now progresses when v$num_enters changes, either from 
  # line ~159 and a response from not very to completely. or from
  # a dna response and change after yes or no is selected
  # the following section also calculates ability, sem, and gets the next item
  
  observeEvent(v$num_enters, {
    # don't do this on start up
    req(v$num_enters > 0)
    
    # converge the response entered to a number, and a merged number for the
    # irt algorithm. see cat_calculations.R
    responses = response_to_numeric(input$select, v$clarify, v$results$merge_cats[v$itnum])
    # save the values returned by resposne_to_numeric in the correct cell in the
    # results data frame
    v$results$response_num[v$itnum] = responses$response_num # numeric response
    v$results$response[v$itnum] = responses$response # text response
    v$results$DNA_comm_dis[v$itnum] = responses$clarify # DNA response if applicable
    v$results$response_merge[v$itnum] = responses$response_merge # merged response number
    
    # calculate ability, sem, and get the next item
    # see cat_calculations.R
    # returns a list with theta, sem, and the next item number. 
    cat_data = goCAT(v)
    
    # save the ability, sem, and the order of the item
    v$results$theta[v$itnum] = cat_data$theta
    v$results$sem[v$itnum] = cat_data$sem
    v$results$order[v$itnum] = v$i
    
    # if there are at least 12 valid responses (ignoring DNA + "no")
    # then allow the user to end the test by showing this button in
    # the nav bar
    if(sum(!is.na(v$results$response_num))>=12){
      shinyjs::show("end_test")
    }
    
    # tracks the number of valid responses (non-DNA + no responses which are NA)
    valid_responses = sum(!is.na(v$results$response_num))
    # tracks the total number of responses including DNA + no
    complete_responses = sum(!is.na(v$results$response))
    
    # if you've reached the max number of responses...go to results
    # either the number of valid resposnes is at the test length
    # or the total number of rsposnes is at 59, in which case there are 
    # no more questions
    if (valid_responses == v$test_length | complete_responses == 59) {
      updateNavbarPage(session = session, "mainpage", selected = "results")
      # show the download buttons, hide end test, and show start over
      shinyjs::show("download_report-report_download")
      shinyjs::show("download_results-results_download")
      shinyjs::hide("end_test")
      shinyjs::show("start_over")
    } else {
      # otherwise, there are more items to give. 
      # reset the radio button selections
      updateRadioButtons(session, "select", selected = character(0))
      v$i = v$i + 1 # iterate on the item number
      v$itnum = cat_data$next_item # this is the next item
      v$clarify = NA # reset clarify to NA
    }
    
  })
  
  ############################################################################
  ############################################################################
  ################################ END TEST EARLY ############################
  ############################################################################
  ############################################################################
  # If you hit the end test button (only available after 12 valid responses)
  observeEvent(input$end_test,{
      # bring up a modal asking whether you want to end the test. 
      showModal(modalDialog(
        h3(
          "Are you sure you want to end the test?"
        ),
        br(),
        tags$p(
          tags$em("Note: A response entered for the current item will not be saved. To save the current response, 
               select 'Cancel', click on 'Enter', and then end the test on the next page")),
        br(),
        easyClose = TRUE,
        size = "m",
        footer = tagList(
          modalButton("Cancel"),
          # triggers the end of the test. DOES NOT save the current response
          actionButton("confirm_end_test", "End test/Go to results")
        )
      ))
    
  })
  
  # If end test has been confirmed in the modal. 
  observeEvent(input$confirm_end_test,{
    v$endTestEarly = T # marker indicating test was ended manually. not currently used
    # the total number of responses (including DNA + no)
    v$test_length = sum(!is.na(v$results$response)) 
    # go to the results page
    updateNavbarPage(session = session, "mainpage", selected = "results")
    # show download buttons, hide end test, allow start-over
    shinyjs::show("download_report-report_download")
    shinyjs::show("download_results-results_download")
    shinyjs::hide("end_test")
    shinyjs::show("start_over")
    removeModal() # remove modal

  })
  
  ################################## OUTPUTS ################################
  # ------------------------------------------------------------------------------
  ################################################################################
  
  # This pulls the question text from the spreadsheet from Will Hula
  # see cat_calculations.R
  output$questionText <- renderUI({
    txt = getTxt(v = v) # function to get current test item text
    tags$div(glue::glue("How effectively do you {txt}?"),
           style = "font-size:1.3rem;margin-top:20px;")
  })
  

  ################################## DOWNLOADS ###################################
  # ------------------------------------------------------------------------------
  ################################################################################
  # Code held in shiny modules download_report.R and download results.R
  # Download the data .csv file
  downloadResultsServer(id = "download_results",
                       # data for download. selects columns and reorders them to be 
                       # helpful for the user. extra columns saved per WH's request.
                       values = v$results %>%
                         dplyr::mutate(date = v$datetime) %>%
                         dplyr::select(item, itnum, item_content,
                                       content_area, order, response, DNA_comm_dis,
                                       theta, sem, discrim, b1, b2, b3, merge_cats,
                                       response_num, response_merge, participant,
                                       examiner, date) %>%
                         dplyr::arrange(order)) 
  # Download the report .pdf file. requires rmarkdown, pandoc, LaTex
  downloadReportServer(id = "download_report", v = v)

  ################################## SUMMARY TEXT ################################
  # ------------------------------------------------------------------------------
  ################################################################################
  #  outputs a summary sentence from the original ACOM java app
  output$results_summary <- renderUI({
    req(input$mainpage == "results") # require the results page
    # get the summary text. returns a list of text and the table. 
    summary_list = get_text_summary(v) 
    v$values = summary_list$values # these are the summary values for export for tests
    # this is the div holding the summary text and table. 
    d = div(align = "left",
            style="margin-top:30px; padding-left:24px;padding-right:24px;",
            
            tags$p(tags$b(summary_list$p1)), 
            tags$p(summary_list$p2), 
            tags$p(summary_list$p3),
            div(align = "center",
                renderTable(summary_list$table1)
            ))
    return(d)
  })
  
  ################################## TABLE #######################################
  # ------------------------------------------------------------------------------
  ################################################################################
  # outputs a table of the item level responses for the results page. 
  output$responses <- DT::renderDataTable(server = FALSE, {
    req(input$mainpage == "results") # require reults page
    # select data, make it a little easier to see
    df = v$results %>% dplyr::select(itnum, item_content,
                                     content_area, order, response, DNA_comm_dis, response_num,
                                     theta, sem) %>%
      dplyr::mutate(theta = round(theta, 4), sem = round(sem, 4)) %>%
      dplyr::arrange(order)
    # datatables output options
    DT::datatable(df,
                  rownames = FALSE,
                  options = list(rowCallback = DT::JS(rowCallback), # grey NA values
                                 dom = 'tir', # table, info, r
                                 scrollX = TRUE, # scroll x for small screens
                                 scrollY = '60vh', # no more than 60 vertical height
                                 scrollCollapse = TRUE, # not sure
                                 paging = FALSE, # no paging
                                 autoWidth = TRUE, # yes to auto width
                                 # make the text column the biggest
                                 columnDefs = list(list(width = '40%', targets = (2)))),
                  filter = list(position = 'bottom', clear = FALSE)
    )
  })
  
  ###############################################################################
  ################################################################################
  ################################## INFO MODAL #################################
  ################################################################################
  ################################################################################
  
  # holds information for the technical documentation
  observeEvent(input$info,{
      showModal(
        modalDialog(
          size = "xl",
          title = "Technical Documentation",
          div(style = "font-size:0.8rem;",
              includeMarkdown(system.file("app/www/about.md", package = "acom"))),
          footer = modalButton("Dismiss"),
          easyClose = TRUE
        )
      )
  })
  
  ################################################################################
  ################################## UPLOADS #####################################
  # ------------------------------------------------------------------------------
  ################################################################################ 
  ################################################################################
  
  #### Scoring an uploaded file. TBD. NOTE YET IN USE####
  
  # output$downloadTemplate <- downloadHandler(
  #   filename = function() {
  #     paste("acom-template", ".xlsx", sep='')
  #   },
  #   content = function(file) {
  #     # myfile <- srcpath <- 'Home/Other Layer/Fancy Template.xlsx'
  #     myfile <- srcpath <-  system.file("app/www/acom-template.xlsx", package = "acom")
  #     file.copy(myfile, file)
  #   }
  # )
  # 
  # observeEvent(input$offline_test,{
  # showModal(
  #   modalDialog(
  #     size = "m",
  #     title = "Score offline test (not yet working)",
  #     div(align = "center",
  #         div(style = "display: inline-block; text-align: left;",
  #             div(tags$b("Step 1: Download and complete Excel template file")), br(),
  #             downloadButton("downloadTemplate", "Download"), br(),br(),
  #             div(tags$b("Step 2: Upload completed file here")), br(),
  #             fileInput("file1", label = "Upload offline test excel file")
  #         )),
  #     
  #     footer = modalButton("Cancel"),
  #     easyClose = FALSE
  #   )
  # )
  # })
  
  # #observer for uploading prior administration data
  # observeEvent(input$file1,{
  #   
  #   uploadedData <- uploadData(file_input = input$file1)
  #   
  #   print(head(uploadedData))
  #   
  # })
  
  
  ################################################################################
  ################################################################################
  ################################## EXPORT TEST DATA ############################
  ################################################################################
  ################################################################################
  
  # This makes the above data available after running unit test.
  exportTestValues(values = v$values,
                   results = v$results,
                   current_page = input$mainpage,
                   itnum = v$itnum)
  
  # ----------------------------------------------------------------------------
  ##############################################################################
  ##############################################################################
  # end of app -----------------------------------------------------------------
  ##############################################################################
  ##############################################################################
  # ----------------------------------------------------------------------------
}
