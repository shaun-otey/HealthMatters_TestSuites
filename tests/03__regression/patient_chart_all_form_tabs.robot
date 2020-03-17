*** Settings ***
Documentation   Any patient chart tab functionality not associated with appointments, chart summary, doctor's order,
...             facesheet, med log, nor phi.
...
Default Tags    regression    re033    points-8    patient chart story
Resource        ../../suite.robot
Suite Setup     Setup a pre admitted patient and forms
Suite Teardown  Run Keywords    Delete tester template    evaluations
...             AND             Loop deletion    Remove old templates    Prosciutto Slice
...             AND             Loop deletion    Remove old templates    Pineapple Slice
...             AND             Loop deletion    Remove old templates    Ham Slice
...             AND             Remove this patient    Black Generating Three
...             AND             Return to mainpage

*** Test Cases ***
Add forms to admitted and pre admitted patients
  [TEMPLATE]    Adding a ${form} with the ${evaluation} type to a ${kind} patient will ${function}
  Pre Admission    Standard form         admitted       work
  Pre Admission    Standard form         preadmitted    fail
  Nursing          Standard form         admitted       work
  Nursing          Standard form         preadmitted    fail
  Pre Admission    Pre-admission form    admitted       fail
  Pre Admission    Pre-admission form    preadmitted    work
  Nursing          Pre-admission form    admitted       fail
  Nursing          Pre-admission form    preadmitted    work

Add a psychiatric evaluation form and check for issues
  Given I am on the "patients" page
  And travel "fast" to "tester" patients "medical orders" page in "${_LOCATION 1}"
  And create a doctor order    medication    meds=oped for noro
  When travel "slow" to "tester" patients "medical" page in "null"
  And with this form "Initial Psychiatric Evaluation" perform these actions "add;edit"
  Then sleep    5
  Custom screenshot
  # medication
  Then sleep    5
  Custom screenshot
  # add medication
  When I hit the "Medical" view
  And with this form "Initial Psychiatric Evaluation" perform these actions "view"
  Then sleep    5
  Custom screenshot
  # count
  I hit the "Medical" view

Add a medication brought in form and check for issues
  Given I am on the "patients" page
  And travel "slow" to "tester" patients "admission" page in "${_LOCATION 1}"
  When with this form "Medications Brought in by Patient" perform these actions "add;edit"
  And fill out the medication form
  Then print view should be correct
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Set count id
  ...           AND             I hit the "admission" patient tab
  ...           AND             With this form "null" perform these actions "wipe"
  ...           AND             Return to mainpage

*** Keywords ***
Setup a pre admitted patient and forms
  I select the "${_LOCATION 1}" location
  I create an invalid patient    Black    Generating    Three    03/28/2018
  I attempt to hit the "templates" tab
  I hit the "templates evaluations" tab
  @{names} =    Create List    Ham Slice    Pineapple Slice    Prosciutto Slice    Mushroom Slice
  @{processes} =    Create List    Pre-Admission    Nursing    Pre-Admission    Nursing
  @{evaluations} =    Create List     Standard form    Standard form    Pre-admission form    Pre-admission form
  :FOR    ${name}    ${process}    ${evaluation}    IN ZIP    ${names}    ${processes}    ${evaluations}
  \    Create tester template    evaluations    ${name}
  \    Editing "evaluations" test template
  \    Form fill    evaluations form    enabled:checkbox=x    patient process:dropdown=${process}
  \    ...          eval type:dropdown=${evaluation}    patient sig:checkbox=x
  \    Run Keyword If    ${_LOCATIONS ACTIVE}    Form fill    evaluations form    all locations:checkbox=x
  \    Save "evaluations" template
  Return to mainpage

