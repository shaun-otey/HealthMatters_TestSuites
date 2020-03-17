*** Settings ***
Documentation   Timezones test coverage.
...             Date/time fields:
...             Test creating and viewing with different locations set (patient's location and master location).
...             When creating they should either default to or populate when clicking "Now" the current time in the patient's time zone.
...             When viewing they should show the same time when user is set to the patient's location as they do when the user is set to "My Locations".
...             Date fields:
...             Check to ensure that date is correct when set under My Locations vs patient's location.
...             Especially because date field have midnight as the implied time so ensure that the date shows correctly at/past midnight
...
Default Tags    acceptance    ac001    longl
Resource        ../../suite.robot
Suite Setup     Run Keywords    Prepare tz items
...             AND             Set pseudo machine clock     -5
Suite Teardown  Run Keywords    Remove tz items
...                             Delete All Sessions
...                             Return to mainpage

# *** Variables ***
# ${TEST TZ}                        MIAMI
# ${MIAMI}                          25.7823907,-80.2996703 -5
# ${BOGOTA}                         4.6482836,-74.2482367 -5
# ${MID-ATLANTIC}                   37.7449602,-25.6959997 -2
# ${TIJUANA}                        32.4966814,-117.0882349 -8
# ${BERLIN}                         52.5065117,13.143869 +1

*** Test Cases ***
Patient integration - Pre admission
  [TAGS]    acceptance    ac001
  [TEMPLATE]    Go to patient ${id} and check pre admission date and time against the ${named} location
  1    ${_LOCATION ALT 2}
  1    ${_LOCATION ALT 3}
  1    ${_LOCATION ALT 5}
  2    ${_LOCATION ALT 2}
  2    ${_LOCATION ALT 3}
  2    ${_LOCATION ALT 5}
  3    ${_LOCATION ALT 2}
  3    ${_LOCATION ALT 3}
  3    ${_LOCATION ALT 5}

Patient integration - Facesheet
  [TAGS]    xxacceptance    ac001xx    seven more    hasprint    testmetzcompare
  [TEMPLATE]    Go to patient ${id} and check facesheet date and time against the ${named} location
  tester    ${_LOCATION 1}
  1         ${_LOCATION ALT 2}
  1         ${_LOCATION ALT 3}
  1         ${_LOCATION ALT 5}

Patient integration - Consents
  [TAGS]    acceptance    ac001    five more    refactorme
  [SETUP]    Basic consent forms setup
  [TEMPLATE]    Go to patient ${id} and check consents date and time against the ${named} location
  tester    ${_LOCATION 1}
  1         ${_LOCATION ALT 2}
  1         ${_LOCATION ALT 3}
  1         ${_LOCATION ALT 5}
  2         ${_LOCATION ALT 2}
  2         ${_LOCATION ALT 3}
  2         ${_LOCATION ALT 5}
  3         ${_LOCATION ALT 2}
  3         ${_LOCATION ALT 3}
  3         ${_LOCATION ALT 5}
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Delete tester template    consent forms
  ...           AND             Return to mainpage

Patient integration - Evaluations
  [TAGS]    acceptance    ac001    unknown more    refactorme
  [SETUP]    Basic evaluations setup
  [TEMPLATE]    Go to patient ${id} and check evaluations date and time against the ${named} location
  tester    ${_LOCATION 1}
  1         ${_LOCATION ALT 2}
  1         ${_LOCATION ALT 3}
  1         ${_LOCATION ALT 5}
  2         ${_LOCATION ALT 2}
  2         ${_LOCATION ALT 3}
  2         ${_LOCATION ALT 5}
  3         ${_LOCATION ALT 2}
  3         ${_LOCATION ALT 3}
  3         ${_LOCATION ALT 5}
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Delete tester template    evaluations
  ...           AND             Return to mainpage

Patient integration - Recurring assessments
  [TAGS]    xxacceptance    ac001xx    weird    testmetzcompare
  [SETUP]    Basic recurring assessments setup
  [TEMPLATE]    Go to patient ${id} and check recurring assessments date and time against the ${named} location
  tester    ${_LOCATION 1}
  1         ${_LOCATION ALT 2}
  1         ${_LOCATION ALT 3}
  1         ${_LOCATION ALT 5}
  2         ${_LOCATION ALT 2}
  2         ${_LOCATION ALT 3}
  2         ${_LOCATION ALT 5}
  3         ${_LOCATION ALT 2}
  3         ${_LOCATION ALT 3}
  3         ${_LOCATION ALT 5}
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Delete tester template    evaluations
  ...           AND             Return to mainpage

Patient integration - Doctors order
  [TAGS]    xxacceptance    ac001    fifteen more    testmetznownow
  [TEMPLATE]    Go to patient ${id} and check doctors order date and time against the ${named} location
  tester    ${_LOCATION 1}
  1         ${_LOCATION ALT 2}
  1         ${_LOCATION ALT 3}
  1         ${_LOCATION ALT 5}
  2         ${_LOCATION ALT 2}
  2         ${_LOCATION ALT 3}
  2         ${_LOCATION ALT 5}
  3         ${_LOCATION ALT 2}
  3         ${_LOCATION ALT 3}
  3         ${_LOCATION ALT 5}

Patient integration - Group sessions
  [TAGS]    acceptance    ac001    three more maybe    issue    testmetzcompare
  [SETUP]    Basic group sessions setup
  Go to and check group sessions date and time against the locations
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Go To    ${BASE URL}${TEMPLATES GROUP SESSIONS}
  ...           AND             Loop deletion    Delete a group sessions template    ${Gs name}
  ...           AND             Return to mainpage

Patient integration - Appointments
  [TAGS]    xxacceptance    ac001    issue
  [TEMPLATE]    Go to patient ${id} and check appointments date and time against the ${named} location
  tester    ${_LOCATION 1}
  1         ${_LOCATION ALT 2}
  1         ${_LOCATION ALT 3}
  1         ${_LOCATION ALT 5}
  2         ${_LOCATION ALT 2}
  2         ${_LOCATION ALT 3}
  2         ${_LOCATION ALT 5}
  3         ${_LOCATION ALT 2}
  3         ${_LOCATION ALT 3}
  3         ${_LOCATION ALT 5}

Patient integration - Chart summary
  # [SETUP]    Run Keywords    Travel "fast" to "@{Tz patients}[2]" patients "medical orders" page in "@{Tz locations}[2]"
  # ...        AND             Create a medication order    meds=lighthaded colada    s date=08/15/2017
  # ...        AND             Travel "fast" to "@{Tz patients}[0]" patients "medical orders" page in "My Locations"
  # ...        AND             Create a medication order    meds=alot tacos    s date=08/15/2017
  [TAGS]    acceptance    ac001    issue
  [TEMPLATE]    Go to patient ${id} and check chart summary date and time against the ${named} location
  tester    ${_LOCATION 1}
  1         ${_LOCATION ALT 2}
  1         ${_LOCATION ALT 3}
  1         ${_LOCATION ALT 5}
  2         ${_LOCATION ALT 2}
  2         ${_LOCATION ALT 3}
  2         ${_LOCATION ALT 5}
  3         ${_LOCATION ALT 2}
  3         ${_LOCATION ALT 3}
  3         ${_LOCATION ALT 5}

Patient integration - Phi log
  [TAGS]    tznono
  [TEMPLATE]    Go to patient ${id} and check phi log date and time against the ${named} location

Patient integration - Golden thread
  [TAGS]    xxacceptance    ac001    broken
  [TEMPLATE]    Go to patient ${id} and check golden thread date and time against the ${named} location
  tester    ${_LOCATION 1}
  1         ${_LOCATION ALT 2}
  1         ${_LOCATION ALT 3}
  1         ${_LOCATION ALT 5}
  2         ${_LOCATION ALT 2}
  2         ${_LOCATION ALT 3}
  2         ${_LOCATION ALT 5}
  3         ${_LOCATION ALT 2}
  3         ${_LOCATION ALT 3}
  3         ${_LOCATION ALT 5}

Patient integration - Lab
  [TAGS]    tznono
  [TEMPLATE]    Go to patient ${id} and check lab date and time against the ${named} location

Admission and discharge date
  [TAGS]    xxacceptance    ac001    compare2chk
  [TEMPLATE]    Go to patient ${id} and modify the ${admit} date in ${named} location
  tester    admission    ${_LOCATION 1}
  tester    discharge    ${_LOCATION 1}
  1         admission    ${_LOCATION ALT 2}
  1         discharge    ${_LOCATION ALT 2}
  1         admission    ${_LOCATION ALT 3}
  1         discharge    ${_LOCATION ALT 3}
  1         admission    ${_LOCATION ALT 5}
  1         discharge    ${_LOCATION ALT 5}
  2         admission    ${_LOCATION ALT 2}
  2         discharge    ${_LOCATION ALT 2}
  2         admission    ${_LOCATION ALT 3}
  2         discharge    ${_LOCATION ALT 3}
  2         admission    ${_LOCATION ALT 5}
  2         discharge    ${_LOCATION ALT 5}
  3         admission    ${_LOCATION ALT 2}
  3         discharge    ${_LOCATION ALT 2}
  3         admission    ${_LOCATION ALT 3}
  3         discharge    ${_LOCATION ALT 3}
  3         admission    ${_LOCATION ALT 5}
  3         discharge    ${_LOCATION ALT 5}

Patient count
  [TAGS]    acceptance    ac001
  Given I am on the "patients" page
  And I record the timezone census
  When checking for each tz patients admission date
  Then the correct census will be based of the master instance timezone

Timestamps - Forms
  [TAGS]    tzfacility
Reports - Midnight admission date
  [TAGS]    tzfirsttests
Returning patient to a sibling facility
  [TAGS]    tzfirsttests
  Wait Until Page Contains    Your Account Settings    1 day
  # Given patient is discharged
  # When patient returns to a new location
  # Then ...
Viewing single and multiple patients
  [TAGS]    tzfirsttests
  Given I hit the "dashboard" tab
  When I select the "${_LOCATION 1}" location
  And verify ...
  And I select the "My Locations" location
  Then verify ...
Verify incoming patients at midnight
  [TAGS]    tzfirsttests
  Given I am on the "patients" page
  When ...
  Then ...

Facility level - Shift note
  [TAGS]    acceptance    ac001    one more    testmetzpushedup
  [TEMPLATE]    Go to patient ${id} and check shift note date and time against the ${named} location
  tester    ${_LOCATION 1}
  1         ${_LOCATION ALT 2}
  1         ${_LOCATION ALT 3}
  1         ${_LOCATION ALT 5}
  2         ${_LOCATION ALT 2}
  2         ${_LOCATION ALT 3}
  2         ${_LOCATION ALT 5}
  3         ${_LOCATION ALT 2}
  3         ${_LOCATION ALT 3}
  3         ${_LOCATION ALT 5}

Facility level - Dashboard
  [TAGS]    tznonodash
  [TEMPLATE]    Go to patient ${id} and check dashboard date and time against the ${named} location
  tester    ${_LOCATION 1}
  # 1         ${_LOCATION ALT 2}
  # 1         ${_LOCATION ALT 3}
  # 1         ${_LOCATION ALT 5}

Facility level - Patient landing page
  [TAGS]    xxacceptance    ac001    hasprint    issue
  [TEMPLATE]    Go to patient ${id} and check patients landing page date and time against the ${named} location
  tester    ${_LOCATION 1}
  1         ${_LOCATION ALT 2}
  1         ${_LOCATION ALT 3}
  1         ${_LOCATION ALT 5}
  2         ${_LOCATION ALT 2}
  2         ${_LOCATION ALT 3}
  2         ${_LOCATION ALT 5}
  3         ${_LOCATION ALT 2}
  3         ${_LOCATION ALT 3}
  3         ${_LOCATION ALT 5}

Facility level - Occupancy
  [TAGS]    unknown check
  [SETUP]    Basic occupancy building setup
  [TEMPLATE]    Go to patient ${id} and check occupancy date and time against the ${named} location
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Return to mainpage
  ...           AND             Remove building
  ...           AND             Return to mainpage

# Facility level - Schedule
#   [TAGS]    testmetz
#   [TEMPLATE]    Go to patient ${id} and check schedule date and time against the ${named} location
#   Already done in Patient integration - Group sessions / Appointments

Facility level - Reports created
  [TAGS]    acceptance    ac001    one more
  [TEMPLATE]    Go to and check reports created date and time against the ${named} location
  ${_LOCATION 1}
  ${_LOCATION ALT 2}
  ${_LOCATION ALT 3}
  ${_LOCATION ALT 5}

Facility level - Users
  [TAGS]    acceptance    ac001    one more    hasprint    comparerdy
  [SETUP]    Run Keywords    Exit system    ${false}
  ...        AND             Start login    ${CURRENT USER}    ${CURRENT PASS}
  [TEMPLATE]    Go to patient ${id} and check users date and time against the ${named} location
  tester    ${_LOCATION 1}
  1         ${_LOCATION ALT 2}
  1         ${_LOCATION ALT 3}
  1         ${_LOCATION ALT 5}
  2         ${_LOCATION ALT 2}
  2         ${_LOCATION ALT 3}
  2         ${_LOCATION ALT 5}
  3         ${_LOCATION ALT 2}
  3         ${_LOCATION ALT 3}
  3         ${_LOCATION ALT 5}

Facility level - Restore
  [TAGS]    xxacceptance    ac001    two more    broken
  [TEMPLATE]    Go to patient ${id} and check restore date and time against the ${named} location
  tester    ${_LOCATION 1}
  1         ${_LOCATION ALT 2}
  1         ${_LOCATION ALT 3}
  1         ${_LOCATION ALT 5}
  2         ${_LOCATION ALT 2}
  2         ${_LOCATION ALT 3}
  2         ${_LOCATION ALT 5}
  3         ${_LOCATION ALT 2}
  3         ${_LOCATION ALT 3}
  3         ${_LOCATION ALT 5}

Facility level - User menu
  [TAGS]    xxacceptance    ac001    two more
  [SETUP]    Basic user menu setup
  [TEMPLATE]    Go to patient ${id} and check user menu date and time against the ${named} location
  1         ${_LOCATION ALT 2}
  1         ${_LOCATION ALT 3}
  1         ${_LOCATION ALT 5}
  2         ${_LOCATION ALT 2}
  2         ${_LOCATION ALT 3}
  2         ${_LOCATION ALT 5}
  3         ${_LOCATION ALT 2}
  3         ${_LOCATION ALT 3}
  3         ${_LOCATION ALT 5}
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Switch Browser    2
  ...           AND             Exit system
  ...           AND             Switch Browser    1
  ...           AND             Return to mainpage

*** Keywords ***
Prepare tz items
  I hit the "username" tab
  Form fill    new user    view user stamps:checkbox=x
  Click Button    Update
  Ajax wait
  Return to mainpage
  I select the "My Locations" location
  ${non tz census} =    Get Text    //span[contains(text(),'Census')]
  ${TRASH}    ${non tz census}    @{TRASH} =    Split String    ${non tz census}
  Set Suite Variable    ${Non tz census}    ${${non tz census}}
  ${date} =    Convert Date    ${Todays Date}    result_format=%m/%d/%Y
  ${date m} =    Add Time To Date    ${Todays Date}    1 day    result_format=%m/%d/%Y
  # @{data} =    Create List    Before Night Amid ${date} 12:00 PM|${EMPTY}
  #              ...            After Night Bmid ${date} 12:00 PM|${EMPTY}
  #              ...            During Night Cmid ${date} 12:00 PM|${EMPTY}
  @{data} =    Create List
               ...            Before Night Amid ${date} 08:55 PM|${EMPTY}
               # ...            After Night Bmid ${date} 02:55 AM|${EMPTY}
               ...            After Night Bmid ${date m} 02:55 AM|${EMPTY}
               ...            During Night Cmid ${date} 12:00 AM|${EMPTY}
               # ...            Example Night Dmid ${date} 09:00 PM|${EMPTY}
               # ...            Pender Night Emid ${EMPTY}|${EMPTY}
               # ...            During Night Cmid ${date} 12:00 PM|${EMPTY}
  # After Night Bmid ${date} 02:55 AM|${EMPTY}
  ${single} =    Set Variable    ${data}
  @{data} =    Create List    ${data}
  ${l cnt} =    Get Length    ${Tz Locations}
  Repeat Keyword    ${l cnt-1}    Append To List    ${data}    ${single}
  @{tz patients} =    Create List    ${EMPTY}
  Set Suite Variable    ${Tz patients}    ${tz patients}
  :FOR    ${list}    ${location}    IN ZIP    ${data}    ${Tz Locations}
  \    Repeat patient additions    ${list}    ${location}    ${date}
  Remove From List    ${Tz patients}    0
  Set Suite Variable    ${Tz patients}    ${Tz patients}

Repeat patient additions
  [ARGUMENTS]    ${list}    ${location}    ${date}
  I select the "${location}" location
  :FOR    ${l}    IN    @{list}
  \    @{name}    ${total dates} =    Split String    ${l}    max_split=3
  \    @{split dates} =    Split String    ${total dates}    |
  \    I create a valid patient    @{name}    ${date}
  \    Append To List    ${Tz patients}    ${Current Id}
  \    Set Suite Variable    ${Tz patients}    ${Tz patients}
  \    Run Keyword If    '@{name}[0]'!='Pender'    Update facesheet    admission date:js=@{split dates}[0]
  \    ...                                         discharge date:js=@{split dates}[1]
  \    ...               ELSE                      Update facesheet    admission date:js=@{split dates}[0]
  \    ...                                         discharge date:js=@{split dates}[1]
  \    ...                                         validation type=failing
  \    Return to mainpage

Remove tz items
  Return to mainpage
  @{locations} =    Create List    ${EMPTY}
  ${p cnt} =    Get Length    ${Tz patients}
  ${l cnt} =    Get Length    ${Tz Locations}
  ${count} =    Evaluate    ${p cnt} / ${l cnt}
  ${count} =    Convert To Integer    ${count}
  :FOR    ${location}    IN    @{Tz locations}
  \    Repeat Keyword    ${count} times    Append To List    ${locations}    ${location}
  Remove From List    ${locations}    0
  :FOR    ${id}    ${location}    IN ZIP    ${Tz patients}    ${locations}
  \    I select the "${location}" location
  \    Go To    ${BASE URL}${PATIENTS}/${id}/edit
  \    Dialog action    Click Link    delete
  \    Wait Until Page Contains    Notice
  I select the "${_LOCATION 1}" location
  I hit the "username" tab
  Form fill    new user    view user stamps:checkbox=o
  Click Button    Update
  Ajax wait


Set pseudo machine clock
  [ARGUMENTS]    ${machine gmt}=null    ${simulated time}=null
  Gtz << Setup api
  ${true gmt} =    Evaluate    (time.timezone if (time.localtime().tm_isdst == 0) else time.altzone) / 60 / 60 * -1
                   ...         time
  ${true gmt} =    Convert To Integer    ${true gmt}
  Run Keyword If    '${machine gmt}'!='null'    Set Suite Variable    ${Machine gmt}    ${machine gmt}
  ...               ELSE                        Set Suite Variable    ${Machine gmt}    ${true gmt}
  Set Suite Variable    ${Change in time}    ${0}
  ${shift} =    Run Keyword If    '${machine gmt}'!='null'    Evaluate    ${machine gmt}-${true gmt}
                ...               ELSE                        Set Variable    0
  @{shift time} =    Create List    ${shift} hours    0 sec
  Run Keyword And Return If    '${simulated time}'=='null'    Set Suite Variable    ${Shift time}    ${shift time}
  ${modified date} =    Add Time To Date    ${true date}    ${shift}    %m/%d/%Y %I:%M %p    False    %m/%d/%Y %I:%M %p
  ${shift} =    Subtract Date From Date    ${true date.split()[0]} ${simulated time}    ${modified date}    verbose
  ...           date1_format=%m/%d/%Y %I:%M %p    date2_format=%m/%d/%Y %I:%M %p
  Set List Value    ${shift time}    1    ${shift}
  Set Suite Variable    ${Shift time}    ${shift time}

Log flowchart info and return patient id
  [ARGUMENTS]    ${id}    ${named}
  Log    Verifying ${TEST NAME} with ${id} within ${named}    console=True
  Return to mainpage
  ${id} =    Select shifted patient    ${id}    ${named}
  [RETURN]    ${id}

Select shifted patient
  [ARGUMENTS]    ${patient}    ${location}=null
  Return From Keyword If    '${patient}'=='tester'    tester
  ${p cnt} =    Get Length    ${Tz patients}
  ${l cnt} =    Get Length    ${Tz locations}
  ${locations} =    Get Dictionary Keys    ${Tz Locations}
  ${location} =    Get Index From List    ${locations}    ${location}
  ${patient} =    Evaluate    (${patient}-1) + ((${p cnt}/${l cnt})*${location})
  ${patient} =    Convert To Integer    ${patient}
  [RETURN]    @{Tz patients}[${patient}]


Get the date now
  [ARGUMENTS]    ${date field}    ${shift}
  ${all shift} =    Add Time To Time    @{shift}[0]    @{shift}[1]    verbose
  Click Element    ${date field}
  Wait Until Element Is Visible    //button[@data-handler='today']
  # Slow wait
  Click Element    //button[@data-handler='today']
  ${default date} =    Execute Javascript    return document.getElementById("${date field}").value
  ${default date} =    Add Time To Date    ${default date}    @{shift}[1]    %m/%d/%Y %I:%M %p    False
                       ...                 %m/%d/%Y %I:%M %p
  ${current date} =    Get Current Date    increment=${all shift}    result_format=%m/%d/%Y %I:%M %p
  # Form fill    ${EMPTY}    ${date field}:direct_js=${default date}
  Custom screenshot
  Click Element    //button[@data-handler='hide']
  # Blur element    ${date field}
  [RETURN]    ${default date};${current date}

Get the datetime
  [ARGUMENTS]    ${date}    ${time}    ${shift}    ${date format}=%A, %b %d, %Y    ${time format}=%I:%M %p %Z
  Custom screenshot
  ${all shift} =    Add Time To Time    @{shift}[0]    @{shift}[1]    verbose
  ${date} =    Get Text    ${date}
  # ${date} =    Strip String    ${date}
  ${date} =    Get Line    ${date.strip(' \t\n\r')}    0
  ${date} =    Convert Date    ${date}    %m/%d/%Y    False    ${date format}
  ${time} =    Get Text    ${time}
  # ${time} =    Strip String    ${time}
  ${time} =    Get Line    ${time.strip(' \t\n\r')}    0
  ${time} =    Convert Date    ${time}    %m/%d/%Y    False    ${time format}
  ####??????????????????
  ${default date} =    Get Current Date    increment=@{shift}[1]    result_format=%m/%d/%Y 12:00 AM
  ${current date} =    Add Time To Date    ${default date}    ${all shift}    %m/%d/%Y 12:00 AM    False
                       ...                 %m/%d/%Y %I:%M %p
  Form fill    ${EMPTY}    ${date field}:direct_js=${default date.split()[0]}
  ####??????????????????
  [RETURN]    ${default date};${current date}

Get the timestamp
  [ARGUMENTS]    ${date field}    ${shift}    ${filter}=nullnullnull
  Custom screenshot
  ${all shift} =    Add Time To Time    @{shift}[0]    @{shift}[1]    verbose
  ${passes} =    Run Keyword And Return Status    Should Not Contain    ${filter}    nullnullnull
  ${filter} =    Run Keyword If    ${passes}    Set Variable    ${filter}
                 ...               ELSE         Create List    ${EMPTY}
  Run Keyword And Ignore Error    I hit the "Time stamps" view
  ${stamped date} =    Get Text    ${date field}
  ${stamped date} =    Get Lines Containing String    ${stamped date}    @{filter}[0]
  ${stamped date} =    Remove String    ${stamped date}    @{filter}
  ${stamped date} =    Line parser    ${stamped date}    0
  ${stamped date} =    Add Time To Date    ${stamped date}    @{shift}[1]    %m/%d/%Y %I:%M %p    False
                       ...                 %m/%d/%Y %I:%M %p
  ${current date} =    Get Current Date    increment=${all shift}    result_format=%m/%d/%Y %I:%M %p
  [RETURN]    ${stamped date};${current date}

Get the comparison dates
  #### TRY MY LOCATIONS, OTHERWISE, SHIFT BACK TO MACHINE TIME
  [ARGUMENTS]    ${date field}    ${format}    ${base location}    ${compare location}    ${shift}
  # # ${all shift} =    Add Time To Time    @{shift}[0]    @{shift}[1]    verbose
  # I select the "${base location}" location
  # Custom screenshot
  # ${date} =    Get Text    ${date field}
  # ${date} =    Get Line    ${date.strip(' \t\n\r')}    0
  # # @{dated} =    Run Keyword And Ignore Error    Line parser    ${date}    1
  # # ${date} =    Run Keyword If    '@{dated}[0]'=='PASS'    Set Variable    @{dated}[1]
  # #              ...               ELSE                     Line parser    ${date}    0
  # ${remove} =    Fetch From Right    ${date}    M${SPACE}
  # ${date} =    Remove String    ${date}    ${SPACE}${remove}
  # # ${current date} =    Add Time To Date    ${date}    ${all shift}    %m/%d/%Y %I:%M %p    False    ${format}
  # ${current date} =    Add Time To Date    ${date}    @{shift}[1]    %m/%d/%Y %I:%M %p    False    ${format}
  # I select the "${compare location}" location
  # Custom screenshot
  # ${date} =    Get Text    ${date field}
  # ${date} =    Get Line    ${date.strip(' \t\n\r')}    0
  # # @{dated} =    Run Keyword And Ignore Error    Line parser    ${date}    1
  # # ${date} =    Run Keyword If    '@{dated}[0]'=='PASS'    Set Variable    @{dated}[1]
  # #              ...               ELSE                     Line parser    ${date}    0
  # ${remove} =    Fetch From Right    ${date}    M${SPACE}
  # ${date} =    Remove String    ${date}    ${SPACE}${remove}
  # ${changed date} =    Add Time To Date    ${date}    @{shift}[1]    %m/%d/%Y %I:%M %p    False    ${format}
  @{compare dates} =    Create List
  :FOR    ${location}    IN    ${base location}    ${compare location}
  \    I select the "${location}" location
  \    Custom screenshot
  \    ${date} =    Get Text    ${date field}
  \    ${date} =    Get Line    ${date.strip(' \t\n\r')}    0
  \    ${remove} =    Fetch From Right    ${date}    M${SPACE}
  \    ${date} =    Remove String    ${date}    ${SPACE}${remove}
  \    ${date} =    Add Time To Date    ${date}    @{shift}[1]    %m/%d/%Y %I:%M %p    False    ${format}
  \    Append To List    ${compare dates}    ${date}
  [RETURN]    @{compare dates}[1];@{compare dates}[0]

Get the named timezone
  [ARGUMENTS]    ${shift}
  ${all shift} =    Add Time To Time    @{shift}[0]    @{shift}[1]    verbose
  ${timestamp} =    Get Current Date    local    ${all shift}    epoch
  ${tznamed} =    Get Text    //div[@class='currentLeft']/div[@class='location']
  ${passes} =    Run Keyword And Return Status    Dictionary Should Contain Key    ${Tz Locations}    ${tznamed}
  ${tz} =    Run Keyword If    ${passes}    Get From Dictionary    ${Tz Locations}    ${tznamed}
             ...               ELSE         Set Variable    ${${TEST TZ}}
  ${tz} =    Gtz << Call gtz    ${timestamp}    ${tz}
  ${tznamed date} =    Add Time To Date    ${timestamp}    ${tz-${Machine gmt}} hours    %m/%d/%Y %I:%M %p    False
                       ...                 epoch
  [RETURN]    ${tznamed date}


Do time checks
  [ARGUMENTS]    ${dates group}    ${named}    ${err}=300
  ${passes} =    Run Keyword And Return Status    Dictionary Should Contain Key    ${Tz Locations}    ${named}
  ${their tz} =    Run Keyword If    ${passes}    Get From Dictionary    ${Tz Locations}    ${named}
                   ...               ELSE         Set Variable    ${${TEST TZ}}
  :FOR    ${dates}    IN    @{dates group}
  \    ${instance date}    ${current date} =    Split String    ${dates}    ;
  \    Run Keyword And Continue On Failure    Adjust for correct time    ${instance date}    ${current date}
  \    ...                                    ${their tz}    err seconds=${err}

Adjust for correct time
  [ARGUMENTS]    ${instance time}    ${current time}    ${now tz}    ${master tz}=${Machine gmt}
  ...            ${change in time}=${Change in time}    ${err seconds}=60
  ${instance time} =    Convert Date    ${instance time}    epoch    False    %m/%d/%Y %I:%M %p
  ${now tz} =    Gtz << Call gtz    ${instance time}    ${now tz}
  ${added time} =    Set Variable    ${change in time*3600}
  ${change in time} =    Evaluate    ${change in time}+${now tz}-${master tz}
  ${current time} =    Add Time To Date    ${current time}    ${change in time} hours    epoch    False
                       ...                 %m/%d/%Y %I:%M %p
  Should Be True    ${instance time+${added time}}<=${current time}<=${instance time+${added time}+${err seconds}}


Go to patient ${id} and check pre admission date and time against the ${named} location
  ${id} =    Log flowchart info and return patient id    ${id}    ${named}
  # ${dates group} =    Create List
  Travel "fast" to "${id}" patients "information" page in "${named}"
  @{filter} =    Create List    last updated at    by ${Admin First} ${Admin Last}
  ${dates} =    Get the timestamp    //h2[contains(text(),'Payment Method')]/following-sibling::div[@class='user_stamps']/span
                ...                  ${Shift time}    ${filter}
  # Append To List    ${dates group}    ${dates}
  ${dates group} =    Create List    ${dates}
  Do time checks    ${dates group}    ${named}


Go to patient ${id} and check facesheet date and time against the ${named} location
  ${id} =    Log flowchart info and return patient id    ${id}    ${named}
  ${dates group} =    Create List
  :FOR    ${test}    IN
  ...     timestamp    utilization review    notes    urgent issues    messages    vob getter    add insurance
  ...     pdf packages    case file    kis transfer    statuses    birthday    sobriety date
  ...     insurance subscriber birthdate    allergies onset
  \    Log    Facesheet ${test}    console=True
  \    ${dates} =    Run Keyword And Continue On Failure    Facesheet ${test}    ${id}    ${named}
  \    Continue For Loop If    '${dates}'=='null' or '${dates}'=='None'
  \    Append To List    ${dates group}    ${dates}
  Do time checks    ${dates group}    ${named}

Facesheet timestamp
  [ARGUMENTS]    ${id}    ${named}
  Travel "fast" to "${id}" patients "information" page in "${named}"
  @{filter} =    Create List    last updated at    by ${Admin First} ${Admin Last}
  ${dates} =    Get the timestamp    //h2[contains(text(),'Payment Method')]/following-sibling::div[@class='user_stamps']/span
                ...                  ${Shift time}    ${filter}
  [RETURN]    ${dates}

Facesheet utilization review
  [ARGUMENTS]    ${id}    ${named}
  ${dates} =    Set Variable    null
  [RETURN]    ${dates}

Facesheet notes
  [ARGUMENTS]    ${id}    ${named}
  Travel "fast" to "${id}" patients "information" page in "${named}"
  Create a "notes" with "We ate at WAWA"
  Reload Page
  @{filter} =    Create List    ${Admin First} ${Admin Last},
  ${dates} =    Get the timestamp    //p[contains(text(),'We ate at WAWA')]/preceding-sibling::span[1]
                ...                  ${Shift time}    ${filter}
  [RETURN]    ${dates}

Facesheet urgent issues
  [ARGUMENTS]    ${id}    ${named}
  Travel "fast" to "${id}" patients "information" page in "${named}"
  Create a "urgent issue" with "Wake up early for gas"
  Reload Page
  @{filter} =    Create List    Issue created by ${Admin First} ${Admin Last},
  ${dates} =    Get the timestamp    //p[contains(text(),'Wake up early for gas')]/preceding-sibling::span[1]
                ...                  ${Shift time}    ${filter}
  [RETURN]    ${dates}

Facesheet messages
  [ARGUMENTS]    ${id}    ${named}
  ${dates} =    Set Variable    null
  [RETURN]    ${dates}

Facesheet vob getter
  [ARGUMENTS]    ${id}    ${named}
  ${dates} =    Set Variable    null
  [RETURN]    ${dates}

Facesheet add insurance
  [ARGUMENTS]    ${id}    ${named}
  ${dates} =    Set Variable    null
  [RETURN]    ${dates}

Facesheet pdf packages
  [ARGUMENTS]    ${id}    ${named}
  ${dates} =    Set Variable    null
  [RETURN]    ${dates}

Facesheet case file
  [ARGUMENTS]    ${id}    ${named}
  ${dates} =    Set Variable    null
  [RETURN]    ${dates}

Facesheet kis transfer
  [ARGUMENTS]    ${id}    ${named}
  ${dates} =    Set Variable    null
  [RETURN]    ${dates}

Facesheet statuses
  [ARGUMENTS]    ${id}    ${named}
  ${dates} =    Set Variable    null
  [RETURN]    ${dates}
  # [TEMPLATE]    Go to patient ${id} and check against the ${named} location
  # Travel "fast" to "${id}" patients "information" page in "${named}"
  Travel "slow" to "${id}" patients "facesheet" page in "${named}"
  # I hit the "Edit ${Patient Handle}" view
  Click Link    Add Commitment
  Ajax wait
  Form fill    patient facesheet    commitment:dropdown=90 days commitment
  ${date field} =    Set Variable    ${PATIENT FACESHEET COMMIT START DATE}
  ${dates} =    Get the timestamp    ${date field}    ${Shift time}
  Click Button    patient[auto_submit]
  Ajax wait
  Give a "passing" facesheet validation
  I hit the "Show Facesheet" view
  # [RETURN]    ${dates}
  # Run Keyword If    '${tab}'=='Facesheet'       Run Keywords    Travel "fast" to "${id}" patients "information" page in "My Locations"
  # ...                                           AND             I hit the "Edit ${Patient Handle}" view
  # ...                                           AND             Prelim steps    ${type}
  # ...    ELSE IF    '${tab}'=='Appointments'    Travel "slow" to "${id}" patients "${tab}" page in "${name}"
  # ...    ELSE IF    '${tab}'=='Timestamps'      Travel "fast" to "${id}" patients "information" page in "${name}"
  # ...               ELSE                        Travel "fast" to "${id}" patients "${tab}" page in "${name}"
  # ${dates} =    Run Keyword If    ${tab.find('medical orders')}==0    Create a doctor order    medication    ${Shift time}
  #               ...    ELSE IF    ${type.find('Vital')}==0            Adding vitals log    live now    ${Shift time}
  #               ...    ELSE IF    ${type.find('Glucose')}==0          Adding glucose log    live now    ${Shift time}
  #               ...    ELSE IF    ${type.find('Weight')}==0           Adding weight log    live now    ${Shift time}
  #               ...    ELSE IF    ${tab.find('Facesheet')}==0         Get the datetime    ${date field}    ${Shift time}
  #               ...    ELSE IF    ${tab.find('Timestamps')}==0        Get the timestamp    ${date field}    ${Shift time}
  #               ...               ELSE                                Get the date now    ${date field}    ${Shift time}
  # # Run Keyword If    Chart Summary    Click Element    //button[@type='submit']
  # Run Keyword If    ${tab.find('Facesheet')}==0     Run Keywords    Click Button    patient[auto_submit]
  # ...                                               AND             Ajax wait
  # ...                                               AND             Give a "passing" facesheet validation
  # ...                                               AND             I hit the "Show Facesheet" view
  # ...                                               AND             Set Test Variable    ${Err}    60
  # ...    ELSE IF    ${tab.find('Timestamps')}==0    Set Test Variable    ${Err}    300
  # ...               ELSE                            Set Test Variable    ${Err}    60
  # # I select the "${name}" location
  # ${local date}    ${current date} =    Split String    ${dates}    ;
  # Ajax wait
  # ${passes} =    Run Keyword And Return Status    Dictionary Should Contain Key    ${Tz locations}    ${name}
  # ${their tz} =    Run Keyword If    ${passes}    Get From Dictionary    ${Tz locations}    ${name}
  #                  ...               ELSE         Set Variable    ${${TEST TZ}}
  # Adjust for correct time    ${local date}    ${current date}    ${their tz}    err seconds=${Err}

Facesheet birthday
  [ARGUMENTS]    ${id}    ${named}
  ${dates} =    Set Variable    null
  [RETURN]    ${dates}
  Travel "slow" to "${id}" patients "facesheet" page in "${named}"
  ${date field} =    Set Variable    ${PATIENT FACESHEET DOB}
  ${dates} =    Get the timestamp    ${date field}    ${Shift time}
  Click Button    patient[auto_submit]
  Ajax wait
  Give a "passing" facesheet validation
  I hit the "Show Facesheet" view
  # [RETURN]    ${dates}
  # [TEMPLATE]    Go to patient ${id} and check against the ${named} location

Facesheet sobriety date
  [ARGUMENTS]    ${id}    ${named}
  ${dates} =    Set Variable    null
  [RETURN]    ${dates}
  Travel "slow" to "${id}" patients "facesheet" page in "${named}"
  ${date field} =    Set Variable    ${PATIENT FACESHEET SOBRIETY DATE}
  ${dates} =    Get the timestamp    ${date field}    ${Shift time}
  Click Button    patient[auto_submit]
  Ajax wait
  Give a "passing" facesheet validation
  I hit the "Show Facesheet" view
  # [RETURN]    ${dates}
  # [TEMPLATE]    Go to patient ${id} and check against the ${named} location

Facesheet insurance subscriber birthdate
  [ARGUMENTS]    ${id}    ${named}
  ${dates} =    Set Variable    null
  [RETURN]    ${dates}
  Travel "slow" to "${id}" patients "facesheet" page in "${named}"
  ${date field} =    Set Variable    ${PATIENT FACESHEET SUBSCRIBER DOB}
  ${dates} =    Get the timestamp    ${date field}    ${Shift time}
  Click Button    patient[auto_submit]
  Ajax wait
  Give a "passing" facesheet validation
  I hit the "Show Facesheet" view
  # [RETURN]    ${dates}
  # [TEMPLATE]    Go to patient ${id} and check against the ${named} location

Facesheet allergies onset
  [ARGUMENTS]    ${id}    ${named}
  ${dates} =    Set Variable    null
  [RETURN]    ${dates}
  Travel "slow" to "${id}" patients "facesheet" page in "${named}"
  ${date field} =    Set Variable    ${PATIENT FACESHEET ONSET}
  ${dates} =    Get the timestamp    ${date field}    ${Shift time}
  Click Button    patient[auto_submit]
  Ajax wait
  Give a "passing" facesheet validation
  I hit the "Show Facesheet" view
  # [RETURN]    ${dates}
  # [TEMPLATE]    Go to patient ${id} and check against the ${named} location


Go to patient ${id} and check consents date and time against the ${named} location
  ${id} =    Log flowchart info and return patient id    ${id}    ${named}
  ${dates group} =    Create List
  :FOR    ${test}    IN    timestamp    patient sig    guarantor sig    guardian sig    user sig    sig revocation
  \    Log    Consents ${test}    console=True
  \    ${dates} =    Run Keyword And Continue On Failure    Consents ${test}    ${id}    ${named}
  \    Continue For Loop If    '${dates}'=='null' or '${dates}'=='None'
  \    Append To List    ${dates group}    ${dates}
  Do time checks    ${dates group}    ${named}

Basic consent forms setup
  Go To    ${BASE URL}${TEMPLATES}
  Create tester template    consent forms    Timezones Flowchart
  Editing "consent forms" test template
  Form fill    consent forms form    patient process:dropdown=Admission    enabled:checkbox=x
  ...          patient sig req:checkbox=x    allow revocation:checkbox=x    rules:dropdown=Only if patient is male
  Run Keyword If    ${_LOCATIONS ACTIVE}    Form fill    consent forms form    all locations:checkbox=x
  Save "consent forms" template

Consents timestamp
  [ARGUMENTS]    ${id}    ${named}
  ${dates} =    Set Variable    null
  [RETURN]    ${dates}

Consents patient sig
  [ARGUMENTS]    ${id}    ${named}
  Travel "fast" to "${id}" patients "information" page in "${named}"
  ${filter} =    Get Text    //h2[contains(text(),'${Patient Handle.title()} Information')]/following-sibling::div[1]/p[1]
  ${filter} =    Strip String    ${filter}
  I hit the "admission" patient tab
  With this form "Timezones Flowchart" perform these actions "add;view"
  Click Button    Sign & submit
  Ajax wait
  Click Element    //canvas
  Click Button    Submit
  Ajax wait
  I hit the "Timezones Flowchart" text
  @{filter} =    Create List    ${filter},
  ${dates} =    Get the timestamp    //span[@class='border_top ']   ${Shift time}    ${filter}
  [RETURN]    ${dates}

Consents guarantor sig
  [ARGUMENTS]    ${id}    ${named}
  ${dates} =    Set Variable    null
  [RETURN]    ${dates}

Consents guardian sig
  [ARGUMENTS]    ${id}    ${named}
  ${dates} =    Set Variable    null
  [RETURN]    ${dates}

Consents user sig
  [ARGUMENTS]    ${id}    ${named}
  ${dates} =    Set Variable    null
  [RETURN]    ${dates}

Consents sig revocation
  [ARGUMENTS]    ${id}    ${named}
  ${dates} =    Set Variable    null
  [RETURN]    ${dates}


Go to patient ${id} and check evaluations date and time against the ${named} location
  ${id} =    Log flowchart info and return patient id    ${id}    ${named}
  ${dates group} =    Create List
  ${date field group} =    Create List
                          #  ...            patient_evaluation_eval_timestamps_attributes_0_timestamp
                          #  ...            //input[@id='patient_evaluation_evaluation_date' and ${CSS SELECT.replace('$CSS','datepicker')}]
                          #  ...            //input[@id='patient_evaluation_evaluation_date' and ${CSS SELECT.replace('$CSS','datetimepicker')}]
                           ...            patient_evaluation_start_time
                           ...            patient_evaluation_end_time
                           ...            patient_evaluation_eval_timestamps_attributes_1_timestamp
                           ...            patient_evaluation_eval_timestamps_attributes_2_timestamp
                           ...            patient_evaluation_eval_timestamps_attributes_3_timestamp
  Travel "fast" to "${id}" patients "nursing" page in "${named}"
  With this form "Timezones Flowchart" perform these actions "add;view"
  :FOR    ${index}    ${field}    IN ENUMERATE    @{date field group}
  \    ${dates} =    Run Keyword If    ${index}<0    Get the datetime    ${field}    ${Shift time}
  \                  ...               ELSE          Get the date now    ${field}    ${Shift time}
  \    Click Button    Update
  \    Ajax wait
  \    Append To List    ${dates group}    ${dates}
  # Click Button    validate_patient_evaluation_fields
  # Ajax wait
  # Click Element    //span[contains(text(),'Preview/print view')]
  Do time checks    ${dates group}    ${named}

Basic evaluations setup
  Go To    ${BASE URL}${TEMPLATES EVALUATIONS}
  Create tester template    evaluations    Timezones Flowchart
  Editing "evaluations" test template
  Form fill    evaluations form    enabled:checkbox=x    patient process:dropdown=Nursing    patient sig:checkbox=x
  Run Keyword If    ${_LOCATIONS ACTIVE}    Form fill    evaluations form    all locations:checkbox=x
  Create timezone evaluations
  Save "evaluations" template

Create timezone evaluations
  :FOR    ${index}    ${item}    IN ENUMERATE
  ...     date stamp;datestamp    evaluation date;evaluation_date    eval date time;evaluation_datetime
  ...     eval start end;evaluation_start_and_end_time    admission date time;patient.admission_datetime
  ...     discharge date time;patient.discharge_datetime    time stamp;timestamp
  # Evaluation date evaluation field type
  # Datestamp evaluation field type
  # Care team evaluation field type
  # UR and Clinical LOC evaluation field types
  # Toggle MARs generation field type
  # Treatment plan objective statuses (treatment plan item and treatment plan objective evaluation field)
  \    Run Keyword If    ${index}>0    Run Keywords    Set count id    +1
  \    ...                             AND             Click Link    Add item
  \    ...                             AND             Ajax wait
  \    ...               ELSE          Add eval item
  \    ${label}    ${type} =    Split String    ${item}    ;
  \    Form fill    evaluations form    item name=tz ${index+1}    item label=${label}
  \    ...          item field type:dropdown=${type}


Go to patient ${id} and check recurring assessments date and time against the ${named} location
  ${id} =    Log flowchart info and return patient id    ${id}    ${named}
  ${dates group} =    Create List
  # Travel "fast" to "${id}" patients "information" page in "${named}"
  # I hit the "Edit ${Patient Handle}" view
  Travel "slow" to "${id}" patients "facesheet" page in "${named}"
  Select Checkbox    //label[contains(text(),'Timezones Flowchart Re')]/following-sibling::input
  Update facesheet    enable recurring:checkbox=x
  I hit the "recurring assessments" patient tab
  With this form "Timezones Flowchart Re${SPACE*2}- previous interval" perform these actions "add"
  With this form "Timezones Flowchart Re${SPACE*2}- next interval" perform these actions "add"
  # Sleep    300
  # I hit the "Timezones Flowchart Glucose" text
  # I hit the "New glucose entry" text
  # Click Element    //*[@id="patient_evaluation_form"]/div/div/a
  # ${dates} =    Adding glucose log    live now    ${Shift time}
  Append To List    ${dates group}    ${dates}
  Do time checks    ${dates group}    ${named}

Basic recurring assessments setup
  Go To    ${BASE URL}${TEMPLATES EVALUATIONS}
  Create tester template    evaluations    Timezones Flowchart Re
  Editing "evaluations" test template
  Form fill    evaluations form    enabled:checkbox=x    patient process:dropdown=Recurring Assessments
  ...          recurring:checkbox=x    daily start t hr:dropdown=08 AM    interval in min=30
  Form fill    evaluations form    eval content:dropdown=Notes/Logs
  Click Button    Ok
  Run Keyword If    ${_LOCATIONS ACTIVE}    Form fill    evaluations form    all locations:checkbox=x
  Add eval item
  Form fill    evaluations form    item name=Glucose    item field type:dropdown=patient.glucose_log
  Save "evaluations" template


Go to patient ${id} and check doctors order date and time against the ${named} location
  ${id} =    Log flowchart info and return patient id    ${id}    ${named}
  ${dates group} =    Create List
  # :FOR    ${test}    IN
  # ...     mars schedule times
  :FOR    ${index}    ${test}    IN ENUMERATE
  ...     standard order    manual order    entering orders    reviewing orders    dc orders    dc review orders
  ...     mars vital sign time    vital signs    mars height time    mars weight time    height weight
  ...     mars glucose time    glucose    action orders    mars action orders    lab orders    mars reflection of order
  ...     mars schedule times    mars yes medication administered    mars no medication administered
  ...     mars patient signature    mars first response    mars note    mars prn default time    mars prn administered
  ...     mars prn note    mars prn first response
  \    Log    Doctors order ${test}    console=True
  \    ${dates} =    Run Keyword And Continue On Failure    Doctors order ${test}    ${id}    ${named}
  \    Continue For Loop If    '${dates}'=='null' or '${dates}'=='None'
  \    Append To List    ${dates group}    ${dates}
  Do time checks    ${dates group}    ${named}    1200

Doctors order standard order
  [ARGUMENTS]    ${id}    ${named}
  @{filter} =    Create List    ${Admin First[:1]}${Admin Last[:1]}
  Travel "fast" to "${id}" patients "medical orders" page in "${named}"
  I am on the "medical orders" patient page
  I hit the "Add standard order" text
  I hit the "PRNs" text
  Click Element    //div[@id='dialog-modal-orders-addorder']//tr[@class='orders_prn'][1]/td[2]
  ${text} =    Get Text    //div[@id='dialog-modal-orders-addorder']//tr[@class='orders_prn'][1]/td[2]//span
  # Form fill    add order    ordered by=QA Doc    via:dropdown=fax
  Doctor "add" ordered by "QA Doc" via "fax"
  Click Element    //span[.='Submit']
  Ajax wait
  ${date field} =    Set Variable    //a[contains(text(),'${text}')]/ancestor::td[1]/following-sibling::td[1]/div
  ${dates} =    Get the timestamp    ${date field}    ${Shift time}    ${filter}
  [RETURN]    ${dates}

Doctors order manual order
  [ARGUMENTS]    ${id}    ${named}
  Travel "fast" to "${id}" patients "medical orders" page in "${named}"
  I am on the "medical orders" patient page
  ${dates} =    Create a doctor order    medication    live now    ${Shift time}
  ## DEFAULTING BY 15 MIN INTERVALS
  [RETURN]    ${dates}

Doctors order entering orders
  [ARGUMENTS]    ${id}    ${named}
  @{filter} =    Create List    ${Admin First[:1]}${Admin Last[:1]}
  Travel "fast" to "${id}" patients "medical orders" page in "${named}"
  I am on the "medical orders" patient page
  ${text} =    Create a doctor order    medication
  ${date field} =    Set Variable    //a[contains(text(),'${text}')]/ancestor::td[1]/following-sibling::td[1]/div
  ${dates} =    Get the timestamp    ${date field}    ${Shift time}    ${filter}
  [RETURN]    ${dates}

Doctors order reviewing orders
  [ARGUMENTS]    ${id}    ${named}
  ${dates} =    Set Variable    null
  [RETURN]    ${dates}

Doctors order dc orders
  [ARGUMENTS]    ${id}    ${named}
  @{filter} =    Create List    Stop:
  Travel "fast" to "${id}" patients "medical orders" page in "${named}"
  I am on the "medical orders" patient page
  I hit the "Discontinue orders" text
  Click Element    //div[@id='dialog-modal-discontinue-discontinueorder']//tr[1]/td[2]
  ${text} =    Get Text    //div[@id='dialog-modal-discontinue-discontinueorder']//tr[1]/td[2]//span
  # Form fill    add order    dc ordered by=QA Doc    dc via:dropdown=fax
  Doctor "dc" ordered by "QA Doc" via "fax"
  Click Element    //span[.='Submit']
  ${date field} =    Set Variable    //a[contains(text(),'${text}')]/ancestor::td[1]/following-sibling::td[1]/div
  ${dates} =    Get the timestamp    ${date field}    ${Shift time}    ${filter}
  [RETURN]    ${dates}

Doctors order dc review orders
  [ARGUMENTS]    ${id}    ${named}
  ${dates} =    Set Variable    null
  [RETURN]    ${dates}

Doctors order vital signs
  [ARGUMENTS]    ${id}    ${named}
  Travel "fast" to "${id}" patients "medical orders" page in "${named}"
  I am on the "medical orders" patient page
  ${date field} =    Set Variable    //div[@id='vital_signs_refresh']//td[@class='vital_signs_data_title']/following-sibling::td[1]
  ${dates} =    Get the timestamp    ${date field}    ${Shift time}
  [RETURN]    ${dates}

Doctors order height weight
  [ARGUMENTS]    ${id}    ${named}
  Travel "fast" to "${id}" patients "medical orders" page in "${named}"
  I am on the "medical orders" patient page
  ${date field} =    Set Variable    //div[@id='weight_refresh']//td[@class='vital_signs_data_title']/following-sibling::td[1]
  ${dates} =    Get the timestamp    ${date field}    ${Shift time}
  [RETURN]    ${dates}

Doctors order glucose
  [ARGUMENTS]    ${id}    ${named}
  Travel "fast" to "${id}" patients "medical orders" page in "${named}"
  I am on the "medical orders" patient page
  ${date field} =    Set Variable    //div[@id='glucose_log_refresh']//td[@class='vital_signs_data_title']/following-sibling::td[1]
  ${dates} =    Get the timestamp    ${date field}    ${Shift time}
  [RETURN]    ${dates}

Doctors order action orders
  [ARGUMENTS]    ${id}    ${named}
  Travel "fast" to "${id}" patients "medical orders" page in "${named}"
  I am on the "medical orders" patient page
  ${dates} =    Create a doctor order    action    live now    ${Shift time}
  [RETURN]    ${dates}

Doctors order lab orders
  [ARGUMENTS]    ${id}    ${named}
  ${dates} =    Set Variable    null
  [RETURN]    ${dates}

Doctors order mars reflection of order
  [ARGUMENTS]    ${id}    ${named}
  ${dates} =    Set Variable    null
  [RETURN]    ${dates}

Doctors order mars schedule times
  [ARGUMENTS]    ${id}    ${named}
  Travel "fast" to "${id}" patients "medical orders" page in "${named}"
  I am on the "medical orders" patient page
  ${text} =    Create a doctor order    medication    meds=sched type
  Travel "fast" to "${id}" patients "record med log" page in "${named}"
  ${date} =    Set Variable    //div[@class='content_limited_width']//li[1]/a
  ${time} =    Set Variable    //div[@class='content_limited_width']//li[1]//tbody/tr[2]/td[@style='width: 10%;']
  # ${date field} =    Set Variable    //div[@id='glucose_log_refresh']//td[@class='vital_signs_data_title']/following-sibling::td[1]
  ${dates} =    Get the datetime    ${date}    ${time}    ${Shift time}
  [RETURN]    ${dates}

Doctors order mars yes medication administered
  [ARGUMENTS]    ${id}    ${named}
  ${dates} =    Set Variable    workon
  ${dates} =    Set Variable    null
  [RETURN]    ${dates}

Doctors order mars no medication administered
  [ARGUMENTS]    ${id}    ${named}
  ${dates} =    Set Variable    workon
  ${dates} =    Set Variable    null
  [RETURN]    ${dates}

Doctors order mars patient signature
  [ARGUMENTS]    ${id}    ${named}
  ${dates} =    Set Variable    workon
  ${dates} =    Set Variable    null
  [RETURN]    ${dates}

Doctors order mars first response
  [ARGUMENTS]    ${id}    ${named}
  ${dates} =    Set Variable    workon
  ${dates} =    Set Variable    null
  [RETURN]    ${dates}

Doctors order mars note
  [ARGUMENTS]    ${id}    ${named}
  ${dates} =    Set Variable    workon
  ${dates} =    Set Variable    null
  [RETURN]    ${dates}

Doctors order mars vital sign time
  [ARGUMENTS]    ${id}    ${named}
  Travel "fast" to "${id}" patients "med log" page in "${named}"
  I am on the "med log" patient page
  ${dates} =    Adding vitals log    live now    ${Shift time}
  [RETURN]    ${dates}

Doctors order mars glucose time
  [ARGUMENTS]    ${id}    ${named}
  Travel "fast" to "${id}" patients "med log" page in "${named}"
  I am on the "med log" patient page
  ${dates} =    Adding glucose log    live now    ${Shift time}
  [RETURN]    ${dates}

Doctors order mars height time
  [ARGUMENTS]    ${id}    ${named}
  ${dates} =    Set Variable    null
  [RETURN]    ${dates}

Doctors order mars weight time
  [ARGUMENTS]    ${id}    ${named}
  Travel "fast" to "${id}" patients "med log" page in "${named}"
  I am on the "med log" patient page
  ${dates} =    Adding weight log    live now    ${Shift time}
  [RETURN]    ${dates}

Doctors order mars prn default time
  [ARGUMENTS]    ${id}    ${named}
  ${dates} =    Set Variable    workon
  ${dates} =    Set Variable    null
  [RETURN]    ${dates}

Doctors order mars prn administered
  [ARGUMENTS]    ${id}    ${named}
  ${dates} =    Set Variable    workon
  ${dates} =    Set Variable    null
  [RETURN]    ${dates}

Doctors order mars prn note
  [ARGUMENTS]    ${id}    ${named}
  ${dates} =    Set Variable    workon
  ${dates} =    Set Variable    null
  [RETURN]    ${dates}

Doctors order mars prn first response
  [ARGUMENTS]    ${id}    ${named}
  ${dates} =    Set Variable    workon
  ${dates} =    Set Variable    null
  [RETURN]    ${dates}

Doctors order mars action orders
  [ARGUMENTS]    ${id}    ${named}
  ${dates} =    Set Variable    workon
  ${dates} =    Set Variable    null
  [RETURN]    ${dates}


Go to and check group sessions date and time against the locations
  Log To Console    Verifying ${TEST NAME} with each test locations
  Log    Verifying ${TEST NAME} with each test locations
  I hit the "schedules" tab
  I am on the "schedules" page
  :FOR    ${test}    IN    group schedule time    group leader signature    review signature
  # ...     group schedule time    group start and end time    group leader signature    review signature
  # ...     change date to yesterday and check time
  \    Log    Group sessions ${test}    console=True
  \    Run Keyword And Continue On Failure    Group sessions ${test}

Basic group sessions setup
  Go To    ${BASE URL}${TEMPLATES GROUP SESSIONS}
  I hit the "New Group Session" view
  Set Test Variable    ${Gs name}    Back to timezones
  Form fill    group sessions form    title=${Gs name}    session type:dropdown=Standard Group
  Click Button    Create Session
  ${day} =    Convert Date    ${Todays Date}    result_format=%A
  &{locations hit} =    Create dict for locations    ${_LOCATION 1};${_LOCATION ALT 2};${_LOCATION ALT 3};${_LOCATION ALT 5}
  Form fill    group sessions form    enabled:checkbox=x    billable:checkbox=x    week day:dropdown=${day}
  ...          start time hr:dropdown=12 AM    start time min:dropdown=00    end time hr:dropdown=11 PM
  ...          end time min:dropdown=59    &{locations hit}
  Click Button    Save
  Ajax wait
  Click Link    ${TEMPLATES GROUP SESSIONS}
  Page Should Contain    Back to timezones

Group sessions group schedule time
  @{names} =    Get Dictionary Keys    ${Tz locations}
  ${dates group} =    Create List    0
  ${date field} =    Set Variable    //div[@id='group_session_detail']/h1
  ${format} =    Set Variable    %B %d, %Y at %I:%M %p
  I select the "My Locations" location
  I hit the "${Gs name}" view
  # \    ${dates} =    Get the comparison dates    ${date field}    ${format}    ${_LOCATION 1}    ${tznamed}
  # \                  ...                         ${Shift time}
  :FOR    ${tznamed}    IN    @{names}
  \    ${dates} =    Get the comparison dates    ${date field}    ${format}    My Locations    ${tznamed}
  \                  ...                         ${Shift time}
  \    Set List Value    ${dates group}    0    ${dates}
  \    Run Keyword And Continue On Failure    Do time checks    ${dates group}    ${tznamed}
  [TEARDOWN]    Run Keywords    Go To    ${BASE URL}${SCHEDULES}
  ...           AND             I select the "My Locations" location
  ...           AND             Loop deletion    Return "${Gs name}" to upcoming group sessions

# Group sessions group start and end time
#   @{names} =    Get Dictionary Keys    ${Tz locations}
#   I select the "My Locations" location
#   I hit the "${Gs name}" view
#   Custom screenshot
#   :FOR    ${tznamed}    IN    @{names}
#   \    I select the "${tznamed}" location
#   \    Ajax wait
#   \    Custom screenshot
#   [TEARDOWN]    Run Keywords    Go To    ${BASE URL}${SCHEDULES}
#   ...           AND             I select the "My Locations" location
#   ...           AND             Run Keyword And Ignore Error    Return "${Gs name}" to upcoming group sessions

Group sessions group leader signature
  @{names} =    Get Dictionary Keys    ${Tz locations}
  ${dates group} =    Create List    0
  @{filter} =    Create List    ${Admin First} ${Admin Last},
  :FOR    ${named}    IN    ${_LOCATION 1}    @{names}
  \    I hit the "schedules" tab
  \    Loop deletion    Return "${Gs name}" to upcoming group sessions
  \    I select the "${named}" location
  \    I hit the "${Gs name}" view
  \    Click Button    sig
  \    Ajax wait
  \    Click Element    //canvas
  \    Click Button    Submit
  \    Ajax wait
  \    I hit the "${Gs name}" view
  \    ${dates} =    Get the timestamp    //div[@id='group_session']/span[@class='border_top ']    ${Shift time}    ${filter}
  \    Set List Value    ${dates group}    0    ${dates}
  \    Run Keyword And Continue On Failure    Do time checks    ${dates group}    ${named}
  [TEARDOWN]    Run Keywords    Go To    ${BASE URL}${SCHEDULES}
  ...           AND             I select the "My Locations" location
  ...           AND             Loop deletion    Return "${Gs name}" to upcoming group sessions

Group sessions review signature
  No Operation

# Group sessions change date to yesterday and check time
#   ${day} =    Subtract Time From Date    ${Todays Date}    1 day    %d    False    %Y-%m-%d
#   Click Element    //div[@id='change_group_session_date']/a
#   Calendar select day "${day.lstrip('0')}"
#   Group sessions group schedule time


Go to patient ${id} and check appointments date and time against the ${named} location
  ${id} =    Log flowchart info and return patient id    ${id}    ${named}
  Travel "fast" to "${id}" patients "information" page in "${named}"
  ${patient} =    Get Text    //h2[contains(text(),'${Patient Handle.title()} Information')]/following-sibling::div[1]/p[1]
  Go To    ${BASE URL}${CALENDAR}
  I am on the "calendar" page
  Slow wait
  Click Element    //button[${CSS SELECT.replace('$CSS','fc-agendaWeek-button')}]
  Slow wait
  Click Element    //button[${CSS SELECT.replace('$CSS','fc-today-button')}]
  Slow wait
  Click Element    //td[@class='fc-widget-content'][1]
  Ajax wait
  ${provider} =    Get Text    //ul[@id='schedulers_list']/li[1]
  Form fill    new appointment     providers:enter_text=${provider}    patients:enter_text=${patient.split()[0]}
  ${dates start search} =    Get the date now    ${NEW APPOINTMENT START DATE TIME}    ${Shift time}
  ${dates end search} =    Add thirty to appointment    ${dates start search}
  @{dates group} =    Create List    ${dates start search}    ${dates end search}
  Run Keyword And Ignore Error    Click Element    ${NEW APPOINTMENT}/div[@class='modal-footer']/button[@type='submit']
  Ajax wait
  Run Keyword And Ignore Error    Click Button    save-anyway
  Slow wait
  Travel "slow" to "${id}" patients "appointments" page in "null"
  :FOR    ${search date}    IN    ${NEW APPOINTMENT SEARCH S DATE TIME}    ${NEW APPOINTMENT SEARCH E DATE TIME}
  \    ${dates} =    Get the date now    ${search date}    ${Shift time}
  \    Append To List    ${dates group}    ${dates}
  ${dates start search} =    Subtract Time From Date    ${dates start search.split(';')[0]}    5 minutes
                             ...                        %m/%d/%Y %I:%M %p    False    %m/%d/%Y %I:%M %p
  ${dates end search} =    Add Time To Date    ${dates end search.split(';')[0]}    5 minutes    %m/%d/%Y %I:%M %p
                           ...                 False    %m/%d/%Y %I:%M %p
  Form fill    new appointment    search s date time:js=${dates start search}
  ...                             search e date time:js=${dates end search}
  Custom screenshot
  Click Element    //button[@type='submit']
  Ajax wait
  Run Keyword And Continue On Failure    Page Should Contain Element    //div[@id='appointments_table']//table
  Do time checks    ${dates group}    ${named}

Add thirty to appointment
  [ARGUMENTS]    ${dates}
  ${TRASH}    ${current date} =    Split String    ${dates}    ;
  ${default date} =    Execute Javascript    return document.getElementById("${NEW APPOINTMENT END DATE TIME}").value
  ${current date} =    Add Time To Date    ${current date}    30 minutes    %m/%d/%Y %I:%M %p    False
                       ...                 %m/%d/%Y %I:%M %p
  [RETURN]    ${default date};${current date}


Go to patient ${id} and check chart summary date and time against the ${named} location
  ${id} =    Log flowchart info and return patient id    ${id}    ${named}
  ${dates group} =    Create List
  :FOR    ${test}    IN    start datetime    end datetime
  \    Log    Chart summary ${test}    console=True
  \    ${dates} =    Run Keyword And Continue On Failure    Chart summary ${test}    ${id}    ${named}
  \    Continue For Loop If    '${dates}'=='null' or '${dates}'=='None'
  \    Append To List    ${dates group}    ${dates}
  Do time checks    ${dates group}    ${named}

Chart summary start datetime
  [ARGUMENTS]    ${id}    ${named}
  Travel "fast" to "${id}" patients "chart summary" page in "${named}"
  ${dates} =    Get the date now    appt-start-date    ${Shift time}
  [RETURN]    ${dates}

Chart summary end datetime
  [ARGUMENTS]    ${id}    ${named}
  Travel "fast" to "${id}" patients "chart summary" page in "${named}"
  ${dates} =    Get the date now    appt-end-date    ${Shift time}
  [RETURN]    ${dates}


Go to patient ${id} and check phi log date and time against the ${named} location
  ${id} =    Log flowchart info and return patient id    ${id}    ${named}
  ${dates group} =    Create List
  Travel "fast" to "${id}" patients "disclosure log" page in "${named}"
  Click Element    addphi
  ?...patient_phi_date_disclosure
  Append To List    ${dates group}    ${dates}
  ?...patient_phi_date_requested
  Append To List    ${dates group}    ${dates}
  Click Button    Submit
  ?...
  Do time checks    ${dates group}    ${named}


Go to patient ${id} and check golden thread date and time against the ${named} location
  ${id} =    Log flowchart info and return patient id    ${id}    ${named}
  Basic golden thread setup    ${id}    ${named}
  ${dates group} =    Create List
  :FOR    ${test}    IN    signatures    notes
  \    Log    Golden thread ${test}    console=True
  \    @{dates} =    Run Keyword And Continue On Failure    Golden thread ${test}    ${id}    ${named}
  \    Continue For Loop If    '@{dates}[0]'=='null' or '@{dates}[0]'=='None'
  \    Append To List    ${dates group}    @{dates}
  Do time checks    ${dates group}    ${named}

Basic golden thread setup
  [ARGUMENTS]    ${id}    ${named}
  Travel "fast" to "${id}" patients "treatment plans" page in "${named}"
  Adding a golden thread form
  ${date} =    Get the named timezone    ${Shift time}
  Set Test Variable    ${Established date}    ${date}
  Form fill    golden thread    date of services:js=${date.split()[0]}
  Click Element    //i[${CSS SELECT.replace('$CSS','glyphicon-list')}]
  Ajax wait
  Click Element    //div[contains(text(),'Occupational Problems')]
  Click Button    Submit
  Ajax wait
  Page Should Contain    Behavioral Definition/As evidenced by (Optional)
  Click Element    validate_patient_evaluation_fields
  Ajax wait
  Page should have    Notice    Validated: no errors
  I hit the "Screens & Assessments" text

Golden thread signatures
  [ARGUMENTS]    ${id}    ${named}
  @{dates} =    Create List
  @{filter} =    Create List    ${Admin First} ${Admin Last},
  ${sig spot} =    Set Variable    //div[@id='show_patient_evaluation']/div[1]/div[@class='wrap']
  :FOR    ${signing}    IN    Sign & Submit    Review sign submit
  \    With this form "Problem List" perform these actions "edit"
  \    I hit the "${signing}" text
  \    Ajax wait
  \    Click Element    //canvas
  \    Click Button    Submit
  \    Ajax wait
  I hit the "Problem List" text
  :FOR    ${index}    IN RANGE    1    3
  \    ${date} =    Get the timestamp    ${sig spot}\[${index}]/span    ${Shift time}    ${filter}
  \    Append To List    ${dates}    ${date}
  I hit the "Treatment Plans" patient tab
  Adding a golden thread form    Treatment Plan
  Form fill    golden thread    date of services:js=${Established date.split()[0]}
  Click Element    validate_patient_evaluation_fields
  Ajax wait
  Page should have    Notice    Validated: no errors
  I hit the "Treatment Plan" text
  :FOR    ${signing}    IN    Client signature    Sign & Submit    Review sign submit
  \    Click Element    //a[contains(text(),'Treatment Plan') and contains(text(),'${Established date.split()[0]}')]/../following-sibling::td[last()]//a[2]
  \    I hit the "${signing}" text
  \    Ajax wait
  \    Click Element    //canvas
  \    Click Button    Submit
  \    Ajax wait
  I hit the "Information" text
  ${patient filter} =    Get Text    //h2[contains(text(),'${Patient Handle.title()} Information')]/following-sibling::div[1]/p[1]
  ${patient filter} =    Strip String    ${patient filter}
  @{patient filter} =    Create List    ${patient filter},
  I hit the "Treatment Plans" patient tab
  Click Element    //a[contains(text(),'Treatment Plan') and contains(text(),'${Established date.split()[0]}')]
  ${date} =    Get the timestamp    ${sig spot}\[1]/div/span    ${Shift time}    ${patient filter}
  Append To List    ${dates}    ${date}
  :FOR    ${index}    IN RANGE    2    4
  \    ${date} =    Get the timestamp    ${sig spot}\[${index}]/span    ${Shift time}    ${filter}
  \    Append To List    ${dates}    ${date}
  [RETURN]    ${dates}

Golden thread notes
  [ARGUMENTS]    ${id}    ${named}
  @{dates} =    Create List    null
  [RETURN]    ${dates}


Go to patient ${id} and check lab date and time against the ${named} location
  Log To Console    Verifying ${TEST NAME} with ${id} within ${named}
  Log    Verifying ${TEST NAME} with ${id} within ${named}
  Return to mainpage
  Set count id
  # ${date field group} =    Create List    //div[@class='user_stamps']/span
  # ${id} =    Select shifted patient    ${id}    1
  # ${dates group} =    Create List
  ...
  Do time checks    ${dates group}    ${named}


Go to patient ${id} and modify the ${admit} date in ${named} location
  ${id} =    Log flowchart info and return patient id    ${id}    ${named}
  Travel "slow" to "${id}" patients "facesheet" page in "${named}"
  ${dates} =    Change the "${admit}" date
  ${dates group} =    Create List    ${dates}
  Do time checks    ${dates group}    ${named}
  # [TEARDOWN]    Set Suite Variable    ${Change in time}    0

Change the "${admit}" date
  ${change in time} =    Set Variable If    '${admit}'=='discharge'    ${30}    ${-1}
  ${current date} =    Get Current Date    increment=${change in time} hours    result_format=%m/%d/%Y %I:%M %p
  ${advanced date} =    Get the named timezone    ${Shift time}
  ${advanced date} =    Add Time To Date    ${advanced date}    ${change in time} hours    %m/%d/%Y %I:%M %p    False
                        ...                 %m/%d/%Y %I:%M %p
  Run Keyword If    '${admit}'=='admission'    Update facesheet    admission date=${advanced date}
  ...               ELSE                       Update facesheet    discharge date=${advanced date}
  I hit the "Show Facesheet" view
  I am on the "information" patient page
  ${advanced date} =    Run Keyword If    '${admit}'=='admission'    Get Text
                        ...                                          //div[.='Admission Date']/following-sibling::div[1]
                        ...               ELSE                       Get Text
                        ...                                          //div[.='Discharge/Transition Date']/following-sibling::div[1]
  [RETURN]    ${advanced date};${current date}


I record the timezone census
  I select the "My Locations" location
  ${current tz census} =    Get Text    //span[contains(text(),'Census')]
  ${TRASH}    ${current tz census}    @{TRASH} =    Split String    ${current tz census}
  Set Test Variable    ${Current tz census}    ${${current tz census}}
  Set Test Variable    ${Tz patients in master}    ${0}

Checking for each tz patients admission date
  ${shift} =    Set Variable    ${Shift time}
  ${all shift} =    Add Time To Time    @{shift}[0]    @{shift}[1]    verbose
  ${current date} =    Get Current Date    increment=${all shift}    result_format=%m/%d/%Y %I:%M %p
  ${p cnt} =    Get Length    ${Tz patients}
  ${l cnt} =    Get Length    ${Tz locations}
  ${count} =    Evaluate    ${p cnt} / ${l cnt}
  ${locations} =    Get Dictionary Keys    ${Tz locations}
  :FOR    ${index}    ${id}    IN ENUMERATE    @{Tz patients}
  \    ${location} =    Evaluate    ${index} // ${count}
  \    ${location} =    Convert To Integer    ${location}
  \    ${named} =    Get From List    ${locations}    ${location}
  \    Travel "fast" to "${id}" patients "information" page in "${named}"
  \    ${local time} =    Get Text    //div[.='Admission Date']/following-sibling::div[1]
  \    Continue For Loop If    '${local time}'=='${EMPTY}'
  \    ${local time} =    Convert Date    ${local time}    epoch    False    %m/%d/%Y %I:%M %p
  \    ${now tz} =    Get From Dictionary    ${Tz locations}    ${named}
  \    ${now tz} =    Gtz << Call gtz    ${local time}    ${now tz}
  \    ${change in time} =    Evaluate    ${now tz}-${Machine gmt}
  \    ${current time} =    Add Time To Date    ${current date}    ${change in time} hours    epoch    False
  \                         ...                 %m/%d/%Y %I:%M %p
  \    Run Keyword If    ${local time}<=${current time}
  \    ...               Set Test Variable    ${Tz patients in master}    ${Tz patients in master+1}

The correct census will be based of the master instance timezone
  Should Be Equal As Numbers    ${Current tz census}    ${Non tz census+${Tz patients in master}}


Go to patient ${id} and check shift note date and time against the ${named} location
  ${id} =    Log flowchart info and return patient id    ${id}    ${named}
  ${dates group} =    Create List
  :FOR    ${test}    IN    timestamps    attachments
  \    Log    Shift note ${test}    console=True
  \    I hit the "shifts" tab
  \    I am on the "shifts" page
  \    I select the "${named}" location
  \    ${dates} =    Run Keyword And Continue On Failure    Shift note ${test}    ${id}    ${named}
  \    Continue For Loop If    '${dates}'=='null' or '${dates}'=='None'
  \    Append To List    ${dates group}    ${dates}
  Do time checks    ${dates group}    ${named}

Shift note timestamps
  [ARGUMENTS]    ${id}    ${named}
  Loop deletion    Dialog action    Click Element    //a[@data-method\='delete']
  I hit the "New report" view
  Page Should Contain Element    //div[@aria-labelledby='ui-id-1']
  Input Text    shift_report_note    late mcdonalds
  Click Button    Save report
  Ajax wait
  @{filter} =    Create List    ${Admin First} ${Admin Last},
  ${dates} =    Get the timestamp    //div[@id='shift_reports']/div[2]/span    ${Shift time}    ${filter}
  Dialog action    Click Element    //a[@data-method\='delete']
  [RETURN]    ${dates}

Shift note attachments
  [ARGUMENTS]    ${id}    ${named}
  ${dates} =    Set Variable    null
  [RETURN]    ${dates}


Go to patient ${id} and check dashboard date and time against the ${named} location
  ${id} =    Log flowchart info and return patient id    ${id}    ${named}
  ${dates group} =    Create List
  :FOR    ${test}    IN
  ...    orders every orders
  ...    med pass filters    actions filters    physician review start date    physician review end date
  \    Log    Dashboard ${test}    console=True
  \    @{dates} =    Run Keyword And Continue On Failure    Dashboard ${test}    ${id}    ${named}
  \    Continue For Loop If    '@{dates}[0]'=='null' or '@{dates}[0]'=='None'
  \    Append To List    ${dates group}    @{dates}
  Do time checks    ${dates group}    ${named}

Basic dashboard setup
  [ARGUMENTS]    ${id}    ${named}
  Travel "fast" to "${id}" patients "medical orders" page in "${named}"
  &{orders} =    Create Dictionary
  I hit the "Add standard order" text
  I hit the "Taper" text
  ${orders.tapers} =    Hit order and store text    orders_taper
  I hit the "PRNs" text
  ${orders.prns} =    Hit order and store text    orders_prn
  I hit the "Other" text
  ${orders.other} =    Hit order and store text    orders_other
  # Form fill    add order    ordered by=QA Doc    via:dropdown=fax
  Doctor "add" ordered by "QA Doc" via "fax"
  Click Element    //span[.='Submit']
  ${orders.med} =    Create a doctor order    medication
  ${order} =    Create a doctor order    medication    meds=Log in staging    prn=x
  Set To Dictionary    ${orders}    med prn=${order}
  ${orders.action} =    Create a doctor order    action
  ${order} =    Create a doctor order    action    meds=Log in production    prn=x
  Set To Dictionary    ${orders}    action prn=${order}
  I hit the "dashboard" tab
  [RETURN]    ${orders}

Hit order and store text
  [ARGUMENTS]    ${order}
  Click Element    //div[@id='dialog-modal-orders-addorder']//tr[@class='${order}'][1]/td[2]
  ${text} =    Get Text    //div[@id='dialog-modal-orders-addorder']//tr[@class='${order}'][1]/td[2]//span
  [RETURN]    ${text}

Dashboard orders admissions
  [ARGUMENTS]    ${id}    ${named}
  @{dates} =    Create List    null
  [RETURN]    ${dates}

Dashboard orders discharges
  [ARGUMENTS]    ${id}    ${named}
  @{dates} =    Create List    null
  [RETURN]    ${dates}

Dashboard orders every orders
  [ARGUMENTS]    ${id}    ${named}
  @{dates} =    Create List
  @{filter} =    Create List    ${Admin First[:1]}${Admin Last[:1]}
  &{orders} =    Basic dashboard setup    ${id}    ${named}
  I hit the "Orders" view
  :FOR    ${order}    IN    All    Medications    Action    Lab
  \    @{date} =    Run Keyword    ${order} orders    ${orders}    ${filter}
  \    Continue For Loop If    '@{date}[0]'=='null' or '@{date}[0]'=='None'
  \    Append To List    ${dates}    @{date}
  [RETURN]    ${dates}
  [TEARDOWN]    Run Keywords    Travel "fast" to "current" patients "medical orders" page in "null"
  ...           AND             Loop deletion    Remove any orders

All orders
  [ARGUMENTS]    ${orders}    ${filter}
  @{dates} =    Create List
  I hit the "All Orders" view
  :FOR    ${order}    IN    tapers    prns    other    med    med prn    action    action prn
  \    ${date field} =    Set Variable    //a[contains(text(),'&{orders}[${order}]')]/ancestor::td[1]/following-sibling::td[1]/div
  \    ${date} =    Get the timestamp    ${date field}    ${Shift time}    ${filter}
  \    Append To List    ${dates}    ${date}
  [RETURN]    ${dates}

Medications orders
  [ARGUMENTS]    ${orders}    ${filter}
  @{dates} =    Create List
  I hit the "Medication Orders" view
  :FOR    ${order}    IN    tapers    prns    other    med    med prn
  \    ${date field} =    Set Variable    //a[contains(text(),'&{orders}[${order}]')]/ancestor::td[1]/following-sibling::td[1]/div
  \    ${date} =    Get the timestamp    ${date field}    ${Shift time}    ${filter}
  \    Append To List    ${dates}    ${date}
  [RETURN]    ${dates}

Action orders
  [ARGUMENTS]    ${orders}    ${filter}
  @{dates} =    Create List
  I hit the "Action Orders" view
  :FOR    ${order}    IN    action    action prn
  \    ${date field} =    Set Variable    //a[contains(text(),'&{orders}[${order}]')]/ancestor::td[1]/following-sibling::td[1]/div
  \    ${date} =    Get the timestamp    ${date field}    ${Shift time}    ${filter}
  \    Append To List    ${dates}    ${date}
  [RETURN]    ${dates}

Lab orders
  [ARGUMENTS]    ${orders}    ${filter}
  @{dates} =    Create List
  I hit the "Lab Orders" view
  @{dates} =    Create List    null
  [RETURN]    ${dates}

Dashboard med pass filters
  [ARGUMENTS]    ${id}    ${named}
  @{dates} =    Create List    null
  [RETURN]    ${dates}

Dashboard actions filters
  [ARGUMENTS]    ${id}    ${named}
  @{dates} =    Create List    null
  [RETURN]    ${dates}

Dashboard physician review
  [ARGUMENTS]    ${id}    ${named}
  @{dates} =    Create List
  @{filter} =    Create List    ${Admin First[:1]}${Admin Last[:1]}
  # @{filter} =    Create List    Start:
  &{orders} =    Basic dashboard setup    ${id}    ${named}
  I hit the "Physician Review" view
  :FOR    ${order}    IN    tapers    prns    other    med    med prn    action    action prn
  \    ${date field} =    Set Variable    //a[contains(text(),'&{orders}[${order}]')]/ancestor::td[1]/following-sibling::td[1]/div
  \    ${date} =    Get the timestamp    ${date field}    ${Shift time}    ${filter}
  \    Append To List    ${dates}    ${date}
  [RETURN]    ${dates}
  [TEARDOWN]    Run Keywords    Travel "fast" to "current" patients "medical orders" page in "null"
  ...           AND             Loop deletion    Remove any orders

Dashboard physician review start date
  [ARGUMENTS]    ${id}    ${named}
  @{dates} =    Create List    null
  [RETURN]    ${dates}

Dashboard physician review end date
  [ARGUMENTS]    ${id}    ${named}
  @{dates} =    Create List    null
  [RETURN]    ${dates}


Go to patient ${id} and check patients landing page date and time against the ${named} location
  ${id} =    Log flowchart info and return patient id    ${id}    ${named}
  ${id} =    Set Variable If    '${id}'=='tester'    ${Test id}    ${id}
  ${dates group} =    Create List
  ${date field} =    Set Variable    //a[contains(@href,'/patients/${id}')][1]/ancestor::tr[1]/td[5]
  ${format} =    Set Variable    %m/%d/%Y %I:%M %p
  Travel "slow" to "${id}" patients "facesheet" page in "${named}"
  ${dates} =    Get the date now    ${PATIENT FACESHEET ADMISSION DATE}    ${Shift time}
  Append To List    ${dates group}    ${dates}
  ${default time} =    Fetch From Left    ${dates}    ;
  ${default time} =    Set Variable    ${default time.split(maxsplit=1)[1]}
  Click Button    patient[auto_submit]
  Ajax wait
  Give a "passing" facesheet validation
  Return to mainpage
  Toggle to "list" view
  Execute Javascript    var paragraph = document.evaluate("${date field}", document, null, 9, null).singleNodeValue;
  ...                   paragraph.textContent += " ${default time}"
  ${dates} =    Get the timestamp    ${date field}    ${Shift time}
  Append To List    ${dates group}    ${dates}
  Do time checks    ${dates group}    ${named}
  [TEARDOWN]    Run Keywords    Return to mainpage
  ...                           Toggle to "tile" view


Go to patient ${id} and check occupancy date and time against the ${named} location
  ${id} =    Log flowchart info and return patient id    ${id}    ${named}
  Basic occupancy location setup    ${named}
  .?
  Travel "fast" to "${id}" patients "information" page in "${named}"
  ${dates group} =    Create List
  :FOR    ${test}    IN
  ...
  \    Log    Occupancy ${test}    console=True
  \    ${dates} =    Run Keyword And Continue On Failure    Occupancy ${test}    ${id}    ${named}
  \    Continue For Loop If    '${dates}'=='null' or '${dates}'=='None'
  \    Append To List    ${dates group}    ${dates}
  Do time checks    ${dates group}    ${named}

Basic occupancy building setup
  Return to mainpage
  Create a new building with beds

Basic occupancy location setup
  [ARGUMENTS]    ${named}
  I hit the "settings" tab
  I hit the "Company" view
  ${named} =    Convert To Lowercase    ${named}
  ${named} =    Replace String    ${named}    ${SPACE}    -
  Click Element    //a[contains(@href,'-${named}/edit')]
  Page Should Contain    Edit location
  @{checks} =    Get Webelements    //input[@id='location_building_ids_']/following-sibling::div/input
  :FOR    ${check}    IN    @{checks}
  \    Unselect Checkbox    ${check}
  Select Checkbox    //label[.='${Test Building}']/following-sibling::input[1]
  Click Button    Update
  I am on the "company" page


# Go to patient ${id} and check schedule date and time against the ${named} location
#   ${id} =    Log flowchart info and return patient id    ${id}    ${named}
#   # setup    ${id}    ${named}
#   ${dates group} =    Create List
#   :FOR    ${test}    IN    present group session    past group session
#   \    Log    Schedule ${test}    console=True
#   \    ${dates} =    Run Keyword And Continue On Failure    Schedule ${test}    ${id}    ${named}
#   \    Continue For Loop If    '${dates}'=='null' or '${dates}'=='None'
#   \    Append To List    ${dates group}    ${dates}
#   Do time checks    ${dates group}    ${named}
# Schedule present group session
#   [ARGUMENTS]    ${named}
# Schedule past group session
#   [ARGUMENTS]    ${named}
# Schedule add calendar appointment
#   [ARGUMENTS]    ${named}


Go to and check reports created date and time against the ${named} location
  Log    Verifying ${TEST NAME} within ${named}    console=True
  ${dates group} =    Create List
  I select the "${named}" location
  :FOR    ${test}    IN    billable    single evaluation    authorization
  \    Log    Reports for ${test}    console=True
  \    I hit the "reports" tab
  \    ${dates} =    Run Keyword And Continue On Failure    Reports for ${test}    ${named}
  \    Continue For Loop If    '${dates}'=='null' or '${dates}'=='None'
  \    Append To List    ${dates group}    ${dates}
  Do time checks    ${dates group}    ${named}

Reports for billable
  [ARGUMENTS]    ${named}
  ${date field} =    Set Variable    //a[contains(text(),'skin and tomato')]/../following-sibling::td[2]/a[2]
  I hit the "New Report" view
  Click Button    financial_button
  Ajax wait
  Form fill    reports    name=skin and tomato    template:dropdown=Billable
  Click Button    Continue
  Ajax wait
  Click Element    ui-id-1
  Select Checkbox    report_field_170
  Click Button    Update
  Slow wait    2
  I hit the "reports" tab
  ${dates} =    Get the timestamp    ${date field}    ${Shift time}
  [RETURN]    ${dates}
  [TEARDOWN]    Run Keywords    Go To    ${BASE URL}${REPORTS}
  ...           AND             Loop deletion    Dialog action    Click Element
  ...                           //a[contains(text(),'skin and tomato')]/ancestor::tr[1]/td[last()]/a[last()]

Reports for single evaluation
  [ARGUMENTS]    ${named}
  ${date field} =    Set Variable    //td[contains(text(),'burping coke')]/following-sibling::td[1]
  I hit the "New Report" view
  Click Button    clinical_button
  Ajax wait
  Form fill    reports    name=burping coke    template:dropdown=Single Evaluation
  Click Button    Continue
  Ajax wait
  Select Radio Button    report[evaluation_id]    58
  Click Button    Update
  Slow wait    5
  Reload Page
  Click Element    kmc-downloads-count
  ${dates} =    Get the timestamp    ${date field}    ${Shift time}
  [RETURN]    ${dates}
  [TEARDOWN]    Run Keywords    Go To    ${BASE URL}${REPORTS}
  ...           AND             Loop deletion    Dialog action    Click Element
  ...                           //a[contains(text(),'burping coke')]/ancestor::tr[1]/td[last()]/a[last()]

Reports for authorization
  [ARGUMENTS]    ${named}
  ${dates} =    Set Variable    null
  [RETURN]    ${dates}


Go to patient ${id} and check users date and time against the ${named} location
  ${id} =    Log flowchart info and return patient id    ${id}    ${named}
  ${dates group} =    Create List
  :FOR    ${test}    IN    times    log times account    log times login
  \    Log    Users ${test}    console=True
  \    ${dates} =    Run Keyword And Continue On Failure    Users ${test}    ${id}    ${named}
  \    Continue For Loop If    '${dates}'=='null' or '${dates}'=='None'
  \    Append To List    ${dates group}    ${dates}
  Do time checks    ${dates group}    ${named}

Users times
  [ARGUMENTS]    ${id}    ${named}
  ${dates} =    Set Variable    null
  [RETURN]    ${dates}

Users log times account
  [ARGUMENTS]    ${id}    ${named}
  ${date field} =    Set Variable    //td[.='Tech'][1]/preceding-sibling::td[last()]
  ${format} =    Set Variable    %m/%d/%Y %I:%M %p
  Turning "on" the "tech" roles for "admin"
  Turning "off" the "tech" roles for "admin"
  Set user search    ${Admin First}    ${Admin Last}
  I hit the "users" tab
  The user is "in" the system
  I hit the "${Admin First}, ${Admin Last}" text
  I hit the "User logs" text
  I hit the "User Account" view
  # ${dates} =    Get the comparison dates    ${date field}    ${format}    ${_LOCATION 1}    ${named}    ${Shift time}
  ${dates} =    Get the comparison dates    ${date field}    ${format}    My Locations    ${named}    ${Shift time}
  [RETURN]    ${dates}

Users log times login
  [ARGUMENTS]    ${id}    ${named}
  ${date field} =    Set Variable    //td[.='Current Sign In:']/following-sibling::td[1]
  ${format} =    Set Variable    %m/%d/%Y %I:%M %p
  Set user search    ${Admin First}    ${Admin Last}
  I hit the "users" tab
  The user is "in" the system
  I hit the "${Admin First}, ${Admin Last}" text
  # ${dates} =    Get the comparison dates    ${date field}    ${format}    ${_LOCATION 1}    ${named}    ${Shift time}
  ${dates} =    Get the comparison dates    ${date field}    ${format}    My Locations    ${named}    ${Shift time}
  [RETURN]    ${dates}


Go to patient ${id} and check restore date and time against the ${named} location
  ${id} =    Log flowchart info and return patient id    ${id}    ${named}
  Basic restore setup
  ${dates group} =    Create List
  :FOR    ${test}    IN
  ...     client    evaluation    consent form    evaluation template    consent form template    logs    unmatched data
  \    Log    Restore ${test}    console=True
  \    I select the "${named}" location
  \    ${dates} =    Run Keyword And Continue On Failure    Restore ${test}    ${id}    ${named}
  \    Continue For Loop If    '${dates}'=='null' or '${dates}'=='None'
  \    Append To List    ${dates group}    ${dates}
  Do time checks    ${dates group}    ${named}

Basic restore setup
  I attempt to hit the "templates" tab
  Create tester template    consent forms    Cold Once
  Editing "consent forms" test template
  Form fill    consent forms form    patient process:dropdown=Admission    enabled:checkbox=x
  ...          patient sig req:checkbox=x    allow revocation:checkbox=x    rules:dropdown=Only if patient is male
  Run Keyword If    ${_LOCATIONS ACTIVE}    Form fill    consent forms form    all locations:checkbox=x
  Save "consent forms" template
  I am on the "templates" page
  I hit the "templates evaluations" tab
  Create tester template    evaluations    Drink Twice
  Editing "evaluations" test template
  Form fill    evaluations form    enabled:checkbox=x    patient process:dropdown=Nursing
  Run Keyword If    ${_LOCATIONS ACTIVE}    Form fill    evaluations form    all locations:checkbox=x
  Save "evaluations" template
  I am on the "templates evaluations" page
  Return to mainpage

Find delete column
  [ARGUMENTS]    ${tab}
  Go To    ${BASE URL}${RESTORE}
  Click Element    //div[@id='Versions']/div[3]//span[.='${tab}']
  @{head} =    Get Webelements    //div[@id='Versions']/div[3]//tr[1]/th
  :FOR    ${index}    ${action}    IN ENUMERATE   @{head}
  \    ${action} =    Line parser    ${action.get_attribute('innerHTML')}    0
  \    Exit For Loop If    '${action}'=='Deleted'
  [RETURN]    ${index+1}

Get restored timestamp
  [ARGUMENTS]    ${tab}    ${search}    ${named}    ${format}=${CURRENT USER} %m/%d/%Y %I:%M %p
  ${format} =    Set Variable    ${format}
  ${delete} =    Find delete column    ${tab}
  ${date field} =    Set Variable    //td[contains(text(),'${search}')][1]/parent::tr/td[${delete}]
  ${dates} =    Get the comparison dates    ${date field}    ${format}    My Locations    ${named}    ${Shift time}
  [RETURN]    ${dates}

Restore client
  [ARGUMENTS]    ${id}    ${named}
  ${date} =    Convert Date    ${Todays Date}    result_format=%m/%d/%Y
  I create a valid patient    Let    Me    Rest    ${date}
  ${first} =    Get Element Attribute    patient_first_name    value
  ${last} =    Get Element Attribute    patient_last_name    value
  Remove this patient    ${first} ${last}
  ${dates} =    Get restored timestamp    Patients    ${first}    ${named}
  [RETURN]    ${dates}

Restore evaluation
  [ARGUMENTS]    ${id}    ${named}
  Travel "fast" to "${id}" patients "nursing" page in "null"
  With this form "Drink Twice" perform these actions "add"
  Page Should Contain Element    //div[@id='sub_nav_content']/table//a[contains(text(),'Drink Twice')]
  Loop deletion    With this form "Drink Twice" perform these actions "delete"
  Page Should Not Contain Element    //div[@id='sub_nav_content']/table//a[contains(text(),'Drink Twice')]
  ${dates} =    Get restored timestamp    Patient Evaluations    Drink Twice    ${named}
  [RETURN]    ${dates}

Restore consent form
  [ARGUMENTS]   ${id}    ${named}
  Travel "fast" to "${id}" patients "admission" page in "null"
  With this form "Cold Once" perform these actions "add"
  Page Should Contain Element    //div[@id='sub_nav_content']/table//a[contains(text(),'Cold Once')]
  Loop deletion    With this form "Cold Once" perform these actions "delete"
  Page Should Not Contain Element    //div[@id='sub_nav_content']/table//a[contains(text(),'Cold Once')]
  ${dates} =    Get restored timestamp    Patient consent forms    Cold Once    ${named}
                ...                       ${CURRENT USER}, %m/%d/%Y %I:%M %p
  [RETURN]    ${dates}

Restore evaluation template
  [ARGUMENTS]    ${id}    ${named}
  Go To    ${BASE URL}${TEMPLATES EVALUATIONS}
  Loop deletion    Remove old templates    Drink Twice
  Reload Page
  Page Should Not Contain    Drink Twice
  ${dates} =    Get restored timestamp    Evaluation templates    Drink Twice    ${named}
                ...                       ${CURRENT USER}, %m/%d/%Y %I:%M %p
  [RETURN]    ${dates}

Restore consent form template
  [ARGUMENTS]    ${id}    ${named}
  Go To    ${BASE URL}${TEMPLATES}
  Loop deletion    Remove old templates    Cold Once
  Reload Page
  Page Should Not Contain    Cold Once
  ${dates} =    Get restored timestamp    Consent form templates    Cold Once    ${named}
                ...                       ${CURRENT USER}, %m/%d/%Y %I:%M %p
  [RETURN]    ${dates}

Restore logs
  [ARGUMENTS]    ${id}    ${named}
  ${dates} =    Set Variable    null
  [RETURN]    ${dates}

Restore unmatched data
  [ARGUMENTS]    ${id}    ${named}
  ${dates} =    Set Variable    null
  [RETURN]    ${dates}


Go to patient ${id} and check user menu date and time against the ${named} location
  ${id} =    Log flowchart info and return patient id    ${id}    ${named}
  ${dates group} =    Create List
  I select the "${named}" location
  :FOR    ${test}    IN    messages    notifications    downloads    incoming    manage faxes
  \    Log    User menu ${test}    console=True
  \    ${dates} =    Run Keyword And Continue On Failure    User menu ${test}    ${id}    ${named}
  \    Continue For Loop If    '${dates}'=='null' or '${dates}'=='None'
  \    Append To List    ${dates group}    ${dates}
  Do time checks    ${dates group}    ${named}

Basic user menu setup
  I hit the "username" tab
  I hit the "Messages" view
  Loop deletion    Click Element    //li[starts-with(@id,'message_thread_')]/div/div/a[2]
  Create a new user
  Start new window process    2700    20
  Switch Browser    2
  Start login    ${Find user}    ${Find pass}
  I am on the "patients" page
  I select the "My Locations" location
  Switch Browser    1

User menu messages
  [ARGUMENTS]    ${id}    ${named}
  I hit the "username" tab
  I hit the "Messages" view
  Loop deletion    Click Element    //li[starts-with(@id,'message_thread_')]/div/div/a[2]
  Click Link    /messages/threads/new
  Slow wait
  Input Text    //input[@class='default']    .
  Input Text    //input[@class='default']    ${Find first} ${Find last}
  Slow wait
  Press Key    //input[@class='default']    \\13
  Input Text    message_content    Dangling fires
  Click Element    sendNewMessageButton
  Ajax wait
  ${send date} =    Get Text    //i[@class='fa fa-clock-o']
  ${send date} =    Evaluate    '${send date[:6]}' + '20' + '${send date[6:]}'
  Switch Browser    2
  Sleep    2
  Reload Page
  Click Link    /messages
  Page should have    ${Admin First}    ${Admin Last}    Dangling fires
  ${received date} =    Get Text    //i[@class='fa fa-clock-o']
  ${received date} =    Evaluate    '${received date[:6]}' + '20' + '${received date[6:]}'
  Loop deletion    Click Element    //li[starts-with(@id,'message_thread_')]/div/div/a[2]
  Return to mainpage
  [RETURN]    ${send date};${received date}
  [TEARDOWN]    Run Keywords    Switch Browser    2
  ...           AND             Return to mainpage
  ...           AND             Switch Browser    1
  ...           AND             Loop deletion    Click Element    //li[starts-with(@id,'message_thread_')]/div/div/a[2]

User menu notifications
  [ARGUMENTS]    ${id}    ${named}
  ${dates} =    Set Variable    null
  [RETURN]    ${dates}

User menu downloads
  [ARGUMENTS]    ${id}    ${named}
  Travel "fast" to "${id}" patients "information" page in "${named}"
  ${patient} =    Get Text    //h2[contains(text(),'${Patient Handle.title()} Information')]/following-sibling::div[1]/p[1]
  ${date field} =    Set Variable    //span[contains(text(),'${patient}')]/ancestor::tr[1]/td[2]
  I hit the "gen casefile" tab
  Generate and confirm pdf with    ${EMPTY}    Protected Tabs    Include Pending Forms
  Click Link    /downloads
  Page Should Contain Element    ${date field}
  ${dates} =    Get the timestamp    ${date field}    ${Shift time}
  [RETURN]    ${dates}

User menu incoming
  [ARGUMENTS]    ${id}    ${named}
  Travel "fast" to "tester" patients "information" page in "My Locations"
  I hit the "gen transfer" tab
  Generate and confirm pdf with    ${named}
  ${date field} =    Set Variable    //td[contains(text(),'${Test first} ${Test last}')]/preceding-sibling::td[1]
  Return to mainpage
  I select the "${named}" location
  Click Link    /transfers
  Page Should Contain Element    ${date field}
  ${dates} =    Get the timestamp    ${date field}    ${Shift time}
  [RETURN]    ${dates}
  [TEARDOWN]    Run Keywords    Go To    ${BASE URL}/transfers
  ...           AND             Dialog action    Click Element
  ...                           //td[contains(text(),'${Test first} ${Test last}')]/following-sibling::td[last()]/a
  ...           AND             I hit the "username" tab
  ...           AND             I select the "${named}" location

User menu manage faxes
  [ARGUMENTS]    ${id}    ${named}
  ${dates} =    Set Variable    null
  [RETURN]    ${dates}




Go to patient ${id} and check against the ${name} location
  Log To Console    Verifying ${TEST NAME} with ${id} within ${name}
  Log    Verifying ${TEST NAME} with ${id} within ${name}
  Return to mainpage
  Set count id
  ${id} =    Select shifted patient    ${id}    2
  ${tab}    ${type} =    Split String    ${TEST NAME}    ${SPACE}-${SPACE}
  ${tab} =    Set Variable If    "${tab}"=="Doctor\'s order"    medical orders
              ...                "${tab}"=="Mars"               med log
              ...                True                           ${tab}
  ${date field} =    Set Variable If    ${type.lower().find('start date/time')}==0    appt-start-date
                     ...                ${type.lower().find('end date/time')}==0      appt-end-date
                     ...                ${type.lower().find('statuses')}==0           ${PATIENT FACESHEET COMMIT START DATE}
                     ...                ${type.lower().find('subscriber')}==0         ${PATIENT FACESHEET SUBSCRIBER DOB}
                     ...                ${type.lower().find('birthday')}==0           ${PATIENT FACESHEET DOB}
                     ...                ${type.lower().find('sobriety')}==0           ${PATIENT FACESHEET SOBRIETY DATE}
                     ...                ${type.lower().find('allergies')}==0          ${PATIENT FACESHEET ONSET}
                     ...                True                                          null
  Run Keyword If    '${tab}'=='Facesheet'       Run Keywords    Travel "fast" to "${id}" patients "information" page in "My Locations"
  ...                                           AND             I hit the "Edit ${Patient Handle}" view
  ...                                           AND             Prelim steps    ${type}
  ...    ELSE IF    '${tab}'=='Appointments'    Travel "slow" to "${id}" patients "${tab}" page in "${name}"
  ...    ELSE IF    '${tab}'=='Timestamps'      Travel "fast" to "${id}" patients "information" page in "${name}"
  ...               ELSE                        Travel "fast" to "${id}" patients "${tab}" page in "${name}"
  ${dates} =    Run Keyword If    ${tab.find('medical orders')}==0    Create a doctor order    medication    ${Shift time}
                ...    ELSE IF    ${type.find('Vital')}==0            Adding vitals log    live now    ${Shift time}
                ...    ELSE IF    ${type.find('Glucose')}==0          Adding glucose log    live now    ${Shift time}
                ...    ELSE IF    ${type.find('Weight')}==0           Adding weight log    live now    ${Shift time}
                ...    ELSE IF    ${tab.find('Facesheet')}==0         Get the datetime    ${date field}    ${Shift time}
                ...    ELSE IF    ${tab.find('Timestamps')}==0        Get the timestamp    ${date field}    ${Shift time}
                ...               ELSE                                Get the date now    ${date field}    ${Shift time}
  # Run Keyword If    Chart Summary    Click Element    //button[@type='submit']
  Run Keyword If    ${tab.find('Facesheet')}==0     Run Keywords    Click Button    patient[auto_submit]
  ...                                               AND             Ajax wait
  ...                                               AND             Give a "passing" facesheet validation
  ...                                               AND             I hit the "Show Facesheet" view
  ...                                               AND             Set Test Variable    ${Err}    60
  ...    ELSE IF    ${tab.find('Timestamps')}==0    Set Test Variable    ${Err}    300
  ...               ELSE                            Set Test Variable    ${Err}    60
  # I select the "${name}" location
  ${local date}    ${current date} =    Split String    ${dates}    ;
  Ajax wait
  ${passes} =    Run Keyword And Return Status    Dictionary Should Contain Key    ${Tz locations}    ${name}
  ${their tz} =    Run Keyword If    ${passes}    Get From Dictionary    ${Tz locations}    ${name}
                   ...               ELSE         Set Variable    ${${TEST TZ}}
  Adjust for correct time    ${local date}    ${current date}    ${their tz}    err seconds=${Err}

Prelim steps
  [ARGUMENTS]    ${ttt}
  Click Link    Add Commitment
  Ajax wait
  Form fill    patient facesheet    commitment:dropdown=90 days commitment

View the medications from "${place}" location
  ${todays Date} =    Get Current Date    result_format=%Y-%m-%d
  Adjust for correct time
