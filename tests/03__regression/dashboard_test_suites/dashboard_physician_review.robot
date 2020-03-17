*** Settings ***
Documentation   Overview of all lab orders and results.
...
Default Tags    regression    re003    dashboard story    notester    hasprint
Resource        ../../../suite.robot
Suite Setup     Setup for physician review
Suite Teardown  Run Keywords    Turning "off" the "Doctor" roles for "admin"
...                             Return to mainpage

*** Test Cases ***
Change pages
  [TAGS]    missing
  Given I am on the "dashboard" page

Sort orders by patient
  Given I am on the "dashboard" page
  And I hit the "All Orders" text
  When I hit column "1" sort
  Then order for column is good    Patient    ${EMPTY}    Select

Sort orders by order
  Given I am on the "dashboard" page
  And I hit the "All Orders" text
  When I hit column "2" sort
  Then order for column is good    Order

Sort orders by date
  Given I am on the "dashboard" page
  And I hit the "All Orders" text
  When I hit column "3" sort
  # Then order for column is good    date    ${false}
  # Then order for column is good
  Then order for column is good    Date    date=%m/%d/%Y %I:%M %p=Start: =\\n
  # 07/27/2017 03:30 PM

Sort orders by status
  Given I am on the "dashboard" page
  And I hit the "All Orders" text
  When I hit column "4" sort
  Then order for column is good    Status

Scroll up
  Given I am on the "dashboard" page
  And I select the "My Locations" location
  When scrolling down
  And I hit the "top" tab
  Then Location Should Contain    \#

Print/pdf
  [TAGS]    hasprint
  Given I am on the "dashboard" page
  And I select the "My Locations" location
  When I hit the "print" tab
  And Sleep    2
  And Unselect Frame
  Then Title Should Be    Print

Select a test result
  [TAGS]    missing
  Given I am on the "dashboard" page
  When I hit the "Lab Test Results" text
  And I hit the "${_PATIENT 9}" text
  Then page should have    ${_PATIENT 9 NAME SEG 1}    ${_PATIENT 9 NAME SEG 2}
  [TEARDOWN]    Go Back

Scroll up in test results
  [TAGS]    missing
  Given I am on the "dashboard" page
  # And I select the "My Locations" location
  When scrolling down
  And I hit the "top" tab
  Then Location Should Contain    \#

Print/pdf in test results
  [TAGS]    hasprint
  Given I am on the "dashboard" page
  And I select the "My Locations" location
  When I hit the "print" tab
  And Sleep    2
  And Unselect Frame
  Then Title Should Be    Print

Sort test results by patient
  [TAGS]    missing
  Given I am on the "dashboard" page
  And I hit the "Lab Test Results" text
  When I hit column "1" sort
  Then order for column is good

Sort test results by document type
  [TAGS]    missing
  Given I am on the "dashboard" page
  And I hit the "Lab Test Results" text
  When I hit column "2" sort
  Then order for column is good

Sort test results by specimen id
  [TAGS]    missing
  Given I am on the "dashboard" page
  And I hit the "Lab Test Results" text
  When I hit column "3" sort
  Then order for column is good

Sort test results by vendor
  [TAGS]    missing
  Given I am on the "dashboard" page
  And I hit the "Lab Test Results" text
  When I hit column "4" sort
  Then order for column is good

Sort test results by specimen source
  [TAGS]    missing
  Given I am on the "dashboard" page
  And I hit the "Lab Test Results" text
  When I hit column "5" sort
  Then order for column is good

Sort test results by collected
  [TAGS]    missing
  Given I am on the "dashboard" page
  And I hit the "Lab Test Results" text
  When I hit column "6" sort
  Then order for column is good    date

Sort test results by completed
  [TAGS]    missing
  Given I am on the "dashboard" page
  And I hit the "Lab Test Results" text
  When I hit column "7" sort
  Then order for column is good    date

Sort test results by status
  [TAGS]    missing
  Given I am on the "dashboard" page
  And I hit the "Lab Test Results" text
  When I hit column "8" sort
  Then order for column is good

