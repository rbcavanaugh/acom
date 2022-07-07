
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
    i = 1,
    itnum = 1,
    results = d,
    num_enters = 0,
    counter = 1,
    clarify = NA
  )
  
  ################################################################################
  ########################## Dealing with user's time ############################
  # ------------------------------------------------------------------------------
  ################################################################################
  ################################################################################
  
  # runs a jsCode snippet from extendshinyJS (see app_ui)
  # this gets the users time
  # when it changes, it is saved in the reactive values
  shinyjs::js$gettime()
  observeEvent(input$jstime,{
    dt <- input$jstime # establishes datetime when app opens for saving
    v$datetime <- as.character(strptime(dt, format = '%a %b %d %Y %H:%M:%S GMT%z'))
    cat("app was opened on", v$datetime, "\n",
        "--------------------------------", "\n")
  }, once = T) # we only want this to happen once

  ################################################################################
  ################################## UPLOADS #####################################
  # ------------------------------------------------------------------------------
  ################################################################################ 
  ################################################################################
  
  output$downloadTemplate <- downloadHandler(
    filename = function() {
      paste("acom-template", ".xlsx", sep='')
    },
    content = function(file) {
      # myfile <- srcpath <- 'Home/Other Layer/Fancy Template.xlsx'
      myfile <- srcpath <-  system.file("app/www/acom-template.xlsx", package = "acom")
      file.copy(myfile, file)
    }
  )
  
  observeEvent(input$offline_test,{
  showModal(
    modalDialog(
      size = "m",
      title = "Score offline test (not yet working)",
      div(align = "center",
          div(style = "display: inline-block; text-align: left;",
              div(tags$b("Step 1: Download and complete Excel template file")), br(),
              downloadButton("downloadTemplate", "Download"), br(),br(),
              div(tags$b("Step 2: Upload completed file here")), br(),
              fileInput("file1", label = "Upload offline test excel file")
          )),
      
      footer = modalButton("Cancel"),
      easyClose = FALSE
    )
  )
  })
  
  #observer for uploading prior administration data
  observeEvent(input$file1,{

    uploadedData <- uploadData(file_input = input$file1)
    
    print(head(uploadedData))

  })
  
  ##############################################################################
  ##############################################################################
  ################################ VALIDATE INPUTS #############################
  ##############################################################################
  ##############################################################################
  
  iv <- shinyvalidate::InputValidator$new()
  iv$add_rule("test", shinyvalidate::sv_between(12, 59))
  iv$enable()
  
  ##############################################################################
  ##############################################################################
  ################################ INTRO TAB NAV ###############################
  ##############################################################################
  ##############################################################################
  
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
  ################################ KEYS ########################################
  ##############################################################################
  ##############################################################################
  
  # Logic for how the key presses work. 

  
  # and the green circle for the assessment slides. 
  output$item_number_slides <- renderUI({
    req(v$test_length)
    n = sum(!is.na(v$results$response_num))
    txt = paste0(n, "/", v$test_length)
    column(align = "left", width = 12,
           div(txt, class = "response"))
  })


  ##############################################################################
  ##############################################################################
  ################################## START ASSESSMENT ##########################
  ##############################################################################
  ##############################################################################
  
  observeEvent(input$start,{
    shinyjs::hide("offline_test")
    updateNavbarPage(session = session, "mainpage", selected = "acom")
    v$results$examiner = input$examiner
    v$results$participant = input$participant
    #v$test_length = ifelse(input$test=="custom", input$custom, input$test)
    v$test_length = input$test
    v$start_time = as.character(strptime(input$jstime,
                                              format = '%a %b %d %Y %H:%M:%S GMT%z'))
    cat("Testing started on", v$start_time, "\n")
  })
  
  

  ##############################################################################
  ##############################################################################
  ##############################################################################
  ################################ FANCY CAT STUFF #############################
  ##############################################################################
  ##############################################################################
  ##############################################################################
  
  # observeEvent(input$enter,{
  #   v$counter = v$counter + 1
  #   cat("enter click")
  # })
  # 
  # observeEvent(input$enter_key,{
  #   v$counter = v$counter + 1
  #   cat("enter key")
  # })
  
  observeEvent(input$enter, {
    # check that a response was entered
    if (is.null(input$select)) {
      shiny::showNotification("Enter a response")
    }
    # don't gor further otherwise
    req(input$select)
    
    # If you select "Doesn't apply to me" open a modal...
    if (input$select == "Doesn't apply to me") {
      showModal(
        modalDialog(
          size = "m",
          title = "Is this due to your communication difficulties or some other reason?",
          div(
            align = "center",
            style = "margin-top: 24px;",
            div(actionButton("yes",
                             tags$b("Yes, due to my communication difficulties"),
                                    width = "100%"), style="margin:20px;"),
            div(actionButton("no",
                             tags$b("No, due to some other reason"),
                             width = "100%"), style="margin:20px;")
            
            # shinyWidgets::radioGroupButtons(
            #   "clarify",
            #   label = NULL,
            #   choices = c(
            #     "No, due to some other reason" = "no",
            #     "Yes, due to my communication difficulties" =
            #       "yes"
            #   ),
            #   selected = character(0)
            #   
            # )
          ),
          footer = modalButton("Cancel"),
          easyClose = FALSE
        )
      )
    } else {
      v$num_enters = v$num_enters + 1
    }
    
    
  })
  
  
  # close the modal when one of the buttons is pressed
  observeEvent(input$no, {
    v$clarify = "no"
    v$num_enters = v$num_enters + 1
    removeModal()
  })
  observeEvent(input$yes, {
    v$clarify = "yes"
    v$num_enters = v$num_enters + 1
    removeModal()
  })
  
  observeEvent(v$num_enters, {
    # don't do this on start up
    req(v$num_enters > 0)
    
    responses = response_to_numeric(input$select, v$clarify, v$results$merge_cats[v$itnum])
    v$results$response_num[v$itnum] = responses$response_num
    v$results$response[v$itnum] = responses$response
    v$results$DNA_comm_dis[v$itnum] = responses$clarify
    v$results$response_merge[v$itnum] = responses$response_merge
    
    cat_data = goCAT(v)
    
    v$results$theta[v$itnum] = cat_data$theta
    v$results$sem[v$itnum] = cat_data$sem
    v$results$order[v$itnum] = v$i
    
    #print(head(v$results, 3))
    
    if(sum(!is.na(v$results$response_num))>=12){
      shinyjs::show("end_test")
    }
    
    # if you've reached the max number of responses...go to results
    if (sum(!is.na(v$results$response_num)) == v$test_length) {
      updateNavbarPage(session = session, "mainpage", selected = "results")
      shinyjs::js$gettime() #end time
      shinyjs::show("download_report-report_download")
      shinyjs::show("download_results-results_download")
      shinyjs::hide("end_test")
      shinyjs::show("start_over")
    } else {
      # otherwise, iterate on the i
      updateRadioButtons(session, "select", selected = character(0))
      
      v$i = v$i + 1
      v$itnum = cat_data$next_item
      v$clarify = NA
      
    }
    
    
  })
  
  ############################################################################
  ############################################################################
  ################################ END TEST EARLY ############################
  ############################################################################
  ############################################################################
  # Bring up the modal
  
  observeEvent(input$end_test,{
    
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
          actionButton("confirm_end_test", "End test/Go to results")
        )
      ))
    
  })
  # 
  # # If end test has been confirmed in the modal. 
  observeEvent(input$confirm_end_test,{
    v$endTestEarly = T # marker indicating test was ended manually
    shinyjs::js$gettime() #end time
    v$test_length = sum(!is.na(v$results$response))
    updateNavbarPage(session = session, "mainpage", selected = "results")
    shinyjs::show("download_report-report_download")
    shinyjs::show("download_results-results_download")
    shinyjs::hide("end_test")
    shinyjs::show("start_over")
    removeModal() # modal go bye bye

  })
  
  
  ################################## OUTPUTS ################################
  # ------------------------------------------------------------------------------
  ################################################################################
  
  output$questionText <- renderUI({
    txt = getTxt(v = v)
    tags$div(glue::glue("How effectively do you {txt}?"),
           style = "font-size:1.3rem;margin-top:20px;")
  })
  

  ################################## DOWNLOADS ###################################
  # ------------------------------------------------------------------------------
  ################################################################################
  
  # Data
  # Code held in shiny modules download_report.R and download results.R
  downloadResultsServer(id = "download_results",
                       values = v$results%>%
                         dplyr::select(item, itnum, item_content,
                                       content_area, order, response, DNA_comm_dis,
                                       theta, sem, discrim, b1, b2, b3, merge_cats, response_num, response_merge) %>%
                         dplyr::arrange(order)) 
  # downloadResultsServer(id = "download_results_rescore",
  #                      values = v$results)
   # REPORT 
  downloadReportServer(id = "download_report",
                       v = v)
  # downloadReportServer(id = "download_report_rescore",
  #                      values = values,
  #                      notes = input$notes)
  
  ################################## PLOT ######################################## 
  # ------------------------------------------------------------------------------
  ################################################################################
  # output$plot <- renderPlot({
  #     req(values$irt_final)
  #     get_plot(irt_final = values$irt_final)
  # })
  # 
  # output$plot_caption <- renderUI({
  #     req(values$irt_final)
  #     tags$em(
  #       get_caption(repeat_admin = !values$new_test)
  #     )
  # })

  ################################## SUMMARY TEXT ################################
  # ------------------------------------------------------------------------------
  ################################################################################
  #  outputs a summary sentence
  output$results_summary <- renderUI({
    req(input$mainpage == "results")
    summary_list = get_text_summary(v)
    
    d = div(align = "left",
            style="margin-top:30px; padding-left:24px;padding-right:24px;",
            
            tags$p(tags$b(summary_list$p1)), 
            tags$p(summary_list$p2), 
            tags$p(summary_list$p3),
            div(align = "center",
                renderTable(summary_list$table1)
            )
    )
    
    return(d)
    
  })
  
  ################################## TABLE #######################################
  # ------------------------------------------------------------------------------
  ################################################################################
  # outputs a table of the item level responses
  
  output$responses <- DT::renderDataTable(server = FALSE, {
    req(input$mainpage == "results")
    df = v$results %>% dplyr::select(itnum, item_content,
                                     content_area, order, response, DNA_comm_dis, response_num,
                                     theta, sem) %>%
      dplyr::mutate(theta = round(theta, 4), sem = round(sem, 4)) %>%
      dplyr::arrange(order)
    
    DT::datatable(df,
                  rownames = FALSE,
                  options = list(rowCallback = DT::JS(rowCallback),
                                 dom = 'tir',
                                 scrollX = TRUE,
                                 scrollY = '60vh',
                                 scrollCollapse = TRUE,
                                 paging = FALSE,
                                 autoWidth = TRUE,
                                 columnDefs = list(list(width = '40%', targets = (2)))),
                  filter = list(position = 'bottom', clear = FALSE)
    )
      
  })
  
  
  
  ###############################################################################
  ################################################################################
  ################################## INFO MODAL #################################
  ################################################################################
  ################################################################################
  
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
  ################################################################################
  ################################## EXPORT TEST DATA ############################
  ################################################################################
  ################################################################################
  
  # observeEvent(input$mainpage,{
  #   values$current_page = input$mainpage
  #   cat(paste("The page updated to", values$current_page, "\n"))
  #   if(values$current_page == "Results"){
  #     if(!isTruthy(values$score_uploaded_test)){
  #       values$end_time = as.character(strptime(input$jstime,
  #                                               format = '%a %b %d %Y %H:%M:%S GMT%z'))
  #       values$duration = as.POSIXlt(values$end_time)-as.POSIXlt(values$start_time)
  #       cat("Testing ended on", values$end_time, "\n",
  #           "Total testing time was", round(values$duration[[1]], 2),
  #                                         units(values$duration), "\n")
  #     }}
  # })
  # 
  # # This makes the above data available after running unit test.
  # exportTestValues(irt_final = values$irt_final,
  #                  results = values$results_data_long,
  #                  current_page = values$current_page#,
  #                  #values = values
  # )
  
  
  
  # ----------------------------------------------------------------------------
  ##############################################################################
  ##############################################################################
  # end of app -----------------------------------------------------------------
  ##############################################################################
  ##############################################################################
  # ----------------------------------------------------------------------------
}
