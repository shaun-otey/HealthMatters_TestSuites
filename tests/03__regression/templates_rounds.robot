*** Settings ***
Documentation   Testing for rounds.
...
Default Tags    regression    re034    points-11    templates story
Resource        ../../suite.robot
Suite Setup     Run Keywords    Create a new user    email=gxx.txx@kxx.hxx    locations=${_LOCATION 1};${_LOCATION 3}
...             AND             Prepare rounds
...             AND             I attempt to hit the "templates" tab
...             AND             I hit the "templates rounds" tab
...             AND             Create tester template    rounds    Pocky House Forevja
...             AND             Editing "rounds" test template
...             AND             Should I reload when adding round lru
Suite Teardown  Run Keywords    End rounds
...                             Delete the new user
Test Setup      Run Keywords    Go To    ${BASE URL}${TEMPLATES ROUNDS}
...             AND             Create tester template    rounds    Pocky House Forevja
Test Teardown   Run Keyword If Test Failed    Custom screenshot

*** Test Cases ***
User roles permission
  [SETUP]    None
  [TEMPLATE]    A tech user with the ${type} roles should ${able 1} to manage rounds
  ...           and should ${able 2} to review rounds
  none                 not be able    not be able
  review               not be able    be able
  manage               be able        be able
  primary therapist    be able        be able

Send correct alerts
  [TAGS]    skip dead case
  Given I am on the "templates rounds" page
  And I select the "My Locations" location
  When modify rounds for alerts
  And Exit system    ${false}
  And Start login    ${Find User}    ${Find Pass}
  Then check for triangle alert
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Exit system    ${false}
  ...           AND             Start login    ${CURRENT USER}    ${CURRENT PASS}

Check for alert duplication
  Given I am on the "templates rounds" page
  And I select the "My Locations" location
  And modify rounds for duplication
  And travel "slow" to "tester" patients "information" page in "${_LOCATION 1}"
  And I hit the "My XL Rounds" view
  When with this form "Pocky House Forevja" perform these actions "assign"
  And I hit the "shifts" tab
  And I hit the "Rounds" view
  Then check for correct start and view

Give custom activities and locations when observing a round
  Given I am on the "templates rounds" page
  And I select the "My Locations" location
  And modify rounds for observing
  And travel "slow" to "tester" patients "information" page in "${_LOCATION 1}"
  And I hit the "My XL Rounds" view
  When with this form "Pocky House Forevja" perform these actions "assign"
  And I hit the "shifts" tab
  And I hit the "Rounds" view
  Then check for custom options here and in the chart summary

Change a round leader from one that has been disabled
  [SETUP]    Create additional users
  Given I am on the "templates rounds" page
  And I select the "My Locations" location
  When create tester template    rounds    Pocky House Forevja
  Then modify rounds leader to user "2"
  And modify rounds leader to user "3"
  And disable user "3"
  And Run Keyword And Expect Error    *    modify rounds leader to user "3"
  And Go To    ${BASE URL}${TEMPLATES ROUNDS}
  When create tester template    rounds    Pocky House Forevja
  Then modify rounds leader to user "2"
  And disable user "2"
  And modify rounds leader to user "4"
  And Run Keyword And Expect Error    *    modify rounds leader to user "2"
  And Go To    ${BASE URL}${TEMPLATES ROUNDS}
  When create tester template    rounds    Pocky House Forevja
  Then modify rounds leader to user "4"
  And modify rounds leader to user "delete"
  And modify rounds leader to user "4"
  And disable user "4"
  And modify rounds leader to user "delete"
  And Run Keyword And Expect Error    *    modify rounds leader to user "3"
  [TEARDOWN]    Run Keywords    Set user search    ${Find first 2}    ${Find last 2}
  ...           AND             Delete the new user
  ...           AND             Set user search    ${Find first 3}    ${Find last 3}
  ...           AND             Delete the new user
  ...           AND             Set user search    ${Find first 4}    ${Find last 4}
  ...           AND             Delete the new user
  ...           AND             Pocket global vars    restore

Check for rounds showing up
  Given I am on the "templates rounds" page
  And I select the "${_LOCATION ALT 5}" location
  When modify rounds for not appearing
  And I hit the "shifts" tab
  And I hit the "Rounds" view
  Then check that the round is showing

