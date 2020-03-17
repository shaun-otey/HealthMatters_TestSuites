*** Settings ***
Documentation   Matches if info of the patient on the front
...             matches when clicked on.
...             UR and Badges are not captured. Assessments are not checked.
...
Default Tags    smoke    sm001    points-1    notester
Resource        ../../suite.robot

*** Test Cases ***
Selecting patient 1
  Given I am on the "patients" page
  And I select the "${_LOCATION 1}" location
  When I select patient "1"
  Then I will see that patients information

# Selecting patient 3
# Selecting patient 6
#   Given I am on the "patients" page
#   And I select the "${_LOCATION 1}" location
#   When I select patient "6"
#   Then I will see that patients information
# Selecting patient 2 in another local
#   Given I am on the "patients" page
#   And I select the "${_LOCATION 2}" location
#   When I select patient "2"
#   Then I will see that patients information

Go through individual parts of a patients facesheet at creation
  Given I am on the "patients" page
  And I select the "${_LOCATION 1}" location
  When creating a patients facesheet    07/24/2019
  Then each step should keep the facesheet intact
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Remove this patient    ${Full name}

Create an mr number only when a patient has an admission date
  Given I am on the "patients" page
  And I select the "${_LOCATION 1}" location
  When creating a patients facesheet
  And I hit the "Create MR" text
  Then page should have    Errors found    Client must have an admission date to generate an MR number.    Create MR
  ...                      NOT|ELEMENT|${PATIENT FACESHEET MR}
  When default date to now    ${PATIENT FACESHEET ADMISSION DATE}
  And I hit the "Create MR" text
  Then page should have    NOT|Errors found    NOT|Client must have an admission date to generate an MR number.
  ...                      NOT|Create MR    ELEMENT|//input[@id='${PATIENT FACESHEET MR}' and @value]
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Remove this patient    ${Full name}

*** Keywords ***
Creating a patients facesheet
  [ARGUMENTS]    ${date}=${EMPTY}
  ${first name}    ${middle name}    ${last name} =    Set Variable    Breaking    Pr    Kitamura
  Create a new patient    ${first name}    ${middle name}    ${last name}    ${date}    ${false}
  ${passes} =    Run Keyword And Return Status    Page should have   NOT|A ${Patient Handle.lower()} with the same name is already in the system.
  Run Keyword If    ${passes}    Page should have    ${first name} ${middle name} ${last name}
  ...               ELSE         Try another name    ${first name}    ${middle name}    ${last name}    ${date}
  Parse current id
  Set Test Variable    ${Full name}    ${first name} ${middle name} ${last name}

Each step should keep the facesheet intact
  ${form} =    Set Variable    //div[@id='patient_form']/form
  @{sections} =    Create List    ELEMENT|${form}/div[@class='form_wrap']/div/label[@for='patient_patient_color_id']
                   ...            ELEMENT|${form}/div[@class='form_wrap']/div[@class='button_add left']
                   ...            ELEMENT|${form}/div[@id='patient_sub_form']/div[@class='form_wrap']/div/label[@for='patient_referrer_name']
                   ...            ELEMENT|${form}/div[@id='patient_sub_form']/div[@class='form_wrap']/div/div/label[@for='patient_recurring_status']
                   ...            ELEMENT|${form}/div[@id='patient_sub_form']/div[@class='form_wrap']/div/label[@for='patient_first_name']
                   ...            ELEMENT|${form}/div[@id='patient_sub_form']/div[@class='form_wrap']/div/label[@for='patient_occupation']
                   ...            ELEMENT|${form}/div[@class='form_wrap']/div/label[@for='patient_payment_method_insurance']
                   ...            ELEMENT|${form}/div[@id='insurance']    ELEMENT|${form}/div[@id='patient_pharmacy']
                   ...            ELEMENT|${form}/div[@id='patient_contact']
                   ...            ELEMENT|${form}/div[@id='food_restrictions']
                   ...            ELEMENT|${form}/div[@class='form_wrap']/div/a[.='Add External App']
                   ...            ELEMENT|${form}/div[@class='form_wrap']/div/a[.='Add External ID Mapping']
  Check sections    @{sections}
  Click Element    //a[contains(text(),'Create MR')]
  Ajax wait
  Check sections    @{sections}    NOT|Create MR
  FOR    ${field}    ${input}    IN
  ...    birth sex:radio             gender_male
  ...    gender identity:dropdown    Birth Gender
      ${passes} =    Run Keyword And Return Status    Form fill    patient facesheet    ${field}=${input}
      Continue For Loop If    not ${passes}
      Check sections    @{sections}
  END
  FOR    ${field}    ${input}    IN
  ...    ssn                     777 77 7777
  ...    dob:js                  10/07/1991
  ...    oto:checkbox            o
  ...    street address 1        123 KipuLane
  ...    city                    Miami
  ...    state:dropdown          Florida
  ...    zip                     33154
  ...    payment method:radio    Insurance
  ...    no allergy:checkbox     x
      Form fill    patient facesheet    ${field}=${input}
      Check sections    @{sections}
  END
  FOR    ${field}    IN
  ...    Add Commitment    Add insurance    Add client contact    Add Allergy    Add Diet    Add External App
  ...    Add External ID Mapping    Delete Allergy
      I hit the "${field}" text
      Check sections    @{sections}
  END
  FOR    ${field}    ${input}    IN
  ...    program:dropdown             1- Detox
  ...    referrer contact:checkbox    x
  ...    enable recurring:checkbox    x
      Form fill    patient facesheet    ${field}=${input}
      Check sections    @{sections}
  END
  Update facesheet    no allergy:checkbox=x
  Check sections    @{sections}

Check sections
  [ARGUMENTS]    @{sections}
  ${passes} =    Run Keyword And Return Status    Page should have    @{sections}
  Run Keyword Unless    ${passes}    Run Keywords    Run Keyword And Continue On Failure    Fail
  ...                                                A section has gone missing!
  ...                                AND             Reload Page
