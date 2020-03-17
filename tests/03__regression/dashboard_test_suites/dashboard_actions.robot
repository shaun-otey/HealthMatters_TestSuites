*** Settings ***
Documentation   Assigned actions to patients.
...
Default Tags    regression    re009    dashboard story    notester    hasprint
Resource        ../../../suite.robot
Suite Setup     Setup for actions
Suite Teardown  Return to mainpage

*** Test Cases ***
Select patient
  Given I am on the "dashboard actions" page
  When I hit the "${_PATIENT 2} " text
  Then page should have    ${_PATIENT 2 NAME SEG 1}    ${_PATIENT 2 NAME SEG 2}
  [TEARDOWN]    Go To    ${BASE URL}${DASHBOARD ACTIONS}

Change page
  Given I am on the "dashboard actions" page
  When I keep going to the next page
  Then I will reach the last page
  [TEARDOWN]    Go To    ${BASE URL}${DASHBOARD ACTIONS}

Click on different programs
  Given I am on the "dashboard actions" page
  When I hit the "${_PROGRAM FILTER 1}" view
  Then confirm "${_PROGRAM FILTER 1}" in results
  [TEARDOWN]    Go To    ${BASE URL}${DASHBOARD ACTIONS}

Click scroll to top
  Given I am on the "dashboard actions" page
  When scrolling down
  And I hit the "top" tab
  Then Location Should Contain    \#

Click Print/PDF
  [TAGS]    hasprint

*** Keywords ***
Setup for actions
  I hit the "dashboard" tab
  I hit the "Actions" view
  ${comeback} =    Get Location
  Set Suite Variable    ${Comeback}    ${comeback}
  I select the "My Locations" location

I keep going to the next page
  Set Test Variable    ${Page}    2
  ${passes} =    Run Keyword And Return Status    Page Should Contain Element
                 ...                              //a[@rel='next' and contains(text(),'Next')]
  Run Keyword If    ${passes}    Run Keywords    Click Element    //a[@rel='next' and contains(text(),'Next')]
  ...                            AND             Next page

Next page
  Ajax wait
  Location Should Contain    p_view=actions&page=${Page}
  ${Page} =    Evaluate    ${Page}+1
  Set Test Variable    ${Page}    ${Page}
  Custom screenshot
  ${passes} =    Run Keyword And Return Status    Page Should Contain Element
                 ...                              //a[@rel='next' and contains(text(),'Next')]
  Run Keyword If    ${passes}    Run Keywords    Click Element    //a[@rel='next' and contains(text(),'Next')]
  ...                            AND             Next page

I will reach the last page
  Page Should Not Contain Element    //a[@rel='next' and contains(text(),'Next')]
  Page Should Not Contain Element    //a[contains(text(),'Last')]

Confirm "${find}" in results
  Do search in    //div[@class='block']//tr    find_element_by_css_selector('td>div').get_attribute('innerHTML')
  ...             Program: ${find}
