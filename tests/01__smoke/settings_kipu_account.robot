*** Settings ***
Documentation   View Kipu instance stats.
...
Default Tags    smoke    sm005    points-1    settings story    notester
Resource        ../../suite.robot
Suite Teardown  Return to mainpage

*** Test Cases ***
View instance stats
  Given I am on the "patients" page
  When I hit the "settings" tab
  And I hit the "Kipu Account" view
  And I hit the "Instance Stats" view
  Then page should load up stats

*** Keywords ***
Page should load up stats
  Wait Until Page Contains Element    //button[contains(text(),'Close')]
  Wait Until Page Contains Element    //div[@class='modal-content']
  # Page Should Contain    Kipu Staff only: List of Super Admins
