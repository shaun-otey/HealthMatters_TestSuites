*** Settings ***
Documentation   User function/job.
...
Default Tags    sanity    sa002    points-2    settings story
Resource        ../../suite.robot
Suite Setup     Run Keywords    I select the "${_LOCATION 1}" location
...             AND             I attempt to hit the "templates" tab
...             AND             I hit the "templates evaluations" tab
...             AND             Create tester template    evaluations    TSA Pre Early Leave
...             AND             Return to mainpage
Suite Teardown  Run Keywords    Delete tester template    evaluations
...             AND             Travel "fast" to "tester" patients "nursing" page in "${_LOCATION 1}"
...             AND             With this form "TSA Pre Early Leave" perform these actions "delete"
...             AND             Return to mainpage

*** Test Cases ***
Add and delete a user function
  Given I am on the "patients" page
  When I add "The Tester" to the "___QA___" function
  And assign myself the function
  And I "do" find and access the function within the evaluation
  And I delete the function
  Then I "do not" find and access the function within the evaluation

*** Keywords ***
I add "${title}" to the "${short}" function
  Set Test Variable    ${Title}    ${title}
  Set Test Variable    ${Short}    ${short}
  I hit the "settings" tab
  I hit the "User" view
  I am on the "user" page
  Loop deletion    Dialog action    Click Link    //input[@value\='${Title}']/../../td[position()\=3]/a
  Click Link    Add item
  Ajax wait
  Input Text    //input[starts-with(@id,'user_title_') and contains(@id,'_name')]    ${Title}
  Input Text    //input[starts-with(@id,'user_title_') and contains(@id,'_short_name')]    ${Short}
  Click Element    commit
  Ajax wait

Assign myself the function
  I hit the "username" tab
  ${value} =    Get Element Attribute    //select[@id='${NEW USER FUNCTION}']/option[contains(text(),'${Title}')]
                ...                      value
  Set Test Variable    ${Value}    ${value}
  Turning "${Title}" the "function" roles for "admin"

I "${find}" find and access the function within the evaluation
  I attempt to hit the "templates" tab
  I hit the "templates evaluations" tab
  Editing "evaluations" test template
  Run Keyword If    '${find}'=='do'    Run Keywords    Page should have    ${Short}
  ...                                  AND             Form fill    evaluations form    enabled:checkbox=x
  ...                                                  patient process:dropdown=Nursing
  ...                                                  staff single sig_|_user_title_${Value}:checkbox=x
  ...                                  AND             Run Keyword If    ${_LOCATIONS ACTIVE}    Form fill
  ...                                                  evaluations form    all locations:checkbox=x
  ...                                  AND             Click Element    //input[@type='submit']
  ...               ELSE               Page should have    NOT|${Short}
  Ajax wait
  Travel "fast" to "tester" patients "nursing" page in "${_LOCATION 1}"
  Run Keyword If    '${find}'=='do'    With this form "TSA Pre Early Leave" perform these actions "add"
  With this form "TSA Pre Early Leave" perform these actions "view"
  ${test type} =    Set Variable If    '${find}'=='do'    ELEMENT    NOT|ELEMENT
  Page should have    ${test type}|form_submit    ${test type}|validate_patient_evaluation_fields
  ...                 ${test type}|//span[contains(text(),'Sign & Submit')]    ${test type}|//a[@name='addUser']
  ...                 ${test type}|//span[contains(text(),'Preview/print view')]

I delete the function
  I hit the "settings" tab
  I hit the "User" view
  I am on the "user" page
  Loop deletion    Dialog action    Click Link    //input[@value\='${Title}']/../../td[position()\=3]/a