Check for rounds having access to comments without vitals
  Given I am on the "templates rounds" page
  And I select the "My Locations" location
  And modify rounds for commenting
  And travel "slow" to "tester" patients "information" page in "${_LOCATION 1}"
  And I hit the "My XL Rounds" view
  When with this form "Pocky House Forevja" perform these actions "assign"
  And I hit the "shifts" tab
  And I hit the "Rounds" view
  Then check for comments in the active round
  And I hit the "shifts" tab
  When I hit the "Rounds Overview" view
  Then check for comments in the rounds overview

Check for round templates populating correctly
  Given I am on the "templates rounds" page
  And I select the "My Locations" location
  When editing "rounds" test template
  Then check add round lru

*** Keywords ***
Prepare rounds
  Go To    ${BASE URL}${INSTANCE}
  Instance edit "Select Checkbox" on "Use rounds"
  Click Button    commit
  Ajax wait
  Click Element    //a[@href='/settings' and .='${Patient Handle}s']
  FOR    ${option}    ${input}    IN
  ...     rounds activities    Sleeping In
  ...     rounds locations     The Nether
  ...     patient processes    My XL Rounds;Rounds
      Adding into client settings "${option}" this "${input}" name
  END
  Clean from client settings "patient processes" this "Rounds" name

End rounds
  Delete tester template    rounds
  Go To    ${BASE URL}${SETTINGS}
  FOR    ${option}    ${input}    IN
  ...     rounds activities    Sleeping In
  ...     rounds locations     The Nether
  ...     patient processes    My XL Rounds
      Clean from client settings "${option}" this "${input}" name
  END
  Go To    ${BASE URL}${INSTANCE}
  Instance edit "Unselect Checkbox" on "Use rounds"
  Click Button    commit
  Ajax wait

Should I reload when adding round lru
  ${reload} =    Run Keyword And Return Status    Check add round lru
  ${reload} =    Evaluate    not ${reload}
  Set Suite Variable    ${Round lru reload}    ${reload}

Check add round lru
  I hit the "Add Round Leader" text
  ${passes 1} =    Run Keyword And Return Status    Page Should Contain List    round_round_leaders_attributes_0_user_id
  I hit the "Add Round Role" text
  ${passes 2} =    Run Keyword And Return Status    Page Should Contain List    round_rounds_roles_attributes_0_role_id
  I hit the "Add Round User Function" text
  ${passes 3} =    Run Keyword And Return Status    Page Should Contain List
                   ...                              round_rounds_user_titles_attributes_0_user_title_id
  ${passes} =    Set Variable    ${true}
  FOR    ${case}    IN RANGE    1    4
      ${passes} =    Set Variable If    not ${passes ${case}}    ${false}    ${passes}
  END
  Run Keyword Unless    ${passes}    Reload Page
  Loop deletion    I hit the "Delete Item" text
  Save "rounds" template
  Should Be True    ${passes}

From start time to later
  [ARGUMENTS]    ${start time}    ${elapsed time}
  ${end time} =    Add Time To Date    ${start time}    ${elapsed time}
  ${left start} =    Convert Date    ${start time}    %I %p
  ${right start} =    Convert Date    ${start time}    %M
  ${left end} =    Convert Date    ${end time}    %I %p
  ${right end} =    Convert Date    ${end time}    %M
  ${day} =    Convert Date    ${Todays Date}    result_format=%A
  [RETURN]    ${left start}    ${right start}    ${left end}    ${right end}    ${day}

A tech user with the ${type} roles should ${able 1} to manage rounds and should ${able 2} to review rounds
  ${switch off}    ${role} =    Set Variable    ${EMPTY}    function
  Go To    ${BASE URL}${TEMPLATES ROUNDS}
  Create tester template    rounds    Pocky House Forevja
  I am on the "templates rounds" page
  Modify rounds for roles
  ${switch on}    ${switch off}    ${role} =    Run Keyword If    '${type}'=='none'      Set Variable    ${switch off}
                                                ...                                      ${switch off}    ${role}
                                                ...    ELSE IF    '${type}'=='manage'    Set Variable    on    off
                                                ...                                      Manage rounds
                                                ...    ELSE IF    '${type}'=='review'    Set Variable    on    off
                                                ...                                      Review rounds
                                                ...               ELSE                   Set Variable
                                                ...                                      Primary Therapist
                                                ...                                      ${switch off}    ${role}
  Turning "${switch on}" the "${role}" roles for "${Find First};${Find Last}"
  Custom screenshot
  Travel "slow" to "tester" patients "information" page in "${_LOCATION 1}"
  I hit the "My XL Rounds" view
  With this form "Pocky House Forevja" perform these actions "assign"
  Exit system    ${false}
  Start login    ${Find User}    ${Find Pass}
  Check that user is "${able 1}" to manage rounds
  Check that user is "${able 2}" to review rounds
  [TEARDOWN]    Run Keywords    Custom screenshot
  ...           AND             Exit system    ${false}
  ...           AND             Start login    ${CURRENT USER}    ${CURRENT PASS}
  ...           AND             Turning "${switch off}" the "${role}" roles for "${Find First};${Find Last}"

