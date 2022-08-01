---
editor_options: 
  markdown: 
    wrap: sentence
---

**Acom 4.0.0 Technical Documentation**

A description of the psychometric characteristics of the current version of the ACOM is available in Hula, Doyle, Stone, Austermann Hula, Kellough, Wambaugh, Ross, Schumacher, and St. Jacque (2015).
Other relevant papers on the development and validation of ACOM score estimates include: Hula, Kellough, & Doyle (2015); Hula, Austermann Hula, & Doyle (2015); Doyle, Hula, Austermann Hula, Stone, Wambaugh, Ross, and Schumacher (2013; and Doyle, McNeil, Le, Hula, & Ventura, M. B. (2008).
For a recent summary of the development of the ACOM and updated guidance on interpretation of ACOM change scores and error estimates, see Hula and Doyle (2021).

Comments, feedback, and bug reports are encouraged.
Please submit as an issue: <https://github.com/rbcavanaugh/acom/issues>.

**About the current ACOM**

The current version of the ACOM is a fully adaptive test.
This test administers between 12 and 59 items adaptively, targeting items to provide the most statistical information at the current ability estimate.
After every item is administered, an updated ability estimate is obtained and is used to select the next item until all items have been administered.
Items are administered based on the examinee's score estimate and the item's content category.
A content-balancing strategy is used to select items from each domain (talking, writing and number use, comprehension, and naming) to ensure that the content balance of each CAT-ACOM administration is reflective of the content balance of the full 59 item bank.
The items selected and their presentation order may differ across administrations because of randomness in content balancing algorithm.

The final T-score estimate and confidence intervals are produced when the test completes administration of all 59 items or when the test administrator exits the program before the test has completed.
The PDF report provides score estimates and confidence intervals and users may also download a file containing the complete administration including the item content and order, and the score estimate after each response.

Although the ACOM only provides a single overall score estimate, which we describe as self-reported communicative effectiveness of persons with aphasia, the scoring model does take into account the grouping of items into domains labelled Talking, Comprehension, Naming, Reading, and Writing and Number Use.
The ACOM does not provide subdomain scores because analysis indicated that although including the domain structure in the underlying scoring model improved its fit to the data, after accounting for the general communicative effectiveness factor, there was not enough unique variance left in any of the domains to support useful measurement (Hula et al., 2015).

Previous versions of the ACOM (3.0.2) were available on a java-based application and included a 59-item partially adaptive test and a 12-item test.
These versions were discontinued in the current version of the ACOM which permits a fully adaptive administration of at least 12 and up to 59 items.
Increasing the number of items administered can impact the bias and precision of the score estimates (see below).

**Ability Estimation Procedure**

T-score ability estimates are generated using the Bayes expected a posteriori (EAP) estimation procedure.
The posterior standard deviation (PSD) is computed as the error of the EAP estimate.
The minimum and maximal possible scores are 10 and 90, respectively, and the estimation procedure approximates the posterior distribution using 33 quadrature points.
The EAP procedure assumes that each score estimate is drawn from a normal distribution with a mean of 50 and a standard deviation of 10.
This assumption, referred to and operationalized as a Bayesian prior, is updated with each new response as it is collected.
Early in a given administration of the ACOM, the prior may have a strong influence on score estimates, biasing them toward the mean.
However, as the test progresses, the increasing amount of observed response data will diminish the influence of the prior.
Thus, score estimates obtained from the full 59-item ACOM will be somewhat less inwardly biased than those obtained from the 12-item CAT-ACOM.
The influence of the prior is also stronger for scores that are farther away from the mean.

The primary advantage of EAP scoring over maximum likelihood scoring is that an EAP estimate can obtained for any observed set of responses.
By contrast, finite maximum likelihood estimates cannot be obtained for extreme (all "not very" or all "completely") response strings.
The literature suggests that the EAP procedure provides a high level of average accuracy for score estimates if the prior is correct (Embretson & Reise, 2013).
In case of the ACOM, the distribution of score estimates for the 329-person calibration sample reported by Hula and colleagues (2015) closely approximated normality (skew = 0.11, kurtosis = -0.14).
For an in-depth description of the EAP procedure, see Baker & Kim (2004).

**References**

Baker, F. B., & Kim, S. H.
(2004).
Item response theory: Parameter estimation techniques.
CRC press.

Doyle, P. J., McNeil, M. R., Le, K., Hula, W. D., & Ventura, M. B.
(2008).
Measuring communicative functioning in community‐dwelling stroke survivors: Conceptual foundation and item development.
Aphasiology, 22(7--8), 718--728.

Embretson, S. E., & Reise, S. P. (2013).
Item response theory.
Psychology Press.

Hula, W. D., & Doyle, P. J.
(2021).
The Aphasia Communication Outcome Measure: Motivation, development, validity evidence, and interpretation of change scores.
Seminars in Speech and Language, 42(03), 211--224.

Hula, W. D., Doyle, P. J., Stone, C. A., Austermann Hula, S. N., Kellough, S., Wambaugh, J. L., Ross, K. B., Schumacher, J. G., & St. Jacque, A.
(2015).
The Aphasia Communication Outcome Measure (ACOM): Dimensionality, item bank calibration, and initial validation.
Journal of Speech Language and Hearing Research, 58(3), 906.

Hula, W. D., Kellough, S., & Doyle, P. J.
(2015).
Reliability and validity of adaptive and static short forms of the Aphasia Communication Outcome Measure.
Presentation to the Clinical Aphasiology Conference, Monterey, CA.
