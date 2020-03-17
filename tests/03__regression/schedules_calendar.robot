*** Settings ***
Documentation   Entire calendar functionality.
...
Default Tags    regression    re012    points-5    hasprint    addmore    exceptions
Resource        ../../suite.robot
Suite Setup     Run Keywords    Travel "slow" to "tester" patients "information" page in "${_LOCATION 1}"
...                             I hit the "schedules" tab
...                             I hit the "calendar" tab
...                             Setup calendar
Suite Teardown  Run Keywords    Toggle all providers    ${true}
...             AND             I select the test appointment
...             AND             Manage this appointment    delete    ${Test appt}
...             AND             Return to mainpage
Test Teardown   Run Keywords    Run Keyword If Test Failed    Custom screenshot
...             AND             Run Keyword If    'blur' in '${Toggle at}'    Run Keyword And Ignore Error
...                                                                           Blur element
...                                                                           //form[@class='edit_appointment']
...             AND             Run Keyword If    'start' in '${Toggle at}'    Toggle all providers
...             AND             Go To    ${BASE URL}${CALENDAR}
...             AND             Slow wait
...             AND             Pressing the "today" view button
...             AND             I am on the "calendar" page
...             AND             Run Keyword If    'end' in '${Toggle at}'    Toggle all providers
...             AND             Set Suite Variable    ${Toggle at}    null

*** Test Cases ***
User can search calendar through the search box
  [SETUP]    Run Keywords    Toggle all providers
  ...        AND             Set Suite Variable    ${Toggle at}    start
  Given I am on the "calendar" page
  And calendar is empty
  When filtering by "search" for "${Test First}"
  Then page should have    ${Test First}    ${Test Middle}    ${Test Last}
  And Page Should Contain Link    /kae/appointments/${Test appt}/edit

User can select specific provider to only generate appointments for that provider
  [SETUP]    Run Keywords    Toggle all providers
  ...        AND             Set Suite Variable    ${Toggle at}    start
  Given I am on the "calendar" page
  And calendar is empty
  When filtering by "provider" for "${Main provider}"
  Then page should have    ${Test First} ${Test Middle}    ${Test Last} - ${Main provider}
  And Page Should Contain Link    /kae/appointments/${Test appt}/edit

User can select calendar synchronization to set up outlook synchronization
  [TAGS]    skip
  Given I am on the "calendar" page
  Then Fail    No calendar synchronization in view!
User can select Personal Settings to customize the calendar. User can select from drop down slot minutes, First hour start time, Slot event overlap, Default view ( day, week, or month), Default duration, and Height. User can update these fields or close.
  [TAGS]    skip
  Given I am on the "calendar" page

User can export to excel and select timeframe from and to by typing date or clicking on calendar
  [TAGS]    hasprint
  Given I am on the "calendar" page
User may select export or close window
  [TAGS]    hasprint
  Given I am on the "calendar" page

User may select month and see how to view calendar and toggle through it with the back and forward arrows
  [SETUP]    Run Keywords    Toggle all providers
  ...        AND             Set Suite Variable    ${Toggle at}    end
  Given I am on the "calendar" page
  And calendar is empty
  When pressing the "month" view button
  Then the view is "all month"
  And moving forward and back in "month" view will be correct

User may select week and see how to view calendar and toggle through it with the back and forward arrows
  [SETUP]    Run Keywords    Toggle all providers
  ...        AND             Set Suite Variable    ${Toggle at}    end
  Given I am on the "calendar" page
  And calendar is empty
  When pressing the "week" view button
  Then the view is "all week"
  And moving forward and back in "week" view will be correct

User may select day and see how to view calendar and toggle through it with the back and forward arrows
  [SETUP]    Run Keywords    Toggle all providers
  ...        AND             Set Suite Variable    ${Toggle at}    end
  Given I am on the "calendar" page
  And calendar is empty
  When pressing the "day" view button
  Then the view is "all day"
  And moving forward and back in "day" view will be correct

User may view appointments with the list view and edit an appointment
  Given I am on the "calendar" page
  When switching to the list view
  And I hit the "Edit" view
  And slow wait
  Then page should have    ELEMENT|//form[@class='edit_appointment']

