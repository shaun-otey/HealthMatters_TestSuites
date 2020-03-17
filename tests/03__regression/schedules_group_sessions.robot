*** Settings ***
Documentation   Group sessions features, including editing and viewing past dates.
...
Default Tags    regression    re017    points-11    hasprint
Resource        ../../suite.robot
Suite Setup     Setup group leader and session
Suite Teardown  Run Keywords    Loop deletion    Return "${Gs name}" to upcoming group sessions
...             AND             Return to mainpage
Test Teardown   Run Keywords    Run Keyword If Test Failed    Custom screenshot
...             AND             Go To    ${BASE URL}${SCHEDULES}

*** Test Cases ***
Scheduled group sessions tab - User can change date to see group sessions on a different day
  Given I am on the "schedules" page
  When I change the calendar to day "1"
  Then the group sessions from day "1" is shown

Scheduled group sessions tab - User can start a group session assigned to that day
  [SETUP]    Loop deletion    Return "${Gs name}" to upcoming group sessions
  Given I am on the "schedules" page
  When I hit the "${Gs name}" view
  And I hit the "schedules" tab
  Then the "${Gs name}" session is in "progress" group sessions

Scheduled group sessions tab - User (group leader) can edit any group "in progress" or "pending review"
  Given I am on the "schedules" page
  When bypass edit the "${Gs name}" session
  Then Page Should Contain    Group leader sign off & submit

Scheduled group sessions tab - User can PDF or print the page
  [TAGS]    hasprint
  Given I am on the "schedules" page

Past group sessions tab - Users can sort group sessions by name
  Given I am on the "schedules" page
  And I hit the "past group sessions" tab
  When I hit the "Session" view
  Then order for column is good    Session

Past group sessions tab - Users can sort group sessions by date/time
  Given I am on the "schedules" page
  And I hit the "past group sessions" tab
  When I hit the "Date/Time" view
  # Then order for column is good    Date/Time    date=%A, %b %d %Y, %I:%M %p %Z=-
  Then order for column is good    Date/Time    format=date;%A, %b %d %Y, %I:%M %p;${EMPTY}; E

Past group sessions tab - Users can sort group sessions by group leader
  Given I am on the "schedules" page
  And I hit the "past group sessions" tab
  When I hit the "Group Leader" view
  Then order for column is good    Group Leader

Past group sessions tab - Users can sort group sessions by status
  Given I am on the "schedules" page
  And I hit the "past group sessions" tab
  When I hit the "Status" view
  Then order for column is good    Status

Past group sessions tab - Users can filter search and sort
  [SETUP]    I select the "My Locations" location
  Given I am on the "schedules" page
  And I hit the "past group sessions" tab
  When searching for "therapy"
  And I hit the "Status" view
  Then Page Should Have    Therapy
  And order for column is good    Status
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             I select the "${_LOCATION 1}" location
  ...           AND             Go To    ${BASE URL}${SCHEDULES}

Past group sessions tab - User can enter a group session from this page
  [TAGS]    update me
  Given I am on the "schedules" page
  And I hit the "past group sessions" tab
  Then I am on the "past group sessions" page

Past group sessions tab - Check that each edit and view links are reachable
  [SETUP]    I select the "My Locations" location
  Given I am on the "schedules" page
  When I hit the "past group sessions" tab
  And create a seperate session
  Then check each view edit link
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             I select the "${_LOCATION 1}" location
  ...           AND             Go To    ${BASE URL}${SCHEDULES}

Inside a group session - User can change the group leader
  Given I am on the "schedules" page
  And bypass edit the "${Gs name}" session
  And Page Should Contain    Group leader: ${Current leader}
  When changing group leader to someone else
  Then page should contain the "${Current leader}" assigned to the "${Gs name}" session
  When bypass edit the "${Gs name}" session
  Then Page Should Contain    Group leader: ${Current leader}

Inside a group session - User can print a sign-in sheet
  Given I am on the "schedules" page
  And bypass edit the "${Gs name}" session
  When I hit the "Print sign-in sheet" view
  Then Page Should Contain    Signin sheet

