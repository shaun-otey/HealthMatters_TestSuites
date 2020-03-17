*** Settings ***
Documentation   Do searching on a patient that has appointments.
...
Default Tags    regression    re021    points-1    patient chart story    addmore
Resource        ../../suite.robot
Suite Setup     Run Keywords    Create an appointment
...                             Travel "slow" to "tester" patients "appointments" page in "null"
Suite Teardown  Return to mainpage
Test Teardown   Run Keywords    Run Keyword If Test Failed    Custom screenshot
...             AND             I hit the "appointments" patient tab

*** Test Cases ***
Check search results
  Given I am on the "appointments" patient page
  When entering search date range
  Then confirm results are in range

# Change an appointment
#   Given I am on the "appointments" patient page
#   When entering search date range
#   Then confirm results are in range

Click scroll to top
  Given I am on the "appointments" patient page
  When scrolling down
  And I hit the "top" tab
  Then Location Should Contain    \#

*** Keywords ***
Create an appointment
  Travel "fast" to "tester" patients "information" page in "${_LOCATION 1}"
  ${patient} =    Get Text    //h2[contains(text(),'${Patient Handle} Information')]/following-sibling::div[1]/p[1]
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
  Form fill    new appointment    providers:enter_text=${provider}    patients:enter_text=${patient.split()[0]}
  ${dates start search} =    Get the date now    ${NEW APPOINTMENT START DATE TIME}
  ${dates end search} =    Add thirty to appointment    ${dates start search}
  @{dates} =    Create List    ${dates start search}    ${dates end search}
  Set Suite Variable    ${Dates group}    ${dates}
  Run Keyword And Ignore Error    Click Element    ${NEW APPOINTMENT}/div[@class='modal-footer']/button[@type='submit']
  Ajax wait
  Run Keyword And Ignore Error    Click Button    save-anyway
  Slow wait

Get the date now
  [ARGUMENTS]    ${date field}
  Click Element    ${date field}
  Wait Until Element Is Visible    //button[@data-handler='today']
  Click Element    //button[@data-handler='today']
  ${date} =    Execute Javascript    return document.getElementById("${date field}").value
  Form fill    ${EMPTY}    ${date field}:direct_js=${date}
  Blur element    ${date field}
  [RETURN]    ${date}

Add thirty to appointment
  [ARGUMENTS]    ${date}
  ${date} =    Add Time To Date    ${date}    30 minutes    %m/%d/%Y %I:%M %p    False    %m/%d/%Y %I:%M %p
  [RETURN]    ${date}

Entering search date range
  ${date} =    Convert Date    ${Todays Date}    result_format=%m/%d/%Y
  Form fill    ${EMPTY}    appt-start-date:direct_js=@{Dates group}[0]    appt-end-date:direct_js=@{Dates group}[1]
  Click Element    //button[@type='submit']
  Ajax wait

Confirm results are in range
  @{times} =    Get Webelements    //div[@id='appointments_table']//li
  FOR    ${time}    IN    @{times}
      ${day} =    Line parser    ${time.find_element_by_tag_name('span').get_attribute('innerHTML')}    0
      ${day} =    Fetch From Right    ${day}    day,${SPACE}
      Inner loop    ${time}    ${day}
  END

Inner loop
  [ARGUMENTS]    ${out}    ${day}
  ${start point} =    Convert Date    @{Dates group}[0]    epoch    False    %m/%d/%Y %I:%M %p
  ${end point} =    Convert Date    @{Dates group}[1]    epoch    False    %m/%d/%Y %I:%M %p
  ${out} =    Set Variable    ${out.find_elements_by_css_selector('table>tbody>tr')}
  FOR    ${time}    IN    @{out}
      ${time} =    Line parser    ${time.find_element_by_css_selector('td:nth-child(2)').get_attribute('innerHTML')}
                   ...            1
      ${time} =    Convert Date    ${day} ${time.split('M ')[0]}M    epoch    date_format=%b${SPACE}%d, %Y %I:%M %p
      Run Keyword And Continue On Failure    Should Be True    ${start point}<=${time}<=${end point}
  END
