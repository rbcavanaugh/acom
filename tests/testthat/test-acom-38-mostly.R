test_that("acom-38-mostly", {
  
  #########################################################
  # Get app to results page
  #########################################################
  
  app <- AppDriver$new(app_dir = here::here(), height = 800, width = 1200, seed = 1)
  
  #app$set_inputs(test = 59)
  app$set_inputs(participant = "one")
  app$set_inputs(examiner = "two")
  app$click("next1")
  app$click("next2")
  app$click("next3")
  app$click("start")
  for(i in 1:38){
    app$set_inputs(select = "Mostly")
    app$click("enter")
  }
  
  app$click("end_test")
  app$click("confirm_end_test")
  
  val = app$get_values()
  
  #########################################################
  # TESTS
  #########################################################
  
  # are we on the results page?
  testthat::expect_equal(val$export$current_page, "results")
  # do the download files work?
  # length of file names are tested. should be 33 characters long
  # irt model sometimes goes in different orders, so could reasonable have
  # slightly different files  
  # testthat::expect_equal(length(app$expect_download("download_results-results_download")), 33)
  #testthat::expect_equal(length(app$expect_download("download_report-report_download")), 33)
  
  testthat::expect_equal(round(val$export$values$theta, 0), 57)
  testthat::expect_equal(round(val$export$values$sem,1), 1.6)

  testthat::expect_equal(val$export$values$test_length, 38)
  testthat::expect_equal(val$export$values$items_completed, 38)
  testthat::expect_equal(val$export$values$marked_NA, 0)
})