Inside a group session - User can edit the start and end time
  [SETUP]    Loop deletion    Return "${Gs name}" to upcoming group sessions
  Given I am on the "schedules" page
  And I hit the "${Gs name}" view
  When form fill    gs leader form    session start hr:dropdown=05 PM    session start min:dropdown=01    session end hr:dropdown=07 PM    session end min:dropdown=59
  And do an update
  And changing group leader to someone else
  Then Page Should Contain    05:01 PM
  When I hit the "${Gs name}" view
  # And page should have    05:01 PM EST - 07:59 PM EST    Session start: 05:01 PM    Session end:${SPACE*3}07:59 PM
  Then page should have    05:01 PM E    T - 07:59 PM E    Session start: 05:01 PM    Session end:${SPACE*3}07:59 PM

Inside a group session - User can enter a topic
  Given I am on the "schedules" page
  And bypass edit the "${Gs name}" session
  When form fill    gs leader form    topic=Sleepy BBQ
  And do an update
  And I hit the "schedules" tab
  # And Page Should Contain    ${Gs name} -${SPACE*2}Sleepy BBQ
  Then page should have    ${Gs name}    Sleepy BBQ
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Go To    ${BASE URL}${SCHEDULES}
  ...           AND             Return "${Gs name}" to upcoming group sessions

Inside a group session - User can check on or off if a patient attended
  Given I am on the "schedules" page
  And bypass edit the "${Gs name}" session
  When checking attendance
  And changing group leader to someone else
  Then I hit the "${Gs name}" view
  And confirm patient "Adina" is "off" the list
  And confirm patient "Peter" is "on" the list
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Go To    ${BASE URL}${SCHEDULES}
  ...           AND             Set count id

Inside a group session - User can enter an individual assessment
  Given I am on the "schedules" page
  And bypass edit the "${Gs name}" session
  When filling assessments
  And changing group leader to someone else
  Then I hit the "${Gs name}" view
  And confirm assessment for "Adina" has "i will not join" written
  And confirm assessment for "Peter" has "going to get evaluated" written
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Go To    ${BASE URL}${SCHEDULES}
  ...           AND             Set count id

Inside a group session - User can delete a client
  Given I am on the "schedules" page
  And bypass edit the "${Gs name}" session
  When deleting patient "${GS LEADER FORM FIRST PATIENT}"
  And changing group leader to someone else
  Then I hit the "${Gs name}" view
  And Page Should Not Contain    ${_PATIENT 4 NAME SEG 1} ${_PATIENT 4 NAME SEG 2} ${_PATIENT 4 NAME SEG 3}
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Go To    ${BASE URL}${SCHEDULES}
  ...           AND             Return "${Gs name}" to upcoming group sessions

Inside a group session - User can enter a group description
  Given I am on the "schedules" page
  And bypass edit the "${Gs name}" session
  When form fill    gs leader form    group description=we hope all tests will pass
  And changing group leader to someone else
  Then I hit the "${Gs name}" text
  And Page Should Contain    we hope all tests will pass

Inside a group session - Use can add an attachment
  [TAGS]    skip
  Given I am on the "schedules" page

Inside a group session - User can print preview
  [SETUP]    Loop deletion    Return "${Gs name}" to upcoming group sessions
  Given I am on the "schedules" page
  And I hit the "${Gs name}" view
  When I hit the "Preview/print view" view
  Then Page Should Contain    Members

Inside a group session - User can sign the group session
  Given I am on the "schedules" page
  And bypass edit the "${Gs name}" session
  When sign off and submit
  Then confirm that the group session is completed
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Go To    ${BASE URL}${SCHEDULES}
  ...           AND             Return "${Gs name}" to upcoming group sessions

Inside a group session - User can delete the group session
  Given I am on the "schedules" page
  And bypass edit the "${Gs name}" session
  When deleting this session
  Then the "${Gs name}" session is in "upcoming" group sessions

