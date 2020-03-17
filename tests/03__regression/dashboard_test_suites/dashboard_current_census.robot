*** Settings ***
Documentation   Overview look of all current patients.
...
Default Tags    regression    re002    dashboard story    notester    hasprint
Resource        ../../../suite.robot
Suite Setup     Setup for current census
Suite Teardown  Run Keywords    Return to mainpage

*** Test Cases ***
Search for an evaluation
  [TAGS]    deprecated
  Given I am on the "dashboard" page
  When I search for "Diagnosis"
  Then find "Diagnosis" in evaluation

View all items
  Given I am on the "dashboard" page
  When I hit the "All Items" text
  Then find "Unsigned Orders" in all items

View all patient items
  [TAGS]    deprecated
  Given I am on the "dashboard" page
  When I hit the "${Patient Handle} Items" text
  Then find functions

Change pages
  Given I am on the "dashboard" page
  When going through each page
  Then verify number of patients
  # And get number of patients
  # When Run Keyword And Ignore Error    I hit the "${Patient Handle.title()} Items" view
  # Then Run Keyword And Ignore Error    find functions

Select patient
  Given I am on the "dashboard" page
  # When I hit the "${_PATIENT 6}" text
  When I hit the "Addy" text
  # Then page should have    ${_PATIENT 6 NAME SEG 1}    ${_PATIENT 6 NAME SEG 2}    ${_PATIENT 6 NAME SEG 3}
  Then page should have    ${_PATIENT 4 NAME SEG 1}    ${_PATIENT 4 NAME SEG 2}    ${_PATIENT 4 NAME SEG 3}

Select form
  [TAGS]    deprecated
  Given I am on the "dashboard" page
  When I hit the "${_ITEM 1}" view
  Then page should have    ${_ITEM 1 SEG 1}    ${_ITEM 1 SEG 2}    ${_ITEM 1 SEG 3}    ${_ITEM 1 SEG 4}    ${_ITEM 1 SEG 5}

Sort direction functionality
  Given I am on the "dashboard" page
  When checking starting configuration
  Then change sorting at settings
  And change sorting at dashboard

Filtering by created or updated by me should show pending orders
  Given I am on the "dashboard" page
  When I hit the all dashboard filter
  # And capture
  Then Run Keyword And Continue On Failure    a certain number of pending orders will at least show up
  When I hit the "Created by me" view
  Then Run Keyword And Continue On Failure    a certain number of pending orders will at least show up
  When I hit the "Updated by me" view
  Then Run Keyword And Continue On Failure    a certain number of pending orders will at least show up
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Go To    ${Comeback}
  ...           AND             I hit the all dashboard filter

Filtering by content status should show the correct orders
  [SETUP]    Pick four patients to update statuses
  Given I am on the "dashboard" page
  And I hit the all dashboard filter
  When I hit the "Open" status filter
  Then page should only have this "${Patient open}"
  And I hit the all dashboard filter
  When I hit the "In Progress" status filter
  Then page should only have this "${Patient in progress}"
  And I hit the all dashboard filter
  When I hit the "Ready for Review" status filter
  Then page should only have this "${Patient ready for review}"
  And I hit the all dashboard filter
  When I hit the "In Use" status filter
  Then page should only have this "${Patient in use}"
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Go To    ${Comeback}
  ...           AND             I hit the all dashboard filter

Print
  [TAGS]    hasprint
  Given I am on the "dashboard" page
  And I select the "My Locations" location
  When I hit the "print" tab
  And Sleep    2
  And Unselect Frame
  Then Title Should Be    Print

Scroll up
  Given I am on the "dashboard" page
  When scrolling down
  And I hit the "top" tab
  Then Location Should Contain    \#

*** Keywords ***
Setup for current census
  I hit the "dashboard" tab
  I hit the "Current Census" view
  ${comeback} =    Get Location
  Set Suite Variable    ${Comeback}    ${comeback}
  I select the "My Locations" location

