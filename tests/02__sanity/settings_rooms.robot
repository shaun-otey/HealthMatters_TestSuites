*** Settings ***
Documentation   Create new building with room and beds, along with turning occupancy on and off.
...
Default Tags    sanity    sa007    points-2    settings story    exceptions
Resource        ../../suite.robot
Suite Setup     I select the "${_LOCATION 1}" location

*** Test Cases ***
A user can remove and re-enable the occupancy feature
  Given I am on the "patients" page
  And I hit the "settings" tab
  And I hit the "Instance" view
  When now "deactivating" the occupancy feature
  Then Page Should Not Contain Link    ${OCCUPANCY}
  When now "activating" the occupancy feature
  Then Page Should Contain Link    ${OCCUPANCY}

A user can create a new building and room with beds then may create beds after creating a building
  Given I am on the "patients" page
  And I hit the "settings" tab
  And I hit the "Rooms" view
  When setting up building and beds
  And adding a new bed
  Then page should have    ${Test Building}    ${Test Room}    ${Test Bed 1}    ${Test Bed 2}    ${Test Bed 3}    Super Dope Bed
  Sleep    20
  # not very good    bucket note
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Remove building

A use can only view the beds from the selected location
  Given I am on the "patients" page
  When create a new building with beds
  And I select the "My Locations" location
  And I hit the "occupancy" tab
  And select the test build
  Then verify only correct beds show up
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Remove building

*** Keywords ***
Now "${active}" the occupancy feature
  ${select} =    Set Variable If    '${active}'=='activating'      Select
                 ...                '${active}'=='deactivating'    Unselect
  Instance edit "${select} Checkbox" on "Use occupancy"
  Click Button    commit
  Ajax wait
  Reload Page

Adding a new bed
  Click Element    //strong[contains(text(),'${Test Building}')]/ancestor::tr[1]/following-sibling::tr[1]/td[2]/a[1]
  Input Text    room_notes    bucket note
  Click Element    room_room_name
  Ajax wait
  Add a bed    Super Dope Bed    not very good
  Click Button    commit
  Ajax wait
  I hit the "Rooms" view

Select the test build
  Click Link    ${Test Building}
  Ajax wait
  Click Link    Edit beds
  Verify for no bad page

Verify only correct beds show up
  ${patient select} =    Set Variable    patient_${Test Id}_bed_name
  ${passes}    ${TRASH} =    Run Keyword And Ignore Error    Page should have
                             ...                             ELEMENT|3x|//*[@id='${patient select}']/option[@value]
  Run Keyword And Continue On Failure    Should Be Equal As Strings    PASS    ${passes}
  Run Keyword If    '${passes}'=='FAIL'    Run Keywords    Click Element    //*[@id='${patient select}']
  ...                                      AND             Blur element    ${patient select}
  ...                                      AND             Run Keyword And Continue On Failure    Page should have
  ...                                                      ELEMENT|3x|//*[@id='${patient select}']/option[@value]
  :FOR    ${bed}    IN    ${Test Bed 1}    ${Test Bed 2}    ${Test Bed 3}
  \    Run Keyword And Continue On Failure    Page Should Contain Element
  \    ...                                    //*[@id='${patient select}']/option[@value='${bed}']
