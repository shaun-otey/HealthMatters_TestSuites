*** Settings ***
Documentation   Overview look of all discharged patients.
...
Default Tags    regression    re008    dashboard story    notester
Resource        ../../../suite.robot
Suite Setup     Setup for discharged patients
Suite Teardown  Return to mainpage

*** Test Cases ***
Search for an evaluation
  # [TAGS]    re008test    re008
  Given I am on the "dashboard" page
  # And I select the "My Locations" location
  When I search for "Diagnosis"
  Then find "Diagnosis" in evaluation

View all items
  # [TAGS]    re008test    re008
  Given I am on the "dashboard" page
  # And I select the "${_LOCATION 3}" location
  When I hit the "All Items" text
  # Then find "Unsigned Orders" in all items
  # Then find "Consent for Treatment" in all items
  Then find functions for all items
  # [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  # ...           AND             I select the "My Locations" location
  # ...           AND             Go To    ${Comeback}

View my items
  # [TAGS]    re008test    re008
  [SETUP]    Assign myself the "Admissions Coordinator" function
  Given I am on the "dashboard" page
  # And I select the "My Locations" location
  When I hit the "My Items" text
  # When Click Link    btn_patient_items
  Then find functions for my items
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Assign myself the "none" function

View patient items
  # [TAGS]    re008test    re008
  Given I am on the "dashboard" page
  # And I select the "My Locations" location
  When I hit the "${Patient Handle} Items" text
  # When Click Link    btn_patient_items
  Then find functions for patient items

# Change pages
#   Given I am on the "dashboard" page
#   And I select the "My Locations" location
#   And get number of patients
#   When I hit the "Patient items" view
#   Then find functions

# Last updated by me

Select patient
  Given I am on the "dashboard" page
  # And I select the "My Locations" location
  When I hit the "${_PATIENT 7} " text
  Then page should have    ${_PATIENT 7 NAME SEG 1}    ${_PATIENT 7 NAME SEG 2}
  [TEARDOWN]    Go Back

Select form
  Given I am on the "dashboard" page
  And I select the "My Locations" location
  When I hit the "${_ITEM 2}" view
  Then page should have    ${_ITEM 2 SEG 1}
  [TEARDOWN]    Go Back

Sort direction functionality
  Given I am on the "dashboard" page
  And I select the "My Locations" location
  When checking starting configuration
  Then change sorting at settings
  And change sorting at dashboard

# Print
#   Given I am on the "dashboard" page
#   And I select the "My Locations" location
#   When I hit the "print" tab
#   And Sleep    2
#   And Unselect Frame
#   Then Title Should Be    Print

Scroll up
  Given I am on the "dashboard" page
  And I select the "My Locations" location
  When scrolling down
  And I hit the "top" tab
  Then Location Should Contain    \#

*** Keywords ***
Setup for discharged patients
  I hit the "dashboard" tab
  I hit the "Discharged ${Patient Handle}s" view
  ${comeback} =    Get Location
  Set Suite Variable    ${Comeback}    ${comeback}
  I select the "My Locations" location

I search for "${search}"
  Input Text    p_eval_name    ${search}
  Click Button    search
  Ajax wait

Find "${search}" in evaluation
  Do search in    //tr/td/div[@class='mleft20px']    find_element_by_tag_name('a').get_attribute('innerHTML')
  ...             ${search}

Find functions for all items
  Do search in    //tr/td[@style='vertical-align:middle']
  ...             find_element_by_class_name('access_box').get_attribute('innerHTML')

Assign myself the "${function}" function
  I hit the "username" tab
  Run Keyword If    '${function}'!='none'    Form fill    new user    function:dropdown=${function}
  ...               ELSE                     Form fill    new user    function:dropdown=${EMPTY}
  Click Button    Update
  Ajax wait
  Go To    ${Comeback}

Find functions for my items
  Do search in    //tr/td[@style='vertical-align:middle']
  ...             find_element_by_xpath(".//*[contains(text(),'ACor')]").get_attribute('innerHTML')    ACor

Find functions for patient items
  # Do search in    //tr/td[@style='vertical-align:middle']  find_element()
  Do search in    //tr/td[@style='vertical-align:middle']
  ...             find_element_by_xpath(".//*[contains(text(),'Client') or contains(text(),'Guardian')]").get_attribute('innerHTML')
  ...             Client;Guardian

Find "${search}" in all items
  Do search in    //div[@class='left mtop06']/../../following-sibling::tr[position()=1]/td/div
  ...             find_element_by_tag_name('a').get_attribute('innerHTML')    ${search}

Checking starting configuration
  :FOR    ${type}    IN    discharged    current
  \    ${sort type} =    Get Text    //select[@id='dashboard_sort_direction']/option[@value='1']
  \    Set Test Variable    ${Sort for ${type}}    ${sort type}
  \    Select From List By Label    dashboard_sort_direction    ${Sort for ${type}}
  \    No Operation
  \    I hit the "Current Census" view
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
  \    Instance edit "Select From List By Label:${sort}" on "Discharged patients order:dropdown"
  \    Click Button    commit
  \    Ajax wait
  \    Reload Page
  \    Run Keyword And Continue On Failure    Page Should Contain Element
  \    ...                                    //select[@id='site_setting_current_census_order']/option[@selected='selected' and .='${Sort for current}']
  \    Run Keyword And Continue On Failure    Page Should Contain Element
  \    ...                                    //select[@id='site_setting_discharged_patients_order']/option[@selected='selected' and .='${sort}']
  \    Go To    ${Comeback other}
  \    Run Keyword And Continue On Failure    Page Should Contain Element
  \    ...                                    //select[@id='dashboard_sort_direction']/option[@selected='selected' and .='${Sort for current}']
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
  \    ...                                    //select[@id='dashboard_sort_direction']/option[@selected='selected' and .='${Sort for current}']
  \    No Operation
  \    Go To    ${BASE URL}${INSTANCE}
  \    Run Keyword And Continue On Failure    Page Should Contain Element
  \    ...                                    //select[@id='site_setting_current_census_order']/option[@selected='selected' and .='${Sort for current}']
  \    Run Keyword And Continue On Failure    Page Should Contain Element
  \    ...                                    //select[@id='site_setting_discharged_patients_order']/option[@selected='selected' and .='${sort}']