Going through each page
  ${shrink down} =    Copy List    ${Dashboard Names}
  ${passes} =    Run Keyword And Return Status    Page Should Not Contain    T...
  Run Keyword Unless    ${passes}    Run Keyword And Continue On Failure    Fail    Names are ending in 3 dots!
  ${dots} =    Set Variable If    ${passes}    .    ...
  :FOR    ${index}    ${name}    IN ENUMERATE    @{shrink down}
  \    Set List Value    ${shrink down}    ${index}    ${name.split(' | ')[1]}${dots}${SPACE}
  Set Test Variable    ${Shrink down}    ${shrink down}
  Set Test Variable    ${Patient count}    ${0}
  Verify next page
  Run Keyword And Continue On Failure    Should Be Empty    ${Shrink down}

Verify next page
  Reload Page
  @{names} =    Get Webelements    //table[@class='grid_tight']/tbody/tr//a[@class='bold disable_click']
  :FOR    ${index}    ${name}    IN ENUMERATE    @{names}
  \    Set List Value    ${names}    ${index}    ${name.get_attribute('innerHTML')}
  \    ${Patient count} =    Set Variable    ${Patient count+1}
  Set Test Variable    ${Patient count}    ${Patient count}
  Log Many    ${Shrink down}
  Remove Values From List    ${Shrink down}    @{names}
  Log Many    ${names}
  Log Many    ${Shrink down}
  ${passes} =    Run Keyword And Return Status    Click Element
                 ...                              //a[@class='ajax_browser_history' and contains(text(),'Next')]
  Run Keyword If    ${passes}    Verify next page
  ...               ELSE         Click Element    //a[@class='ajax_browser_history' and contains(text(),'First')]

Verify number of patients
  ${count} =    Get Text    //div[@id='sub_nav_content']/h2
  ${count} =    Convert To Integer    ${count.split()[1]}
  Run Keyword And Continue On Failure    Should Be True    ${count} == ${Patient count} >= 31
  Run Keyword And Continue On Failure    Page Should Contain Element
  ...                                    //div[@id='sub_nav_content']/h2[contains(text(),'${Patient count.__str__()}')]

I search for "${search}"
  Input Text    p_eval_name    ${search}
  Click Button    search
  Ajax wait

Find "${search}" in evaluation
  Do search in    //tr/td/div[@class='mleft20px']    find_element_by_tag_name('a').get_attribute('innerHTML')
  ...             ${search}

Find "${search}" in all items
  Do search in    //div[@class='left mtop06']/../../following-sibling::tr[1]/td/div
  ...             find_element_by_tag_name('a').get_attribute('innerHTML')    ${search}

Find functions
  Do search in    //tr/td[@style='vertical-align:middle']    find_element()

Pick four patients to update statuses
  @{names} =    Evaluate    random.sample(@{Dashboard Names},4)    random
  ${selected patients} =    Create List
  :FOR    ${index}    ${name}    IN ENUMERATE    @{names}
  \    ${name} =    Set Variable    ${name.split(' | ')[1]}
  \    Append To List    ${selected patients}    ${name}
  \    I hit the "${name}" text
  \    Parse current id
  \    I hit the "treatment plans" patient tab
  \    With this form "Treatment Plan" perform these actions "add"
  \    Run Keyword If    ${index}==0    Run Keywords    Set Test Variable    ${Patient open}    ${name}
  \    ...                              AND             Go To    ${Comeback}
  \    ...                              AND             Continue For Loop
  \    With this form "Treatment Plan" perform these actions "edit"
  \    Hit "Client signature" to sign
  \    Run Keyword If    ${index}==1    Run Keywords    Set Test Variable    ${Patient in progress}    ${name}
  \    ...                              AND             Go To    ${Comeback}
  \    ...                              AND             Continue For Loop
  \    With this form "Treatment Plan" perform these actions "edit"
  \    Hit "Sign & Submit" to sign
  \    Run Keyword If    ${index}==2    Run Keywords    Set Test Variable    ${Patient ready for review}    ${name}
  \    ...                              AND             Go To    ${Comeback}
  \    ...                              AND             Continue For Loop
  \    With this form "Treatment Plan" perform these actions "edit"
  \    Hit "Review sign submit" to sign
  \    Set Test Variable    ${Patient in use}    ${name}
  \    Go To    ${Comeback}
  Set Test Variable    ${Seleceted patients}    ${selected patients}

Hit "${sig}" to sign
  I hit the "${sig}" text
  Ajax wait
  Click Element    //canvas
  Click Button    Submit
  Ajax wait

