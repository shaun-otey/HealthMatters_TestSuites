*** Settings ***
Documentation   Different integrations with HealthMatters and other external apps.
...
Default Tags    sanity    sa016    ntrdy
Resource        ../../suite.robot
Suite Setup     Run Keywords    Create a new user
...             AND             Turning "off;on" the "Tech;Super admin" roles for "${Find First};${Find Last}"
...             AND             Exit system    ${false}
...             AND             Start login    ${Find User}    ${Find Pass}
...             AND             I hit the "settings" tab
...             AND             I hit the "Konnectors" view
Suite Teardown  Run Keywords    Exit system    ${false}
...             AND             Start login    ${CURRENT USER}    ${CURRENT PASS}
...             AND             Delete the new user
# Test Teardown   ...

*** Test Cases ***
Check that konnectors are available
  [TAGS]    sanity    sa016
  Given I am on the "konnectors" page
  When I hit the "New Konnector" text
  Then check and validate each konnector

Konnector for external app
  Given I am on the "konnectors" page
  When I hit the "New Konnector" text
  And Form fill    vendor    name=QA Externals    type:dropdown=external app
  And create a konnector for "external app"

Konnector for collaborate md
  # [TAGS]    sanity    sa016
  Given I am on the "konnectors" page
  And loop deletion    Click Element    //a[.\='Collab Those QA']/ancestor::td[1]/following-sibling::td[last()]/a
  When I hit the "New Konnector" text
  And form fill    vendor    name=Collab Those QA    type:dropdown=Collaborate MD
  And create a konnector for "collaborate md"
  And travel "slow" to "tester" patients "facesheet" page in "${_LOCATION 1}"
  # And add an external app
  And Click Link    Add External App
  And ajax wait
  And set count id
  And update facesheet    external app:dropdown=collaborate_md
  And I hit the "Show Facesheet" view
  And I hit the "Send to CollaborateMD" view
  And page should have    Notice    Patient Created. CollaborateMD Patient ID
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Go To    ${BASE URL}${KONNECTORS}
  ...           AND             Loop deletion    Click Element
  ...                           //a[.\='Collab Those QA']/ancestor::td[1]/following-sibling::td[last()]/a

Konnector for pharmacy
  Given I am on the "konnectors" page
  When I hit the "New Konnector" text
  And Form fill    vendor    name=Top QA Pharmacy    type:dropdown=pharmacy
  And create a konnector for "pharmacy"

Konnector for scheduled report
  Given I am on the "konnectors" page
  When I hit the "New Konnector" text
  And Form fill    vendor    name=A QA Report    type:dropdown=scheduled report
  And create a konnector for "scheduled report"

Konnector for pdf dropoff
  Given I am on the "konnectors" page
  When I hit the "New Konnector" text
  And Form fill    vendor    name=Drop Dead QA    type:dropdown=pdf dropoff
  And create a konnector for "pdf dropoff"

Konnector for ext id mapping
  Given I am on the "konnectors" page
  When I hit the "New Konnector" text
  And Form fill    vendor    name=QA Compiles Map    type:dropdown=ext id mapping
  And create a konnector for "ext id mapping"

Konnector for ping md
  Given I am on the "konnectors" page
  When I hit the "New Konnector" text
  And Form fill    vendor    name=Ping The QA A Drink    type:dropdown=ping md
  And create a konnector for "ping md"

Konnector for practice suite
  Given I am on the "konnectors" page
  When I hit the "New Konnector" text
  And Form fill    vendor    name=Future QA Practice    type:dropdown=practice suite
  And create a konnector for "practice suite"

Konnector for kipu facesheet transfer
  Given I am on the "konnectors" page
  When I hit the "New Konnector" text
  And Form fill    vendor    name=Broken Facesheet By QA    type:dropdown=Kipu Facesheet Transfer
  And create a konnector for "kipu facesheet transfer"

Konnector for medics premier
  Given I am on the "konnectors" page
  When I hit the "New Konnector" text
  And Form fill    vendor    name=QA Medics    type:dropdown=Medics Premier
  And create a konnector for "medics premier"