User can create an appointment by selecting a provider
  [SETUP]    Toggle all providers    ${true}
  Given I am on the "calendar" page
  When I create an appointment by provider    ${Main provider}
  And I select the provider appointment
  Then confirm "Providers:multi" update has "${Main provider}"
  And confirm "Patients:multi" update has "${_PATIENT 4 NAME SEG 1}"
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Go To    ${BASE URL}${CALENDAR}
  ...           AND             Slow wait
  ...           AND             Pressing the "today" view button
  ...           AND             I am on the "calendar" page
  ...           AND             I select the provider appointment
  ...           AND             Manage this appointment    delete
  ...           AND             Toggle all providers

User can add/or edit provider by typing in name and selecting provider
  [TAGS]    bugged    i keep old input
  Given I am on the "calendar" page
  When I select the test appointment
  And remove "Providers" and add "${_PROVIDER 2 NAME SEG 1};${_PROVIDER 3 NAME SEG 1}"
  And update the test appointment
  Then I select the test appointment
  And confirm "Providers:multi" update has "${_PROVIDER 2};${_PROVIDER 3}"
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Remove "Providers" and add "${Main provider[0:3]}"
  ...           AND             Update the test appointment
  ...           AND             Go To    ${BASE URL}${CALENDAR}
  ...           AND             Slow wait
  ...           AND             Pressing the "today" view button
  ...           AND             I am on the "calendar" page
User can add/or edit patient by typing in name and selecting patient
  [TAGS]    bugged    i keep old input
  Given I am on the "calendar" page
  When I select the test appointment
  And remove "Patients" and add "...,..."
  And update the test appointment
  Then I select the test appointment
  And confirm "Patients" update has "..."
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Remove "Patients" and add "${_PATIENT 6 NAME SEG 4}"
  ...           AND             Update the test appointment
  ...           AND             Go To    ${BASE URL}${CALENDAR}
  ...           AND             Slow wait
  ...           AND             Pressing the "today" view button
  ...           AND             I am on the "calendar" page
User can add/or edit start date and time by using drop down calendar
  [TAGS]    bugged    i only change time, not date
  Given I am on the "calendar" page
  When I select the test appointment
  And move the date by "1" days and "2" hours
  And update the test appointment
  Then I select the test appointment
  #And ...

User can change appointment type in appointment type dropdown
  [SETUP]    Run Keywords    Toggle all providers    ${true}
  ...        AND             Set Suite Variable    ${Toggle at}    blur start
  Given I am on the "calendar" page
  When I select the test appointment
  And form fill    new appointment    type:dropdown=Intervention
  And update the test appointment
  And toggle all providers
  And calendar is empty
  Then filtering by "views" for "Intervention"
  And page should have    ${Test First} ${Test Middle} ${Test Last} -
  And I select the test appointment
  And confirm "type:dropdown" update has "Intervention"

User can change status in status dropdown but cannot view it without a provider selected
  [SETUP]    Run Keywords    Toggle all providers    ${true}
  ...        AND             Set Suite Variable    ${Toggle at}    blur start
  Given I am on the "calendar" page
  And I select the test appointment
  When form fill    new appointment    status:dropdown=Remind
  And update the test appointment
  And toggle all providers
  And calendar is empty
  Then filtering by "statuses" for "Remind"
  And Run Keyword And Expect Error    *    page should have    ${Test First} ${Test Middle} ${Test Last} -

User can change status in status dropdown and view it when a provider is selected
  [SETUP]    Run Keywords    Toggle all providers    ${true}
  ...        AND             Set Suite Variable    ${Toggle at}    blur start
  Given I am on the "calendar" page
  And I select the test appointment
  When form fill    new appointment    status:dropdown=No Show
  And update the test appointment
  Then filtering by "statuses" for "No Show"
  And page should have    ${Test First} ${Test Middle} ${Test Last} -
  When I select the test appointment
  Then status confirm update has "No Show"
  And confirm "status:dropdown" update has "No Show"

User can slide off and on to make an appointment billable or non billable
  Given I am on the "calendar" page
  And I select the test appointment
  When form fill    new appointment    billable:click=x
  And update the test appointment
  And I select the test appointment
  Then confirm "billable:click" update has "on"
  When form fill    new appointment    billable:click=x
  And update the test appointment
  And I select the test appointment
  Then confirm "billable:click" update has "off"

