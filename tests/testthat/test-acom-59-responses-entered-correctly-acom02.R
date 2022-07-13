test_that("acom-59-responses-saved-correctly", {

  #########################################################
  # Get app to results page
  #########################################################

  joins = read.csv(here::here("tests", "testthat", "files", "join.csv"))
  
  df = read_java_acom(here::here("tests", "testthat", "files", "test_acom_02.txt"))
  
  df1 = df$data %>%
    dplyr::left_join(joins, by = "item") %>%
    dplyr::arrange(itnum) %>%
    dplyr::mutate(
      response_eq = ifelse(stringr::str_detect(response, "Due to"), response, NA),
      response = ifelse(stringr::str_detect(response, "Due to"), "Doesn't apply to me", response),
      response_eq = ifelse(stringr::str_detect(response_eq, "communication"), "yes", "no"))
  
  theta1 = as.numeric(df$test_info[which(df$test_info$description=="Final T-Score Estimate"),]$value)
  sem1   = as.numeric(df$test_info[which(df$test_info$description=="Final Standard Error"),]$value)
  
  DNA_no = sum(df1$response_eq=="no", na.rm = TRUE)
  test_len = sum(!is.na(df1$response))
  
  app <- AppDriver$new(app_dir = here::here(), height = 800, width = 1200, seed = 1) 

  #### PARTICIPANT 1 TEST ####
  app$set_inputs(participant = "one")
  app$set_inputs(examiner = "two")
  app$click("next1")
  app$click("next2")
  app$click("next3")
  app$click("start")
  for(i in 1:59){
    tmp = app$get_value(export = "itnum")
    app$set_inputs(select = df1$response[which(df1$itnum==tmp)])
    app$click("enter")
    if(df1$response[which(df1$itnum==tmp)]=="Doesn't apply to me"){
      sel = df1$response_eq[which(df1$itnum==tmp)]
      app$click(sel)
    }
  }

  val = app$get_values()

  #########################################################
  # TESTS
  #########################################################

  # are we on the results page?
  testthat::expect_equal(val$export$current_page, "results")
  # are responses tracked accurately?
  
  testthat::expect_equal(val$export$values$theta, theta1, tolerance = 0.05)
  testthat::expect_equal(val$export$values$sem, sem1, tolerance = 0.05)

  testthat::expect_equal(val$export$values$test_length, 59-DNA_no)
  testthat::expect_equal(val$export$values$items_completed, 59)
  testthat::expect_equal(val$export$values$marked_NA, DNA_no)
  
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
  testthat::expect_equal(responses, df1$response)
  testthat::expect_equal(items, df1$itnum)

  
})

