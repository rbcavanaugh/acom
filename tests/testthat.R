library(testthat)
library(shinytest2)
library(acom)

testthat::test_local(path = here::here("tests", "testthat"))


# Testing to do:

# Check that downloaded file logged the response strings correctly. 
# come up with several response strings of 12, 35, 38, 59. 
# download the end file
# Check that the responses entered in order match the file. 