*** Settings ***
Documentation   Testing for BAM.
...
Default Tags    acceptance    ac004    ntrdy
Resource        ../../suite.robot
Suite Setup     Run Keywords    Prepare outcomes measurement
...                             Connect pingmd
...                             Create a bam patient
...                             Return to mainpage
Suite Teardown  Run Keywords    No Operation
...                             Destroy pingmd connector
...                             End outcomes measurement
...                             Return to mainpage

*** Test Cases ***
Create a user with different role requirements
  [SETUP]    Create a new user
  Given turning "on" the "Doctor" roles for "${Find First};${Find Last}"
  And exit system    ${false}
  And start login    ${Find User}    ${Find Pass}
  Then travel "slow" to "${Bam patient}" patients "information" page in "null"
  And Run Keyword And Continue On Failure    verify that the user "cannot" use bam
  When exit system    ${false}
  And start login    ${CURRENT USER}    ${CURRENT PASS}
  And turning "on" the "Assessment manager" roles for "${Find First};${Find Last}"
  And exit system    ${false}
  And start login    ${Find User}    ${Find Pass}
  Then travel "slow" to "${Bam patient}" patients "information" page in "null"
  And Run Keyword And Continue On Failure    verify that the user "can" use bam
  When exit system    ${false}
  And start login    ${CURRENT USER}    ${CURRENT PASS}
  And turning "on;off;off" the "Super admin;Doctor;Assessment manager" roles for "${Find First};${Find Last}"
  And exit system    ${false}
  And start login    ${Find User}    ${Find Pass}
  Then travel "slow" to "${Bam patient}" patients "information" page in "null"
  And Run Keyword And Continue On Failure    verify that the user "can" use bam
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Exit system    ${false}
  ...           AND             Start login    ${CURRENT USER}    ${CURRENT PASS}
  ...           AND             Delete the new user
  ...           AND             Return to mainpage

Mechanism to indicate that a facility/instance is participating in bam
  Given I am on the "patients" page
  When bam is turned "off"
  Then verify that bam is turned "off"
  When bam is turned "on"
  Then verify that bam is turned "on"
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Bam is turned "on"
  ...           AND             Return to mainpage

Allow client to designate what frequency triggers they wish to have enabled?
  [TAGS]    in development

Mechanism to indicate that a person is participating in bam
  Given I am on the "patients" page
  When travel "slow" to "tester" patients "information" page in "null"
  Then verify that this patient "is not" in bam
  When travel "slow" to "${Bam patient}" patients "information" page in "null"
  Then verify that this patient "is" in bam

Mechanism to allow a discharged patient to receive incoming assessments from ping
  [TAGS]    in development
  Given I am on the "patients" page
  When create a new patient    ...    ...    ...
  Then show new status
  When patient is sent to aftercare
  Then show new status
  When patient is sent to archiving
  Then show new status
  - Per Todd documents cannot be added once the patient is discharged.  Assuming, discharge currently closes chart (?).

Create bam iop assessment with ping enabled
  # [TAGS]    testmebam
  Given I am on the "patients" page
  And travel "slow" to "${Bam patient}" patients "information" page in "null"
  And I hit the "Testing Bam" view
  When doing an enrollment in "BAM-IOP"
  And sending the "BAM-IOP" assessment
  Then the status for the "BAM-IOP" assessment is "Sent"
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Delete the "BAM-IOP" assessment
  ...           AND             Unenroll from the "BAM-IOP" assessment
  ...           AND             Return to mainpage

Create bam r assessment with ping enabled
  Given I am on the "patients" page
  And travel "slow" to "${Bam patient}" patients "information" page in "null"
  And I hit the "Testing Bam" view
  When doing an enrollment in "BAM-R"
  And sending the "BAM-R" assessment
  Then the status for the "BAM-R" assessment is "Sent"
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Delete the "BAM-R" assessment
  ...           AND             Unenroll from the "BAM-R" assessment
  ...           AND             Return to mainpage

