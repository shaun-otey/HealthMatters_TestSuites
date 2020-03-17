*** Settings ***
Documentation   Basic client side functionality.
...
Default Tags    regression    re001    points-9    hasprint
Resource        ../../suite.robot
Suite Setup     Prepare dummy patients
Suite Teardown  Remove dummy patients
Test Teardown   Run Keywords    Custom screenshot
...                             Return to mainpage

*** Test Cases ***
Change location view
  Given I am on the "patients" page
  When I select the "${_LOCATION 3}" location
  Then I am on the "patients" page
  [TEARDOWN]    Run Keywords    Custom screenshot
  ...                           Return to mainpage
  ...                           I select the "${_LOCATION 1}" location

Should show errors on invalid patient create
  Given I am on the "patients" page
  When I create an invalid patient    badauto    the    fail    08/08/2015
  Then Page Should Contain    Errors found
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Remove this patient    badauto the fail

Click on patient's chart by index in tile view
  Given I am on the "patients" page
  And toggle to "tile" view
  When I select patient "2"
  Then I will see that patient's information

Click on patient's chart by index in list view
  Given I am on the "patients" page
  And toggle to "list" view
  When I select patient "3"
  Then I will see that patient's information

Click on patient's chart by name in tile view
  Given I am on the "patients" page
  And toggle to "tile" view
  When I select patient "${Test first}"
  Then I will see that patient's information

Click on patient's chart by name in list view
  Given I am on the "patients" page
  And toggle to "list" view
  When I select patient "${Test first}"
  Then I will see that patient's information

Toggle between list and tile view
  Given I am on the "patients" page
  When toggle view
  And figure out what view style I am in
  And I am on this view style
  And toggle view
  And figure out what view style I am in
  Then I am on this view style

Print and pdf
  [TAGS]    hasprint
  Fail    Test not ready!

Click pre-admission view
  Given I am on the "patients" page
  When I hit the "Pre-Admission" view
  Then current page "does not" have mr numbers

Click current view
  Given I am on the "patients" page
  When I hit the "Current" view
  Then current page "does" have mr numbers

Click arriving today
  Given I am on the "patients" page
  When filtering patients that are "Arriving Today"
  Then page should have    &{Name verify}[Arriver A]    &{Name verify}[Discharger C]    &{Name verify}[Discharger D]    &{Name verify}[Reviewer E]

Click arriving tomorrow
  Given I am on the "patients" page
  When filtering patients that are "Arriving Tomorrow"
  Then page should have    &{Name verify}[Arriver B]    &{Name verify}[Pender I]

Click discharging today
  Given I am on the "patients" page
  When filtering patients that are "Discharging Today"
  Then page should have    &{Name verify}[Discharger C]

Click discharging tomorrow
  Given I am on the "patients" page
  When filtering patients that are "Discharging Tomorrow"
  Then page should have    &{Name verify}[Discharger D]    &{Name verify}[Pender H]

Review today (concurrent review)
  Given I am on the "patients" page
  When filtering patients that are "Review Today"
  Then page should have    &{Name verify}[Reviewer E]

Review tomorrow (concurrent review)
  Given I am on the "patients" page
  When filtering patients that are "Review Tomorrow"
  Then page should have    &{Name verify}[Reviewer F]

Review past due (concurrent review)
  Given I am on the "patients" page
  When filtering patients that are "Review Past Due"
  Then page should have    &{Name verify}[Reviewer G]

Click pending admission
  Given I am on the "patients" page
  When filtering patients that are "Pending Admission"
  Then page should have    &{Name verify}[Pender H]

Click pending discharge
  Given I am on the "patients" page
  When filtering patients that are "Pending Discharge"
  Then page should have    &{Name verify}[Pender I]    &{Name verify}[Arriver A]    &{Name verify}[Arriver B]    &{Name verify}[Reviewer E]    &{Name verify}[Reviewer F]    &{Name verify}[Reviewer G]

Search
  Given I am on the "patients" page
  When searching for "${Test first}"
  Then current page have the names "${Test first}"

Click chart audit view
  Given I am on the "patients" page
  When I hit the "Chart Audit" view
  Then page should have    &{Name verify}[Charter J]

Click different program views
  Given I am on the "patients" page
  And go get the "patient programs" options
  When I select the "My Locations" location
  And I hit the "${_PROGRAM FILTER 4}" view
  Then the "${_PROGRAM FILTER 4}" filter will work
  [TEARDOWN]    Run Keywords    Custom screenshot
  ...           AND             Return to mainpage
  ...           AND             I select the "${_LOCATION 1}" location

Click scroll to top
  Given I am on the "patients" page
  When scrolling down
  And I hit the "top" tab
  Then Location Should Contain    \#

Click on user name to view profile
  Given I am on the "patients" page
  When I hit the "username" tab
  Then Page Should Contain    User Information

Click on notifications
  [TAGS]    skip
  Fail    Where is it!

Click on settings
  Given I am on the "patients" page
  When I hit the "settings" tab
  Then I am on the "settings" page

Pagination at top and bottom
  [SETUP]    I select the "My Locations" location
  Given I am on the "patients" page
  When I hit the "Chart Audit" view
  Then verify that there are two pagination bars
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Return to mainpage
  ...           AND             I select the "${_LOCATION 1}" location

