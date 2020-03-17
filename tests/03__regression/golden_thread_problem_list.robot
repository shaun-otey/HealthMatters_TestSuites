*** Settings ***
Documentation   The first step in using Golden Thread is listing the problems identified.
...
Default Tags    regression    re027    points-3    golden thread story
Resource        ../../suite.robot
Test Teardown   Run Keywords    Run Keyword If Test Failed    Custom screenshot
...             AND             Travel "fast" to "tester" patients "screens and assessments" page in "null"
...             AND             Loop deletion    With this form "Problem List" perform these actions "delete"
...             AND             Return to mainpage

*** Test Cases ***
Click on a problem
  Given I am on the "patients" page
  And travel "slow" to "tester" patients "screens and assessments" page in "${_LOCATION 1}"
  When adding a golden thread form
  And selecting the problem "Chronic Pain"
  Then Page Should Contain    Behavioral Definition/As evidenced by (Optional)

Start typing a problem
  Given I am on the "patients" page
  And travel "slow" to "tester" patients "screens and assessments" page in "${_LOCATION 1}"
  When adding a golden thread form
  And begin typing "Spirit"
  Then Page Should Contain    Behavioral Definition/As evidenced by (Optional)

Add a custom problem
  Given I am on the "patients" page
  And travel "slow" to "tester" patients "screens and assessments" page in "${_LOCATION 1}"
  When adding a golden thread form
  And begin typing "Needs to eat fruits"
  Then Page Should Contain    Behavioral Definition/As evidenced by (Optional)

Select possible problems based on current diagnoses
  [TAGS]    skip
  Given I am on the "patients" page
  And travel "slow" to "tester" patients "screens and assessments" page in "${_LOCATION 1}"
  When adding a problem list
  And...
  Then...

Repeat the problem list creation to catch duplication
  Given I am on the "patients" page
  When travel "slow" to "tester" patients "screens and assessments" page in "${_LOCATION 1}"
  Then check for problem list duplication

*** Keywords ***
Selecting the problem "${problem}"
  Click Element    //i[${CSS SELECT.replace('$CSS','glyphicon-list')}]
  Ajax wait
  Click Element    //div[contains(text(),'${problem}')]
  Click Button    Submit
  Ajax wait

Begin typing "${problem}"
  Input Text    problem_list_text_field    ${problem}
  Slow wait
  ${passes} =    Run Keyword And Return Status    Click Element    //li[@class='ui-menu-item']
  Click Button    Add problem
  Ajax wait
  Run Keyword If    ${passes}    Page Should Contain Element    //div[@id='problem_list']//tr[@class='border_bottom'][1]//i[${CSS SELECT.replace('$CSS','glyphicon-list')}]
  ...               ELSE         Page Should Not Contain Element    //div[@id='problem_list']//tr[@class='border_bottom'][1]//i[${CSS SELECT.replace('$CSS','glyphicon-list')}]

Check for problem list duplication
  :FOR    ${index}    IN RANGE    10
  \    Adding a golden thread form
  \    ${passes} =    Run Keyword And Return Status    Xpath Should Match X Times
  \    ...            //*[@id='${GOLDEN THREAD DATE OF SERVICES}']    1
  \    Run Keyword Unless    ${passes}    Fail    Duplication found!
  \    Go Back
  \    With this form "Problem List" perform these actions "delete"