Sort test results by review
  [TAGS]    missing
  Given I am on the "dashboard" page
  And I hit the "Lab Test Results" text
  When I hit column "9" sort
  Then order for column is good    number

Select a order
  Given I am on the "dashboard" page
  When I hit the "All Orders" text
  And I hit the "${_ITEM 3}" text
  And page should have    ${_PATIENT 8 NAME SEG 1}    ${_PATIENT 8 NAME SEG 2}    ${_PATIENT 8 NAME SEG 3}
  And Go Back
  And I hit the "${_PATIENT 8}" text
  Then page should have    ${_ITEM 3 SEG 1}    ${_ITEM 3 SEG 2}    ${_ITEM 3 SEG 3}
  [TEARDOWN]    Go Back

*** Keywords ***
Setup for physician review
  Turning "off" the "Doctor" roles for "admin"
  Return to mainpage
  I hit the "dashboard" tab
  I hit the "Physician Review" view
  ${comeback} =    Get Location
  Set Suite Variable    ${Comeback}    ${comeback}
  Page Should Not Contain    My Orders
  Turning "on" the "Doctor" roles for "admin"
  # I hit the "username" tab
  # Form fill    new user    Doctor:checkbox=x
  # Click Button    Update
  # Ajax wait
  Go To    ${Comeback}
  Page Should Contain    My Orders
  I select the "My Locations" location

# Turn off the docter role
#   Return to mainpage
#   I hit the "username" tab
#   Form fill    new user    Doctor:checkbox=o
#   Click Button    Update
#   Ajax wait

I hit column "${col}" sort
  Click Element    //tr[position()=1]/th[position()=${col}]/a
  Ajax wait
  # Set Test Variable    ${Col}    ${col}

Select
  [ARGUMENTS]    ${row}
  ${fit} =    Get Length    ${row}
  ${row} =    Run Keyword If    ${fit}>1    Get Line    ${row}    0
              ...               ELSE           Set Variable    null
  ${row} =    Run Keyword If    '${row}'!='null' and ${row.find('Warning:')}==-1    Catenate    SEPARATOR=;    pass
              ...                                                                   ${row}
              ...               ELSE                                                Catenate    SEPARATOR=;    fail
              ...                                                                   ${row}
  [RETURN]    ${row}

# Order for column is good
#   [ARGUMENTS]    ${filter}=${EMPTY}    ${link}=${true}
#   ${table} =    Get Webelement    //tbody
#   ${row} =    Run Keyword If    ${link}    Set Variable    ${table.find_elements_by_css_selector('tr>td:nth-child(${col}) a')}
#               ...               ELSE       Set Variable    ${table.find_elements_by_css_selector('tr>td:nth-child(${col}) div')}
#   @{my set} =    Create List    ${EMPTY}
#   :FOR    ${r}    IN    @{row}
#   \    ${r} =    Fetch From Left    ${r.get_attribute('innerHTML')}    <
#   \    ${r} =    Run Keyword If    '${filter}'=='date'    Convert date to epoch    ${r}    ${link}
#   \    ...       ELSE IF           '${filter}'=='number'  Convert To Integer    ${r}
#   \    ...       ELSE                                     Convert To Lowercase    ${r}
#   \    Append To List    ${my set}    ${r}
#   Remove From List    ${my set}    0
#   @{ordered set} =    Copy List    ${my set}
#   Sort List    ${ordered set}
#   :FOR    ${m}    ${o}    IN ZIP    ${my set}    ${ordered set}
#   \    Run Keyword And Continue On Failure    Should Be Equal As Strings    ${m}    ${o}
#
# Convert date to epoch
#   [ARGUMENTS]    ${date}    ${link}
#   ${date} =    Run Keyword If    ${link}    Convert Date    ${date}    epoch    date_format=%m/%d/%Y
#                ...               ELSE       Extended convert date to epoch    ${date}
#   [RETURN]    ${date}
#
# Extended convert date to epoch
#   [ARGUMENTS]    ${date}
#   ${date} =    Line parser    ${date}    2
#   ${date} =    Convert Date    ${date}    epoch    date_format=%m/%d/%Y %H:%M %p
#   [RETURN]    ${date}
