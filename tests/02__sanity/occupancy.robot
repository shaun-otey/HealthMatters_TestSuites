*** Settings ***
Documentation   Assign patients to beds.
...
Default Tags    sanity    sa001    points-3    exceptions
Resource        ../../suite.robot
Suite Setup     Run Keywords    I select the "${_LOCATION 1}" location
...                             Assign building and beds to the "${_LOCATION 1}" location
Suite Teardown  Remove building

*** Test Cases ***
Assign an unassigned client to a location and bed
  [TAGS]    skip
  Given I am on the "patients" page
  And I hit the "occupancy" tab
  When assigning patient "${Test id}" to bed "B2-B"
  Then confirm bed spot

Reassign a client to an occupied bed
  [TAGS]    skip
  Given I am on the "patients" page
  And I hit the "occupancy" tab
  When assigning patient "${Test id}" to bed "B3-A"
  Then confirm bed spot    "B2-B"

Reassign a client to a new empty bed
  [TAGS]    skip
  Given I am on the "patients" page
  And I hit the "occupancy" tab
  When assigning patient "${Test Id}" to bed "B3-B"
  Then confirm bed spot

Assigns or reassigns the test patient to T1-A
  Given I am on the "patients" page
  And I hit the "occupancy" tab
  When assigning patient "${Test Id}" to bed "T1-A"
  Then confirm bed spot

Assigns or reassigns the test patient to T1-C
  Given I am on the "patients" page
  And I hit the "occupancy" tab
  When assigning patient "${Test id}" to bed "T1-C"
  Then confirm bed spot

*** Keywords ***
Assign building and beds to the "${location}" location
  Create a new building with beds
  I hit the "settings" tab
  I hit the "Company" view
  ${location} =    Convert To Lowercase    ${location}
  ${location} =    Replace String    ${location}    ${SPACE}    -
  Click Element    //a[contains(@href,'-${location}/edit')]
  Page Should Contain    Edit location
  Select Checkbox    //label[.='${Test Building}']/following-sibling::input[1]
  Click Button    Update
  I am on the "company" page
  Return to mainpage

Assigning patient "${patient}" to bed "${bed}"
  Set Test Variable    ${Patient select}    patient_${patient}_bed_name
  Set Test Variable    ${Patient bed}    ${bed}
  Click Link    Edit beds
  Click Link    ${Test Building}
  Ajax wait
  Select From List By Label    ${Patient select}    ${Patient bed}
  Ajax wait
  Click Button    Submit

Confirm bed spot
  [ARGUMENTS]    ${spot}=${Patient bed}
  Run Keyword And Continue On Failure    Element Should Contain    //select[@id='${Patient select}']/option[@selected='selected']    ${spot}
