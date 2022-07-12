test_that("acom-59-responses-saved-correctly", {

  #########################################################
  # Get app to results page
  #########################################################

  joins = read.csv(here::here("tests", "testthat", "files", "join.csv"))
  
  df = read_java_acom(here::here("tests", "testthat", "files", "test2.txt"))
  
  df2 = df$data %>%
    dplyr::left_join(joins, by = "item") %>%
    dplyr::arrange(itnum)
  
  theta2 = as.numeric(df$test_info[which(df$test_info$description=="Final T-Score Estimate"),]$value)
  sem2   = as.numeric(df$test_info[which(df$test_info$description=="Final Standard Error"),]$value)
  
  app <- AppDriver$new(app_dir = here::here(), height = 800, width = 1200, seed = 1) 

  
  #### ------------------------------- END P1 ------------------------------####
  
  #### PARTICIPANT 2 TEST ####
  
  app$set_inputs(participant = "three")
  app$set_inputs(examiner = "four")
  app$click("next1")
  app$click("next2")
  app$click("next3")
  app$click("start")
  for(i in 1:59){
    tmp = app$get_value(export = "itnum")
    app$set_inputs(select = df2$response[which(df2$itnum==tmp)])
    app$click("enter")
  }
  
  val = app$get_values()
  
  #########################################################
  # TESTS
  #########################################################
  
  # are we on the results page?
  testthat::expect_equal(val$export$current_page, "results")
  # are responses tracked accurately?
  
  testthat::expect_equal(val$export$values$theta, theta2, tolerance = 0.05)
  testthat::expect_equal(val$export$values$sem, sem2, tolerance = 0.05)
  
  testthat::expect_equal(val$export$values$test_length, 59)
  testthat::expect_equal(val$export$values$items_completed, 59)
  testthat::expect_equal(val$export$values$marked_NA, 0)
  
  # test that responses entered into the app are logged correctly
  # arrange the data by item number
  # pull the responses by strings and the item number identifier
  # test that the strings are equal to the strings entered above
  # and the item numbers are identical
  # if all else fails, this ensures that the .csv file
  # output of the app is proving the correctly entered responses
  # so that responses can be rescored in an R script. 
  items = val$export$results %>% dplyr::arrange(itnum) %>% dplyr::pull(itnum)
  responses = val$export$results %>% dplyr::arrange(itnum) %>% dplyr::pull(response)
  testthat::expect_equal(responses, df2$response)
  testthat::expect_equal(items, df2$itnum)
  
  
})
