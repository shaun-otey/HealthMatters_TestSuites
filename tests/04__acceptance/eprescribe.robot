*** Settings ***
Documentation   E-Prescribe - DoseSpot Integration.
...
Default Tags    acceptance    ac006    points-4    exceptions
Resource        ../../suite.robot
Suite Setup     Run Keywords    Create a new user
# ...             AND             Turning "on" the "Doctor" roles for "${Find First};${Find Last}"
...             AND             Turning "on;off" the "Super admin;Tech" roles for "${Find First};${Find Last}"
...             AND             Enabling eprescribe
...             AND             Travel "slow" to "tester" patients "facesheet" page in "${_LOCATION 1}"
...             AND             Update facesheet    phone=503-678-0000
...             AND             Exit system    ${false}
...             AND             Start login    ${Find User}    ${Find Pass}
Suite Teardown  Run Keywords    Exit system    ${false}
...             AND             Start login    ${CURRENT USER}    ${CURRENT PASS}
...             AND             Travel "slow" to "tester" patients "facesheet" page in "${_LOCATION 1}"
...             AND             Update facesheet    phone=${EMPTY}
...             AND             Delete the new user
...             AND             Disabling eprescribe
...             AND             Return to mainpage

*** Test Cases ***
Enrolling a patient and prescribing a medication to this patient
  Given I am on the "patients" page
  When I hit the "settings" tab
  Then Run Keyword And Expect Error    *    I hit the "eprescribe" tab
  And travel "slow" to "tester" patients "medical orders" page in "${_LOCATION 1}"
  When I hit the "Enroll in eRx" text
  Then dosespot will show the patients information
  When creating an erx order
  Then Wait Until Page Contains    Notice
  And page should have    eRx submitted successfully
  ...                     ELEMENT|//b[.='eRx']/../following-sibling::a[contains(.,'${Order}')]
  When I hit the "eRx Portal" text
  Then dosespot will show the patients medication
  [TEARDOWN]    Return to mainpage

The eprescribe physician creates and enters the portal for a patient with an allergy then again without one
  [SETUP]    Run Keywords    I select the "${_LOCATION 1}" location
  ...        AND             I create a valid patient    Roger    Alrgy    Prabh    04/03/2019
  ...        AND             Click Link    Add Allergy
  ...        AND             Ajax wait
  ...        AND             Update facesheet    phone=503-678-0000    allergen=Advil    allergy type:dropdown=Drug
  ...                        reaction=asdawd    reaction type:dropdown=Allergy    onset=04/03/2019    treatment=awdw
  ...                        allergy status:dropdown=Active    allergy source:dropdown=Self-Reported
  ...        AND             Return to mainpage
  Given I am on the "patients" page
  When I hit the "settings" tab
  And travel "slow" to "current" patients "medical orders" page in "null"
  When I hit the "Enroll in eRx" text
  Then dosespot will show the patients information
  And I hit the "information" patient tab
  When I hit the "Edit ${Patient Handle}" view
  And I hit the "Delete Allergy" view
  And update facesheet    no allergy:checkbox=x
  And I hit the "medical orders" patient tab
  And I hit the "eRx Portal" text
  Then dosespot will show the patients information
  And I hit the "information" patient tab
  When update facesheet    no allergy:checkbox=o    validation type=failing
  And I hit the "medical orders" patient tab
  And I hit the "eRx Portal" text
  # Sleep    100
  [TEARDOWN]    Run Keywords    Remove this patient    Roger Alrgy Prabh
  ...           AND             Return to mainpage

*** Keywords ***
Enabling eprescribe
  I hit the "settings" tab
  I hit the "instance" tab
  Temporarily reveal eprescribe options
  Instance edit "Select Checkbox" on "Enable ePrescribe"
  Click Button    commit
  Ajax wait
  Reload Page
  I hit the "eprescribe" tab
  Verify for no bad page
  Loop deletion    Dialog action    Click Element    //a[@class\='delete_erx_setting' and @data-method\='delete']
  Form fill    eprescribe    location:dropdown=${_LOCATION 1}
  Click Button    Add Setting
  Ajax wait
  ${id} =    Get Element Attribute    //div[starts-with(@id,'eprescribe_setting_')]/h2[.='${_LOCATION 1}']/parent::div[1]
             ...                      id
  Set count id    ${id.replace('eprescribe_setting_','')}
  Form fill    eprescribe    clinic id=644    clinic key=yPSd6fgNHvqSuH4uF6XvwFHhp7QfkRaw    master clinician id=1724
  Click Button    Update
  Ajax wait
  Click Element    //a[@href='/e_prescribe_settings/${Cid}/new_e_prescribe_clinician']
  Ajax wait
  Form fill    eprescribe    user:dropdown=${Find First} ${Find Last}    clinician id=1724
  Click Element    //div[@id='add-eprescribe-clinician']/following-sibling::div[last()]//button[.='Submit']
  Ajax wait
  Set count id

Disabling eprescribe
  Set count id
  Go To    ${BASE URL}${EPRESCRIBE}
  Verify for no bad page
  Loop deletion    Dialog action    Click Element    //a[@class\='delete_erx_setting' and @data-method\='delete']
  Go To    ${BASE URL}${INSTANCE}
  Temporarily reveal eprescribe options
  Instance edit "Unselect Checkbox" on "Enable ePrescribe"
  Click Button    commit
  Ajax wait

Creating an erx order
  ${order} =    Create a doctor order    medication    meds=Aspirin    route=oral    form=tablet, chewable    dose=81 mg
                ...                      freq=before lunch    dur=2    erx=${true}    proper fill=${true}
  Set Test Variable    ${Order}    ${order}

Dosespot will show the patients information
  ${passes} =    Run Keyword And Return Status    Page should have    ♂
  ${gender} =    Set Variable If    ${passes}    Male    Female
  ${age} =    Get Text    //div[@id='patient_header']//span[contains(text(),'Age: ')]
  ${age} =    Set Variable    ${age.replace('Age:','').strip()}
  Slow wait    10
  Custom screenshot
  ${s2l} =    Get Library Instance    SeleniumLibrary
  ${webdriver} =    Set Variable    ${s2l._drivers.current}
  ${dosespot} =    Get Webelement    //iframe
  ${dosespot} =    FRAME Switch    ${webdriver}    ${dosespot}
  FOR    ${element}    IN
  ...    <span id="fullname-target">${Test First} ${Test Middle} ${Test Last}</span>
  ...    <span id="gender-target">${gender}</span>    <span id="age-target">${age} yrs</span>
      Run Keyword And Continue On Failure    Should Contain    ${dosespot}    ${element}
  END
  ${passes} =    Run Keyword And Return Status    Click Element
                 ...                              //span[${CSS SELECT.replace('$CSS','ui-icon-closethick')}]
  Run Keyword If    not ${passes}    Reload Page

Dosespot will show the patients medication
  Slow wait    10
  ${s2l} =    Get Library Instance    SeleniumLibrary
  ${webdriver} =    Set Variable    ${s2l._drivers.current}
  ${dosespot} =    Get Webelement    //iframe
  ${dosespot} =    FRAME Switch    ${webdriver}    ${dosespot}
  Run Keyword And Continue On Failure    Should Contain    ${dosespot}    ${Order}
  ${passes} =    Run Keyword And Return Status    Click Element
                 ...                              //span[${CSS SELECT.replace('$CSS','ui-icon-closethick')}]
  Run Keyword If    not ${passes}    Reload Page