Inside a group session - User can PDF or print the page
  [TAGS]    hasprint
	Given I am on the "schedules" page

Inside a group session - Patients with an mr should not be added
  ### EX
  [SETUP]    Run Keywords    Return to mainpage
  ...        AND             I create an invalid patient    thedumpisfailed    oh    no    05/05/2018
  ...        AND             Go To    ${BASE URL}${SCHEDULES}
  Given I am on the "schedules" page
  And bypass edit the "${Gs name}" session
  When I hit the "Add ${Patient Handle.title()}" view
  Then Page Should Contain    Nobody to add
  And return to mainpage
  When I create a valid patient    thedumpisgood    oh    yay    06/06/2018
  And Go To    ${BASE URL}${SCHEDULES}
  And bypass edit the "${Gs name}" session
  Then search to add patient "thedumpis"
  And the patient "thedumpisfailed" shown "cannot" be added
  And the patient "thedumpisgood" shown "can" be added
  When search to add patient "thedumpisfailed"
  Then the patient "thedumpis" shown "cannot" be added
  And Page Should Contain    No results found
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Remove this patient    thedumpisfailed oh no
  ...           AND             Remove this patient    thedumpisgood oh yay
  ...           AND             Go To    ${BASE URL}${SCHEDULES}

Inside a group session - Preferred name on print out sheet
  ### EX
  [SETUP]    Create nick named patients
  Given I am on the "schedules" page
  And bypass edit the "${Gs name}" session
  When adding the patients "mister;endless"
  And I hit the "Print sign-in sheet" view
  Then page should have    redbull o    endless n
  When Go To    ${BASE URL}${INSTANCE}
  And instance edit "Unselect Checkbox" on "Show preferred name in sign in sheet"
  And I hit the "schedules" tab
  And return "${Gs name}" to upcoming group sessions
  And bypass edit the "${Gs name}" session
  Then adding the patients "mister;endless"
  And I hit the "Print sign-in sheet" view
  And page should have    mister o    endless n
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Remove this patient    mister no oreo
  ...           AND             Remove this patient    endless no name
  ...           AND             Go To    ${BASE URL}${INSTANCE}
  ...           AND             Instance edit "Unselect Checkbox" on "Show preferred name in sign in sheet"
  ...           AND             Go To    ${BASE URL}${SCHEDULES}
  ...           AND             Return "${Gs name}" to upcoming group sessions

Entire group session procedure - Match start, end, and duration with actual times
  [SETUP]    Setup for matching times
  Given I am on the "schedules" page
  And page should have    ${Gs match name}    ${Match start}
  And bypass edit the "${Gs match name}" session
  When verify page is correct and add the test patient
  And modify patient "${Test First}" participation starting from "02:22 PM" to "03:33 PM"
  And sign off and submit
  Then travel "slow" to "tester" patients "chart summary" page in "${_LOCATION 1}"
  And verify outside and inside chart summary for duration
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             I select the "My Locations" location
  ...           AND             Go To    ${BASE URL}${SCHEDULES}
  ...           AND             Return "${Gs match name}" to upcoming group sessions
  ...           AND             Delete tester template    group sessions
  ...           AND             Go To    ${BASE URL}${SCHEDULES}
  ...           AND             I select the "${_LOCATION 1}" location

Entire group session procedure - Ending and starting group sessions exact time should not give warning
  [SETUP]    Setup for ending times
  Given I am on the "schedules" page
  And page should have    ${Gs start name}    ${Gs end name}
  When bypass edit the "${Gs start name}" session
  And adding the patients "${Test First}"
  And I hit the "← Groups" view
  And bypass edit the "${Gs end name}" session
  And adding the patients "${Test First}"
  Then Page Should Not Contain    This patient appears to be attending another group at this time:
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Go To    ${BASE URL}${SCHEDULES}
  ...           AND             I select the "My Locations" location
  ...           AND             Return "${Gs start name}" to upcoming group sessions
  ...           AND             Return "${Gs end name}" to upcoming group sessions
  ...           AND             Go To    ${BASE URL}${TEMPLATES GROUP SESSIONS}
  ...           AND             Loop deletion    Remove old templates    ${Gs start name}
  ...           AND             Loop deletion    Remove old templates    ${Gs end name}
  ...           AND             Go To    ${BASE URL}${SCHEDULES}
  ...           AND             I select the "${_LOCATION 1}" location

