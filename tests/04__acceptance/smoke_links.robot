*** Settings ***
Documentation   Check links.
...
Default Tags    acceptance    ac002    points-12    addmore
Resource        ../../suite.robot
Test Teardown   Run Keywords    Run Keyword If Test Failed    Custom screenshot
...             AND             Delete All Sessions
...             AND             Return to mainpage

*** Test Cases ***
All routes
  [TAGS]    testmesmoke
  ${session cookie} =    Get Cookie    _session_id
  ${session} =    Create Dictionary   _session_id=${session cookie}
  Create Session    page    ${BASE URL}    verify=True    cookies=${session}
  ${routes} =    Get File    ${Root dir}/all_routes.txt
  @{routes} =    Split String    ${routes}    ,
  Remove From List    ${routes}    3
  :FOR    ${route}    IN    @{routes}
  \    ${link} =    Set Variable    /${route.replace('"','').strip(' []\n')}
  \    Log    ${link}
  \    Continue For Loop If    ':' in '${link}'
  \    Go To    ${BASE URL}${link}
  \    Custom screenshot
  \    ${resp} =    Get Request    page    ${link}
  \    ${passes} =    Run Keyword And Return Status    Should Be True    200<=${resp.status_code}<300
  \    ${resp} =    Set Variable    ${resp.text}
  \    Run Keyword Unless    ${passes}    Run Keyword And Continue On Failure    Fail    Bad return!

Hit links on dashboard
  Given I am on the "patients" page
  And I hit the "dashboard" tab
  When collecting links on current page
  Then Smoke << Reach all links    @{All links}

Hit links on patients
  Given I am on the "patients" page
  And I hit the "patients" tab
  When collecting links on current page
  Then Smoke << Reach all links    @{All links}

Hit links on occupancy
  Given I am on the "patients" page
  And I hit the "occupancy" tab
  When collecting links on current page
  Then Smoke << Reach all links    @{All links}

Hit links on schedules
  Given I am on the "patients" page
  And I hit the "schedules" tab
  When collecting links on current page
  Then Smoke << Reach all links    @{All links}

Hit links on shifts
  Given I am on the "patients" page
  And I hit the "shifts" tab
  When collecting links on current page
  Then Smoke << Reach all links    @{All links}

Hit links on contacts
  Given I am on the "patients" page
  And I hit the "contacts" tab
  When collecting links on current page
  Then Smoke << Reach all links    @{All links}

Hit links on reports
  Given I am on the "patients" page
  And I hit the "reports" tab
  When collecting links on current page
  Then Smoke << Reach all links    @{All links}

Hit links on templates
  Given I am on the "patients" page
  And I hit the "templates" tab
  When collecting links on current page
  Then Smoke << Reach all links    @{All links}

*** Keywords ***
Collecting links on current page
  ${a links} =    Collect type of links    //a    href
  ${img links} =    Collect type of links    //img    src
  ${links} =    Combine Lists    ${a links}    ${img links}
  Set Test Variable    ${All links}    ${links}
  Log    ${links}