Verify order of questions for a bam r assessment
  Given I am on the "patients" page
  And travel "slow" to "${Bam patient}" patients "information" page in "null"
  And I hit the "Testing Bam" view
  When doing an enrollment in "BAM-R"
  And sending the "BAM-R" assessment
  And the status for the "BAM-R" assessment is "Sent"
  Then verify the questions in the assessment
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Go Back
  ...           AND             Delete the "BAM-R" assessment
  ...           AND             Unenroll from the "BAM-R" assessment
  ...           AND             Return to mainpage

Triggers to deploy specific bam type
  [TAGS]    in development
  based on set frequency 30 days or 7 days depending on specified BAM type
  based on enrollment at the time set as standard
  based on UR LOC or client dictated
	based on Change in LOC
    From UR level of care, based on new entry, specific to start date entered
  based on approaching Tx Plan next Review Date w/in X Hours

Receive and retain ping specific data related to deployed assessment
  [TAGS]    in development
  Given I am on the "patients" page
  When an assessment is deployed
  Then Calculate and Store administration time (Complete- Start vs. Submit vs. Start)
  And BAM assessment responses (see appendix for allowed values, data types and scores)
 
Send notification to care team related bam behavior
  [TAGS]    in development
  Given I am on the "patients" page
  When completing a bam
  Then bam will need a review
  When a bam changed due to severity increase
  Then bam will need a review
  That BAM score for domain changed:  Use Increase, Risk Increase or Protective Decreased compared to previous submission
	  Need discussion – Have client set thresholds for notification vs. standards set by ourselves?

Display retained data graphically as a bar chart and a line chart for a patient
  [TAGS]    in development
  Given I am on the "patients" page
  And go to bam graphs
  Ability to render a specific graph for each domain score and item level score for 1 specified assessment

Display retained data graphically as a bar chart and a line chart for a patient
  [TAGS]    in development
  Given I am on the "patients" page
  And go to bam graphs
	Ability to render specific graphs comparing item level and domain level score (Use, Risk, Protective) changes based on the following:
    Compare last X data points as defined by the user.  (example: last 3 entries, last 6 entries, last 9 entries, show all – Max of ??)
    Compare to last assessment
    Compare over a particular date range entered by User  (example:  all from 3/1/2017-4/21/2017)
    Compare over specified data ranges common to reporting:  This Year, Last Year, YTD, Current Month, Last Month
    Compare all entries Individual item changes based on scored value
    Provide option to display baseline on all graphs

Display retained data graphically as a bar chart and a line chart for a patient
  [TAGS]    in development
  Given I am on the "patients" page
  And go to bam graphs
  All graphs and scores for each domain level items have the ability to allow user to see each component score that comprise the composite score.

Facility level reporting - Graph data
  [TAGS]    in development
  Given I am on the "patients" page
  And go to bam graphs
  Allow for Cohort reporting at the individual patient level.
    Ability to compare the individuals scores for a given time period (listed above) compared to their peers as it relates to:
      Peers in the same age brackets (Bracket’s TBD-need to determine norms typically 5 to 10 yr groupings)
      Peers in the same program level based on the program at the time taken
      Peers in the same level of care base on LOC at time taken
      Peers based on the days in treatment
      Peers based on Gender

Facility level reporting - Facilty average against patient
  [TAGS]    in development
  Displaying averages for the facility for all patients

Facility level reporting - Patient average within program level
  [TAGS]    in development
	Displaying averages for the patients in same program level

Facility level reporting - Patient average within facilty
  [TAGS]    in development
	Displaying averages for the patients in the same facility/location

Facility level reporting - Patient average under a care provider
  [TAGS]    in development
	Displaying averages for the patients under the direction of a specified care provider

Facility level reporting - Patient average within a group
  [TAGS]    in development
	Displaying averages for patients in a user specified group

Facility level reporting - Patient group average against another
  [TAGS]    in development
	Display and compare averages for patients in one group vs another

Facility level reporting - Percentage pie chart
  [TAGS]    in development
	Display response specific counts and % per question response in pie chart format with % of responses or list with percentages.
    Drill down to patient level when selected using selected hierarchy
      Facility/Location, Program, Level of Care, Therapist, Patient
  Allow level arrow indicators based on % change in score between each interval – quarter, month etc.
  Participation Reporting:
    Number of respondents BAM was sent to by BAM type per Period per Gender

