*** Settings ***
Documentation   Do searching on a patient's chart summary.
...
Default Tags    regression    re020    points-3    patient chart story
Resource        ../../suite.robot
Suite Setup     Run Keywords    Travel "fast" to "tester" patients "medical orders" page in "${_LOCATION 1}"
...             AND             Create a doctor order    medication    meds=steak fillet    ordered by=Herku fire
...             AND             Travel "slow" to "current" patients "chart summary" page in "null"
Suite Teardown  Run Keywords    Travel "fast" to "tester" patients "medical orders" page in "null"
...             AND             Loop deletion    Remove any orders
...             AND             Return to mainpage
Test Teardown   Run Keywords    Run Keyword If Test Failed
...             AND             Travel "fast" to "current" patients "chart summary" page in "null"

*** Test Cases ***
Do a search
  Given I am on the "chart summary" patient page
  When entering search date range
  Then page should have    steak fillet    Herku fire

Check search results
  Given I am on the "chart summary" patient page
  When entering search date range
  Then confirm results are in range

Adding an evaluation to a patient will make it show up
  [SETUP]    Run Keywords    Go To    ${BASE URL}${TEMPLATES EVALUATIONS}
  ...        AND             Create tester template    evaluations    Insanely Long Stand Drive
  ...        AND             Editing "evaluations" test template
  ...        AND             Form fill    evaluations form    enabled:checkbox=x    patient process:dropdown=Nursing
  ...                        patient sig:checkbox=x
  ...        AND             Run Keyword If    ${_LOCATIONS ACTIVE}    Form fill    evaluations form
  ...                                                                  all locations:checkbox=x
  ...        AND             Save "evaluations" template
  ...        AND             Travel "fast" to "current" patients "chart summary" page in "null"
  Given I am on the "chart summary" patient page
  And I hit the "nursing" patient tab
  When with this form "Insanely Long Stand Drive" perform these actions "add;edit"
  And perform signature    I hit the "Sign & Submit" text
  Then I hit the "chart summary" patient tab
  And confirm evaluation is complete
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Delete tester template    evaluations
  ...           AND             Travel "fast" to "current" patients "chart summary" page in "null"

Sort summary by creation date
  Given I am on the "chart summary" patient page
  When I hit the "Created" column sort
  Then order for column is good    Created
  ...                              //div[@id='flowchart-wrap']/table/thead/tr;//div[@id='flowchart-wrap']/table/tbody/tr;null
  ...                              date;%m/%d/%Y %I:%M %p
  When I hit the "Created" column sort
  Then order for column is good    Created
  ...                              //div[@id='flowchart-wrap']/table/thead/tr;//div[@id='flowchart-wrap']/table/tbody/tr;null
  ...                              date;%m/%d/%Y %I:%M %p    direction=down

Sort summary by service time
  Given I am on the "chart summary" patient page
  When I hit the "Service Time" column sort
  Then order for column is good    Service Time
  ...                              //div[@id='flowchart-wrap']/table/thead/tr;//div[@id='flowchart-wrap']/table/tbody/tr;null
  ...                              date;%m/%d/%Y %I:%M %p
  When I hit the "Service Time" column sort
  Then order for column is good    Service Time
  ...                              //div[@id='flowchart-wrap']/table/thead/tr;//div[@id='flowchart-wrap']/table/tbody/tr;null
  ...                              date;%m/%d/%Y %I:%M %p    direction=down

Sort summary by tab
  Given I am on the "chart summary" patient page
  When I hit the "Tab" column sort
  Then order for column is good    Tab
  ...                              //div[@id='flowchart-wrap']/table/thead/tr;//div[@id='flowchart-wrap']/table/tbody/tr;null
  When I hit the "Tab" column sort
  Then order for column is good    Tab
  ...                              //div[@id='flowchart-wrap']/table/thead/tr;//div[@id='flowchart-wrap']/table/tbody/tr;null
  ...                              direction=down

Sort summary by name
  Given I am on the "chart summary" patient page
  When I hit the "Name" column sort
  Then order for column is good    Name
  ...                              //div[@id='flowchart-wrap']/table/thead/tr;//div[@id='flowchart-wrap']/table/tbody/tr;null
  When I hit the "Name" column sort
  Then order for column is good    Name
  ...                              //div[@id='flowchart-wrap']/table/thead/tr;//div[@id='flowchart-wrap']/table/tbody/tr;null
  ...                              direction=down

