
### acom: The Aphasia Communication Outcome Measure

An R package and shiny web-app for administering the Aphasia Communication Outcome Measure (ACOM). 

A description of the psychometric characteristics of the current version of the ACOM is available in Hula, Doyle, Stone, Austermann Hula, Kellough, Wambaugh, Ross, Schumacher, and St. Jacque (2015). Other relevant papers on the development and validation of ACOM score estimates include: Hula, Kellough, & Doyle (2015); Hula, Austermann Hula, & Doyle (2015); Doyle, Hula, Austermann Hula, Stone, Wambaugh, Ross, and Schumacher (2013; and Doyle, McNeil, Le, Hula, & Ventura, M. B. (2008). 

Comments, feedback, and bug reports are encouraged. Please submit as an issue: https://github.com/rbcavanaugh/acom/issues

Citation: Cavanaugh, R., Swiderski, A.M., Hula, W.D. (2022). acom: The Aphasia Communication Outcome Measure. Version 4.0.2, Available from https://github.com/rbcavanaugh/acom.

### Installing & Using the application

There are a number of ways to use the application (see below). However, please note that server resources are finite, and therefore **we ask that researchers use option 2 for the following reasons:** (1) The version of the app remains consistent throughout the research study (option 1, 3, and 4 may change based on any updates to the app), (2) There is an inactive time-out limitation on the free online version of the app to keep server costs reasonable, which means that a long break (>15 minutes) without activity may cause you to lose your current session. (3) Both the free online version and `shiny::runGithub()` function require a stable internet connection and data will be lost if an internet connection is lost. 

**Detailed installation instructions can be found here: https://github.com/rbcavanaugh/acom/wiki**

#### 1. Online

The app is now online at  https://rb-cavanaugh.shinyapps.io/acom/

#### 2. Local Installation

The app can be installed locally via `remotes::install_github()`

#### 3. Local installation on RStudio Cloud

The app can be installed and run from RStudio Cloud (https://rstudio.cloud/)
if R/Rstudio can't be installed locally.

#### 4. Remote access to the app, run locally

The app can also be accessed via `shiny::runGitHub()`


#### 5. Clone the repository

If desired, the repository can be cloned, and run locally. 

```
git clone https://github.com/rbcavanaugh/acom.git
```

A helpful resource for this step is here: https://happygitwithr.com/

### Prior versions

Prior versions of the ACOM application were available through a java-based web application (the latest being 3.0.2). However, updates to java mean that this application does not consistently save a results file. Using older, unstable versions of java may contain potential security concerns. Thus using the prior version of the ACOM java application is not recommended. 

The acom package does include af function to extract values from prior versions of the ACOM administered using the java app. It returns a list with two items. The first is a summary dataframe with information about the test and the second is a dataframe with the item-level responses. 

```{r}
acom::read_java_acom("path_to_txt_file")
```

### Combining and summarizing multiple ACOM files

To combine item-level responses for multiple ACOM administrations, the R package includes
a function called `combine_acom_files()` which requires a path to a folder with at least one .csv file
that can be downloaded at the end of each ACOM test. The resulting file will contain all responses for
all participants in the folder in long format.

```{r}
acom::combine_acom_files("path_to_folder_with_csv_files")
```

To create a summary dataframe of the final ability estimates, standard error, and 95% confidence interval, include the argument `summary = TRUE`.

```{r}
acom::combine_acom_files("path_to_folder_with_csv_files", summary = TRUE)
```

Note that modifying the .csv files (especially the headers) or including other .csv files in the
folder may cause this function to return an error.

### About the ACOM

Technical documentation: https://github.com/rbcavanaugh/acom/wiki/Technical-Documentation

Guidelines on selecting test length: https://github.com/rbcavanaugh/acom/wiki/Selecting-Test-Length


**References**

Baker, F. B., & Kim, S. H. (2004). Item response theory: Parameter estimation techniques. CRC press.

Doyle, P. J., McNeil, M. R., Le, K., Hula, W. D., & Ventura, M. B. (2008). Measuring communicative functioning in community‐dwelling stroke survivors: Conceptual foundation and item development. Aphasiology, 22(7–8), 718–728.

Embretson, S. E., & Reise, S. P. (2013). Item response theory. Psychology Press.

Hula, W. D., & Doyle, P. J. (2021). The Aphasia Communication Outcome Measure: Motivation, development, validity evidence, and interpretation of change scores. Seminars in Speech and Language, 42(03), 211–224.

Hula, W. D., Doyle, P. J., Stone, C. A., Austermann Hula, S. N., Kellough, S., Wambaugh, J. L., Ross, K. B., Schumacher, J. G., & St. Jacque, A. (2015). The Aphasia Communication Outcome Measure (ACOM): Dimensionality, item bank calibration, and initial validation. Journal of Speech Language and Hearing Research, 58(3), 906.

Hula, W. D., Kellough, S., & Doyle, P. J. (2015). Reliability and validity of adaptive and static short forms of the Aphasia Communication Outcome Measure. Presentation to the Clinical Aphasiology Conference, Monterey, CA.