Modify rounds for roles
  I select the "My Locations" location
  Editing "rounds" test template
  I hit the "Add Round User Function" text
  Run Keyword If    ${Round lru reload}    Reload Page
  ...               ELSE                   Ajax wait
  ${left start} =    Get Text    //select[@id='${ROUNDS FORM START TIME HR}']/option[@selected='selected']
  ${right start} =    Get Text    //select[@id='${ROUNDS FORM START TIME MIN}']/option[@selected='selected']
  ${start time} =    Subtract Time From Date    ${Todays Date} ${left start} ${right start}    5m
                     ...                        date_format=%Y-%m-%d %I %p %M
  ${left start}    ${right start}    ${left end}    ${right end}    ${day} =    From start time to later    ${start time}
                                                                                ...                         25m
  Form fill    rounds form    enabled:checkbox=x    vitals:checkbox=x    weight:checkbox=x    glucose:checkbox=x
  ...          ${day}:checkbox=x    locations:dropdown=${_LOCATION 1}    user function:dropdown=Primary Therapist
  ...          start time hr:dropdown=${left start}    start time min:dropdown=${right start}
  ...          end time hr:dropdown=${left end}    end time min:dropdown=${right end}    interval mins:dropdown=20
  Custom screenshot
  Save "rounds" template

Check that user is "${able}" to manage rounds
  ${able} =    Set Variable If    'not' in '${able}'    ${false}    ${true}
  ${round base} =    Set Variable    //span[@class='patient_name' and contains(text(),'${Test First}')]/ancestor::form[1]
  ${round dropdowns} =    Set Variable    ${round base}/div[@class='col-sm-6']
  ${round observe} =    Set Variable    ${round base}/div[@class='col-sm-2']//input[@value='Observe']
  I hit the "shifts" tab
  ${passes} =    Run Keyword And Return Status    I hit the "Rounds" view
  ${passes} =    Run Keyword If    ${able}      Run Keyword And Return Status    Click Element
                 ...                            //td[contains(text(),'Pocky House Forevja')]/parent::tr[1]//a
                 ...    ELSE IF    ${passes}    Run Keyword And Return Status    Page should have
                 ...                            ELEMENT|//td[contains(text(),'Pocky House Forevja')]/parent::tr[1]//a
                 ...               ELSE         Set Variable    ${passes}
  Run Keyword If    ${able}    Run Keyword And Continue On Failure    Should Be True    ${passes}
  ...               ELSE       Run Keyword And Continue On Failure    Should Not Be True    ${passes}
  Custom screenshot
  Run Keyword Unless    ${able}    Run Keywords    Exit system    ${false}
  ...                              AND             Start login    ${CURRENT USER}    ${CURRENT PASS}
  ...                              AND             I hit the "shifts" tab
  ...                              AND             I hit the "Rounds" view
  ...                              AND             Click Element    //td[contains(text(),'Pocky House Forevja')]/parent::tr[1]//a
  ...                              AND             Ajax wait
  ...                              AND             Select From List By Label
  ...                                              ${round dropdowns}//select[@name='patient_observation[activity]']
  ...                                              Sleeping In
  ...                              AND             Select From List By Label
  ...                                              ${round dropdowns}//select[@name='patient_observation[location]']
  ...                                              The Nether
  ...                              AND             Click Element    ${round observe}
  ...                              AND             Ajax wait
  ...                              AND             Exit system    ${false}
  ...                              AND             Start login    ${Find User}    ${Find Pass}