Checking starting configuration
  :FOR    ${type}    IN    current    discharged
  \    ${sort type} =    Get Text    //select[@id='dashboard_sort_direction']/option[@value='1']
  \    Set Test Variable    ${Sort for ${type}}    ${sort type}
  \    Select From List By Label    dashboard_sort_direction    ${Sort for ${type}}
  \    No Operation
  \    I hit the "Discharged ${Patient Handle}s" view
  ${comeback} =    Get Location
  Set Test Variable    ${Comeback other}    ${comeback}
  Go To    ${BASE URL}${INSTANCE}
  Run Keyword And Continue On Failure    Page Should Contain Element
  ...                                    //select[@id='site_setting_current_census_order']/option[@selected='selected' and .='${Sort for current}']
  Run Keyword And Continue On Failure    Page Should Contain Element
  ...                                    //select[@id='site_setting_discharged_patients_order']/option[@selected='selected' and .='${Sort for discharged}']

Change sorting at settings
  @{sortings} =    Get List Items    site_setting_current_census_order
  ${first sort} =    Remove From List    ${sortings}    0
  :FOR    ${sort}    IN    @{sortings}    ${first sort}
  \    Go To    ${BASE URL}${INSTANCE}
  \    Instance edit "Select From List By Label:${sort}" on "Current census order:dropdown"
  \    Click Button    commit
  \    Ajax wait
  \    Reload Page
  \    Run Keyword And Continue On Failure    Page Should Contain Element
  \    ...                                    //select[@id='site_setting_current_census_order']/option[@selected='selected' and .='${sort}']
  \    Run Keyword And Continue On Failure    Page Should Contain Element
  \    ...                                    //select[@id='site_setting_discharged_patients_order']/option[@selected='selected' and .='${Sort for discharged}']
  \    Go To    ${Comeback other}
  \    Run Keyword And Continue On Failure    Page Should Contain Element
  \    ...                                    //select[@id='dashboard_sort_direction']/option[@selected='selected' and .='${Sort for discharged}']
  \    No Operation
  \    Go To    ${Comeback}
  \    Run Keyword And Continue On Failure    Page Should Contain Element
  \    ...                                    //select[@id='dashboard_sort_direction']/option[@selected='selected' and .='${sort}']
  \    No Operation

Change sorting at dashboard
  @{sortings} =    Get List Items    dashboard_sort_direction
  ${first sort} =    Remove From List    ${sortings}    0
  :FOR    ${sort}    IN    @{sortings}    ${first sort}
  \    Go To    ${Comeback}
  \    Select From List By Label    dashboard_sort_direction    ${sort}
  \    No Operation
  \    Go To    ${Comeback other}
  \    Run Keyword And Continue On Failure    Page Should Contain Element
  \    ...                                    //select[@id='dashboard_sort_direction']/option[@selected='selected' and .='${Sort for discharged}']
  \    No Operation
  \    Go To    ${BASE URL}${INSTANCE}
  \    Run Keyword And Continue On Failure    Page Should Contain Element
  \    ...                                    //select[@id='site_setting_current_census_order']/option[@selected='selected' and .='${sort}']
  \    Run Keyword And Continue On Failure    Page Should Contain Element
  \    ...                                    //select[@id='site_setting_discharged_patients_order']/option[@selected='selected' and .='${Sort for discharged}']

I hit the all dashboard filter
  Click Element    //a[@data-disable-with='All']
  Ajax wait

I hit the "${content}" status filter
  Run Keyword And Continue On Failure    Click Element    //a[@data-disable-with='${content}']
  Ajax wait

A certain number of pending orders will at least show up
  @{orders} =    Get Webelements    //a[.='Unsigned Orders']
  ${count} =    Get Length    ${orders}
  Should Be True    ${count} >= 10

Page should only have this "${patient}"
  :FOR    ${name}    IN    @{Selected patients}
  \    Run Keyword If    '${patient}'=='${name}'    Run Keyword And Continue On Failure    Page Should Contain
  \    ...                                          ${patient}
  \    ...               ELSE                       Run Keyword And Continue On Failure    Page Should Not Contain
  \    ...                                          ${name}
