*** Settings ***
Documentation   .
...
Default Tags    sanity    sa013    settings story    ntrdy
Resource        ../../suite.robot
Suite Setup     Run Keywords    I hit the "settings" tab
...                             I hit the "Instance" view
Suite Teardown  Return to mainpage

*** Test Cases ***
Clicking settings
  [TEMPLATE]    I will turn on and off the ${option} setting and see the results
  #~70
  #------------#Kipu licensee;string
  #------------#Kipu account;string
  #------------#Kipu Labs
  #------------#HL7 Lab Interface
  #1:??? HL7 Lab Interface;Enable lab audit interface
  #------------#HL7 Lab Interface;Manage lab requisitions manually
  #------------#HL7 Lab Interface;Allow image upload for requisitions
  #------------#HL7 Lab Interface;Modify diagnosis code on lab requisitions
  #------------#HL7 Lab Interface;Require patient consent for testing
  #2:??? #Match patient since discharge in days
  #------------#Number of locations;string
  #------------#Enforce locations
  #3
  #-----??-------#Use KIS
  #4
  #-----??-------#Use KIS;Use KIS facesheet transfer
  #5???Use KIS;Emit API Events
  #6
  #------------#Use KIS;Enable PDF Dropoff
  #------------#Use calendar
  #7:??? #Stay Shorter Days Threshold
  #!!! #Contract type
  #!!! #Active day ranges (click to edit)
  #8NOWORK Use CollaborateMD Interface
  #9:\/NOWORK Use PracticeSuite Interface
  #------------#User External Apps
  #------------#Use VOBGetter
  #------------#Use External Identity Mappings (p/episode of care)
  #$$$ Kipu Insurance Service
  #$$$ Kipu Insurance Service;Add unknown insurances to payor list
  # Only allow known insurances
  #10:??? Lab Insurance Service (deprecated)
  #$$$ Enable ICD/DSM Service
  # Enable ICD/DSM Service;Use specific codes only
  # Medication Database
  #------------#Use shift reports
  #------------#Use group sessions
  #11MAY BE REGRESSIVE
  #------------#Use group sessions;View individual group sessions (AZ)
  #------------#Use occupancy
  # Enable faxing
  # Enable free-form diagnosis codes
  #------------#Vitals
  #------------#Weight
  #------------#Glucose
  # Enable MARs generation by orders
  # Require MAR patient signature
  # #Monitor first medication response
  # #Minutes until response
  # Observation Status
  # Enable Messages Service
  #------------#Patient string (singular);string
  #------------#Patient name format;dropdown
  #------------#MR Number string;string
  # Print patient photos
  # Require SSN
  #------------#Use gender (male/female)
  #------------#Use gender (male/female);Use gender identity
  #------------#Use ethnicity and race information
  #------------#Use payment methods for patient
  #------------#Case Manager
  #------------#Primary Therapist
  #------------#Primary Physician
  #------------#Primary Nurse
  #12:??? Therapist string (singular);string
  #------------#Provider string (singular);string
  # Use sobriety date for patients
  ###Show level of care;dropdown
  ###Show pre-admission status for patient
  ###Use patient programs
  ###Use patient programs;Title for patient programs;string
  ###Use patient statuses
  # Create unknown referrers in contacts
  # Validate evaluations when signing
  # #Casefile documents: default sort order
  # #Allow patient signature within (hours,0 to exclude)

*** Keywords ***
I will turn on and off the ${option} setting and see the results
  Log To Console    Changing ${option} setting
  ${keyword}    @{rest} =    Split String    ${option}    ;    1
  ${rest} =    Set Variable If    ${rest}    @{rest}[0]    ${EMPTY}
  ${passes} =    Run Keyword And Return Status    Run Keyword And Ignore Error
  ...            Checkbox Should Be Selected    //*[contains(text(),'${keyword}')]/ancestor::tr/td[2]/input[@type='checkbox']
  ### ^LOL WHAT, PLEASE REFACTOR ME^
  ${orig} =    Set Variable    ${EMPTY}
  Run Keyword If    '${rest}'=='${EMPTY}'    Checkbox test    ${keyword}    ${passes}
  ...    ELSE IF    '${rest}'=='string'      String test      ${keyword}
  ...    ELSE IF    '${rest}'=='dropdown'    Dropdown test    ${keyword}
  ...               ELSE                     Run Keywords     Run Keyword If    not ${passes}    Select Checkbox    //*[contains(text(),'${keyword}')]/ancestor::tr/td[2]/input[@type='checkbox']
  ...                                        AND              I will turn on and off the ${rest} setting and see the results
  [TEARDOWN]    Turn back to original    ${passes}    ${keyword}    ${orig}