Universal cohort reporting
  [TAGS]    in development
  Able to compare one facility’s scores against that of like entities
  Universal reporting would not have drill down capabilities to the patient level
	  Individual item and domain specific comparison needed
	  Deidentified information need to be a constant
    Comparison grids of Facility X vs Universe – by item response %
	  Comparison for time periods specified Item Change based on score month to month quarter to quarter

*** Keywords ***
Prepare outcomes measurement
  Bam is turned "on"
  ${item} =    Set Variable    //div[@id='${CLIENT PROCESSES TABLE}']//input[starts-with(@id,'patient_process_') and @value='NAME']/../descendant::span[${CSS SELECT.replace('$CSS','badge')}]
  Set Suite Variable    ${Bam item}    ${item}
  Click Element    //a[@href='/settings' and .='${Patient Handle}s']
  Run Keyword And Ignore Error    Page Should Contain Element    ${item.replace('NAME','Patient Assessments')}
  # Clean client process    Patient Assessments
  # Page Should Not Contain Element    ${Bam item.replace('NAME','Patient Assessments')}
  Loop deletion    Clean client process    Testing Bam
  Page Should Not Contain Element    ${Bam item.replace('NAME','Testing Bam')}
  Click Link    ${CLIENT PROCESSES ADD}
  Ajax wait
  ${selection} =    Get Webelement    //div[@id='${CLIENT PROCESSES TABLE}']//form
  ${new row} =    Set Variable    ${selection.find_element_by_css_selector('li:last-child>div:first-child>input').get_attribute('id')}
  Input Text    ${new row}    Testing Bam
  Unselect Checkbox    //input[@id='${new row}']/../following-sibling::div[1]//label[contains(text(),'Forms/Eval.')]/following-sibling::input[@type='checkbox']
  Select Checkbox    //input[@id='${new row}']/../following-sibling::div[1]//label[contains(text(),'Patient Assessments')]/following-sibling::input[@type='checkbox']
  Click Button    ${selection.find_element_by_name('commit')}
  Ajax wait
  Page Should Contain Element    ${Bam item.replace('NAME','Testing Bam')}

Create a bam patient
  Return to mainpage
  I select the "${_LOCATION 1}" location
  I create a valid patient    chicken    in    sandwich    02/19/2018
  ${first} =    Get Element Attribute    ${PATIENT FACESHEET FIRST NAME}    value
  ${last} =    Get Element Attribute    ${PATIENT FACESHEET LAST NAME}    value
  # # #
  # Update facesheet    ssn=${EMPTY}    validation type=failing
  Set Suite Variable    ${Bam patient}    ${first} ${last[:1]}
  I hit the "Show Facesheet" view
  I hit the "Invite to PingMD" view
  Page should have    Errors found    doesn't have email
  Click Link    Edit ${Patient Handle}
  ${rand} =    Generate Random String    6    [UPPER][NUMBERS]
  Update facesheet    email=lucnh${rand}@break.com
  Travel "slow" to "current" patients "information" page in "${_LOCATION 1}"
  I hit the "Invite to PingMD" view
  Wait Until Keyword Succeeds    5x    4s
  ...                            Run Keywords    Slow wait    2
  ...                            AND             Reload Page
  ...                            AND             Page Should Contain    Check PingMD
  # ...                            AND             Page Should Contain Element    //td[.='PingMD']/following-sibling::td[1]
  Run Keyword And Expect Error    *    Visual indicator of bam participation on patient
  ${id} =    Get Text    //td[.='PingMD']/following-sibling::td[1]
  Pingmd << Setup api
  ${resp} =    Pingmd << Account status    ${id}    get
  Should Be True    200<=${resp.status_code}<300
  ${resp} =    Pingmd << Activate user    ${id}    post
  Should Be True    200<=${resp.status_code}<300
  ${resp} =    Pingmd << Account status    ${id}    get
  Should Be True    200<=${resp.status_code}<300
  &{resp} =    Set Variable    ${resp.json()}
  &{resp} =    Set Variable If    'data' in ${resp}    ${resp.data}    &{resp}
  Should Be True    ${resp.is_active}
  Wait Until Keyword Succeeds    3x    5s
  ...                            Run Keywords    I hit the "Check PingMD" view
  ...                            AND             Visual indicator of bam participation on patient

