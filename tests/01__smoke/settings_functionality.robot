*** Settings ***
Documentation   Run through all the settings options and verify
...             by url that the pages are correct.
...
Default Tags    smoke    sm002    points-2    settings story    notester
Resource        ../../suite.robot
Suite Setup     I hit the "settings" tab
Suite Teardown  Return to mainpage
Test Teardown   Run Keywords    Run Keyword If Test Failed    Custom screenshot
...             AND             Go To    ${BASE URL}${SETTINGS}

*** Test Cases ***
Hit patients
  Given I am on the "settings" page
  When Click Element    //a[@href='/settings' and .='${Patient Handle}s']
  Then I am on the "settings" page

Hit medication
  Given I am on the "settings" page
  When I hit the "Medication" view
  Then I am on the "medications" page

Hit orders
  Given I am on the "settings" page
  When I hit the "Orders" view
  Then I am on the "orders" page

Hit rooms
  Given I am on the "settings" page
  When I hit the "Rooms" view
  Then I am on the "rooms" page

Hit tags and filters
  Given I am on the "settings" page
  When I hit the "Tags & Filters" view
  Then I am on the "tags and filters" page

Hit user
  Given I am on the "settings" page
  When I hit the "User" view
  Then I am on the "user" page

Hit company
  Given I am on the "settings" page
  When I hit the "Company" view
  Then I am on the "company" page

Hit contact types
  Given I am on the "settings" page
  When I hit the "contact types" tab
  Then I am on the "contact types" page

Hit konnectors
  Given I am on the "settings" page
  When I hit the "Konnectors" view
  Then I am on the "konnectors" page

Hit golden thread
  Given I am on the "settings" page
  When I hit the "Golden Thread" view
  Then I am on the "golden thread" page

Hit instance
  Given I am on the "settings" page
  When I hit the "Instance" view
  Then I am on the "instance" page

Hit payors
  Given I am on the "settings" page
  When I hit the "Payors" view
  Then I am on the "payors" page

Hit kipu account
  Given I am on the "settings" page
  When I hit the "Kipu Account" view
  Then I am on the "kipu account" page

Hit kipu labs
  Given I am on the "settings" page
  When I hit the "Kipu Labs" view
  Then I am on the "kipu labs" page

Hit restore
  Given I am on the "settings" page
  When I hit the "Restore" view
  Then I am on the "restore" page

Hit services
  Given I am on the "settings" page
  When I hit the "Services" view
  Then I am on the "services" page