Adding a ${form} with the ${evaluation} type to a ${kind} patient will ${function}
  ${form}    ${tab} =    Run Keyword If    '${evaluation}'=='Standard form' and '${form}'=='Pre Admission'
                         ...               Set Variable    Ham Slice    ${form}
                         ...    ELSE IF    '${evaluation}'=='Standard form' and '${form}'=='Nursing'
                         ...               Set Variable    Pineapple Slice    ${form}
                         ...    ELSE IF    '${form}'=='Pre Admission'    Set Variable    Prosciutto Slice    ${form}
                         ...               ELSE                          Set Variable    Mushroom Slice    ${form}
  ${kind} =    Set Variable If    '${kind}'=='admitted'    tester    Black T
  Travel "slow" to "${kind}" patients "${tab}" page in "null"
  ${comeback} =    Log Location
  ${passes} =    Run Keyword And Return Status    With this form "${form}" perform these actions "add;edit"
  Custom screenshot
  Run Keyword If    ${passes}    Run Keywords    Should Be Equal As Strings    ${function}    work
  ...                            AND             Wait Until Page Contains Element    //div[@id='please_wait' and contains(@style,'display') and contains(@style,'none')]
  ...                            AND             Verify for no bad page
  ...               ELSE         Run Keywords    Should Be Equal As Strings    ${function}    fail
  ...                            AND             Page Should Contain    Errors found
  [TEARDOWN]    Run Keywords    Go To    ${comeback}
  ...           AND             Loop deletion    With this form "${form}" perform these actions "delete"
  ...           AND             Return to mainpage

Fill out the medication form
  ${date} =    Convert Date    ${Todays Date}    result_format=%m/%d/%Y
  Set count id
  Repeat Keyword    2x    I hit the "Add medication" text
  Form fill    meds brought in    keep my order=${true}    date:js=${date} 12:00 AM    medication=Lexapro    amount=50
  ...          route:dropdown=oral    dosage form=tablet    dose=20 mg    freq:dropdown=once a day, at bedtime
  ...          quantity=1.0    medications brought:radio=Medication brought in (enter below)
  Set count id    +1
  Form fill    meds brought in    keep my order=${true}    medication=Super    amount=9999    route:dropdown=rectal
  ...          destroyed:checkbox=x    dosage form=a ton    dose=0.000001 mg    freq:dropdown=before meals
  ...          quantity=0.0    prn:checkbox=x    last dose:js=${date} 12:00 AM    justification=I am being split
  ...          note=blurg blurg blurg
  Click Element    form_submit
  Ajax wait
  I hit the "Preview/print view" view

Print view should be correct
  ${date} =    Convert Date    ${Todays Date}    result_format=%m/%d/%Y
  @{headers} =    Create List    Medication    Amount brought in on admission    Route    Dosage Form    Dose
                  ...            Frequency    Quantity    Prn    Last dose    Destroyed    Justification
  @{col 1} =    Create List    Lexapro    50    oral    tablet    20 mg    once a day, at bedtime    1.0    No
                ...            ${EMPTY}    No    ${EMPTY}
  @{col 2} =    Create List    Super    9999    rectal    a ton    0.000001 mg    before meals    0.0    Yes
                ...            08/14/2018 12:00 AM    Yes    I am being split
  Page should have    Date/Time:    ${date} 12:00 AM     Note: blurg blurg blurg
  # Run Keyword And Continue On Failure    Page Should Contain Element    //span[contains(text(),'☑')]/ancestor::div[contains(text(),'Medication brought in (enter below)')]
  Run Keyword And Continue On Failure    Page Should Contain Element    //div[contains(text(),'☑') and contains(text(),'Medication brought in (enter below)')]
  ${main table} =    Set Variable    //div[@id='show_patient_evaluation']/div/div/div[contains(text(),'Medications')]/following-sibling::table[1]/tbody
  @{table} =    Get Webelements    ${main table}/tr[1]/th
  :FOR    ${index}    ${header}    IN ENUMERATE    @{table}
  \    Set List Value    ${table}    ${index}    ${header.get_attribute('innerHTML')}
  :FOR    ${header}    ${data 1}    ${data 2}    IN ZIP    ${headers}    ${col 1}    ${col 2}
  \    Run Keyword And Ignore Error    Log    ${table.get_attribute('innerHTML')}
  \    ${passes} =    Run Keyword And Return Status    Page Should Contain    ${header}
  \    Run Keyword Unless    ${passes}    Run Keywords    Run Keyword And Continue On Failure    Fail    Missing column!
  \    ...                                AND             Continue For Loop
  \    ${col} =    Get Index From List    ${table}    ${header}
  \    Run Keyword And Continue On Failure    Page Should Contain Element    ${main table}/tr[2]/td[position()=${col+1} and contains(text(),'${data 1}')]
  \    Run Keyword And Continue On Failure    Page Should Contain Element    ${main table}/tr[3]/td[position()=${col+1} and contains(text(),'${data 2}')]