Entire group session procedure - Create a group sessions 2 with multiple occurrences
  [SETUP]    Setup for group sessions two
  Given I am on the "schedules" page
  And I attempt to hit the "templates" tab
  And I hit the "templates group sessions" tab
  And I hit the "templates group sessions 2" tab
  When create tester template    group sessions 2    Why Bill Tax 9000
  And create multiple occurrences
  And I hit the "schedules" tab
  Then page should contain multiple similiar group sessions
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Set count id
  ...           AND             Delete tester template    group sessions 2
  ...           AND             Go To    ${BASE URL}${INSTANCE}
  ...           AND             Temporarily reveal billing options
  ...           AND             Instance edit "Unselect Checkbox" on "Enable Group Billing"
  ...           AND             Click Button    commit
  ...           AND             Ajax wait
  ...           AND             Go To    ${BASE URL}${SCHEDULES}
  ...           AND             I select the "${_LOCATION 1}" location

Entire group session procedure - Complete a session, remove its template, then attempt to access it in the past
  [SETUP]    Setup for adding and removing
  Given I am on the "schedules" page
  And page should have    ${Gs remove name}
  When bypass edit the "${Gs remove name}" session
  And sign off and submit
  Then I hit the "past group sessions" tab
  And page should have    ${Gs remove name}
  When delete tester template    group sessions
  And I hit the "schedules" tab
  Then I hit the "past group sessions" tab
  And verify that viewing and editing works
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             I select the "My Locations" location
  ...           AND             Go To    ${BASE URL}${SCHEDULES}
  ...           AND             Run Keyword And Ignore Error    Return "${Gs remove name}" to upcoming group sessions
  ...           AND             Go To    ${BASE URL}${PAST GROUP SESSIONS}
  ...           AND             Run Keyword And Ignore Error    Dialog action    Click Element
  ...                           //a[.='${Gs remove name}']/../following-sibling::td[last()]/a[@data-method='delete']
  ...           AND             Run Keyword And Ignore Error    Delete tester template    group sessions
  ...           AND             Go To    ${BASE URL}${SCHEDULES}
  ...           AND             I select the "${_LOCATION 1}" location

*** Keywords ***
Setup group leader and session
  Set up first two patients for group sessions
  I hit the "schedules" tab
  Set Suite Variable    ${Current leader}    ${Admin First} ${Admin Last}
  ${name} =    Get Text    //a[contains(text(),'Living Skills:') and contains(@href,'/group_session_leaders')][1]
  Set Suite Variable    ${Gs name}    ${name}
  Loop deletion    Return "${Gs name}" to upcoming group sessions

Set up first two patients for group sessions
  :FOR    ${name}    IN    Adina    Peter
  \    Travel "slow" to "${name}" patients "admission" page in "${_LOCATION 1}"
  \    ${passes} =    Run Keyword And Return Status    Element Should Not Be Visible    //a[.='Residential Schedule']
  \    Run Keyword If    ${passes}    With this form "Residential Schedule" perform these actions "add"
  Return to mainpage

Create a seperate session
  ${cookie} =    Get Cookie    _session_id
  ${session} =    Create Dictionary   _session_id=${cookie.value}
  Create Session    gs    ${BASE URL}    verify=True    cookies=${session}