Sort summary by status
  ### fixme
  Given I am on the "chart summary" patient page
  When I hit the "Status" column sort
  Then order for column is good    Status
  ...                              //div[@id='flowchart-wrap']/table/thead/tr;//div[@id='flowchart-wrap']/table/tbody/tr;null
  When I hit the "Status" column sort
  Then order for column is good    Status
  ...                              //div[@id='flowchart-wrap']/table/thead/tr;//div[@id='flowchart-wrap']/table/tbody/tr;null
  ...                              direction=down

# Sort summary by duration
#   [TAGS]    testmedev
#   Travel "slow" to "108" patients "chart summary" page in "null"
#   Given I am on the "chart summary" patient page
#   When I hit the "Duration" column sort
#   Then order for column is good    Created
#   ...                              //div[@id='flowchart-wrap']/table/thead/tr;//div[@id='flowchart-wrap']/table/tbody/tr;null
#   ...                              date;%I:%M %p
#   When I hit the "Duration" column sort
#   Then order for column is good    Created
#   ...                              //div[@id='flowchart-wrap']/table/thead/tr;//div[@id='flowchart-wrap']/table/tbody/tr;null
#   ...                              date;%m/%d/%Y %I:%M %p    direction=down

Sort summary by staff signature
  Given I am on the "chart summary" patient page
  When I hit the "Staff Signature" column sort
  Then order for column is good    Staff Signature
  ...                              //div[@id='flowchart-wrap']/table/thead/tr;//div[@id='flowchart-wrap']/table/tbody/tr;null
  When I hit the "Staff Signature" column sort
  Then order for column is good    Staff Signature
  ...                              //div[@id='flowchart-wrap']/table/thead/tr;//div[@id='flowchart-wrap']/table/tbody/tr;null
  ...                              direction=down

Sort summary by review signature
  Given I am on the "chart summary" patient page
  When I hit the "Review Signature" column sort
  Then order for column is good    Review Signature
  ...                              //div[@id='flowchart-wrap']/table/thead/tr;//div[@id='flowchart-wrap']/table/tbody/tr;null
  When I hit the "Review Signature" column sort
  Then order for column is good    Review Signature
  ...                              //div[@id='flowchart-wrap']/table/thead/tr;//div[@id='flowchart-wrap']/table/tbody/tr;null
  ...                              direction=down

Click scroll to top
  Given I am on the "chart summary" patient page
  When scrolling down
  And I hit the "top" tab
  Then Location Should Contain    \#

*** Keywords ***
Entering search date range
  ${date} =    Convert Date    ${Todays Date}    result_format=%m/%d/%Y
  Form fill    ${EMPTY}    appt-start-date:direct_js=01/01/2017 1:00 AM    appt-end-date:direct_js=${date} 10:00 PM
  Click Element    //button[@type='submit']
  Ajax wait

Confirm results are in range
  ${start point} =    Convert Date    2017-01-01 01:00:00    epoch
  ${end point} =    Convert Date    ${Todays Date} 22:00:00    epoch
  @{service times} =    Get Webelements    //div[@id='flowchart-wrap']/table/tbody/tr/td[2]/a
  FOR    ${time}    IN    @{service times}
      ${time} =    Convert Date    ${time.get_attribute('innerHTML').strip(' \t\n\r')}    epoch
                   ...             date_format=%m/%d/%Y %H:%M %p
      Run Keyword And Continue On Failure    Should Be True    ${start point}<=${time}<=${end point}
  END

Confirm evaluation is complete
  ${table} =    Set Variable    //div[@id='flowchart-wrap']/table/tbody
  @{names} =    Get Webelements    ${table}/tr/td[4]/a
  FOR    ${index}    ${name}    IN ENUMERATE    @{names}
      ${position} =    Set Variable    ${index+1}
      ${passes} =    Run Keyword And Return Status    Should Be Equal As Strings
                     ...                              ${name.get_attribute('innerHTML').strip(' \t\n\r')}
                     ...                              Insanely Long Stand Drive
      Run Keyword If    ${passes}                          Exit For Loop
      ...    ELSE IF    ${names.__len__()}==${position}    Fail    Evaluation on summary not found!
  END
  Page should have    ELEMENT|${table}/tr[${position}]/td[3]/a[contains(text(),'Nursing')]
  ...                 ELEMENT|${table}/tr[${position}]/td[contains(text(),'complete') and position()=5]

I hit the "${col}" column sort
  Click Element    //div[@id='flowchart-wrap']/table/thead/tr/th/a[.='${col}']
  Ajax wait
