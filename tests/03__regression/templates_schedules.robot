*** Settings ***
Documentation   Test creating and modifying a template for scheduling.
...
Default Tags    regression    re015    points-2    templates story
Resource        ../../suite.robot
Suite Setup     Run Keywords    I attempt to hit the "templates" tab
...             AND             I hit the "templates schedules" tab
...             AND             Create tester template    schedules    My Test Sched
...             AND             Setup the schedule
Suite Teardown  Run Keywords    Loop deletion    Delete tester template    schedules
...             AND             Return to mainpage
Test Teardown   Run Keywords    Run Keyword If Test Failed    Custom screenshot
...             AND             Go To    ${BASE URL}${TEMPLATES SCHEDULES}

*** Test Cases ***
User can name a schedule
  Given I am on the "templates schedules" page
  And editing "schedules" test template
  When form fill    schedules form    name=The Better Sched
  And save "schedules" template
  Then Page Should Contain    The Better Sched
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Reset name

User can choose a patient process from the drop-down menu
  Given I am on the "templates schedules" page
  And editing "schedules" test template
  When form fill    schedules form    patient process:dropdown=Nursing
  And save "schedules" template
  Then confirm the patient process change
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Reset patient process

User can choose the location of the schedule
  Given I am on the "templates schedules" page
  And editing "schedules" test template
  When changing the location
  And save "schedules" template
  Then confirm the location change
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Reset location

User can choose the group sessions on the created schedule by clicking the check boxes
  Given I am on the "templates schedules" page
  And editing "schedules" test template
  When choosing some group sessions
  And save "schedules" template
  Then confirm the group sessions change

User can PDF or print the page
  [TAGS]    skip
  Given I am on the "templates schedules" page

*** Keywords ***
Setup the schedule
  Editing "schedules" test template
  Form fill    schedules form    enabled:checkbox=x    patient process:dropdown=Financial
  Select Checkbox    //div[normalize-space()='${_LOCATION 1}']/input[@name='schedule[location_ids][]']
  Save "schedules" template
  Page Should Not Contain Element    //a[@href='${TEMPLATES SCHEDULES}/${Template Id}/edit']/span[@class='disabled']
  Page Should Contain Element    //a[@href='${TEMPLATES SCHEDULES}/${Template Id}/edit']

Reset name
  Editing "schedules" test template
  Form fill    schedules form    name=My Test Sched
  Save "schedules" template
  Page Should Contain    My Test Sched

Confirm the patient process change
  Return to mainpage
  Travel "slow" to "tester" patients "nursing" page in "${_LOCATION 1}"
  I hit the "Add form" text
  Page Should Contain    My Test Sched

Reset patient process
  Go To    ${BASE URL}${TEMPLATES SCHEDULES}
  Editing "schedules" test template
  Form fill    schedules form    patient process:dropdown=Financial
  Save "schedules" template

Changing the location
  # Select Checkbox    //div[normalize-space()='${_LOCATION 5}']/input[@name='schedule[location_ids][]']
  Select Checkbox    //div[normalize-space()='${_LOCATION 4}']/input[@name='schedule[location_ids][]']

Confirm the location change
  Return to mainpage
  # Travel "slow" to "1" patients "financial" page in "${_LOCATION 5}"
  Travel "slow" to "1" patients "financial" page in "${_LOCATION 4}"
  I hit the "Add form" text
  Page Should Contain    My Test Sched

Reset location
  Go To    ${BASE URL}${TEMPLATES SCHEDULES}
  I select the "${_LOCATION 1}" location
  Editing "schedules" test template
  Select Checkbox    //div[normalize-space()='${_LOCATION 1}']/input[@name='schedule[location_ids][]']
  Save "schedules" template

Choosing some group sessions
  # ${item} =    Set Variable    //input[@id='schedule_group_session_ids_' and @value='98']
  ${item} =    Set Variable    //input[@id='schedule_group_session_ids_' and @value='153']
  Select Checkbox    ${item}
  ${session} =    Get Text    ${item}/following-sibling::span[1]
  Set Test Variable    ${Session}    ${session.split(' at ')[0]}

Confirm the group sessions change
  Return to mainpage
  Travel "slow" to "tester" patients "financial" page in "${_LOCATION 1}"
  With this form "My Test Sched" perform these actions "add;view"
  # Page Should Contain    Open topic group
  Page Should Contain    ${Session}