Check each view edit link
  Ajax wait
  ${view links} =    Collect type of links    //div[@id='past_group_sessions']/table/tbody/tr/td[1]/a    href
  ${edit links} =    Collect type of links    //div[@id='past_group_sessions']/table/tbody/tr/td[last()]/a[not(@data-method='delete')]
                     ...                      href
  ${links} =    Combine Lists    ${view links}    ${edit links}
  FOR    ${link}    IN    @{links}
      ${response} =    Run Keyword    ${link[1]} Request    gs    ${link[0]}
      ${response} =    Set Variable    ${response.text}
      Log    ${response}
      Run Keyword And Continue On Failure    Should Contain    ${response}    Past Group Sessions
  END
  ${passes} =    Run Keyword And Return Status    Click Element
                 ...                              //a[@class='ajax_browser_history' and contains(text(),'Next')]
  Run Keyword If    ${passes}    Check each view edit link
  ...               ELSE         Click Element    //a[@class='ajax_browser_history' and contains(text(),'First')]

I change the calendar to day "${day}"
  Click Element    //div[@id='change_group_session_date']/a
  Calendar select day "${day}"

The group sessions from day "${day}" is shown
  ${today} =    Get Current Date    result_format=%d
  ${zero} =    Set Variable If    ${day}>9    ${SPACE}    ${SPACE*2}
  ${date} =    Get Current Date    result_format=%b${zero}${day}, %Y
  ${date} =    Run Keyword If    '${today}'!='01'    Convert Date    ${date}    %A, ${date}\ \ (Past)    False
               ...                                   %b${zero}%d, %Y
               ...               ELSE                Convert Date    ${date}    Today,\ \ %A, ${date}    False
               ...                                   %b${zero}%d, %Y
  Page should have    ${date}    Upcoming Group Sessions    Group Sessions in Progress/Completed
  ...                 Group Sessions Pending Review

Changing group leader to someone else
  I hit the "Change group leader" view
  ${leader} =    Get Text    //select[@id='group_session_leader_group_leader_id']/option[1]
  Set Suite Variable    ${Current leader}    ${leader}
  Click Element    //div[@class='ui-dialog-buttonset']/button[.='Update']
  Ajax wait

Page should contain the "${leader}" assigned to the "${session}" session
  Element Should Contain    //a[contains(text(),'${session}')]/ancestor::tr[1]    ${leader}

Do an update
  Click Button    Update
  Ajax wait
  # Click Link    default=/group_session_leaders?date_filter=${Todays Date}

Checking attendance
  Set count id
  @{attendees} =    Get Webelements    //label[contains(@for,'group_session_leader_group_session_attendances_attributes_')]//h3/span
  @{search} =    Create List    nullnullnull    Peter    Adina
  @{actions} =    Create List    CRASH    x    o
  :FOR    ${attendant}    IN    @{attendees}
  \    ${attendant} =    Set Variable    ${attendant.get_attribute('innerHTML')}
  \    Run Keyword If    '@{search}[-1]' in '${attendant}'    Run Keywords    Form fill    gs leader form
  \    ...                                                                    patient:checkbox=@{actions}[-1]
  \    ...                                                    AND             Remove From List    ${search}    -1
  \    ...                                                    AND             Remove From List    ${actions}    -1
  \    Set count id    +1

Confirm patient "${patient}" is "${marked}" the list
  Run Keyword If    '${marked}'=='on'    Element Should Contain
  ...                                    //a[contains(text(),'${patient}')]/../following-sibling::td[1]//span    ☑
  ...               ELSE                 Element Should Contain
  ...                                    //a[contains(text(),'${patient}')]/../following-sibling::td[1]//span    ☐

Filling assessments
  Set count id
  @{attendees} =    Get Webelements    //label[contains(@for,'group_session_leader_group_session_attendances_attributes_')]//h3/span
  @{search} =    Create List    nullnullnull    Peter    Adina
  @{actions} =    Create List    CRASH    going to get evaluated    i will not join
  :FOR    ${attendant}    IN    @{attendees}
  \    ${attendant} =    Set Variable    ${attendant.get_attribute('innerHTML')}
  \    Run Keyword If    '@{search}[-1]' in '${attendant}'    Run Keywords    Form fill    gs leader form
  \    ...                                                                    assessment=@{actions}[-1]
  \    ...                                                    AND             Remove From List    ${search}    -1
  \    ...                                                    AND             Remove From List    ${actions}    -1
  \    Set count id    +1

