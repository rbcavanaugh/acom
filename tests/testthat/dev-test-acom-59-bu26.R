# test_that("acom-59-mostly", {
#   
#   #########################################################
#   # Get app to results page
#   #########################################################
#   df = tibble::tibble(
#     response = c(1,0,3,3,3,3,2,2,3,1,3,2,0,2,3,3,2,3,2,2,2,2,0,0,1,2,1,2,1,2,2,3,3,2,3,2,2,2,1,3,3,2,2,3,2,3,3,1,1,2,1,2,1,3,2,2,3,3,1)
#     ) %>%
#     dplyr::mutate(response_num = dplyr::case_when(
#         response == 3 ~ "Completely",
#         response == 2 ~ "Mostly",
#         response == 1 ~ "Somewhat",
#         response == 0 ~ "Not very"
#       )
#     )
#   
#   app <- AppDriver$new(app_dir = here::here(), height = 800, width = 1200, seed = 1)
#   
#   #app$set_inputs(test = 59)
#   app$set_inputs(participant = "one")
#   app$set_inputs(examiner = "two")
#   app$click("next1")
#   app$click("next2")
#   app$click("next3")
#   app$click("start")
#   for(i in 1:59){
#     app$set_inputs(select = df$response_num[i])
#     app$click("enter")
#   }
#   
#   val = app$get_values()
#   
#   #########################################################
#   # TESTS
#   #########################################################
#   
#   # are we on the results page?
#   testthat::expect_equal(val$export$current_page, "results")
#   # are responses tracked accurately? 
#   testthat::expect_equal(length(app$expect_download("download_results-results_download")), 33)
#   
#   
#   testthat::expect_equal(round(val$export$values$theta, 0), 57)
#   testthat::expect_equal(round(val$export$values$sem,1), 1.4)
# 
#   testthat::expect_equal(val$export$values$test_length, 59)
#   testthat::expect_equal(val$export$values$items_completed, 59)
#   testthat::expect_equal(val$export$values$marked_NA, 0)
# })
