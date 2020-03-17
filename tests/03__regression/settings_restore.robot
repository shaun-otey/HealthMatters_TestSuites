*** Settings ***
Documentation   Navigate to Settings – Restore
...             1. Click the "Patients" tab - click on the word "Restore" corresponding to the Client you would like to restore.
...             2. Click the "Patient Evaluations" tab - click on the word "Restore" corresponding to the Evaluation forms you would like to restore.
...             3. Click the "Patients consent forms" tab - click on the word "Restore" corresponding to the Consent form you would like to restore.
...             4. Click the "Evaluation templates" tab - click on the word "Restore" corresponding to the Evaluation form template that you would like to restore.
...             5. Click the "Consent form templates" tab - click on the word "Restore" corresponding to the Consent form templates that you would like to restore.
...             6. Click the "Logs" tab - click on the word "Restore" corresponding to the Client you would like to restore.
...             7. Click the "Unmatched data" tab - click on the word "Restore" corresponding to the unmatched data you would like to restore.
...
Default Tags    regression    re024    points-10    settings story    notester
Resource        ../../suite.robot
Suite Setup     Create patient and templates
Suite Teardown  Run Keywords    Remove patient and templates
...                             Return to mainpage
Test Teardown   Run Keyword If Test Failed    Custom screenshot

*** Test Cases ***
Restore a client
  [SETUP]    Client prep
  Given I am on the "restore" page
  When I hit the restore "Patients" tab
  And restore the top item    ${Restore first}
  Then return to mainpage
  And confirm that the client is restored

Restore an evaluation
  [SETUP]    Evaluation prep
  Given I am on the "restore" page
  When I hit the restore "Patient Evaluations" tab
  And restore the top item    Hard Breathing
  Then travel "fast" to "${Restore patient id}" patients "Nursing" page in "null"
  And confirm that "Hard Breathing" is restored in "evaluation"

Restore a consent form
  [SETUP]    Consent form prep
  Given I am on the "restore" page
  When I hit the restore "Patient consent forms" tab
  And restore the top item    Steam Room
  Then travel "fast" to "${Restore patient id}" patients "Admission" page in "null"
  And confirm that "Steam Room" is restored in "consent form"

Restore an evaluation form template
  [SETUP]    Evaluation template prep
  Given I am on the "restore" page
  When I hit the restore "Evaluation templates" tab
  And restore the top item    Hard Breathing
  Then I attempt to hit the "templates" tab
  And I hit the "templates evaluations" tab
  And confirm that "Hard Breathing" is restored in "evaluation form template"

Restore a consent form template
  [SETUP]    Consent form template prep
  Given I am on the "restore" page
  When I hit the restore "Consent form templates" tab
  And restore the top item    Steam Room
  Then I attempt to hit the "templates" tab
  And confirm that "Steam Room" is restored in "consent form template"

Restores logs
  [TAGS]    skip
  Given I am on the "restore" page
  When I hit the restore "Logs" tab
  And restore the top item
  Then confirm evaluation restore

Restore unmatched data
  [TAGS]    skip
  Given I am on the "restore" page
  When I hit the restore "Unmatched data" tab
  And restore the top item
  Then confirm evaluation restore

*** Keywords ***
Create patient and templates
  I select the "${_LOCATION 1}" location
  ${date} =    Convert Date    ${Todays Date}    result_format=%m/%d/%Y
  I create a valid patient    Sick    Drinking    Tired    ${date}
  ${first} =    Get Element Attribute    patient_first_name@value
  ${last} =    Get Element Attribute    patient_last_name@value
  Set Suite Variable    ${Restore first}    ${first}
  Set Suite Variable    ${Restore last}    ${last}
  Set Suite Variable    ${Restore patient id}    ${Current Id}
  I attempt to hit the "templates" tab
  I select the "My Locations" location
  Create tester template    consent forms    Steam Room
  Editing "consent forms" test template
  Form fill    consent forms form    patient process:dropdown=Admission    enabled:checkbox=x
  ...          patient sig req:checkbox=x    allow revocation:checkbox=x    rules:dropdown=Only if patient is male
  Run Keyword If    ${_LOCATIONS ACTIVE}    Form fill    consent forms form    all locations:checkbox=x
  Save "consent forms" template
  I am on the "templates" page
  I hit the "templates evaluations" tab
  Create tester template    evaluations    Hard Breathing
  Editing "evaluations" test template
  Form fill    evaluations form    enabled:checkbox=x    patient process:dropdown=Nursing
  Run Keyword If    ${_LOCATIONS ACTIVE}    Form fill    evaluations form    all locations:checkbox=x
  Save "evaluations" template
  I am on the "templates evaluations" page