User can slide off and on to make an appointment all day event
  [SETUP]    Run Keywords    Toggle all providers    ${true}
  ...        AND             I create an appointment by day
  Given I am on the "calendar" page
  And I select the default appointment
  When form fill    new appointment    all day:click=x
  And manage this appointment    update
  Then Element Should Be Visible    //a[${CSS SELECT.replace('$CSS','fc-day-grid-event')}]
  When I select the all day appointment
  And form fill    new appointment    all day:click=x
  And manage this appointment    update
  Then Element Should Not Be Visible    //a[${CSS SELECT.replace('$CSS','fc-day-grid-event')}]
  And page should have    ELEMENT|//div[@class='fc-time' and data-start='12:00AM' and data-full='12:00 AM']
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Go To    ${BASE URL}${CALENDAR}
  ...           AND             Slow wait
  ...           AND             Pressing the "today" view button
  ...           AND             I am on the "calendar" page
  ...           AND             I select the default appointment
  ...           AND             Manage this appointment    delete
  ...           AND             Go To    ${BASE URL}${CALENDAR}
  ...           AND             Slow wait
  ...           AND             Pressing the "today" view button
  ...           AND             I am on the "calendar" page
  ...           AND             Toggle all providers

User has ability to make notes
  Given I am on the "calendar" page
  And I select the test appointment
  When form fill    new appointment    notes=the calendar testing nightmare
  And update the test appointment
  Then I select the test appointment
  And confirm "notes" update has "the calendar testing nightmare"

User has ability to make appointment recurring through recurring rule
  [TAGS]    combine
  [DOCUMENTATION]    daily, weekly on weekends, weekly on weekdays,
  ...                weekly on Monday, Wednesday, Fridays, Monthly on the 15th of the month,
  ...                Monthly on the 1st and 15th of the month, or Custom Schedule
  Given I am on the "calendar" page
  When I select the test appointment
  And form fill    ...
  And update the test appointment
  Then I select the test appointment
  And ...
User has ability to select recurring end time.
  [TAGS]    combine
  Given I am on the "calendar" page
  When I select the test appointment
  And form fill    ...
  And update the test appointment
  Then I select the test appointment
  And ...
User may slide recurring until discharge on or off.
  [TAGS]    combine
  Given I am on the "calendar" page
  When I select the test appointment
  And form fill    ...
  And update the test appointment
  Then I select the test appointment
  And ...

User can click on client name to go into chart to see appointment tab
  Given I am on the "calendar" page
  And I select the test appointment
  When Click Link    //a[contains(text(),'${Test First}')]
  And slow wait
  Then page should have    Appointments    ${Test First}    ${Test Middle}    ${Test Last}
  And I am on the "appointments" patient page

User can click on mr number, diagnosis code, and loc to see client information
  [TAGS]    not in hm
  Given I am on the "calendar" page
  And I select the test appointment
  When Click Link    //a[contains(text(),'MIFL')]
  # And parse current id
  Then page should have    Appointments    ${Test First}    ${Test Middle}    ${Test Last}
  And I am on the "appointments" patient page
# User may click on SMS to send text message once an appointment has been created and saved.
#   Given I am on the "calendar" page
# User can select YES to send message or cancel not to send. If user selects YES, than user will be notified that message was sent.
#   Given I am on the "calendar" page

*** Keywords ***
Setup calendar
  I am on the "calendar" page
  Slow wait
  Pressing the "week" view button
  Pressing the "today" view button
  ${provider} =    Get Text    //ul[@id='schedulers_list']/li[1]
  Set Suite Variable    ${Main provider}    ${provider}
  Toggle all providers    ${true}
  Set Suite Variable    ${Toggle at}    null
  Create tester appointment

Pressing the "${selector}" view button
  ${selector} =    Set Variable If    '${selector}'=='month'    fc-month-button
                   ...                '${selector}'=='week'     fc-agendaWeek-button
                   ...                '${selector}'=='day'      fc-simpleAgendaDay-button
                   ...                '${selector}'=='today'    fc-today-button
                   ...                '${selector}'=='left'     fc-prev-button
                   ...                '${selector}'=='right'    fc-next-button
                   ...                True                      fc-timelineDay-button
  Click Element    //button[${CSS SELECT.replace('$CSS','${selector}')}]
  Slow wait

Toggle all providers
  [ARGUMENTS]    ${show}=null
  ${passes} =    Run Keyword And Return Status    Calendar is empty
  Run Keyword If    '${show}'=='null' or ${show}==${passes}    Click Link    all-btn
  Slow wait

Calendar is empty
  Element Should Not Be Visible    //a[${CSS SELECT.replace('$CSS','fc-time-grid-event')} or ${CSS SELECT.replace('$CSS','fc-day-grid-event')}]

