
#' Combine ACOM files
#' 
#' This function returns either all responses combined or a summary table of final ability and sem scores
#' given a folder with only unmodified output of files generated from the ACOM 4.0.0 application. 
#'
#' @param folder_path a path to a folder containing only unmodified acom output files
#' @param summary whether to return a summary of the final scores for each file. defaults to FALSE
#'
#' @return a .csv file of all data or summary data
#' @export
combine_acom_files <- function(folder_path, summary = FALSE){
  
 files = list.files(folder_path, full.names = TRUE, pattern = "*acom.csv")
  
 file_list = list()
 
 for(i in 1:length(files)){
   tmp = read.csv(files[i])
   file_list[[i]] = tmp
 }
 
 all_files = dplyr::bind_rows(file_list)
 
 
 if(summary){
   out = all_files %>% 
     dplyr::group_by(participant) %>%
     dplyr::filter(order == max(order, na.rm = TRUE)) %>%
     dplyr::mutate(
       lower_95 = theta - 1.96*sem,
       upper_95 = theta + 1.96*sem
     ) %>%
     dplyr::select(participant, examiner, theta, sem, lower_95, upper_95, date, num_items = order)
     
  } else {
   out = all_files
   
  }
 
 return(out)
  
}
