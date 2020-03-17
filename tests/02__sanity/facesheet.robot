*** Settings ***
Documentation   /features/patient_chart/facesheet_spec.rb
...             # The Face Sheet includes the patient’s:
...             # •	Pre-admission information
...             # •	Admission date
...             # •	Bed history
...             # •	Program
...             # •	Case manager
...             # •	Primary therapist
...             # •	Referrer
...             # •	Demographic information
...             # •	Insurance information
...             # •	Concurrent reviews
...             # •	Emergency contact information
...             # •	Food restrictions and allergies'
...             # facesheet should also includes space for to write notes, create urgent issues and edit the client’s demographic information.
...             # while viewing the facesheet, a case file should be able to be generated.
...
Default     sanity    sa005    points-4    addmore
Resource        ../../suite.robot
Suite Setup     Travel "slow" to "tester" patients "information" page in "My Locations"
Suite Teardown  Return to mainpage
Test Teardown   Run Keywords    Run Keyword If Test Failed    Custom screenshot
...             AND             Go To    ${BASE URL}${PATIENTS}/${Test Id}${Patient Information}

*** Test Cases ***
Should successfully update facesheet
  Given page should have    ${Test First}    ${Test Middle}    ${Test Last}    Edit ${Patient Handle}
  When I hit the "Edit ${Patient Handle}" view
  And update info properly
  And I hit the "Show Facesheet" view
  Then page should have    ${Patient Handle} Information    Phone: 305-111-1111    Alternate phone: 305-222-2222
  ...                      Postman    USPS    305-333-3333    456 KipuDrive    Miami Beach, GA 33155
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Go To    ${BASE URL}${PATIENTS}/${Test Id}/edit
  ...           AND             Default patient    ${false}
  ...           AND             Go To    ${BASE URL}${PATIENTS}/${Test Id}${Patient Information}

Should show errors on invalid facesheet update
  Given page should have    ${Test First}    ${Test Middle}    ${Test Last}    Edit ${Patient Handle}
  When I hit the "Edit ${Patient Handle}" view
  And update info badly
  Then Page Should Contain    Errors found
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Go To    ${BASE URL}${PATIENTS}/${Test Id}/edit
  ...           AND             Default patient    ${false}
  ...           AND             Go To    ${BASE URL}${PATIENTS}/${Test Id}${Patient Information}

Should add an urgent issue to a patient and resolve it
  ### EX
  Given page should have    ${Test First}    ${Test Middle}    ${Test Last}    Edit ${Patient Handle}
  When create a "urgent issue" with "This is an urgent issue"
  And exit system    ${false}
  And start login    ${CURRENT USER}    ${CURRENT PASS}
  And I select patient "${Test First}"
  # Then I hit the "Show Facesheet" view
  Then page "should" contain urgent issue
  When I resolve an urgent issue with "This is an urgent issue"
  And I hit the "Show Facesheet" view
  Then page "should not" contain urgent issue
  # Create user to allow issue popup

Should add note to a patient
  Given page should have    ${Test First}    ${Test Middle}    ${Test Last}    Edit ${Patient Handle}
  When create a "notes" with "This is a patient note"
  And Reload Page
  Then Page Should Contain    This is a patient note

Check allergy for patient validation
  Given page should have    ${Test First}    ${Test Middle}    ${Test Last}    Edit ${Patient Handle}
  And return to mainpage
  And I select the "${_LOCATION 1}" location
  When I create an invalid patient    Mode    Pepper    Duplicate    03/14/2018
  Then update with no allergy and fail
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Remove this patient    Mode Pepper Duplicate
  ...           AND             I select the "My Locations" location
  ...           AND             Go To    ${BASE URL}${PATIENTS}/${Test Id}${Patient Information}

Enter anticipated discharge date with an evaluation
  [SETUP]    Create discharge date evaluation
  Given page should have    ${Test First}    ${Test Middle}    ${Test Last}    Edit ${Patient Handle}
  And I hit the "Edit ${Patient Handle}" view
  When update facesheet    anti discharge:js=12/12/2999
  And I hit the "nursing" patient tab
  And add the discharge date evaluation
  Then confirm the discharge and change it
  When I hit the "information" patient tab
  Then confirm the changed discharge
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Delete tester template    evaluations
  ...           AND             Go To    ${BASE URL}${PATIENTS}/${Test Id}${Patient Information}

Assign a case manager then make a modification in the facesheet
  Given page should have    ${Test First}    ${Test Middle}    ${Test Last}    Edit ${Patient Handle}
  And I hit the "admission" patient tab
  When assigning a case manager
  And I hit the "information" patient tab
  Then page should have    Case Manager: ${Main case manager}
  When I hit the "Edit ${Patient Handle}" view
  And update info properly
  And I hit the "Show Facesheet" view
  Then page should have    ${Patient Handle} Information    Case Manager: ${Main case manager}
  ...                      Phone: 305-111-1111    Alternate phone: 305-222-2222    Postman    USPS    305-333-3333
  ...                      456 KipuDrive    Miami Beach, GA 33155
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Travel "fast" to "tester" patients "admission" page in "null"
  ...           AND             With this form "Assignment of Care Team" perform these actions "edit"
  ...           AND             Form fill    ct assign    case manager:dropdown=None
  ...           AND             Click Button    Update
  ...           AND             Ajax wait
  ...           AND             Dialog action    Click Element
  ...                           //form[@class='edit_patient_evaluation']//a[@data-method='delete']
  ...           AND             Go To    ${BASE URL}${PATIENTS}/${Test Id}/edit
  ...           AND             Default patient    ${false}
  ...           AND             Go To    ${BASE URL}${PATIENTS}/${Test Id}${Patient Information}