Check that user is "${able}" to review rounds
  ${able} =    Set Variable If    'not' in '${able}'    ${false}    ${true}
  I hit the "shifts" tab
  Custom screenshot
  ${passes} =    Run Keyword And Return Status    I hit the "Rounds Overview" view
  ${passes} =    Run Keyword If    not ${able} and not ${passes}    Set Variable    ${passes}
                 ...               ELSE                             Run Keyword And Return Status    Page should have
                 ...                                                Pocky House Forevja
  Run Keyword If    ${able}    Run Keyword And Continue On Failure    Should Be True    ${passes}
  ...               ELSE       Run Keyword And Continue On Failure    Should Not Be True    ${passes}
  Custom screenshot

Modify rounds for alerts
  Editing "rounds" test template
  I hit the "Add Round Leader" text
  Run Keyword If    ${Round lru reload}    Reload Page
  ...               ELSE                   Ajax wait
  ${left start} =    Get Text    //select[@id='${ROUNDS FORM START TIME HR}']/option[@selected='selected']
  ${right start} =    Get Text    //select[@id='${ROUNDS FORM START TIME MIN}']/option[@selected='selected']
  ${start time} =    Add Time To Date    ${Todays Date} ${left start} ${right start}    1m
                     ...                 date_format=%Y-%m-%d %I %p %M
  ${left start}    ${right start}    ${left end}    ${right end}    ${day} =    From start time to later    ${start time}
                                                                                ...                         15m
  # Form fill    rounds form    enabled:checkbox=x    interval mins:dropdown=15    vitals:checkbox=x    weight:checkbox=x
  # ...          missed interval count=1    alert missed start:checkbox=x    alert missed interval:checkbox=x
  # ...          glucose:checkbox=x    alert round leaders:checkbox=x    send email alerts:checkbox=x    ${day}:checkbox=x
  # ...          send sms alerts:checkbox=x    start time hr:dropdown=${left start}    locations:dropdown=${_LOCATION 3}
  # ...          start time min:dropdown=${right start}    end time hr:dropdown=${left end}    missed start mins=1
  # ...          end time min:dropdown=${right end}    leader:dropdown=${Find First} ${Find Last}
  Form fill    rounds form    enabled:checkbox=x    interval mins:dropdown=15    vitals:checkbox=x    weight:checkbox=x
  ...          leader:dropdown=${Find First} ${Find Last}    start time hr:dropdown=${left start}    missed start mins=1
  ...          start time min:dropdown=${right start}    end time hr:dropdown=${left end}    glucose:checkbox=x
  ...          end time min:dropdown=${right end}    locations:dropdown=${_LOCATION 3}    ${day}:checkbox=x
  Save "rounds" template

Check for triangle alert
  # Page Should Contain Element    //*[contains(@href,'/shift')]//i[${CSS SELECT.replace('$CSS','fa-exclamation-triangle')}]
  Page should have    ELEMENT|//*[@id='shifts_tab']//i[${CSS SELECT.replace('$CSS','fa-exclamation-triangle')}]

Modify rounds for duplication
  Editing "rounds" test template
  ${left start} =    Get Text    //select[@id='${ROUNDS FORM START TIME HR}']/option[@selected='selected']
  ${right start} =    Get Text    //select[@id='${ROUNDS FORM START TIME MIN}']/option[@selected='selected']
  ${start time} =    Subtract Time From Date    ${Todays Date} ${left start} ${right start}    2h
                     ...                        date_format=%Y-%m-%d %I %p %M
  ${left start}    ${right start}    ${left end}    ${right end}    ${day} =    From start time to later    ${start time}
                                                                                ...                         2h 3m
  Form fill    rounds form    start time hr:dropdown=${left start}    start time min:dropdown=${right start}
  ...          ${day}:checkbox=x    enabled:checkbox=x    vitals:checkbox=x    weight:checkbox=x    glucose:checkbox=x
  ...          locations:dropdown=${_LOCATION 1}    end time hr:dropdown=${left end}    interval mins:dropdown=5
  ...          end time min:dropdown=${right end}
  Save "rounds" template

Check for correct start and view
  # ${link} =    Set Variable    /following-sibling::table[1]//td[contains(text(),'Pocky House Forevja')]
  ${link} =    Set Variable    /following-sibling::table[1]//*[contains(text(),'Pocky House Forevja')]
  ${correct start} =    Set Variable    //h2[.='Upcoming']${link}/following::a[.='Start']
  ${correct view} =    Set Variable    //h2[.='In Progress']${link}/following::a[.='View']
  # ${bad start} =    Set Variable    //h2[.='Alert']${link}/following::a[.='Start']
  Page should have    ELEMENT|${correct start}
  Click Element    ${correct start}
  I hit the "shifts" tab
  I hit the "Rounds" view
  # Page should have    ELEMENT|//*[@id='shift_rounds']/table[2]/tbody/tr/td[6]/a
  # ...                 NOT|ELEMENT|//a[contains(text(),'Start')]
  Page should have    ELEMENT|${correct view}    NOT|ELEMENT|//a[contains(text(),'Start')]