*** Keywords ***
Check and validate each konnector
  ${name} =    Set Variable    mario and greg talk
  ${delete k} =    Set Variable    //a[.\='${name}']/ancestor::td[1]/../descendant::a[@data-method\='delete']
  @{k list} =    Get List Items    ${VENDOR TYPE}
  @{retry list} =    Create List
  FOR    ${konnector}    IN
  ...    Analyzer    Collaborate MD    External App    Lab    Liquid Dispensing Pump    Pharmacy    Vob Getter
  ...    Scheduled Report    Pdf Dropoff    Ext Id Mapping    Ping MD    Practice Suite    Kipu Facesheet Transfer
  ...    Medics Premier
      I hit the "Konnectors" view
      Loop deletion    Click Element    ${delete k}
      I hit the "New Konnector" text
      ${passes} =    Run Keyword And Return Status    List Should Contain Value    ${k list}    ${konnector}
      Run Keyword Unless    ${passes}    Run Keywords    Run Keyword And Continue On Failure    Fail
      ...                                                Konnector ${konnector} cannot be used!
      ...                                AND             Append To List    ${retry list}    ${konnector}
      ...                                AND             Continue For Loop
      Form fill    vendor    name=${name}    type:dropdown=${konnector}
      Click Button    commit
      Custom screenshot
      Verify for no bad page
      Page should have    ${konnector}: ${name}
  END
  I hit the "Konnectors" view
  Loop deletion    Click Element    ${delete k}
  Exit system    ${false}
  Start login    ${CURRENT USER}    ${CURRENT PASS}
  I hit the "settings" tab
  FOR    ${konnector}    IN    @{retry list}
      I hit the "Konnectors" view
      Loop deletion    Click Element    ${delete k}
      I hit the "New Konnector" text
      ${passes} =    Run Keyword And Return Status    Form fill    vendor    name=${name}    type:dropdown=${konnector}
      Run Keyword Unless    ${passes}    Run Keywords    Run Keyword And Continue On Failure    Fail
      ...                                                Konnector ${konnector} is gone!
      ...                                AND             Continue For Loop
      Click Button    commit
      Custom screenshot
      Verify for no bad page
      Page should have    ${konnector}: ${name}
  END
  I hit the "Konnectors" view
  Loop deletion    Click Element    ${delete k}

Create a konnector for "${vendor}"
  Click Button    commit
  Ajax wait
  Run Keyword    ${vendor} creation

# Remove the vob getter konnector
#   Return to mainpage
#   I hit the "settings" tab
#   I hit the "konnectors" tab
#   Loop deletion    Click Element    //a[contains(text(),'VOBGetter QA Konnector')]/ancestor::td[1]/following-sibling::td[last()-1]//a
#   Return to mainpage

External app creation
  Form fill    vendor    status:checkbox=x    locations|6:checkbox=x    external app name=HFF Patient ID
  Click Button    commit
  Ajax wait

Collaborate md creation
  &{locations hit} =    Create dict for locations    ${_LOCATION 1};${_LOCATION 2};${_LOCATION 3};${_LOCATION 5}
  # locations|6:checkbox=x    collab facility name=Test Facility
  Form fill    vendor    status:checkbox=x    collab facility id=10211743
  ...          collab customer name=Kipu Interface Test Account    collab customer id=10014011
  ...          collab provider number=5555555555    collab provider last name=Doctor    collab provider first name=Test
  ...          collab user name=kipuapi    collab password=XGzeBBTn    collab api version:radio=webapi
  ...          &{locations hit}
  # collab user name=generic10014011    collab password=blonde753U    collab api version:radio=legacy
  Click Button    commit
  Ajax wait
  # Dialog Action    I hit the "Test Connection" text
  Run Keyword And Expect Error    *    I hit the "Test Connection" text
  Alert Should Be Present    API: 200 OK, Credentials: Success

Pharmacy creation
  Form fill    vendor    status:checkbox=x    locations|6:checkbox=x    contact name=Jason Markson
  ...          contact phone=800-555-8888    address|1=98 Coastal Street    city=Local    state:dropdown=Florida
  ...          zip=33333    company phone=800-555-8888    company fax=800-555-9999    pharmacy fax number=305-675-0322
  Click Button    commit
  Ajax wait

Scheduled report creation
  Form fill    vendor    status:checkbox=x    report|?:checkbox=x    recurring role:dropdown=Daily
  ...          date run at:dropdown=11 AM
  Form fill    vendor sftp    server=23.21.214.252    port=22    user name=kipuinstance-labportal    results=labteam/
  I hit the "Test Connection" text
  # Click Button    commit
  # Ajax wait

Pdf dropoff creation
  Form fill    vendor    status:checkbox=x    ?
  Click Button    commit
  Ajax wait

Ext id mapping creation
  Form fill    vendor    status:checkbox=x    ?
  Click Button    commit
  Ajax wait

Ping md creation
  Form fill    vendor    status:checkbox=x    pingmd=2703
  Click Button    commit
  Ajax wait

Practice suite creation
  Form fill    vendor    status:checkbox=x    locations|6:checkbox=x
  Form fill    vendor practice    facility name=FcName    facility id=FcID    account=12345    provider number=098765
  ...          provider first name=FName    provider last name=LName    user name=Uname
  Click Button    commit
  Ajax wait

Kipu facesheet transfer creation
  Form fill    vendor    status:checkbox=x    ?
  Click Button    commit
  Ajax wait

Medics premier creation
  Form fill    vendor    status:checkbox=x    ?
  Click Button    commit
  Ajax wait
