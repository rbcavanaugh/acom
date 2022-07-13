#' read java acom
#'
#' @param path path of acom .txt file from java app
#'
#' @return a list of two data frames, one with test info and one with test data
#' @export
read_java_acom <- function(path){
  

    df_txt = readLines(path) %>%
      tibble::as_tibble()
    
    detect = paste(
      c(
      "Examinee",
      "Administrator",
      "Final T-Score Estimate",
      "Final Standard Error",
      "Session", 
      "Date",
      "95% C.I.",
      "Item parameter set used",
      "Number of items administered",
      "Number of items marked NA"
    ), collapse = "|")
    
    test_info = df_txt %>%
      dplyr::filter(stringr::str_detect(value, detect)) %>%
      tidyr::separate(value, into = c("description", "value"), sep = ":|=", extra = "merge") %>%
      dplyr::mutate(description = stringr::str_trim(description),
             value = stringr::str_trim(value)) %>%
      dplyr::slice(1:10)
    
    df = readr::read_lines(path, skip = 79) %>% 
      tibble::as_tibble() %>% dplyr::filter(value != "") %>% 
      dplyr::mutate(value = stringr::str_trim(value)) %>%
      tidyr::separate(value, c("index", "item", "item_content", "response", "response_eq", "theta", "sem", "time"), sep = "[ ]{2,}" )
    
    colnames(df) = c("index", "item", "item_content", "response", "response_eq", "theta", "sem", "time")
    
    out = list(
      test_info = test_info,
      data = df
    )

  return(out)
    
}
