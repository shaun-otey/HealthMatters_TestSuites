*** Settings ***
Documentation   Assigned med pass to patients.
...
Default Tags    regression    re007    dashboard story    notester
Resource        ../../../suite.robot
Suite Setup     Setup for med pass
Suite Teardown  Return to mainpage

*** Test Cases ***
Select patient
  Given I am on the "dashboard" page
  And I select the "My Locations" location
  When I hit the "${_PATIENT 4} " text
  Then page should have    ${_PATIENT 4 NAME SEG 1}    ${_PATIENT 4 NAME SEG 2}
  [TEARDOWN]    Go Back

Change page
  [TAGS]    skip

Click on different programs
  Given I am on the "dashboard" page
  And I select the "My Locations" location
  When I hit the "${_PROGRAM FILTER 3}" view
  Then confirm "${_PROGRAM FILTER 3}" in results

Click scroll to top
  Given I am on the "dashboard" page
  And I select the "My Locations" location
  When scrolling down
  And I hit the "top" tab
  Then Location Should Contain    \#

Click Print/PDF
  [TAGS]    skip

*** Keywords ***
Setup for med pass
  I hit the "dashboard" tab
  I hit the "Med Pass" view
  ${comeback} =    Get Location
  Set Suite Variable    ${Comeback}    ${comeback}
  I select the "My Locations" location

Confirm "${find}" in results
  Do search in    //div[@class='block']//tr    find_element_by_css_selector('td>div').get_attribute('innerHTML')
  ...             \ Program: ${find}\
