test_that("acom-59-responses-saved-correctly", {

  #########################################################
  # Get app to results page
  #########################################################
  df = read.csv(here::here("tests", "testthat", "files", "test1.csv"))%>%
    dplyr::mutate(response = ifelse(response == "Notvery", "Not very", response)) %>%
    dplyr::arrange(itnum)
  app <- AppDriver$new(app_dir = here::here(), height = 800, width = 1200, seed = 1) 

  #app$set_inputs(test = 59)
  app$set_inputs(participant = "one")
  app$set_inputs(examiner = "two")
  app$click("next1")
  app$click("next2")
  app$click("next3")
  app$click("start")
  for(i in 1:59){
    tmp = app$get_value(export = "itnum")
    app$set_inputs(select = df$response[which(df$itnum==tmp)])
    app$click("enter")
  }

  val = app$get_values()

  #########################################################
  # TESTS
  #########################################################

  # are we on the results page?
  testthat::expect_equal(val$export$current_page, "results")
  # are responses tracked accurately?
  
  testthat::expect_equal(round(val$export$values$theta, 2), 60.37)
  testthat::expect_equal(round(val$export$values$sem, 1), 1.5)

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
  testthat::expect_equal(responses, df$response)
  testthat::expect_equal(items, df$itnum)
  
  
})