Turn back to original
  [ARGUMENTS]    ${on}    ${keyword}    ${orig}
  Go To    ${BASE URL}${INSTANCE}
  Run Keyword If    '${on}'=='True'        Run Keywords    Select Checkbox    //*[contains(text(),'${keyword}')]/ancestor::tr/td[2]/input[@type='checkbox']
  ...                                      AND             Click Button    commit
  ...    ELSE IF    '${on}'=='string'      Run Keywords    Input Text    //*[contains(text(),'${keyword}')]/ancestor::tr/td[2]/input[@type='text']    ${orig}
  ...                                      AND             Click Button    commit
  ...    ELSE IF    '${on}'=='dropdown'    Run Keywords    Select From List By Label    //*[contains(text(),'${keyword}')]/ancestor::tr/td[2]/select   ${orig}
  ...                                      AND             Click Button    commit
  Ajax wait

Do submit
  [ARGUMENTS]    ${keyword}    ${active}
  Click Button    commit
  Ajax wait
  Reload Page
  Run Keyword    ${keyword} ${active}

Reverse submit
  [ARGUMENTS]    ${keyword}    ${info}
  Run Keyword And Ignore Error    Input Text    //*[contains(text(),'${keyword}')]/ancestor::tr/td[2]/input[@type='text']    ${info}
  Run Keyword And Ignore Error    Select From List By Label    //*[contains(text(),'${keyword}')]/ancestor::tr/td[2]/select    ${info}
  Click Button    commit
  Ajax wait

Checkbox test
  [ARGUMENTS]    ${keyword}    ${passes}
  Run Keyword If    not ${passes}    Run Keywords    Select Checkbox    //*[contains(text(),'${keyword}')]/ancestor::tr/td[2]/input[@type='checkbox']
  ...                                AND             Run Keyword And Ignore Error    Click Element    //html/body/div[11]/div[3]/div/button
  ...                                AND             Do submit    ${keyword}    True
  ...               ELSE             Run Keyword     ${keyword} True
  Go To    ${BASE URL}${INSTANCE}
  Unselect Checkbox    //*[contains(text(),'${keyword}')]/ancestor::tr/td[2]/input[@type='checkbox']
  Do submit    ${keyword}    False

String test
  [ARGUMENTS]    ${keyword}
  ${orig} =    Get Value    //*[contains(text(),'${keyword}')]/ancestor::tr/td[2]/input[@type='text']
  Run Keyword    ${keyword}
  [TEARDOWN]    Run Keywords    Set Test Variable    ${passes}    string
  ...           AND             Set Test Variable    ${orig}    ${orig}

Dropdown test
  [ARGUMENTS]    ${keyword}
  ${orig} =    Get Text    //*[contains(text(),'${keyword}')]/ancestor::tr/td[2]//option[@selected='selected']
  Run Keyword    ${keyword}
  [TEARDOWN]    Run Keywords    Set Test Variable    ${passes}    dropdown
  ...           AND             Set Test Variable    ${orig}    ${orig}

Kipu licensee
  Reverse submit    Kipu licensee    Very Tired Feedback Test
  I hit the "Kipu Account" view
  Page Should Have    Very Tired Feedback Test

Kipu account
  Reverse submit    Kipu account    578993479
  I hit the "Kipu Account" view
  Page Should Have    578993479

Kipu labs ${active}
  Run Keyword If    ${active}    Page Should Contain Link    /kipu_labs/lab_client_status
  ...               ELSE         Page Should Not Contain Link    /kipu_labs/lab_client_status

HL7 lab interface ${active}
  Run Keyword If    ${active}    Page Should Contain Link    ${LAB INTERFACE TODAY}
  ...               ELSE         Page Should Not Contain Link    ${LAB INTERFACE TODAY}

Enable lab audit interface ${active}
  No Operation

Manage lab requisitions manually ${active}
  Run Keyword If    ${active}    Run Keywords   I hit the "lab interface manual" tab
  ...                            AND            Page Should Contain Textfield    requisition_selected_manually
  ...               ELSE         Run Keywords   I hit the "lab interface" tab
  ...                            AND            Element Should Not Be Visible    requisition_selected_manually

Allow image upload for requisitions ${active}
  I hit the "lab interface today" tab
  Click Element    //a[starts-with(@href,'/lab_requisitions/new?lab_order_ids=')][1]
  Run Keyword If    ${active}    Page Should Contain Element    patient_lab_test_image
  ...               ELSE         Page Should Not Contain Element    patient_lab_test_image

Modify diagnosis code on lab requisitions ${active}
  I hit the "lab interface today" tab
  Click Element    //a[starts-with(@href,'/lab_requisitions/new?lab_order_ids=')][1]
  Run Keyword If    ${active}    Page Should Contain Element    token-input-diagnosis_code
  ...               ELSE         Page Should Not Contain Element    token-input-diagnosis_code