Remove patient and templates
  Remove this patient    ${Restore first} ${Restore last}
  Go To    ${BASE URL}${TEMPLATES}
  Loop deletion    Remove old templates    Steam Room
  Go To    ${BASE URL}${TEMPLATES EVALUATIONS}
  Loop deletion    Remove old templates    Hard Breathing
  Return to mainpage

I hit the restore "${tab}" tab
  Click Element    //div[@id='Versions']/div[3]//span[.='${tab}']

Restore the top item
  [ARGUMENTS]    ${name}
  @{head} =    Get Webelements    //div[@id='Versions']/div[3]//tr[1]/th
  :FOR    ${index}    ${action}    IN ENUMERATE   @{head}
  \    ${action} =    Line parser    ${action.get_attribute('innerHTML')}    0
  \    Exit For Loop If    '${action}'=='Action'
  Wait Until Keyword Succeeds    10x    6s
  ...                            Run Keywords    Reload Page
  ...                            AND             Click Element    //td[contains(text(),'${name}')][1]/parent::tr/td[${index+1}]/a
  Wait Until Page Contains    Notice
  I am on the "restore" page

Confirm that the client is restored
  Wait Until Keyword Succeeds    10x    6s
  ...                            Run Keywords    Reload Page
  ...                            AND             Page Should Contain    ${Restore first} ${Restore last[:1]}

Confirm that "${name}" is restored in "${type}"
  ${passes} =    Run Keyword And Return Status    Should Not Contain    ${type}    template
  ${check} =    Set Variable If    ${passes}    //div[@id='sub_nav_content']/table//a[contains(text(),'${name}')]
                ...                             //div[@id='index_list']/*[1]//*[contains(text(),'${name}')]
  Wait Until Keyword Succeeds    10x    6s
  ...                            Run Keywords    Reload Page
  ...                            AND             Page Should Contain Element    ${check}

Client prep
  Return to mainpage
  Page Should Contain    ${Restore first} ${Restore last[:1]}
  Remove this patient    ${Restore first} ${Restore last}
  Page Should Not Contain    ${Restore first} ${Restore last[:1]}
  I hit the "settings" tab
  I hit the "Restore" view

Evaluation prep
  Travel "fast" to "${Restore patient id}" patients "nursing" page in "null"
  With this form "Hard Breathing" perform these actions "add"
  Page Should Contain Element    //div[@id='sub_nav_content']/table//a[contains(text(),'Hard Breathing')]
  Loop deletion    With this form "Hard Breathing" perform these actions "delete"
  Page Should Not Contain Element    //div[@id='sub_nav_content']/table//a[contains(text(),'Hard Breathing')]
  Go To    ${BASE URL}${RESTORE}

Consent form prep
  Travel "fast" to "${Restore patient id}" patients "admission" page in "null"
  With this form "Steam Room" perform these actions "add"
  Page Should Contain Element    //div[@id='sub_nav_content']/table//a[contains(text(),'Steam Room')]
  Loop deletion    With this form "Steam Room" perform these actions "delete"
  Page Should Not Contain Element    //div[@id='sub_nav_content']/table//a[contains(text(),'Steam Room')]
  Go To    ${BASE URL}${RESTORE}

Evaluation template prep
  Go To    ${BASE URL}${TEMPLATES EVALUATIONS}
  Loop deletion    Remove old templates    Hard Breathing
  Reload Page
  Page Should Not Contain    Hard Breathing
  Go To    ${BASE URL}${RESTORE}

Consent form template prep
  Go To    ${BASE URL}${TEMPLATES}
  Loop deletion    Remove old templates    Steam Room
  Reload Page
  Page Should Not Contain    Steam Room
  Go To    ${BASE URL}${RESTORE}