Confirm assessment for "${patient}" has "${note}" written
  Element Should Contain    //a[contains(text(),'${patient}')]/../following-sibling::td[2]    ${note}

Deleting patient "${selection}"
  Dialog Action    Click Element    ${selection}/../following-sibling::div[@class='_10']/a

Adding the patients "${patients}"
  @{patients} =    Split String    ${patients}    ;
  :FOR    ${patient}    IN    @{patients}
  \    Search to add patient "${patient}"
  \    ${patient} =    The patient "${patient}" shown "can" be added
  \    Click Element At Coordinates    ${patient}    0    0
  Click Button    Add Selected
  Ajax wait

Search to add patient "${patient}"
  Run Keyword And Ignore Error    I hit the "Add ${Patient Handle}" view
  Input Text    //input[@class='select2-search__field']    ${patient}
  Ajax wait

The patient "${patient}" shown "${shown}" be added
  ${patient} =    Set Variable    //li[${CSS SELECT.replace('$CSS','select2-results__option')}]//p[contains(text(),'${patient}')]
  ${shown} =    Set Variable If    '${shown}'=='cannot'    Not${SPACE}    ${EMPTY}
  Run Keyword And Continue On Failure    Page Should ${shown}Contain Element    ${patient}
  [RETURN]    ${patient}

Changing group leader to "${leader}"
  Set Suite Variable    ${Current leader}    ${leader}
  I hit the "Change group leader" view
  Form fill    ${EMPTY}    group_session_leader_group_leader_id:direct_drop=${leader}
  # Click Button    //div[@id='group-leader-dialogs']//button[2]
  # Click Button    //html/body/div[11]/div[11]/div/button[2]
  Click Element    //div[@class='ui-dialog-buttonset']/button[.='Update']
  Ajax wait

Confirm that the group session is completed
  Page Should Contain Element    //a[contains(text(),'Living Skills:') and contains(@href,'/group_session_leaders')]/../following-sibling::td[contains(text(),'complete')]

Deleting this session
  Dialog Action    Click Element    //button[@id='open-signature-dialog']/../following-sibling::div[1]/a

Create nick named patients
  Go To    ${BASE URL}${INSTANCE}
  Instance edit "Select Checkbox" on "Show preferred name in sign in sheet"
  Return to mainpage
  I create a valid patient    mister    no    oreo    02/26/2018
  Update facesheet    preferred name=redbull
  Return to mainpage
  I create a valid patient    endless    no    name    02/26/2018
  Go To    ${BASE URL}${SCHEDULES}

Setup for matching times
  Go To    ${BASE URL}${TEMPLATES GROUP SESSIONS}
  ${title} =    Set Variable    Match Milk Move
  I select the "My Locations" location
  Create tester template    group sessions    ${title}
  Editing "group sessions" test template
  &{locations hit} =    Create dict for locations    ${_LOCATION 1};${_LOCATION 2};${_LOCATION 3};${_LOCATION 5}
  ${minutes} =    Get Current Date    result_format=%M
  ${minutes} =    Convert To Integer    ${minutes}
  ${offset} =    Evaluate    10 - max(0,${minutes}-49)
  Set Test Variable    ${Duration}    ${offset}
  # ${left start}    ${right start}    ${left end}    ${right end} =    Set Variable    11 AM    11    05 PM    55
  ${right start}    ${right end} =    Set Variable    ${minutes}    ${minutes+${offset}}
  ${day} =    Convert Date    ${Todays Date}    %A    False    %Y-%m-%d
  ${left start} =    Get Text    //select[@id='${GROUP SESSIONS FORM START TIME HR}']/option[@selected='selected']
  ${left end} =    Get Text    //select[@id='${GROUP SESSIONS FORM END TIME HR}']/option[@selected='selected']
  Form fill    group sessions form    enabled:checkbox=x    billable:checkbox=x    week day:dropdown=${day}
  ...          start time min:dropdown=${right start.__str__().zfill(2)}
  ...          end time min:dropdown=${right end.__str__().zfill(2)}    &{locations hit}
  Save "group sessions" template
  Go To    ${BASE URL}${SCHEDULES}
  I select the "${_LOCATION 1}" location
  Set Test Variable    ${Gs match name}    ${title}
  Set Test Variable    ${Left match start}    ${left start}
  Set Test Variable    ${Right match start}    ${right start.__str__().zfill(2)}
  Set Test Variable    ${Left match end}    ${left end}
  Set Test Variable    ${Right match end}    ${right end.__str__().zfill(2)}
  Set Test Variable    ${Match start}    ${Left match start.split()[0]}:${Right match start} ${Left match start.split()[1]}