Require patient consent for testing ${active}
  I hit the "lab interface today" tab
  Click Element    //a[starts-with(@href,'/lab_requisitions/new?lab_order_ids=')][1]
  Run Keyword If    ${active}    Page Should Contain Button    open-signature-dialog
  ...               ELSE         Page Should Not Contain Button    open-signature-dialog

Number of locations
  Reverse submit    Number of locations    1
  I hit the "Company" view
  Page Should Not Contain Link    /company_settings/1/locations/new

Enforce locations ${active}
  Run Keyword If    ${active}    Page Should Contain Element    user_selected_location
  ...               ELSE         Page Should Not Contain Element    user_selected_location

Use kis ${active}
  Travel "fast" to "tester" patients "information" page in "${_LOCATION 1}"
  Run Keyword If    ${active}    Page Should Contain Element    full_casefile_btn
  ...               ELSE         Page Should Not Contain Element    full_casefile_btn

Use kis facesheet transfer ${active}
  Travel "fast" to "tester" patients "information" page in "${_LOCATION 1}"
  Run Keyword If    ${active}    Page Should Contain Element    //span[@title='Send patient facesheet to another company']
  ...               ELSE         Page Should Not Contain Element    //span[@title='Send patient facesheet to another company']

Enable pdf dropoff ${active}
  I hit the "Konnectors" view
  I hit the "New Konnector" text
  Run Keyword If    ${active}    Page Should Contain Element    //option[@value='pdf_dropoff']
  ...               ELSE         Page Should Not Contain Element    //option[@value='pdf_dropoff']

Use calendar ${active}
  I hit the "schedules" tab
  Run Keyword If    ${active}    Page Should Contain Link    ${CALENDAR}
  ...               ELSE         Page Should Not Contain Link    ${CALENDAR}

User external apps ${active}
  Go To    ${Clean me up}
  Scrolling down
  Run Keyword If    ${active}    Page Should Contain Link    Add External App
  ...               ELSE         Page Should Not Contain Link    Add External App

Use vobgetter ${active}
  Go To    ${Clean me up}
  Click Link    Add insurance
  Ajax wait
  Run Keyword If    ${active}    Page Should Contain Element    //div[starts-with(@id,'vob_getter_')]
  ...               ELSE         Page Should Not Contain Element    //div[starts-with(@id,'vob_getter_')]
  Click Element    //a[@data-association='insurances'][last()]
  Ajax wait
  Give a "passing" facesheet validation

Use external identity mappings (p/episode of care) ${active}
  Go To    ${Clean me up}
  Scrolling down
  Run Keyword If    ${active}    Page Should Contain Link    Add External ID Mapping
  ...               ELSE         Page Should Not Contain Link    Add External ID Mapping

Kipu insurance service ${active}
  Go To    ${Clean me up}
  Click Link    Add insurance
  Ajax wait
  Input Text    //div[@id='insurance']/div[@class='fields'][last()]/div/div[1]/input[1]
  ...           b
  Slow wait    2
  Run Keyword If    ${active}    Wait Until Element Is Visible    //li[@class='ui-menu-item' and @role='presentation']
  ...               ELSE         Element Should Not Be Visible    //li[@class='ui-menu-item' and @role='presentation']
  Press Key    //div[@id='insurance']/div[@class='fields'][last()]/div/div[1]/input[1]
  ...          \\27
  Click Element    //a[@data-association='insurances'][last()]
  Ajax wait
  Give a "passing" facesheet validation

Add unknown insurances to payor list ${active}
  Go To    ${Clean me up}
  Click Link    Add insurance
  Ajax wait
  Input Text    //div[@id='insurance']/div[@class='fields'][last()]/div/div[1]/input[1]
  ...           b
  Wait Until Element Is Visible    //li[@class='ui-menu-item' and @role='presentation']
  Press Key    //div[@id='insurance']/div[@class='fields'][last()]/div/div[1]/input[1]
  ...          \\9
  Run Keyword If    ${active}    Alert Should Be Present
  ...               ELSE         Run Keyword And Expect Error    Alert Should Be Present
  Click Element    //a[@data-association='insurances'][last()]
  Ajax wait
  Give a "passing" facesheet validation

Enable icd/dsm service ${active}
  Travel "fast" to "tester" patients "screens and assessments" page in "${_LOCATION 1}"
  With this form "Manage Diagnosis" perform these actions "add;edit"
  Input Text    token-input-diagnosis_code
  Slow wait    2
  Run Keyword If    ${active}    Wait Until Element Is Visible    //div[@class='token-input-dropdown']
  ...               ELSE         Element Should Not Be Visible    //div[@class='token-input-dropdown']
  Go Back
  Loop deletion    With this form "Manage Diagnosis" perform these actions "delete"

Use specific codes only ${active}

Use shift reports ${active}
  Run Keyword If    ${active}    Page Should Contain Link    ${SHIFTS}
  ...               ELSE         Page Should Not Contain Link    ${SHIFTS}

