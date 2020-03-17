*** Settings ***
Documentation   Case managers and their patients.
...
Default Tags    regression    re005    dashboard story    notester    hasprint
Resource        ../../../suite.robot
Suite Setup     Run Keywords    I hit the "dashboard" tab
...                             I hit the "Case Manager Load" view
Suite Teardown  Return to mainpage
Test Teardown   I hit the "Case Manager Load" view

*** Test Cases ***
Click on patient
  Given I am on the "dashboard case manager load" page
  And I select the "My Locations" location
  When I hit the "All Case Manager" view
  And I hit the "${_PATIENT 5} " text
  Then page should have    ${_CASE MANAGER 1}    ${_PATIENT 5 NAME SEG 1}    ${_PATIENT 5 NAME SEG 2}    ${_PATIENT 5 NAME SEG 3}
  [TEARDOWN]    Go To    ${BASE URL}${DASHBOARD CASE MANAGER LOAD}

Click unassigned patients
  Given I am on the "dashboard case manager load" page
  And I select the "My Locations" location
  When I hit the "Unassigned Patients" view
  And I hit the "${_PATIENT 6} " text
  Then page should have    ${_PATIENT 6 NAME SEG 1}    ${_PATIENT 6 NAME SEG 2}    ${_PATIENT 6 NAME SEG 3}
  [TEARDOWN]    Go To    ${BASE URL}${DASHBOARD CASE MANAGER LOAD}

Click scroll to top
  Given I am on the "dashboard case manager load" page
  And I select the "My Locations" location
  When scrolling down
  And I hit the "top" tab
  Then Location Should Contain    \#

Click Print/PDF
  [TAGS]    hasprint