*** Keywords ***
# Add new info
#   [ARGUMENTS]    ${allergen}    ${allergy type}    ${reaction}    ${treatment}
#   Click Link    Add Allergy
#   Ajax wait
#   ${selection} =    Get Webelement    //div[@id='food_restrictions']//div[@class='fields'][1]
#   Input Text    ${selection.find_element_by_css_selector('div._100.allergy_field>table>tbody>tr:nth-child(1)>td:nth-child(1)>input')}    ${allergen}
#   Select From List By Label    ${selection.find_element_by_css_selector('div._100.allergy_field>table>tbody>tr:nth-child(1)>td:nth-child(2)>select')}    ${allergy type}
#   Input Text    ${selection.find_element_by_css_selector('div._100.allergy_field>table>tbody>tr:nth-child(1)>td:nth-child(3)>input')}    ${reaction}
#   Input Text    ${selection.find_element_by_css_selector('div._100.allergy_field>table>tbody>tr:nth-child(2)>td:nth-child(2)>input')}    ${treatment}
#   Click Button    patient[auto_submit]
#   Ajax wait

Update info properly
  Update facesheet    phone=305-111-1111    alt phone=305-222-2222    occupation=Postman    employer name=USPS
  ...                 employer phone=305-333-3333    street address 1=456 KipuDrive    city=Miami Beach
  ...                 state:dropdown=Georgia    zip=33155

Update info badly
  Update facesheet    first name=${EMPTY}    last name=${EMPTY}    validation type=failing

Page "${should}" contain urgent issue
  Slow wait
  Run Keyword If    '${should}'=='should'    Page Should Contain Element    //*[@id="patient_header"]/div[2]/table/tbody/tr/td[1]/h1/span[2]/a/span
  ...               ELSE                     Page Should Not Contain Element    //*[@id="patient_header"]/div[2]/table/tbody/tr/td[1]/h1/span[2]/a/span
  # //span[.='URGENT ISSUE']

I resolve an urgent issue with "${message}"
  Click Element    //*[@id="patient_header"]/div[2]/table/tbody/tr/td[1]/h1/span[2]/a/span
  # Click Link    URGENT ISSUE
  Click Element    //p[contains(text(),'${message}')]/preceding::span[contains(text(),'Resolve issue')]
  Ajax wait
  Input Text    urgent_issue_resolved_text    Hurricane destroys fl
  Click Button    Resolve Issue
  Ajax wait
  Page Should Contain    Issue resolved

Update with no allergy and fail
  Click Element    //a[contains(text(),'Create MR')]
  Ajax wait
  Update facesheet    ssn=777 77 7777    gender identity:dropdown=Birth Gender    dob:js=10/07/1991    oto:checkbox=o
  ...                 street address 1=123 KipuLane    city=Miami    state:dropdown=Florida    zip=33154
  ...                 payment method:radio=Insurance    birth sex:radio=gender_male    no allergy:checkbox=o
  ...                 validation type=failing

Create discharge date evaluation
  Go To    ${BASE URL}${TEMPLATES EVALUATIONS}
  Create tester template    evaluations    Discharge Green
  Editing "evaluations" test template
  Run Keyword If    ${_LOCATIONS ACTIVE}    Form fill    evaluations form    all locations:checkbox=x
  Set count id
  Click Link    Add item
  Ajax wait
  Form fill    evaluations form    enabled:checkbox=x    load manually:checkbox=x    patient process:dropdown=Nursing
  ...          item name=Anticipated Discharge Date   item label=Anticipated Discharge Date
  ...          item label width:dropdown=20%    item field type:dropdown=patient.anticipated_discharge_date
  Save "evaluations" template
  I am on the "templates evaluations" page
  Go To    ${BASE URL}${PATIENTS}/${Test Id}${Patient Information}

Add the discharge date evaluation
  Loop deletion    With this form "Discharge Green" perform these actions "delete"
  With this form "Discharge Green" perform these actions "add;edit"

Confirm the discharge and change it
  ${field} =    Set Variable    patient_evaluation_eval_timestamps_attributes_0_timestamp
  Ajax wait
  Wait Until Element Is Visible    ${field}
  Page Should Contain Element    //input[@id='${field}' and contains(@value,'12/12/2999')]
  Default date to now    ${field}

Confirm the changed discharge
  ${date} =    Convert Date    ${Todays Date}    result_format=%m/%d/%Y
  Page Should Contain Element    //*[contains(text(),'Anticipated Discharge Date')]/following-sibling::*[contains(text(),'${date}')]

Assigning a case manager
  With this form "Assignment of Care Team" perform these actions "add;edit"
  @{case managers} =    Get List Items    ${CT ASSIGN CASE MANAGER}
  Set Test Variable    ${Main case manager}    @{case managers}[1]
  Form fill    ct assign    case manager:dropdown=${Main case manager}
  Click Button    Update
