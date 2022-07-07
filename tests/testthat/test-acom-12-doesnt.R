test_that("acom-12-mostly", {
  
  #########################################################
  # Get app to results page
  #########################################################
  
  app <- AppDriver$new(app_dir = here::here(), height = 800, width = 1200, seed = 1)
  
  app$set_inputs(test = 12)
  app$set_inputs(participant = "one")
  app$set_inputs(examiner = "two")
  app$click("next1")
  app$click("next2")
  app$click("next3")
  app$click("start")
  for(i in 1:5){
    app$set_inputs(select = "Mostly")
    app$click("enter")
  }
  
  app$set_inputs(select = "Doesn't apply to me")
  app$click("enter")
  app$click("no")
  
  for(i in 1:7){
    app$set_inputs(select = "Mostly")
    app$click("enter")
  }
  
  val = app$get_values()
  
  #########################################################
  # TESTS
  #########################################################
  
  # are we on the results page?
  testthat::expect_equal(val$export$current_page, "results")
  # are responses tracked accurately? 
  testthat::expect_equal(length(app$expect_download("download_results-results_download")), 33)
  # testthat::expect_gt(length(app$snapshotDownload("download_report-report_download")), 100)
  
  testthat::expect_equal(round(val$export$values$theta, 0), 56)
  testthat::expect_equal(round(val$export$values$sem,1), 2.6)

  testthat::expect_equal(val$export$values$test_length, 12)
  testthat::expect_equal(val$export$values$items_completed, 13)
  testthat::expect_equal(val$export$values$marked_NA, 1)
})
