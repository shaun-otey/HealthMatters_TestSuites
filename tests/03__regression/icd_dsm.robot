*** Settings ***
Documentation   User with Super admin is able to select which "encyclopedia" of codes they can use.
...             If the client wants to only use DSM V codes then a user can select the DSMV ICD codes
...             in settings>instance>enable ICD/DSM Service>Select ICD-10 Groups
...
...             User can give a diganosis to a patient via the facesheet
...             (ONLY if no other form that can diagnoses the patient is open).
...             Clicking Edit patient>Diagnosis (add a diagnosis)
...
...             User can give a patient a diagnosis through a form that is using the field type "patient.diagnosis_code".
...             Add the form>select a date>select diagnosis..
...
Default Tags    regression    re023    points-7
Resource        ../../suite.robot
Suite Setup     I select the "${_LOCATION 1}" location
Suite Teardown  Return to mainpage

*** Test Cases ***
Give a patient diagnosis
  [TEMPLATE]    I will select these code ${groups} and will add ${codes} diagnosis to the patient,
  ...           these ${diagnosis} will show up on the patient
  only;specific;C00-D49;S00-T88        freedom;C11;T62.1X2D;F20    C11.1 Malignant neoplasm of posterior wall of nasopharynx|T62.1X2D Toxic effect of ingested berries, intentional self-harm, subsequent encounter
  any;specific;none                    freedom;C11;T62.1X2D;F20    freedom|C11|T62.1X2D|F20
  any;specific;F01-F99                 freedom;C11;T62.1X2D;F20    freedom|C11|T62.1X2D|F20.0 Paranoid schizophrenia
  only;specific;none                   freedom;C11;T62.1X2D;F20    ${EMPTY}
  only;non-specific;C00-D49;S00-T88    freedom;C11;T62.1X2D;F20    C11 Malignant neoplasm of nasopharynx|T62.1X2D Toxic effect of ingested berries, intentional self-harm, subsequent encounter
  any;non-specific;none                freedom;C11;T62.1X2D;F20    freedom|C11|T62.1X2D|F20
  any;non-specific;F01-F99             freedom;C11;T62.1X2D;F20    freedom|C11|T62.1X2D|F20 Schizophrenia
  only;non-specific;none               freedom;C11;T62.1X2D;F20    ${EMPTY}

*** Keywords ***
I will select these code ${groups} and will add ${codes} diagnosis to the patient, these ${diagnosis} will show up on the patient
  Log    These selections -> (${groups}) should show these results -> (${diagnosis})    console=True
  I am on the "patients" page
  I hit the "settings" tab
  I hit the "instance" tab
  @{d codes} =    Split String    ${groups}    ;
  ${only} =    Remove From List    ${d codes}    0
  ${spec} =    Remove From List    ${d codes}    0
  Run Keyword If    '${only}'!='only'    Select Checkbox    site_setting_enable_free_diag_code
  ...               ELSE                 Unselect Checkbox    site_setting_enable_free_diag_code
  Run Keyword If    '${spec}'=='specific'    Select Checkbox    site_setting_icd_specific_code
  ...               ELSE                     Unselect Checkbox    site_setting_icd_specific_code
  Select code groups    @{d codes}
  Click Button    commit
  Ajax wait
  Travel "fast" to "tester" patients "medical" page in "null"
  With this form "Manage Diagnosis" perform these actions "add;edit"
  Page should have    Manage Diagnosis    Date    Diagnosis
  ${date} =    Convert Date    ${Todays Date}    result_format=%m/%d/%Y
  Form fill    ${EMPTY}    patient_evaluation_evaluation_date:direct_js=${date} 12:00AM
  Loop deletion    Delete old diagnosis
  @{d codes} =    Split String    ${codes}    ;
  Insert diagnosis codes    @{d codes}
  @{diagnosis} =    Split String    ${diagnosis}    |
  Run Keyword If    '@{diagnosis}[0]'!='${EMPTY}'    Page should have    @{diagnosis}
  ...               ELSE                             Page should not have    @{d codes}
  [TEARDOWN]    Run Keywords    Travel "fast" to "tester" patients "medical" page in "null"
  ...           AND             Loop deletion    With this form "Manage Diagnosis" perform these actions "delete"
  ...           AND             Return to mainpage

Delete old diagnosis
  Page should have    ELEMENT|//li[${CSS SELECT.replace('$CSS','token-input-token')}]
  Click Element    //li[${CSS SELECT.replace('$CSS','token-input-token')}][1]/span
  Ajax wait

Insert diagnosis codes
  [ARGUMENTS]    @{codes}
  FOR    ${code}    IN    @{codes}
      Input Text    token-input-diagnosis_code    ${code}
      Slow wait
      ${passes} =    Run Keyword And Return Status    Wait Until Keyword Succeeds    3x    0.5
                     ...                              Click Element    //div[@class='token-input-dropdown']//li[1]/p
      Run Keyword Unless    ${passes}    Press Key    token-input-diagnosis_code    \\13
      Slow wait
  END
  Click Button    validate_patient_evaluation_fields
  Ajax wait
  Page should have    Validated: no errors
  Click Element    //span[contains(text(),'Preview/print view')]

Page should not have
  [ARGUMENTS]    @{codes}
  FOR    ${code}    IN    @{codes}
      Page should have    NOT|${code}
  END