Get offset
  [ARGUMENTS]    ${time}
  ${day} =    Get Horizontal Position    //td[@data-date='${Todays Date}']
  ${offset} =    Get Horizontal Position    //tr[@data-time='${time}:00']
  ${time}    ${TRASH} =    Get Element Size    //tr[@data-time='${time}:00']
  ${offset} =    Evaluate    5+${day}-${offset}-${time}/2
  [RETURN]    ${offset}

Create tester appointment
  ${test appt} =    I create an appointment by day    06:00
  Click Element At Coordinates    //tr[@data-time='06:00:00']    ${test appt}    0
  Ajax wait
  Wait Until Page Contains Element    //form[@class='edit_appointment']
  ${test appt} =    Get Element Attribute    //form[@class='edit_appointment']    id
  ${test appt} =    Remove String    ${test appt}    edit_appointment_
  Set Suite Variable    ${Test appt}    ${test appt}
  Set Suite Variable    ${Div save}    /div[4]/div[3]/div[2]/div/a[1]
  Form fill    new appointment    patients:enter_text=${Test First}    type:dropdown=Doctor\'s Appt
  Update the test appointment

I create an appointment by day
  [ARGUMENTS]    ${time}=01:15
  ${x} =    Get offset    ${time}
  ${date} =    Convert Date    ${Todays Date}    result_format=%m/%d/%Y
  Click Element At Coordinates    //tr[@data-time='${time}:00']    ${x}    0
  Ajax wait
  ${p}    ${TRASH} =    Split String    ${time}    :
  ${p} =    Convert To Integer    ${p}
  ${p} =    Set Variable If    ${p}<12    AM    PM
  Page should have    ELEMENT|//input[@value='${date} ${time} ${p}']
  Form fill    new appointment    providers:enter_text=${Main provider[0:3]}
  Confirm appointment creation
  [RETURN]    ${x}

I create an appointment by provider
  [ARGUMENTS]    ${provider}
  Click Element    //a[@title='Create appointment with ${provider}']
  Ajax wait
  Page should have    ELEMENT|//p[.='${provider}']
  ${date} =    Convert Date    ${Todays Date}    result_format=%m/%d/%Y
  Form fill    new appointment    start date time:js=${date} 02:00 AM    end date time:js=${date} 02:22 AM
  ...          patients:enter_text=${_PATIENT 4 NAME SEG 1}
  Confirm appointment creation

Confirm appointment creation
  Run Keyword And Ignore Error    Click Element    ${NEW APPOINTMENT}/div[@class='modal-footer']/button[@type='submit']
  Ajax wait
  Run Keyword And Ignore Error    Click Button    save-anyway
  Slow wait

I select the test appointment
  Click Link    /kae/appointments/${Test appt}/edit
  Slow wait

I select the default appointment
  [ARGUMENTS]    ${time}=01:15
  ${x} =    Get offset    ${time}
  Click Element At Coordinates    //tr[@data-time='${time}:00']    ${x}    0
  Slow wait

I select the provider appointment
  I select the default appointment    02:00

I select the all day appointment
  ${x} =    Get offset    00:00
  Click Element At Coordinates    //div[@class='fc-content-skeleton']/table/tbody/tr    ${x}    0
  Slow wait

Manage this appointment
  [ARGUMENTS]    ${action}    ${id}=${EMPTY}
  Run Keyword If    '${action}'=='update'    Click Button    appt-update
  ...    ELSE IF    '${action}'=='delete'    Click Element    appt-delete
  Run Keyword And Ignore Error    Click Element    //*[starts-with(@id,'edit_appointment_${id}')]${Div save}
  Slow wait    3
  Run Keyword And Ignore Error    Click Element    //*[starts-with(@id,'edit_appointment_${id}')]${Div save}
  Ajax wait
  Run Keyword And Ignore Error    Click Button    save-anyway
  Slow wait

Update the test appointment
  Manage this appointment    update    ${Test appt}

Filtering by "${type}" for "${search}"
  Run Keyword If    '${type}'=='providers'    Click Element    //a[@title='Show appointments for ${search}']
  ...    ELSE IF    '${type}'=='views'        Click Element    //a[@title='Show ${search} appointments']
  ...    ELSE IF    '${type}'=='statuses'     Click Element    //a[@title='Show appointments of status ${search}']
  ...               ELSE                      Run Keywords    Input Text    filters_query    ${search.split()[0]}
  ...                                         AND             Click Element    //button[@type='submit']
  Slow wait