Use group sessions ${active}
  Run Keyword If    ${active}    Page Should Contain Link    ${SCHEDULES}
  ...               ELSE         Page Should Not Contain Link    ${SCHEDULES}

View individual group sessions (az) ${active}
  I hit the "schedules" tab
  I hit the "Start" text
  Click Element    //span[contains(text(),'Preview/print view')]
  Run Keyword If    ${active}    Page Should Contain Element    //span[contains(text(),'Show individual notes')]
  ...               ELSE         Page Should Not Contain Element    //span[contains(text(),'Show individual notes')]

Use occupancy ${active}
  Run Keyword If    ${active}    Page Should Contain Link    ${OCCUPANCY}
  ...               ELSE         Page Should Not Contain Link    ${OCCUPANCY}

Vitals ${active}
  Travel "fast" to "tester" patients "med log" page in "${_LOCATION 1}"
  Run Keyword If    ${active}    Page Should Contain Element    vital_signs_refresh
  ...               ELSE         Page Should Not Contain Element    vital_signs_refresh

Weight ${active}
  Travel "fast" to "tester" patients "med log" page in "${_LOCATION 1}"
  Run Keyword If    ${active}    Page Should Contain Element    weight_refresh
  ...               ELSE         Page Should Not Contain Element    weight_refresh

Glucose ${active}
  Travel "fast" to "tester" patients "med log" page in "${_LOCATION 1}"
  Run Keyword If    ${active}    Page Should Contain Element    glucose_log_refresh
  ...               ELSE         Page Should Not Contain Element    glucose_log_refresh

Patient string (singular)
  Reverse submit    Patient string (singular)    very_best_friend
  Reload Page
  Page Should Contain Element    //a[@href='${PATIENTS}' and contains(text(),'very_best_friend')]

Patient name format
  Reverse submit    Patient name format    last name, first name
  Return to mainpage
  I select the "${_LOCATION 1}" location
  Page Should Contain    ${Test last}, ${Test first}

MR number string
  Reverse submit    MR Number string    preVEGAS
  Go To    ${Clean me up}
  Page Should Contain Element    //label[@for='patient_mr' and contains(text(),'preVEGAS')]

Use gender (male/female) ${active}
  Go To    ${Clean me up}
  Run Keyword If    ${active}    Page Should Contain Element    patient[gender_short]
  ...               ELSE         Page Should Not Contain Element    patient[gender_short]

Use gender identity ${active}
  Go To    ${Clean me up}
  Run Keyword If    ${active}    Page Should Contain Element    patient_gender_identity_short
  ...               ELSE         Page Should Not Contain Element    patient_gender_identity_short

Use ethnicity and race information ${active}
  Go To    ${Clean me up}
  Run Keyword If    ${active}    Run Keywords    Page Should Contain Element    patient_ethnicity
  ...                            AND             Page Should Contain Element    patient_race
  ...               ELSE         Run Keywords    Page Should Not Contain Element    patient_ethnicity
  ...                            AND             Page Should Not Contain Element    patient_race

Use payment methods for patient ${active}
  Go To    ${Clean me up}
  Run Keyword If    ${active}    Page Should Contain Element    patient[payment_method]
  ...               ELSE         Page Should Not Contain Element    patient[payment_method]

Case manager ${active}
  I hit the "top" tab
  I hit the "dashboard" tab
  Run Keyword If    ${active}    Page Should Contain Link    Case Manager Load
  ...               ELSE         Page Should Not Contain Link    Case Manager Load

Primary therapist ${active}
  I hit the "top" tab
  I hit the "dashboard" tab
  Run Keyword If    ${active}    Page Should Contain Link    Therapist Case Load
  ...               ELSE         Page Should Not Contain Link    Therapist Case Load

Primary physician ${active}
  I hit the "top" tab
  I hit the "dashboard" tab
  Run Keyword If    ${active}    Page Should Contain Link    Physician Case Load
  ...               ELSE         Page Should Not Contain Link    Physician Case Load

Primary nurse ${active}
  I hit the "top" tab
  I hit the "dashboard" tab
  Run Keyword If    ${active}    Page Should Contain Link    Nurse Case Load
  ...               ELSE         Page Should Not Contain Link    Nurse Case Load

Therapist string (singular)
  Reverse submit    Therapist string (singular)

Provider string (singular)
  Reverse submit    Provider string (singular)    purple
  I hit the "schedules" tab
  I hit the "Calendar" view
  Page Should Contain Element    //a[contains(@title,'Show appointments for all purple')]

# Use sobriety date for patients

Show level of care
  Reverse submit    Show level of care

Show pre-admission status for patient ${active}


Use patient programs ${active}


Title for patient programs
  Reverse submit    Title for patient programs

Use patient statuses ${active}