Verify page is correct and add the test patient
  ${date} =    Convert Date    ${Todays Date}    %B %d, %Y    False    %Y-%m-%d
  Page should have    ${date} at    ${Match start}
  Page Should Contain Element    ${GS LEADER FORM SESSION START HR}/option[@selected='selected' and contains(text(),'${Left match start}')]
  Page Should Contain Element    ${GS LEADER FORM SESSION START MIN}/option[@selected='selected' and contains(text(),'${Right match start}')]
  Page Should Contain Element    ${GS LEADER FORM SESSION END HR}/option[@selected='selected' and contains(text(),'${Left match end}')]
  Page Should Contain Element    ${GS LEADER FORM SESSION END MIN}/option[@selected='selected' and contains(text(),'${Right match end}')]
  Adding the patients "${Test First}"

Modify patient "${patient}" participation starting from "${new start}" to "${new end}"
  ${left start}    ${right start} =    Split String    ${new start}    :
  ${left start}    ${right start} =    Set Variable    ${left start} ${right start.split()[1]}
                                       ...             ${right start.split()[0]}
  ${left end}    ${right end} =    Split String    ${new end}    :
  ${left end}    ${right end} =    Set Variable    ${left end} ${right end.split()[1]}    ${right end.split()[0]}
  ${session time} =    Set Variable    //*[contains(text(),'${patient}')]/ancestor::div[@class='fields']//select[contains(@id,'TIME')]
  Select From List By Label    ${session time.replace('TIME','_session_start_time_4i')}    ${left start}
  Select From List By Label    ${session time.replace('TIME','_session_start_time_5i')}    ${right start}
  Select From List By Label    ${session time.replace('TIME','_session_end_time_4i')}    ${left end}
  Select From List By Label    ${session time.replace('TIME','_session_end_time_5i')}    ${right end}
  Set Suite Variable    ${Actual start}    ${new start}
  Set Suite Variable    ${Actual end}    ${new end}

Sign off and submit
  # Click Button    Update
  Click Element    form_submit
  Ajax wait
  Click Button    Group leader sign off & submit
  Click Element    //canvas
  Click Button    Submit
  Ajax wait

Verify outside and inside chart summary for duration
  Verify for no bad page
  # Page should have    ${Actual start}    Duration: 1 hour and 11 minutes
  Run Keyword And Continue On Failure    Page should have    ${Actual start}    Duration: 10 minutes
  Click Element    //ul[@id='flowchart']//a
  Run Keyword And Continue On Failure    Page should have    ${Match start}    ${Actual start}    ${Actual end}    01:11

Setup for ending times
  Go To    ${BASE URL}${TEMPLATES GROUP SESSIONS}
  ${title 1} =    Set Variable    Accessing R Start
  ${title 2} =    Set Variable    Assessing R End
  Set Test Variable    ${Gs start name}    ${title 1}
  Set Test Variable    ${Gs end name}    ${title 2}
  @{titles} =    Create List    ${title 1}    ${title 2}
  @{times} =    Create List    11 AM;58;12 PM;45    12 PM;45;01 PM;00
  ${day} =    Convert Date    ${Todays Date}    %A    False    %Y-%m-%d
  :FOR    ${title}    ${time}    IN ZIP    ${titles}    ${times}
  \    ${start hr}    ${start min}    ${end hr}    ${end min} =    Split String    ${time}    ;
  \    Create tester template    group sessions    ${title}
  \    Editing "group sessions" test template
  \    &{locations hit} =    Create dict for locations    ${_LOCATION 1};${_LOCATION 2};${_LOCATION 3};${_LOCATION 5}
  \    Form fill    group sessions form    enabled:checkbox=x    billable:checkbox=x    week day:dropdown=${day}
  \    ...          start time hr:dropdown=${start hr}    start time min:dropdown=${start min}
  \    ...          end time hr:dropdown=${end hr}    end time min:dropdown=${end min}    &{locations hit}
  \    Save "group sessions" template
  Go To    ${BASE URL}${SCHEDULES}
  I select the "${_LOCATION 1}" location