End outcomes measurement
  Remove this patient    ${Bam patient}
  Go To    ${BASE URL}${SETTINGS}
  Loop deletion    Clean client process    Testing Bam
  Page Should Not Contain Element    ${Bam item.replace('NAME','Testing Bam')}
  Bam is turned "off"

Bam is turned "${state}"
  ${state} =    Set Variable If    '${state}'=='on'    Select    Unselect
  I hit the "settings" tab
  I hit the "Instance" view
  Instance edit "${state} Checkbox" on "Outcomes Measurement"
  Click Button    commit
  Ajax wait

Visual indicator of bam participation on patient
  # Select icon
	# Display last BAM completed date
  Page Should Contain Element    //i[${CSS SELECT.replace('$CSS','fa-phone-square')}]

Clean client process
  [ARGUMENTS]    ${name}
  ${selection} =    Get Webelement    //div[@id='${CLIENT PROCESSES TABLE}']//form
  Click Element    ${selection.find_element_by_xpath('.//input[@value="${name}"]/../following::a[1]')}
  Ajax wait
  Select From List By Label    new_patient_process_id    Nursing
  Click Button    Update & delete
  Ajax wait

Verify that bam is turned "${state}"
  ${state} =    Set Variable If    '${state}'=='off'    NOT${SPACE}    ${EMPTY}
  I hit the "settings" tab
  Run Keyword    Page Should ${state}Contain Element    ${Bam item.replace('NAME','Testing Bam')}
  Run Keyword And Ignore Error    Run Keyword    Page Should ${state}Contain Element    ${Bam item.replace('NAME','Patient Assessments')}
  Travel "slow" to "tester" patients "information" page in "${_LOCATION 1}"
  Run Keyword    Page Should ${state}Contain    Testing Bam
  Run Keyword And Ignore Error    Run Keyword    Page Should ${state}Contain    Patient Assessments

Verify that this patient "${participation}" in bam
  Page Should Contain    Testing Bam
  @{participation} =    Run Keyword If    '${participation}'=='is not'    Create List    Run Keyword And Expect Error
                        ...                                               *
                        ...               ELSE                            Create List
  Run Keyword    @{participation}    Visual indicator of bam participation on patient
  I hit the "Testing Bam" view
  Run Keyword    @{participation}    Page Should Contain Element
  ...            //a[starts-with(@href,'/outcomes_measurement/assessment_programs/programs_enrollment')]

Verify that the user "${participation}" use bam
  I hit the "Testing Bam" view
  @{participation} =    Run Keyword If    '${participation}'=='cannot'    Create List    Run Keyword And Expect Error
                        ...                                               *
                        ...               ELSE                            Create List
  Run Keyword And Continue On Failure    @{participation}    Page Should Contain Element    //a[starts-with(@href,'/outcomes_measurement/assessment_programs/programs_enrollment')]

