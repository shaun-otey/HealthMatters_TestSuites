*** Settings ***
Documentation   Golden Thread will allow you to add Progress Notes, and tag them to specific problems,
...             treatment plans, goals and/or objectives. You can also use pre-set progress note components,
...             such as sentences or phrases.
...
Default Tags    regression    re030    points-2    golden thread story
Resource        ../../suite.robot
Suite Setup     Set up a problem list and treatment plan
Suite Teardown  Run Keywords    Travel "fast" to "tester" patients "treatment plans" page in "null"
...             AND             Loop deletion    With this form "Treatment Plan" perform these actions "delete"
...             AND             Travel "fast" to "tester" patients "screens and assessments" page in "null"
...             AND             Loop deletion    With this form "Problem List" perform these actions "delete"
...             AND             Return to mainpage

*** Test Cases ***
Adding group sessions notes
  Given I am on the "patients" page
  When starting a "group sessions" note
  Then confirm the "group sessions" note has been added
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Return to mainpage
  ...           AND             Do quick group sessions setup
  ...           AND             Return to mainpage

Adding progressive notes
  Given I am on the "patients" page
  When starting a "progressive" note
  Then confirm the "progressive" note has been added

*** Keywords ***
Set up a problem list and treatment plan
  Travel "slow" to "tester" patients "screens and assessments" page in "${_LOCATION 1}"
  Adding a golden thread form
  Click Element    //i[${CSS SELECT.replace('$CSS','glyphicon-list')}]
  Ajax wait
  Click Element    //div[contains(text(),'Gambling')]
  Click Element    //div[contains(text(),'Legal Problems')]
  Click Button    Submit
  Ajax wait
  Page Should Contain    Behavioral Definition/As evidenced by (Optional)
  Travel "slow" to "tester" patients "treatment plans" page in "null"
  Adding a golden thread form    Treatment Plan
  Form fill    golden thread    modality:dropdown=Nursing    problem:dropdown=Legal Problems
  Build the treatment    Goal 1:add=null    Goal 1:select=2    Goal 1>Objective 1:add=null
  ...                    Goal 1>Objective 1:select=3
  Return to mainpage

Starting a "${type}" note
  Set Test Variable    ${Gs name}    null
  ${gs patient} =    Set Variable    //span[contains(text(),'${Test First}')]/ancestor::div[@class='fields']
  ${gt button} =    Set Variable    //a[contains(@href,'/treatment_plans/golden_thread_choices')]
  Run Keyword If    "${type}"=="progressive"       Run Keywords    Travel "fast" to "tester" patients "nursing" page in "null"
  ...                                              AND             With this form "Nursing Progress Note" perform these actions "add;edit"
  ...                                              AND             Click Element    ${gt button}
  ...    ELSE IF    "${type}"=="group sessions"    Run Keywords    Do quick group sessions setup
  ...                                              AND             Bypass edit the "${Gs name}" session
  ...                                              AND             Click Element    ${gs patient}${gt button}
  ${strong bold} =    Set Variable If    "${type}"=="progressive"    //div[@id='golden_thread_choices']/div[2]/div/div//strong    ${gs patient}//div[contains(@id,'group_session_attendance_')]//strong
  # Click Element    //a[contains(@href,'/treatment_plans/golden_thread_choices')][1]
  # Click Element    //span[contains(text(),'${Test first}')]/ancestor::div[@class='fields']
  # ${date} =    Convert Date    ${Todays Date}    result_format=%m/%d/%Y
  Ajax wait
  Loop deletion    Click Element    //span[${CSS SELECT.replace('$CSS','glyphicon-chevron-right')}]
  @{checkboxes} =    Get Webelements    //input[${CSS SELECT.replace('$CSS','check_box_collapse')}]
  @{treatment steps} =    Create List
  :FOR    ${checkbox}    IN    @{checkboxes}
  \    Select Checkbox    ${checkbox}
  \    Append To List    ${treatment steps}    ${checkbox.find_element_by_xpath('./..').text.strip(' \t\n\r').split(': ')[-1]}
  \    Log    ${treatment steps}
  # Sort List    ${treatment steps}
  Click Button    Submit
  Ajax wait
  @{strong bold} =    Get Webelements    ${strong bold}
  @{treatment output} =    Create List
  :FOR    ${strong}    IN    @{strong bold}
  \    Append To List    ${treatment output}    ${strong.text}
  \    Log    ${treatment output}
  # Sort List    ${treatment output}
  Sleep    20
  Lists Should Be Equal    ${treatment steps}    ${treatment output}
  Page should have    Legal Problems    Gambling
  Run Keyword If    "${type}"=="progressive"    Run Keywords    Click Element    //i[${CSS SELECT.replace('$CSS','glyphicon-list')}]
  ...                                           AND             Ajax wait
  # ...                                           AND             Click Element    //div[contains(text(),'What is staging')]
  ...                                           AND             Click Element    //div[contains(text(),'Patient denies suicidality')]
  ...                                           AND             Click Button    Submit
  ...                                           AND             Ajax wait
  ...                                           AND             I hit the "Sign & Submit" text
  ...                                           AND             Ajax wait
  ...                                           AND             Click Element    //canvas
  ...                                           AND             Click Element    //div[@id='signature-dialog']/following-sibling::div[1]//button[.='Submit']
  Ajax wait
  # Form fill    golden thread    date of services:js=${date}    modality:dropdown=Alternative
  # ...          problem:dropdown=Chronic Pain

Do quick group sessions setup
  I hit the "schedules" tab
  ${name} =    Get Text    //a[contains(text(),'Living Skills:') and contains(@href,'/group_session_leaders')][1]
  Set Test Variable    ${Gs name}    ${name}
  Loop deletion    Return "${Gs name}" to upcoming group sessions

Confirm the "${type}" note has been added
  Run Keyword If    "${type}"=="progressive"    With this form "Nursing Progress Note" perform these actions "view"
  I hit the "Legal Problems" text
  Click Element    //img[@alt='Kipu knot']
  Ajax wait
  # Page should have    What is staging
  Run Keyword If    "${type}"=="progressive"    Page Should Contain    Patient denies suicidality
  ...               ELSE                        Page Should Contain    ${Gs name}