Setup for group sessions two
  Go To    ${BASE URL}${INSTANCE}
  Temporarily reveal billing options
  Instance edit "Select Checkbox" on "Enable Billing Interface"
  Click Button    commit
  Ajax wait
  Go To    ${BASE URL}${SCHEDULES}

Create multiple occurrences
  Editing "gs/group sessions" test template
  &{locations hit} =    Create dict for locations    ${_LOCATION 1};${_LOCATION 2};${_LOCATION 3};${_LOCATION 5}
  ${day} =    Convert Date    ${Todays Date}    %A    False    %Y-%m-%d
  Repeat Keyword    4x    I hit the "Add Occurrence" view
  Form fill    group sessions 2 form    enabled:checkbox=x    &{locations hit}
  Set count id
  :FOR    ${hour}    IN    ${1}    ${2}    ${3}    ${4}
  \    ${start} =    Set Variable    ${hour.__str__().zfill(2)}
  \    ${end} =    Set Variable    ${${hour+1}.__str__().zfill(2)}
  \    Form fill    group sessions 2 form    week day:dropdown=${day}    start hr:dropdown=${start} AM
  \    ...          start min:dropdown=00    end hr:dropdown=${end} AM    end min:dropdown=00
  \    Set count id    +1
  Set count id
  Save "group sessions 2" template

Page should contain multiple similiar group sessions
  Page should have    ELEMENT|4x|//a[contains(text(),'Why Bill Tax 9000')]

Setup for adding and removing
  Set Test Variable    ${Gs remove name}    Much Parrilhada
  Go To    ${BASE URL}${TEMPLATES GROUP SESSIONS}
  Create tester template    group sessions    ${Gs remove name}
  Editing "group sessions" test template
  &{locations hit} =    Create dict for locations    ${_LOCATION 1};${_LOCATION 2};${_LOCATION 3};${_LOCATION 5}
  ${day} =    Convert Date    ${Todays Date}    %A    False    %Y-%m-%d
  Form fill    group sessions form    enabled:checkbox=x    billable:checkbox=x    week day:dropdown=${day}
  ...          start time hr:dropdown=01 AM    end time hr:dropdown=02 AM    &{locations hit}
  Save "group sessions" template
  Go To    ${BASE URL}${PAST GROUP SESSIONS}
  Loop deletion    Dialog action    Click Element
  ...              //a[.\='${Gs remove name}']/../following-sibling::td[last()]/a[@data-method\='delete']
  Go To    ${BASE URL}${SCHEDULES}
  I select the "${_LOCATION 1}" location
  Loop deletion    Return "${Gs remove name}" to upcoming group sessions

Verify that viewing and editing works
  Create a seperate session
  ${view links} =    Collect type of links    //a[.='${Gs remove name}']    href
  ${edit links} =    Collect type of links    //a[.='${Gs remove name}']/../following-sibling::td[last()]/a[not(@data-method='delete')]
                     ...                      href
  ${links} =    Combine Lists    ${view links}    ${edit links}
  FOR    ${link}    IN    @{links}
      ${response} =    Run Keyword    ${link[1]} Request    gs    ${link[0]}
      ${response} =    Set Variable    ${response.text}
      Log    ${response}
      Run Keyword And Continue On Failure    Should Contain    ${response}    Past Group Sessions
  END