Modify rounds for observing
  Editing "rounds" test template
  ${left start} =    Get Text    //select[@id='${ROUNDS FORM START TIME HR}']/option[@selected='selected']
  ${right start} =    Get Text    //select[@id='${ROUNDS FORM START TIME MIN}']/option[@selected='selected']
  ${start time} =    Subtract Time From Date    ${Todays Date} ${left start} ${right start}    10m
                     ...                        date_format=%Y-%m-%d %I %p %M
  ${left start}    ${right start}    ${left end}    ${right end}    ${day} =    From start time to later    ${start time}
                                                                                ...                         20m
  Form fill    rounds form    start time hr:dropdown=${left start}    start time min:dropdown=${right start}
  ...          ${day}:checkbox=x    enabled:checkbox=x    vitals:checkbox=x    weight:checkbox=x    glucose:checkbox=x
  ...          locations:dropdown=${_LOCATION 1}    end time hr:dropdown=${left end}    interval mins:dropdown=5
  ...          end time min:dropdown=${right end}
  Save "rounds" template

Check for custom options here and in the chart summary
  ${round base} =    Set Variable    //span[@name='patient_name' and contains(text(),'${Test First}')]/ancestor::form[1]
  ${round dropdowns} =    Set Variable    ${round base}/div[@class='col-sm-6']
  ${round observe} =    Set Variable    ${round base}/div[@class='col-sm-2']/input[@value='Observe']
  ${round observations} =    Set Variable    ${round base}//div[@class='col-sm-8']
  Click Element    //td[contains(text(),'Pocky House Forevja')]/parent::tr[1]//a
  Ajax wait
  Select From List By Label    ${round dropdowns}//select[@name='patient_observation[activity]']    Sleeping In
  Select From List By Label    ${round dropdowns}//select[@name='patient_observation[location]']    The Nether
  Click Element    ${round observe}
  Slow wait    2
  Run Keyword And Continue On Failure    List Selection Should Be
  ...                                    ${round dropdowns}//select[@name='patient_observation[activity]']
  ...                                    Sleeping In
  Run Keyword And Continue On Failure    List Selection Should Be
  ...                                    ${round dropdowns}//select[@name='patient_observation[location]']    The Nether
  Travel "slow" to "tester" patients "information" page in "null"
  I hit the "My XL Rounds" view
  Page should have    ELEMENT|//tr[starts-with(@id,'patient_observation_')]/td[contains(text(),'Sleeping In')]
  ...                 ELEMENT|//tr[starts-with(@id,'patient_observation_')]/td[contains(text(),'The Nether')]
  Click Element    //a[contains(@href,'round_q_slots')]
  Ajax wait
  Run Keyword And Continue On Failure    List Selection Should Be
  ...                                    ${round observations}//select[@name='patient_observation[activity]']
  ...                                    Sleeping In
  Run Keyword And Continue On Failure    List Selection Should Be
  ...                                    ${round observations}//select[@name='patient_observation[location]']
  ...                                    The Nether

Create additional users
  Pocket global vars    Find First    Find Last    Find User    Find Pass
  Go To    ${BASE URL}${TEMPLATES ROUNDS}
  FOR    ${index}    IN RANGE    2    5
      Create a new user    robot${index}    demo${index}    new_user${index}    new_pass${index}
      ...                  g${index}${index}.t${index}${index}@kxx.hxx    ${_LOCATION 1};${_LOCATION 3}
      Set Suite Variable    ${Find first ${index}}    ${Find First}
      Set Suite Variable    ${Find last ${index}}    ${Find Last}
  END
  Go To    ${BASE URL}${TEMPLATES ROUNDS}

