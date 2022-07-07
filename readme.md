
### acom: The Aphasia Communication Outcome Measure

An R package and shiny web-app for administering the Aphasia Communication Outcome Measure (ACOM). 

A description of the psychometric characteristics of the current version of the ACOM is available in Hula, Doyle, Stone, Austermann Hula, Kellough, Wambaugh, Ross, Schumacher, and St. Jacque (2015). Other relevant papers on the development and validation of ACOM score estimates include: Hula, Kellough, & Doyle (2015); Hula, Austermann Hula, & Doyle (2015); Doyle, Hula, Austermann Hula, Stone, Wambaugh, Ross, and Schumacher (2013; and Doyle, McNeil, Le, Hula, & Ventura, M. B. (2008). 

Citation: Cavanaugh, R., Swiderski, A.M., Hula, W.D. (2022). acom: The Aphasia Communication Outcome Measure. Version 4.0.0, Available from https://github.com/rbcavanaugh/acom.

### Using the application

There are a number of ways to use the application (see below). However, please note that server resources are finite, and therefore **we recommend that researchers use option 2 for the following reasons:** (1) The version of the app remains consistent throughout the research study (option 1, 3, and 4 will change based on any updates to the app), (2) There is an inactive time-out limitation on the free online version of the app to keep server costs reasonable. (3) Both the free online version and `shiny::runGithub()` function require a stable internet connection and data will be lost if an internet connection is lost. 

#### 1. Online

The app is now online at  https://rb-cavanaugh.shinyapps.io/acom/

#### 2. Local Installation

The app can be installed locally via `remotes::install_github()`

*Note: It's likely that installing the package will prompt you to update packages on your local machine. This may be necessary if you have much older versions of some packages installed (e.g. the {bslib} package). Sometimes this can cause errors. Please raise an issue in github if there are any issues downloading the app.*

1. Download the package: 

```{r}
install.packages("remotes")
remotes::install_github("rbcavanaugh/acom")
```

If needed, instructions for installing R and Rstudio can be found here: https://rstudio-education.github.io/hopr/

2. Run the app using the built in function

```{r}
library(acom)
acom::run_app()
```

#### 3. Remote access to the app

The app can also be accessed via `shiny::runGitHub()`

1. Necessary packages must be installed first: 

```{r}
install.packages(c('config', 'golem','shiny', 'shinyvalidate', 'catR','DT','here','shinyjs','tibble','tidyr','dplyr','pkgload','htmltools', 'markdown','magrittr','utils','stats','knitr'))
```

2. The app can be run straight from Github

```{r}
shiny::runGitHub("rb-cavanaugh/acom")
```

*Note: If you get any errors about missing a package, install it, restart your session, and try again*

#### 4. Clone the repository

If desired, the repository can be cloned, and run locally. 

```
git clone https://github.com/rbcavanaugh/acom.git
```

A helpful resource for this step is here: https://happygitwithr.com/

### Prior versions

Prior versions of the ACOM application were available through a java-based web application (the latest being 3.0.2). However, updates to java mean that this application does not consistently save a results file. Using older, unstable versions of java may contain potential security concerns. Thus using the prior version of the ACOM java application is not recommended. 

### About the ACOM

The current version of the ACOM is a fully adaptive 59-item test. This test administers *up to* 59 items adaptively, targeting items to provide the most statistical information at the current ability estimate. After every item is administered, an updated ability estimate is obtained and is used to select the next item until all items have been administered. Items are administered based on the examinee's score estimate and based on the item's content category. A content-balancing strategy is used to select items from each domain (talking, writing and number use, comprehension, and naming) to insure that the content balance of each CAT-ACOM administration is reflective of the content balance of the full 59 item bank.

The final T-score estimate and confidence intervals are produced when the test completes administration of all 59 items or when the test administrator exits the program before the test has completed. The PDF report provides score estimates and confidence intervals for both the 12-item adaptive version and the full 59-item bank.

Previous versions of the ACOM (3.0.2) were available on a java-based application and included a 59-item partially adaptive test and a 12-item test. These versions were discontinued in the current version of the ACOM which permits a fully adaptive administration of at least 12 and up to 59 items. Increasing the number of items administered can impact the bias and precision of the score estimates (see below).

### Ability Estimation Procedure

T-score ability estimates are generated using the Bayes expected a posteriori (EAP) estimation procedure. The posterior standard deviation (PSD) is computed as the error of the EAP estimate. Quadrature points used for the EAP procedure range from 10 to 90, in increments of 1.

The EAP procedure assumes that each score estimate is drawn from a normal distribution with a mean of 50 and a standard deviation of 10. This assumption, referred to and operationalized as a Bayesian prior, is updated with each new response as it is collected. Early in a given administration of the ACOM, the prior may have a strong influence on score estimates, biasing them toward the mean. However, as the test progresses, the increasing amount of observed response data will diminish the influence of the prior. Thus, score estimates obtained from the full 59-item ACOM will be somewhat less inwardly biased than those obtained from the 12-item CAT-ACOM. The influence of the prior is also stronger for scores that are farther away from the mean.

The primary advantage of EAP scoring over maximum likelihood scoring is that an EAP estimate can obtained for any observed set of responses. By contrast, finite maximum likelihood estimates cannot be obtained for extreme (all “not very” or all “completely”) response strings. The literature suggests that the EAP procedure provides a high level of average accuracy for score estimates if the prior is correct (Embretson & Reise, 2000). In case of the ACOM, the distribution of score estimates for the 329-person calibration sample reported by Hula and colleagues (2015) closely approximated normality (skew  = 0.11, kurtosis = -0.14). For an in-depth description of the EAP procedure, see Baker & Kim (2004).


### References

Doyle, P. J., McNeil, M. R., Le, K., Hula, W. D., & Ventura, M. B. (2008). Measuring communicative functioning in community‐dwelling stroke survivors: Conceptual foundation and item development. Aphasiology, 22(7–8), 718–728.

Hula, W. D., & Doyle, P. J. (2021). The Aphasia Communication Outcome Measure: Motivation, development, validity evidence, and interpretation of change scores. Seminars in Speech and Language, 42(03), 211–224.

Hula, W. D., Doyle, P. J., Stone, C. A., Austermann Hula, S. N., Kellough, S., Wambaugh, J. L., Ross, K. B., Schumacher, J. G., & St. Jacque, A. (2015). The Aphasia Communication Outcome Measure (ACOM): Dimensionality, item bank calibration, and initial validation. Journal of Speech Language and Hearing Research, 58(3), 906.

Hula, W. D., Kellough, S., & Doyle, P. J. (2015). Reliability and validity of adaptive and static short forms of the Aphasia Communication Outcome Measure. Presentation to the Clinical Aphaisology Conference, Monterey, CA.