Verify the questions in the assessment
  I hit the "BAM-R Assessment" text
  Slow wait
  Click Element    //a[contains(@href,'patient_assessment_')]/h3
  @{hm questions} =    Get Webelements    //div[@id='sp_100']/div/div/div/div[1]//span
  :FOR    ${index}    ${question}    IN ENUMERATE    @{hm questions}
  \    Set List Value    ${hm questions}    ${index}
  \    ...               ${question.get_attribute('innerHTML').strip(' \t\n\r').replace('(required) ','')}
  Log Many    @{hm questions}
  @{draft questions} =    Create List    1. In the past 30 days, how would you say your physical health has been?
                          ...            2. In the past 30 days, how many nights did you have trouble falling asleep or staying asleep?
                          ...            3. In the past 30 days, how many days have you felt depressed, anxious, angry or very upset throughout most of the day?
                          ...            4. In the past 30 days, how many days did you drink ANY alcohol?
                          ...            5. In the past 30 days, how many days did you have at least 5 drinks (if you are a man) or at least 4 drinks (if you are a woman)? Description: One drink is considered one shot of hard liquor (1.5 oz.) or 12-oz. can/bottle of beer or 5-oz. glass of wine.
                          ...            6. In the past 30 days, how many days did you use any illegal or street drugs or abuse any prescription medications?
                          ...            7. Marijuana (cannabis, pot, weed)?
                          ...            8. Sedatives and/or Tranquilizers (benzos, Valium, Xanax, Ativan, Ambien, barbs, Phenobarbital, downers, etc.)?
                          ...            9. Cocaine and/or Crack?
                          ...            10. Other Stimulants (amphetamine, methamphetamine, Dexedrine, Ritalin, Adderall, speed, crystal meth, ice, etc.)?
                          ...            11. Opiates (Heroin, Morphine, Dilaudid, Demerol, Oxycontin, oxy, codeine (Tylenol 2,3,4), Percocet, Vicodin, Fentanyl, etc.)?
                          ...            12. Inhalants (glues, adhesives, nail polish remover, paint thinner, etc.)?
                          ...            13. Other drugs (steroids, non-prescription sleep and diet pills, Benadryl, Ephedra, other over-the-counter or unknown medications)?
                          ...            14. In the past 30 days, how much were you bothered by cravings or urges to drink alcohol or use of drugs?
                          ...            15. How confident are you that you will NOT use alcohol and drugs in the next 30 days?
                          ...            16. In the past 30 days, how many days did you attend self-help meetings like AA or NA to support your recovery?
                          ...            17. In the past 30 days, how many days were you in any situations or with any people that might put you at any increased risk for using alcohol or drugs (i.e. around risky "people, places or things")?
                          ...            18. Does your religion or spirituality help support your recovery?
                          ...            19. In the past 30 days, how many days did you spend much of the time at work, school, or doing volunteer work?
                          ...            20. Do you have enough income (from legal sources) to pay for necessities such as housing, transportation, food and clothing for yourself and your dependents?
                          ...            21. In the past 30 days, how much have you been bothered by arguments or problems getting along with any family members or friends?
                          ...            22. In the past 30 days, how many days did you contact or spent time with any family members or friends who are supportive of your recovery?
                          ...            23. How satisfied are you with your progress toward achieving your recovery goals?
                          # 15. How confident are you in your ability to be completely abstinent (clean) from alcohol and drugs in the next 30 days?
  Run Keyword And Continue On Failure    Lists Should Be Equal    ${draft questions}    ${hm questions}
  :FOR    ${index}    ${question}    IN ENUMERATE    @{hm questions}
  \    Set List Value    ${hm questions}    ${index}    ${question.split('. ',1)[1]}
  Sort List    ${hm questions}
  :FOR    ${index}    ${question}    IN ENUMERATE    @{draft questions}
  \    Set List Value    ${draft questions}    ${index}    ${question.split('. ',1)[1]}
  Sort List    ${draft questions}
  Lists Should Be Equal    ${draft questions}    ${hm questions}

Doing an enrollment in "${program}"
  Click Element    //a[starts-with(@href,'/outcomes_measurement/assessment_programs/programs_enrollment')]
  Ajax wait
  Select Checkbox    //div[@id='assessment_programs_enrollment_dialog']//td[contains(text(),'${program}')]/preceding-sibling::td[1]/input
  Click Element    //button[.='Enroll']
  Page should have    Notice    successfully enrolled in selected assessment programs
  # WHY SAME ID selected_assessment_programs_

Sending the "${program}" assessment
  Click Element    //a[starts-with(@href,'/outcomes_measurement/patient_assessments/sending')]
  Ajax wait
  Select Checkbox    //div[@id='patient_assessments_sending_dialog']//td[contains(text(),'${program}')]/preceding-sibling::td[1]/input
  Click Element    //button[.='Send']
  Page should have    Notice    Selected programmed assessments successfully sent. Give us some time to deliver, refresh to check
  Wait Until Keyword Succeeds    3x    7s
  ...                            Run Keywords    Slow wait    5
  ...                            AND             Reload Page
  ...                            AND             Page Should Not Contain    No Patient assessments found