Modify rounds leader to user "${index}"
  Go To    ${BASE URL}${TEMPLATES ROUNDS}
  Editing "rounds" test template
  Form fill    rounds form    enabled:checkbox=o    interval mins:dropdown=30    vitals:checkbox=x    weight:checkbox=x
  ...          glucose:checkbox=x    start time hr:dropdown=12 AM    start time min:dropdown=00    sunday:checkbox=x
  ...          end time hr:dropdown=11 PM    end time min:dropdown=59    locations:dropdown=${_LOCATION 1}
  ...          monday:checkbox=x    tuesday:checkbox=x    wednesday:checkbox=x    thursday:checkbox=x
  ...          friday:checkbox=x    saturday:checkbox=x
  Run Keyword If    '${index}'=='delete'    Loop deletion    I hit the "Delete Item" text
  ...               ELSE                    Run Keywords    Run Keyword And Ignore Error
  ...                                                       I hit the "Add Round Leader" text
  ...                                       AND             Form fill    ${EMPTY}
  ...                                                       round_round_leaders_attributes_0_user_id:direct_drop=${Find first ${index}} ${Find last ${index}}
  Save "rounds" template

Disable user "${index}"
  Turning "on" the "user_disabled" roles for "${Find first ${index}};${Find last ${index}}"
  Go To    ${BASE URL}${TEMPLATES ROUNDS}

Modify rounds for not appearing
  Editing "rounds" test template
  Form fill    rounds form    enabled:checkbox=x    interval mins:dropdown=30    vitals:checkbox=x    weight:checkbox=x
  ...          glucose:checkbox=x    start time hr:dropdown=12 AM    start time min:dropdown=00    sunday:checkbox=x
  ...          end time hr:dropdown=11 PM    end time min:dropdown=59    locations:dropdown=${_LOCATION ALT 5}
  ...          monday:checkbox=x    tuesday:checkbox=x    wednesday:checkbox=x    thursday:checkbox=x
  ...          friday:checkbox=x    saturday:checkbox=x
  Save "rounds" template

Check that the round is showing
  ${link} =    Set Variable    /following-sibling::table[1]//td[contains(text(),'Pocky House Forevja')]
  Page should have    ELEMENT|//h2[.='Upcoming']${link}/following::a[.='Start']

Modify rounds for commenting
  Editing "rounds" test template
  ${left start} =    Get Text    //select[@id='${ROUNDS FORM START TIME HR}']/option[@selected='selected']
  ${right start} =    Get Text    //select[@id='${ROUNDS FORM START TIME MIN}']/option[@selected='selected']
  ${start time} =    Subtract Time From Date    ${Todays Date} ${left start} ${right start}    2m
                     ...                        date_format=%Y-%m-%d %I %p %M
  ${left start}    ${right start}    ${left end}    ${right end}    ${day} =    From start time to later    ${start time}
                                                                                ...                         10m
  Form fill    rounds form    start time hr:dropdown=${left start}    start time min:dropdown=${right start}
  ...          ${day}:checkbox=x    enabled:checkbox=x    vitals:checkbox=o    weight:checkbox=o    glucose:checkbox=o
  ...          locations:dropdown=${_LOCATION 1}    end time hr:dropdown=${left end}    interval mins:dropdown=10
  ...          end time min:dropdown=${right end}
  Save "rounds" template

Check for comments in the active round
  ${round dialog} =    Set Variable    //div[@id='patient-observation-vitals-dialog']
  Click Element    //td[contains(text(),'Pocky House Forevja')]/parent::tr[1]//a
  Ajax wait
  Click Element    //span[@name='patient_name' and contains(text(),'${Test First}')]/ancestor::form[1]/div[@class='col-sm-2']/a
  Ajax wait
  Select From List By Label    ${round dialog}/div/form//select[@name='patient_observation[activity]']    Sleeping In
  Select From List By Label    ${round dialog}/div/form//select[@name='patient_observation[location]']    Hallway
  Input Text    patient_observation_comment    mexevomatch
  Click Element    ${round dialog}/following-sibling::div[last()]//span[.='Observe']
  Ajax wait

Check for comments in the rounds overview
  ${round view} =    Set Variable    //td[contains(text(),'Pocky House Forevja')]/following-sibling::td[last()]/a
  ${round overview} =    Get Element Attribute    ${round view}    href
  Click Element    ${round view}
  Ajax wait
  Click Element    //div[@id='round_observation_${round overview.rsplit('/',1)[1]}-list']/table/tbody/tr/td[last()]/a
  Ajax wait
  Page should have    ELEMENT|//textarea[@id='patient_observation_comment' and not(@disabled) and contains(.,'mexevomatch')]
