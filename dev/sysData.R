# # read in item parameters for full ACOM
# acom_itpar_content <- read.csv(file = here::here("dev", "acom_Tscaled_ItemParameters_Content.csv"),na.strings = "NA")
# acom_itpar_content$itnum <- as.numeric(seq(1:59))
# 
# acom_itpar <- acom_itpar_content[1:59,c(4:7,3)]
# acom_itpar <- data.matrix(acom_itpar)
# 
# bank = acom_itpar[,1:4]
# 
# # define options for content balancing
# acom_cb_names <- c("talk","comp","gen","writ","nam")
# acom_cb_props <- c(0.355932203, 0.271186441, 0.13559322, 0.13559322, 0.101694915)
# acom_cbControl <- list(names = acom_cb_names, props = acom_cb_props)
# acom_cb_group <- acom_itpar_content$content_area
# catR::test.cbList(acom_cbControl, cbGroup = acom_cb_group)
# 
# rowCallback <- c(
#   "function(row, data){",
#   "  for(var i=0; i<data.length; i++){",
#   "    if(data[i] === null){",
#   "      $('td:eq('+i+')', row).html('NA')",
#   "        .css({'color': 'rgb(151,151,151)', 'font-style': 'italic'});",
#   "    }",
#   "  }",
#   "}"
# )
# 
# 
# d = read.csv(here::here("dev", "acom_Tscaled_ItemParameters_Content.csv"))
# d$itnum <- as.numeric(seq(1:59))
# d$order = NA
# d$response = NA
# d$response_num = NA
# d$DNA_comm_dis = NA
# d$theta = NA
# d$sem = NA

funding = "The development of the Aphasia Communication Outcome Measure and this software was funded by the Veterans Affairs Rehabilitation Research and Development Service under Awards C2386R, C6098R, and C4134P (PI: Patrick J. Doyle); Career Development Awards 6210M and 7476W, and Merit Award I01RX001963 (PI: William Hula), and the National Institutes of Health National Institute on Deafness and other Communication Disorders award F31 DC019853-01 (PI: Cavanaugh). The authors gratefully acknowledge the support of the VA Pittsburgh Healthcare System Geriatric Research, Education, and Clinical Center, the VAPHS Audiology and Speech Pathology Service, and the support and assistance of Patrick Doyle, Ann St. Jacques, Billy Irwin, Hannele Nicholson, Lindsey Cox, Stacey Kellough, Brooke Lang, Emily Boss, Jim Schumacher, Mary Sullivan, Shannon Austermann Hula, Michael Walsh Dickey, William Evans, Gerasimos Fergadiotis, Rebecca Ruffing, Alyssa Autenreith, Ronda Winans-Mitrik, and Christine Matthews."

tooltip = "The full length adaptive ACOM administers 59 items by default while the published adaptive short-form ACOM includes only 12 items. You can also administer any number of items between 12 and 59. Increasing the number of items improves measurement precision but requires more time."

#load("~/github-repos/acom/R/sysdata.rda")
usethis::use_data(
  jsCode,
  enter,
  end_test_key,
  d,
  rowCallback,
  bank,
  acom_cb_group,
  acom_cbControl,
  acom_cb_names,
  funding,
  tooltip,
  internal = T, overwrite = T)
