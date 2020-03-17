*** Settings ***
Documentation   View orders by date.
...
Default Tags    regression    re006    dashboard story    notester
Resource        ../../../suite.robot
Suite Setup     Setup for orders
Suite Teardown  Return to mainpage

*** Test Cases ***
Pick a date and select a patient
  Given I am on the "dashboard" page
  And I select the "My Locations" location
  When I select the "01/08/2016" date
  And I hit the "${_PATIENT 8}" text
  Then page should have    ${_PATIENT 8 NAME SEG 1}    ${_PATIENT 8 NAME SEG 2}    ${_PATIENT 8 NAME SEG 3}
  [TEARDOWN]    Go Back

Date Range
  Change the single date selection to a date/time range selection

Programs

All orders
  Default

Medication orders
  Shows only medication orders and filters out lab and action orders.

Action orders
  Shows only action orders and filters out medication and lab orders.

Lab orders

Click scroll to top
  Given I am on the "dashboard" page
  And I select the "My Locations" location
  When scrolling down
  And I hit the "top" tab
  Then Location Should Contain    \#

Click Print/PDF
  [TAGS]    skip

*** Keywords ***
Setup for orders
  I hit the "dashboard" tab
  I hit the "Orders" view
  ${comeback} =    Get Location
  Set Suite Variable    ${Comeback}    ${comeback}
  I select the "My Locations" location

I select the "${date}" date
  Click Link    Select date
  Ajax wait
  Execute Javascript    $('#p_order_date').val('${date}')
  Click Element At Coordinates    p_order_date    -1000    0
  Sleep    1
  Click Button    //button[2]
  Ajax wait
  Page Should Contain Element    //table[@class='grid_index']