*** Keywords ***
Prepare dummy patients
  I select the "${_LOCATION 1}" location
  ${date} =    Convert Date    ${Todays Date}    result_format=%m/%d/%Y
  ${date m} =    Add Time To Date    ${Todays Date}    1 day    result_format=%m/%d/%Y
  ${date y} =    Subtract Time From Date    ${Todays Date}    1 day    result_format=%m/%d/%Y
  @{data} =    Create List    Arriver Day Ato ${date} 09:00 PM|${EMPTY}|${EMPTY}
               ...            Arriver Morrow Bto ${date m} 01:00 PM|${EMPTY}|${EMPTY}
               ...            Discharger Day Cto ${date} 09:00 PM|${date} 11:00 PM|${EMPTY}
               ...            Discharger Morrow Dto ${date} 09:00 PM|${date m} 01:00 PM|${EMPTY}
               ...            Reviewer Day Eto ${date} 09:00 PM|${EMPTY}|${date}
               ...            Reviewer Morrow Fto ${date} 04:00 AM|${EMPTY}|${date m}
               ...            Reviewer Du Gp ${date} 04:00 AM|${EMPTY}|${date y}
               ...            Pender Add Hto ${EMPTY}|${date m} 01:00 PM|${EMPTY}
               ...            Pender Dis Ito ${date m} 01:00 PM|${EMPTY}|${EMPTY}
               ...            Charter Audit Jand ${date y} 01:00 PM|${date y} 09:00 PM|${EMPTY}
  @{dummy ids} =    Create List    ${EMPTY}
  &{name verify} =    Create Dictionary
  :FOR    ${d}    IN    @{data}
  \    @{name}    ${total dates} =    Split String    ${d}    max_split=3
  \    ${first} =    Get From List    ${name}    0
  \    ${last} =    Get From List    ${name}    2
  \    ${key} =    Set Variable    ${first} ${last[:1]}
  \    @{split dates} =    Split String    ${total dates}    |
  \    I create a valid patient    @{name}    ${date}
  \    Append To List    ${dummy ids}    ${Current Id}
  \    Set Suite Variable    ${Dummy ids}    ${dummy ids}
  \    ${first} =    Get Element Attribute    ${PATIENT FACESHEET FIRST NAME}@value
  \    ${last} =    Get Element Attribute    ${PATIENT FACESHEET LAST NAME}@value
  \    Set To Dictionary    ${name verify}    ${key}=${first} ${last[:1]}
  \    Form fill    patient facesheet    admission date:js=@{split dates}[0]    discharge date:js=@{split dates}[1]
  \    Click Button    Update
  \    Ajax wait
  \    ${passes} =    Set Variable If    '@{name}[1]'!='Add'    passing    failing
  \    Run Keyword If    '@{split dates}[2]'=='${EMPTY}'    Give a "${passes}" facesheet validation
  \    ...               ELSE                               Run Keywords    Click Link    Add insurance
  \    ...                                                  AND             Ajax wait
  \    ...                                                  AND             Input insurance company
  \    ...                                                  AND             Fill out insurance info
  \    ...                                                  AND             Update facesheet    subscriber rship:dropdown=Self
  \    ...                                                  AND             I hit the "Show Facesheet" view
  \    ...                                                  AND             I hit the "Add review" view
  \    ...                                                  AND             Form fill    ${EMPTY}    insurance_authorization_next_review_date:direct_js=@{split dates}[2]
  \    ...                                                  AND             Click Element    //div[@id='insurance-authorization-dialog']/following-sibling::div[last()]//div[@class='ui-dialog-buttonset']/button[2]
  \    Ajax wait
  \    Return to mainpage
  Remove From List    ${dummy ids}    0
  Set Suite Variable    ${Dummy ids}    ${dummy ids}
  Set Suite Variable    ${Name verify}    ${name verify}

Remove dummy patients
  I select the "${_LOCATION 1}" location
  :FOR    ${id}    IN    @{Dummy ids}
  \    Continue For Loop If    '${id}'=='${EMPTY}'
  \    Go To    ${BASE URL}${PATIENTS}/${id}/edit
  \    Dialog action    Click Link    delete
  \    Wait Until Page Contains    Notice

Toggle to "${view}" view
  Run Keyword Unless    '${View style}'=='${view}'    Run Keywords    Toggle view
  ...                                                                 Figure out what view style I am in

I am on this view style
  Run Keyword If    '${View style}'=='list'    Location Should Be    ${BASE URL}${VIEW TOGGLE}list
  ...               ELSE                       Location Should Be    ${BASE URL}${VIEW TOGGLE}

Filtering patients that are "${filter}"
  ${type}    ${time} =    Split String    ${filter}    max_split=1
  Click Element    //*[contains(text(),'${type}')]/ancestor::div[${CSS SELECT.replace('$CSS','wrap')}]//span[contains(text(),'${time}')]
  Ajax wait

Current page "${contain}" have mr numbers
  Run Keyword If    '${contain}'=='does'    Do search in    ${patient ${View style}}
  ...                                                       ${patient ${View style} mr number}
  ...               ELSE                    Do search in    ${patient ${View style}}
  ...                                                       ${patient ${View style} mr number}    ${EMPTY}

Current page have the names "${name}"
  Do search in    //ul[@id='search']/li    find_element_by_tag_name('a').get_attribute('innerHTML')    ${name}

Verify that there are two pagination bars
  Page should have    ELEMENT|2x|//nav[@class='pagination ajax_browser_history pagination-k-ajax']
