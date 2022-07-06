  
#' Text summary for the top of the results page above the plot
#'
#' @param v all data
#' @export
get_text_summary <- function(v){
  
  final = v$results %>%
    tidyr::drop_na(response) %>%
    dplyr::filter(order == max(order, na.rm = TRUE)) %>%
    dplyr::mutate(theta = round(theta, 2), sem = round(sem, 2))
  
  theta = final$theta
  sem = final$sem
  z = (theta-50)/10
  ab = ifelse(z>=0, "above", "below")
  
  x95 = glue::glue("{round(theta-1.96  *sem, 2)}, {round(theta+1.96  *sem, 2)}")
  x90 = glue::glue("{round(theta-1.645 *sem, 2)}, {round(theta+1.645 *sem, 2)}")
  x68 = glue::glue("{round(theta-1     *sem, 2)}, {round(theta+1     *sem, 2)}")
  
  completed = v$results %>%
    dplyr::mutate(theta = round(theta, 2), sem = round(sem, 2)) %>%
    tidyr::drop_na(response)
  
  valid = v$results %>%
    dplyr::mutate(theta = round(theta, 2), sem = round(sem, 2)) %>%
    tidyr::drop_na(response_num)
  
  table1 = tibble::tribble(
    ~"label", ~"score",
    "Final T-Score Estimate" , as.character(theta),
    "Final Standard Error"   , as.character(sem),   
    "Final Estimate Type"    , as.character("EAP"),   
    "95% C.I."               , as.character(x95),
    "90% C.I."               , as.character(x90),
    "68% C.I."               , as.character(x68),
    "Test Length"            , as.character(nrow(valid)),
    "Items completed"        , as.character(nrow(completed)),
    "Items marked NA"        , as.character(sum(is.na(completed$response_num)))
  ) %>%
    dplyr::rename(" " = 1, "  " = 2)

  p1 = glue::glue(
    "This individual's T-score estimate of {theta} (95% confidence interval: {x95}) 
    indicates self-reported communicative functioning approximately {abs(round(z,2))} standard 
    deviations {ab} the mean reported in a large reference sample of community-dwelling
    persons with aphasia of at least one month post-onset.")
    
  p2 = "T-scores are scaled such that the mean and standard deviation in the reference
    sample are 50 and 10, respectively. Given that the scores in the reference sample
    were approximately normally distributed, roughly 68% of scores drawn from the
    population are expected to fall between 40 and 60, and roughly 5% are expected
    to be lower than 30 or greater than 70."
    
   p3 = "The confidence interval expresses the uncertainty in the score estimate,
    with wider intervals at a given confidence level indicating 
    greater uncertainty. If the test could be administered to this individual
    a large number of times under identical conditions, 95 out of 100 of the
    of 95% confidence intervals would contain the true value of the communicative
    functioning score."
  
  funding = "The development of this testing application was funded by National Institute on Deafness and Other Communication Disorders Awards R03DC014556 (PI: Fergadiotis) and R01DC018813 (MPIs: Fergadiotis & Hula), VA Rehabilitation Research & Development Career Development Award C7476W (PI: Hula), and the VA Pittsburgh Healthcare System Geriatric Research, Education, and Clinical Center. We would also like to acknowledge the support and assistance of Myrna Schwartz, Dan Mirman, Adelyn Brecher, Erica Middleton, Patrick Doyle, Malcolm McNeil, Christine Matthews, Angela Grzybowski, Brooke Swoyer, Maria Fenner, Michelle Gravier, Alyssa Autenreith, Emily Boss, Haley Dresang, Lauren Weerts, Hattie Olson, Kasey Graue, Chia-Ming Lei, Joann Silkes, Diane Kendall, the staff of the VA Pittsburgh Healthcare System Audiology and Speech Pathology Program."
  
  return(list(
    p1 = p1,
    p2 = p2,
    p3 = p3,
    table1 = table1,
    funding = funding
  ))
  
  
      
}
