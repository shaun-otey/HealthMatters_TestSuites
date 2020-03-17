*** Settings ***
Documentation   HTTP Test
...
Resource        ../suite.robot
Library         Collections
Library         RequestsLibrary
#Suite Setup     Login to system
#Suite Teardown  Exit system
#Test Teardown   Return to mainpage

*** Test Cases ***
Get Requests
  Create Session    github    http://api.github.com
  Create Session    google    http://www.google.com
  ${resp} =    Get Request    google    ${EMPTY}
  Should Be Equal As Strings    ${resp.status_code}    200
  ${resp} =    Get Request    github    /users/bulkan
  Should Be Equal As Strings    ${resp.status_code}    200
  Dictionary Should Contain Value    ${resp.json()}    Bulkan Evcimen