The view is "${all}"
  ${date} =    Convert Date    ${Todays Date}    %a
  Run Keyword If    '${all}'=='all day'    Run Keywords    Pressing the "today" view button
  ...                                      AND             Page should have    ${date}
  ...               ELSE                   Page should have    Sun    Mon    Tue    Wed    Thu    Fri    Sat
  Run Keyword If    '${all}'=='all month'    Page should have    NOT|All day
  ...               ELSE                     Page should have    All day

Moving forward and back in "${view}" view will be correct
  ${timecheck} =    Run Keyword If    '${view}'=='day'     Convert Date    ${Todays Date}    %B %d, %Y
                    ...    ELSE IF    '${view}'=='week'    Convert Date    ${Todays Date}    %a %m/%d
                    ...               ELSE                 Convert Date    ${Todays Date}    %B %Y
  ${future} =    Run Keyword If    '${view}'=='day'     Add Time To Date    ${Todays Date}    1d    %B %d, %Y
                 ...    ELSE IF    '${view}'=='week'    Add Time To Date    ${Todays Date}    7d    %a %m/%d
                 ...               ELSE                 Add Time To Date    ${Todays Date}    28d    %B %Y
  Page should have    ${timecheck.replace(' 0',' ')}
  Pressing the "right" view button
  Page should have    ${future.replace(' 0',' ')}
  Pressing the "left" view button
  Page should have    ${timecheck.replace(' 0',' ')}

Switching to the list view
  ${wait done} =    Set Variable    //a[${CSS SELECT.replace('$CSS','edit-appointment')}]
  Click Element    //span[@title='List view']
  ${passes} =    Run Keyword And Return Status    Wait Until Page Contains Element    ${wait done}    1m
  Run Keyword Unless    ${passes}    Run Keywords    Reload Page
  ...                                AND             Slow wait
  ...                                AND             Click Element    //span[@title='List view']
  ...                                AND             Wait Until Page Contains Element    ${wait done}    1m
  Slow wait

Confirm "${item}" update has "${change}"
  ${input} =    Fetch From Right    ${item}    :
  ${item} =    Fetch From Left    ${item}    :
  Run Keyword If    '${input}'=='dropdown'    Element Should Contain
  ...                                         //*[@id='${NEW APPOINTMENT ${item}}']/option[@selected='selected']
  ...                                         ${change}
  ...    ELSE IF    '${input}'=='multi'       Multi confirm    ${item}    ${change}
  ...    ELSE IF    '${input}'=='click'       Click confirm    ${change}
  ...               ELSE                      Element Should Contain    ${NEW APPOINTMENT ${item}}    ${change}

Multi confirm
  [ARGUMENTS]    ${type}    ${changes}
  ${type} =    Set Variable If    '${type}'=='Patients'    ${Patient Handle}s    ${type}
  @{changes} =    Split String    ${changes}    ;
  FOR    ${i}    ${change}    IN ENUMERATE    @{changes}
      ${i} =    Evaluate    ${i}+1
      Element Should Contain    //label[@for='${type}']/following-sibling::ul/li[${i}]/p    ${change}
  END

Click confirm
  [ARGUMENTS]    ${change}
  Run Keyword If    '${change}'=='on'    Page should have    ELEMENT|//form[@id='edit_appointment_${Test appt}']//span[@class='status badge billable']
  ...               ELSE                 Page should have    NOT|ELEMENT|//form[@id='edit_appointment_${Test appt}']//span[@class='status badge billable']

Remove "${type}" and add "${names}"
  ${remove} =    Set Variable    //label[@for='${type}']/following-sibling::ul//span[@class='token-input-delete-token-mac']
  ${count} =    Get Element Count    ${remove}
  Repeat Keyword    ${count}    Click Element    ${remove}\[1]
  @{names} =    Split String    ${names}    ;
  FOR    ${name}    IN    @{names}
      Form fill    new appointment    ${type}:enter_text=${name}
  END

Move the date by "${days}" days and "${hours}" hours
  ${date} =    Add Time To Date    ${Todays Date}    ${days}d    %m/%d/%Y
  ${time} =    Evaluate    6+${hours}
  Form fill    new appointment    start date time:js=${date} ${time}:00 AM    end date time:js=${date} ${time}:30 AM

Status confirm update has "${status}"
  Slow wait
  Element Should Contain    //span[@class='status badge ']/ancestor::h4[1]    ${status}
