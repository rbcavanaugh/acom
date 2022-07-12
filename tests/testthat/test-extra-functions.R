# Testing for two additional functions

df = combine_acom_files(folder_path = here::here("inst", "example_acom_files"))

testthat::expect_equal(nrow(df), 118)
testthat::expect_equal(ncol(df), 19)
testthat::expect_equal(unique(df$participant), c(NA, "sadg"))
testthat::expect_equal(sum(df$response_num, na.rm = TRUE), 7)



df = combine_acom_files(folder_path = here::here("inst", "example_acom_files"), summary = TRUE)

testthat::expect_equal(nrow(df), 2)
testthat::expect_equal(ncol(df), 8)
testthat::expect_equal(sum(is.na(df)), 2)
testthat::expect_equal(sum(df$num_items), 25)

rm(df)

df_list = read_java_acom(here::here("tests", "testthat", "files", "test1.txt"))

info = df_list$test_info
record = df_list$data

testthat::expect_equal(sum(is.na(info)), 0)
testthat::expect_equal(nrow(info), 10)

testthat::expect_equal(sum(is.na(record)), 0)
testthat::expect_equal(nrow(record), 59)