The status for the "${program}" assessment is "${status}"
  ${freq}    ${desc} =    Run Keyword If    '${program}'=='BAM-IOP'    Set Variable    7    Brief addiction monitor assessment (BAM) for intensive outpatient treatment (IOP)
                          ...    ELSE IF    '${program}'=='BAM-R'      Set Variable    30    Brief addiction monitor assessment (BAM) for continuous response (R)
                          ...               ELSE                       Fail    This program is not in the system!
  Wait Until Keyword Succeeds    7x    6s
  ...                            Run Keywords    Reload Page
  ...                            AND             Get assessment description    ${program}
  ...                            AND             Should Be Equal As Strings    ${Read desc}    ${desc}
  ...                            AND             Should Be Equal As Strings    ${Read freq}    ${freq}
  ...                            AND             Run Keyword If    '${Read status}'!='Ready' and '${Read status}'!='${status}'    CRASH
  ...                            AND             Should Be Equal As Strings    ${Read status}    ${status}

Get assessment description
  [ARGUMENTS]    ${program}
  ${assessment} =    Get Webelement    //div[@id='patient_assessments_container']//td[contains(text(),'${program}')]/parent::tr[1]
  Set Test Variable    ${Read desc}    ${assessment.find_element_by_css_selector('td:nth-child(3)').get_attribute('innerHTML').strip(' \t\n\r')}
  Set Test Variable    ${Read freq}    ${assessment.find_element_by_css_selector('td:nth-child(5)').get_attribute('innerHTML').strip(' \t\n\r')}
  Set Test Variable    ${Read status}    ${assessment.find_element_by_css_selector('td:nth-child(7)>div>span').get_attribute('innerHTML').strip(' \t\n\r')}

Delete the "${program}" assessment
  Dialog action    Click Element    //div[@id='patient_assessments_container']//td[contains(text(),'${program}')]/following-sibling::td[last()]/a
  Ajax wait
  Page should have    Notice     assessment successfully deleted

Unenroll from the "${program}" assessment
  Click Element    //a[starts-with(@href,'/outcomes_measurement/assessment_programs/programs_unenrollment')]
  Ajax wait
  Select Checkbox    //div[@id='assessment_programs_unenrollment_dialog']//td[contains(text(),'${program}')]/preceding-sibling::td[1]/input
  Click Element    //button[.='Unenroll']
  Page should have    Notice    successfully unenrolled from selected assessment programs



An assessment is deployed
  Retain Time Date Deployed
  Date/Time Message Read
  Date/Time Assessment was Started  (multiple start times possible if person abandons and restarts—need the start associated with the completed assessment)
  Date/Time Assessment was Complete (signature vs submission)
  Date/Time Assessment was submitted – e/f could be same value per Josh and better served as F
  Data/Time Received by KIPU System

BAM assessment responses
  Classify Submissions Received
    Designated the first BAM of each type as BASELINE; whether it is performed in PING or in KIPU
    Designate each subsequent BAM of each type as Follow up
  Score Results based on assessment responses using scoring values associate with each question as described by the BAM tool creators. See associated Spec for BAM-R and BAM – IOP
    Retain Scores per question (see appendix)
  Calculate and store a Score per domain per instruction by creator:
    BAM-R
      Risk Factors (sum of score for Q’s = 1,2,3,8,11,15= max 180)
      Self-Reported Substance Use (Sum of score for Q’s = 4,5,6=max 90)
      Protective Factors (Sum of score for Q’s= 9,10,12,13,14,16= max 180)
    BAM-IOP
      Risk Factors (sum of score for Q’s = 1,2,3,8,11,15= max 24)
      Self-Reported Substance Use (Sum of score for Q’s = 4,5,6=max 12)
      Protective Factors (Sum of score for Q’s= 9,10,12,13,14,16= max 24)

Store & retain Point in Time Patient related attributes for Cohort reporting needs
  UR level of Care as point in time reference based on submission date
  Retain age of patient at time of assessment
  Retain Program Enrollment at time of assessment
  Retain Location at time of assessment
