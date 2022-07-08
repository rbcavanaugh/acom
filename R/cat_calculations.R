#' goCat
#'
#' @param v all values
#'
#' @return list of three irt parameters theta, sem, next_item
#' @export
#'
goCAT <- function(v){
  
  # start with the table of all responses and items
  # get rid of hte items without a repsonse yet
  dat = v$results %>% tidyr::drop_na(response) 
  # the item numbers of the completed items for the next item function
  done = dat$itnum
  # need to keep track of the valid and total responses here. 
  valid_responses = nrow(dat %>% tidyr::drop_na(response_num))
  total_responses = nrow(dat)
  # if there are no responses yet, start with theta = 50.
  if(all(is.na(dat$response_num))){
    cur_theta = NA
    cur_sem = NA
    theta = 50
  } else {
    
    #estimate theta using discrim, b1, b2, b3 columns from d. 
    cur_theta <- catR::thetaEst(
                          # item parameters
                          it = dat %>% 
                            dplyr::select(discrim, b1, b2, b3),
                          x = dat$response_merge, # responses
                          method = "EAP", model = "GRM", # method info
                          D = 1, priorDist = "norm",
                          priorPar = c(50, 10),
                          parInt = c(10, 90, 33))
    theta = cur_theta
    
    cur_sem <- catR::semTheta(cur_theta, # current theta etimate from above
                        it = dat %>% dplyr::select(discrim, b1, b2, b3),
                        x = dat$response_merge,
                        method = "EAP", model = "GRM", D = 1, priorDist = "norm",
                        priorPar = c(50, 10), parInt = c(10, 90, 33))
  }
  
  # only get the next item if the number of valid reponses hasn't reached the
  # test length yet AND the total number of repsonses is less than 59. Has 
  # to be an AND not an OR. Otherwise the teset will fail with lots of
  # invalid DNA + no responses. 
  if(valid_responses < v$test_length & total_responses < 59){

        it_next <- catR::nextItem(
                        itemBank = bank,
                        model = "GRM",
                        theta = theta,
                        out = done,
                        x = NULL,
                        criterion = "MFI",
                        method = "EAP",
                        priorDist = "norm", priorPar = c(50, 10),
                        D = 1, range = c(10, 90), parInt = c(10, 90, 81),
                        infoType = "observed",
                        randomesque = 1, random.seed = check_test_random(),
                        rule = "length", thr = 20, SETH = NULL,
                        AP = 1, nAvailable = NULL, maxItems = 59, 
                        cbControl = acom_cbControl, cbGroup = acom_cb_group)
  
        next_item = it_next$item
  } else {
    # if there are no more items or the test is over, just put NA
    next_item = NA
  }
  
  # list of theta, sem, and next item to return
  data_out = list(theta = cur_theta,
                  sem = cur_sem,
                  next_item = next_item)
  
  return(data_out)
  
}


#' response_to_numeric
#'
#' @param select selected response
#' @param clarify ask for clarification for doesn't apply
#'
#' @return single row dataframe with response, response_num, response_merge, and clarify
#' @export
response_to_numeric <- function(select, clarify, merge){
  # From Will's script:
  # cannot do because of my communication problem = 0
  # cannot do for some other reason = NA
  # not very = 0
  # somewhat = 1
  # mostly = 2
  # completely = 3 
  
  df = tibble::tibble(response = select, clarify = clarify, merge_cats = merge) 
  #print(df)
  
  df = df %>%
    # Convert response to numeric
    dplyr::mutate(response_num = dplyr::case_when(
      response == "Completely" ~ 3,
      response == "Mostly" ~ 2,
      response == "Somewhat" ~ 1,
      response == "Not very"~ 0,
      response == "Doesn't apply to me" & clarify == "no" ~ NA_real_,
      response == "Doesn't apply to me" & clarify == "yes" ~ 0,
      TRUE ~ 999
    )) %>%
    # merge response
    dplyr::mutate(response_merge = dplyr::case_when(
      merge_cats == 1 & response_num == 1 ~ 0,
      merge_cats == 1 & response_num == 2 ~ 1,
      merge_cats == 1 & response_num == 3 ~ 2,
      
      merge_cats == 2 & response_num == 2 ~ 1,
      merge_cats == 2 & response_num == 3 ~ 2,
      
      merge_cats == 3 & response_num == 3 ~ 2,
      
      merge_cats == 4 & response_num == 2 ~ 1,
      merge_cats == 4 & response_num == 3 ~ 1,
      TRUE ~ response_num
    )) %>%
    # select columns needed. 
    dplyr::select(response, response_num, response_merge, clarify)
  # return a single row dataframe with the needed items
  return(df)
}


#' Get text
#'
#' @param v all data
#'
#' @return the sentence of the current stimuli
#' @export

getTxt <- function(v) {
  txt = d$item_content[v$itnum]
  return(txt)
}

#' check test random
#'
#' @return random seed if test mode for consistent responses
#' @export
check_test_random <- function(){
  if(isTRUE(getOption("shiny.testmode"))){
    return(1)
  } else {
    return(NULL)
  } 
}
