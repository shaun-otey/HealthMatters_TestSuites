*** Settings ***
Documentation   Users are able to create group sessions for any day of the week.
...             Creating a group session allows you to start the group session in schedules (https://demo.kipuworks.com/group_session_leaders).
...             Clicking start on a session will open a page to begin typing information about the session.
...             Patients that have been previously scheduled to attend a session will be able to appear in the session without having to add them manually with "add patient" button.
...             Group sessions that are created in templates (https://demo.kipuworks.com/group_sessions ) can be assigned to a schedule (https://demo.kipuworks.com/group_sessions ).
...             The schedule is then placed in the patients chart and then the patients will appear automatically when starting any session that was part of that schedule. (example: https://demo.kipuworks.com/patients/1205/patient_schedules/1666?process=1 )

Default Tags    regression    re010    points-13    templates story    notester    hasprint    exceptions
Resource        ../../suite.robot
Suite Setup     Run Keywords    I attempt to hit the "templates" tab
...                             I hit the "templates group sessions" tab
Suite Teardown  Return to mainpage

*** Test Cases ***
Create group session templates
  ### EX
  [SETUP]    Prepare male and female patients
  [TEMPLATE]    I create a ${group} called ${title}, that is ${enabled} and ${billable},
  ...           at the ${locations} on ${day} from ${start time} to ${end time}
  # ...           with the group leaders being ${name}
  # ${_GROUP LEADERS 1} ${EMPTY} ${EMPTY}${_GROUP LEADERS 2} ${_GROUP LEADERS 3}
  Standard Group           Standard Test       enabled         billable        ${_LOCATION 5}                   Sunday      08 PM:34    03 PM:00
  Caseload Group           Caseload Test       not enabled     billable        ${_LOCATION 5}                   Tuesday     04 AM:00    04 AM:11
  Schedule Placeholder     Placeholder Test    enabled         not billable    ${_LOCATION 3}                   Saturday    12 PM:46    09 AM:29
  Caseload Group           Caseload Plus       enabled         not billable    ${_LOCATION 5}                   Tuesday     04 AM:00    04 AM:11
  Schedule Placeholder     Placeholder Plus    not enabled     billable        ${_LOCATION 3};${_LOCATION 1}    Saturday    12 PM:46    09 AM:29
  Gender Group - Male      Male Test           not enabled     not billable    ${_LOCATION 2};${_LOCATION 1}    Friday      06 AM:17    11 AM:56
  # Gender Group - Female    Female Test         enabled         billable        ${_LOCATION 1}                   Monday      09 PM:00    10 PM:00
  Gender Group - Female    Female Test         enabled         billable        ${_LOCATION 1}                   Today       12 AM:00    11 PM:59
  Standard Group           Standard Today      enabled         billable        ${_LOCATION 1}                   Today       12 AM:00    11 PM:59
  Caseload Group           Caseload Today      enabled         billable        ${_LOCATION 1}                   Today       12 AM:00    11 PM:59
  Gender Group - Male      Male Today          enabled         billable        ${_LOCATION 1}                   Today       12 AM:00    11 PM:59
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Remove this patient    Boy of war
  ...           AND             Remove this patient    Girl of war
  ...           AND             Go To    ${BASE URL}${TEMPLATES GROUP SESSIONS}

Group session end date shows up correctly when done overnight
  [SETUP]    Set Test Variable    ${Gs name}    Dashin mex fail
  [TEMPLATE]    I create a group from ${start time} to ${end time}, thus the session ends ${day}
  05 PM    04 PM    tomorrow
  05 PM    04 AM    tomorrow
  05 AM    04 AM    tomorrow
  05 AM    04 PM    today
  04 PM    05 AM    today
  05 AM    05 AM    tomorrow
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Go To    ${BASE URL}${TEMPLATES GROUP SESSIONS}

Edit a group session template
  [TAGS]    skip

Group sessions correctly show up in their assigned locations
  [SETUP]    Set Test Variable    ${Gs name}    No chick nuggets
  Given I am on the "templates group sessions" page
  And create tester template    group sessions    ${Gs name}
  And edit and prepare the group session for testing locations
  When I select the "My Locations" location
  Then Run Keyword And Continue On Failure    Page Should Contain    ${Gs name}
  And I select the "${_LOCATION 5}" location
  And Run Keyword And Continue On Failure     Page Should Contain    ${Gs name}
  And I select the "${_LOCATION 2}" location
  And Run Keyword And Continue On Failure     Page Should Not Contain    ${Gs name}
  When I select the "My Locations" location
  And bypass edit the "${Gs name}" session
  And I hit the "schedules" tab
  Then Run Keyword And Continue On Failure    Page Should Contain    ${Gs name}
  And I select the "${_LOCATION 5}" location
  And Run Keyword And Continue On Failure    Page Should Contain    ${Gs name}
  And I select the "${_LOCATION 2}" location
  And Run Keyword And Continue On Failure     Page Should Not Contain    ${Gs name}
  When I select the "My Locations" location
  And bypass edit the "${Gs name}" session
  And sign off and submit
  And I hit the "past group sessions" tab
  Then Run Keyword And Continue On Failure    Page Should Contain    ${Gs name}
  And I select the "${_LOCATION 5}" location
  And Run Keyword And Continue On Failure    Page Should Contain    ${Gs name}
  And I select the "${_LOCATION 2}" location
  And Run Keyword And Continue On Failure     Page Should Not Contain    ${Gs name}
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Go To    ${BASE URL}${SCHEDULES}
  ...           AND             I select the "My Locations" location
  ...           AND             Return "${Gs name}" to upcoming group sessions
  ...           AND             Delete tester template    group sessions
  ...           AND             Go To    ${BASE URL}${TEMPLATES GROUP SESSIONS}

Print/pdf
  [TAGS]    hasprint

Scroll up
  Given I am on the "templates group sessions" page
  When scrolling down
  And I hit the "top" tab
  Then Location Should Contain    \#

*** Keywords ***
I create a ${group} called ${title}, that is ${enabled} and ${billable}, at the ${locations} on ${day} from ${start time} to ${end time}
  Log    I create a ${group} called ${title}, that is ${enabled} and ${billable}, at the ${locations} on ${day} from ${start time} to ${end time}
  ...    console=True
  I am on the "templates group sessions" page
  ${left start}    ${right start} =    Split String    ${start time}    :
  ${left end}    ${right end} =    Split String    ${end time}    :
  ${enabled} =    Set Variable If    '${enabled}'=='enabled'    x    o
  ${billable} =    Set Variable If    '${billable}'=='billable'    x    o
  ${day} =    Run Keyword If    '${day}'!='Today'    Set Variable    ${day}
              ...               ELSE                 Convert Date    ${Todays Date}    %A    False    %Y-%m-%d
  Create tester template    group sessions    ${title}
  Editing "group sessions" test template
  &{locations hit} =    Create dict for locations    ${locations}
  Form fill    group sessions form    session type:dropdown=${group}    enabled:checkbox=${enabled}
  ...          billable:checkbox=${billable}    week day:dropdown=${day}    start time hr:dropdown=${left start}
  ...          start time min:dropdown=${right start}    end time hr:dropdown=${left end}
  ...          end time min:dropdown=${right end}    &{locations hit}
  ${passes} =    Run Keyword And Return Status    Page Should Contain    Add Group Leader
  ${leader} =    Run Keyword If    ${passes}    Set up group leader
                 ...               ELSE         Set Variable    null
  Save "group sessions" template
  Page Should Contain    ${title}
  Run Keyword If    '${enabled}'=='x' and '${group}'!='Schedule Placeholder'
  ...               Check in session    ${locations}    ${day}    ${title}    ${leader}
  ...               ${left start.replace(' ',':${right start} ')}    ${left end.replace(' ',':${right end} ')}
  [TEARDOWN]    Delete tester template    group sessions

I create a group from ${start time} to ${end time}, thus the session ends ${day}
  Log    I create a group from ${start time} to ${end time}, thus the session ends ${day}    console=True
  I am on the "templates group sessions" page
  ${numeric start} =    Convert Date    ${Todays Date} ${start time} 00    epoch    False    %Y-%m-%d %I %p %M
  ${numeric end} =    Convert Date    ${Todays Date} ${end time} 00    epoch    False    %Y-%m-%d %I %p %M
  Create tester template    group sessions    ${Gs name}
  Editing "group sessions" test template
  ${day} =    Convert Date    ${Todays Date}    %A    False    %Y-%m-%d
  &{locations hit} =    Create dict for locations    ${_LOCATION 1}
  Form fill    group sessions form    enabled:checkbox=x    week day:dropdown=${day}
  ...          start time hr:dropdown=${start time}    end time hr:dropdown=${end time}    &{locations hit}
  Save "group sessions" template
  I hit the "schedules" tab
  Sleep    5
  Loop deletion    Return "${Gs name}" to upcoming group sessions
  [TEARDOWN]    Delete tester template    group sessions

Set up group leader
  I hit the "Add Group Leader" view
  # Ajax wait
  Run Keyword And Continue On Failure    Page Should Contain Element    //label[@for='group_session_locations']
  ${leader} =    Get Text    //select[@id='group_session_group_leaders_attributes_0_user_id']/option[1]
  [RETURN]    ${leader}

Check in session
  [ARGUMENTS]    ${location}    ${day}    ${name}    ${leader}    ${start time}    ${end time}
  I hit the "schedules" tab
  I select the "${location}" location
  ${week today} =    Convert Date    ${Todays Date}    %w    False    %Y-%m-%d
  ${week day} =    Set Variable If    '${day}'=='Sunday'       0
                   ...                '${day}'=='Monday'       1
                   ...                '${day}'=='Tuesday'      2
                   ...                '${day}'=='Wednesday'    3
                   ...                '${day}'=='Thursday'     4
                   ...                '${day}'=='Friday'       5
                   ...                True                     6
  ${go back} =    Evaluate    math.copysign(1,${week today}-${week day})*(${week today}-${week day})%7    math
  ${target day} =    Subtract Time From Date    ${Todays Date}    ${go back} days    %d    False    %Y-%m-%d
  ${target day} =    Convert To Integer    ${target day}
  ${today} =    Convert To Integer    ${Todays Date.rsplit('-',1)[-1]}
  Loop deletion    Select date and return to session    ${target day}    ${today}    ${name}
  Run Keyword If    '${leader}'!='null'    Run Keyword And Continue On Failure    Element Should Contain
  ...                                      //a[contains(text(),'${name}')]/ancestor::tr[1]    ${leader}
  I hit the "${name}" view
  # Bypass edit the "${name}" session
  I hit the "Preview/print view" text
  Page should have    ${start time}    ${end time}
  Run Keyword If    '${name.split()[0]}' in ['Female','Male']    Run Keywords    Go Back
  ...                                                                            Add gender patients
  [TEARDOWN]    Run Keywords    Custom screenshot
  ...           AND             Go To    ${BASE URL}${SCHEDULES}
  ...           AND             Loop deletion    Select date and return to session    ${target day}    ${today}
  ...                           ${name}

Select date and return to session
  [ARGUMENTS]    ${target day}    ${today}    ${session}
  Click Element    //div[@id='change_group_session_date']/a
  Run Keyword If    ${target day} > ${today}    Click Element    //span[@class='ui-icon ui-icon-circle-triangle-w']
  Calendar select day "${target day.__str__().lstrip('0')}"
  Dialog Action    Click Element    //a[contains(text(),'${session}')]/../following-sibling::td[last()]/a[1]

Add gender patients
  Search to add patient "Boy of war"
  Sleep    2
  Search to add patient "Girl of war"
  Sleep    2

Search to add patient "${patient}"
  Custom screenshot
  Run Keyword And Ignore Error    I hit the "Add ${Patient Handle}" view
  Custom screenshot
  Input Text    //input[@class='select2-search__field']    ${patient}
  Custom screenshot
  Ajax wait

Prepare male and female patients
  ${comeback} =    Log Location
  Return to mainpage
  I select the "${_LOCATION 1}" location
  I create a valid patient    Boy    of    war    05/01/2021
  Return to mainpage
  I create a valid patient    Girl    of    war    05/02/2021
  Update facesheet    birth sex:radio=gender_female
  Go To    ${comeback}

Edit and prepare the group session for testing locations
  Editing "group sessions" test template
  ${day} =    Convert Date    ${Todays Date}    %A    False    %Y-%m-%d
  &{locations hit} =    Create dict for locations    ${_LOCATION 5}
  Form fill    group sessions form    enabled:checkbox=x    week day:dropdown=${day}    &{locations hit}
  Save "group sessions" template
  I hit the "schedules" tab
  Loop deletion    Return "${Gs name}" to upcoming group sessions

# Edit and prepare the group session for testing overnight
#   Editing "group sessions" test template
#   ${day} =    Convert Date    ${Todays Date}    %A    False    %Y-%m-%d
#   &{locations hit} =    Create dict for locations    ${_LOCATION 1}
#   Form fill    group sessions form    enabled:checkbox=x    week day:dropdown=${day}    start time min:dropdown=${right start.__str__()}    end time min:dropdown=${right end.__str__()}    &{locations hit}
#   Save "group sessions" template
#   I hit the "schedules" tab
#   Loop deletion    Return "${Gs name}" to upcoming group sessions

Sign off and submit
  # Click Button    Update
  Click Element    form_submit
  Ajax wait
  Click Button    Group leader sign off & submit
  Click Element    //canvas
  Click Button    Submit
  Ajax wait
