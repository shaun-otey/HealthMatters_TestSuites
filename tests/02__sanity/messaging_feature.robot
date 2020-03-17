*** Settings ***
Documentation   Users can send each other messages only when they have user accounts created within the same "instance".
...             You can send each other messages by clicking on your name on
...             the top right>click on Messages> click on new Thread> select a recipient and write your message (click send).
...
...             Users can check their messages that are new by clicking on the mailbox icon or clicking on their name on the top right.
...
...             There is a second way to be able to send messages. Click on a patient>click on messages>create a message..
...
Default Tags    sanity    sa012    ntrdy
Resource        ../../suite.robot
Suite Setup     Start two user setup
Suite Teardown  Clean the two user setup
Test Teardown   Run Keywords    Run Keyword If Test Failed    Custom screenshot
...             AND             Reset users to mainpage

*** Test Cases ***
Passing messages between users
  Given I am on the "patients" page
  And I hit the "username" tab
  And I hit the "Messages" view
  When starting a new thread
  And go to "ending" user messages loop containing "${ADMIN FIRST}" and "${ADMIN LAST}"
  Then page should have    ${Find first}    ${Find last}    Robot received

Passing messages related to a patient
  [TAGS]    skip
  Given I am on the "patients" page
  And Switch Browser    2
  And I select the "${_LOCATION 1}" location
  When I select patient "${Test first}"
  And starting a new patient thread
  And go to "starting" user messages loop containing "${Find first}" and "${Find last}"
  Then open message
  And page should have    ${ADMIN FIRST}    ${ADMIN LAST}    Robot received

Sending faxes
  [TAGS]    testmefax
  [SETUP]    Run Keywords    Go To    ${BASE URL}${INSTANCE}
  ...        AND             Instance edit "Select Checkbox" on "Enable faxing"
  ...        AND             Click Button    commit
  ...        AND             Ajax wait
  ...        AND             Set username id
  ...        AND             Turning "on;on" the "Manage faxes;Manage pharmacy orders" roles for "admin"
  ...        AND             I hit the "settings" tab
  ...        AND             I hit the "Konnectors" view
  ...        AND             Loop deletion    Click Element    //a[.\='Top QA Pharmacy']/ancestor::td[1]/following-sibling::td[last()]/a
  ...        AND             I hit the "New Konnector" text
  ...        AND             Form fill    vendor    name=Top QA Pharmacy    type:dropdown=Pharmacy
  ...        AND             Setup a pharmacy
  ...        AND             Return to mainpage
  Given I am on the "patients" page
  travel "fast" to "tester" patients "medical orders" page in "${_LOCATION 1}"
  create a doctor order    medication
  I hit the "Fax to pharmacy" text
  # Ajax wait
  Click Element    //label[starts-with(@for,'order_ids_')]
  # Click Button    Submit
  Click Element    //*[contains(text(),'Submit')]
  Ajax wait
  Click Element    //a[@role='submit']
  Ajax wait
  Page Should Contain    Orders successfully faxed. Please check the status to track delivery.
  Sleep    30
  [TEARDOWN]    Run Keywords    Go To    ${BASE URL}${INSTANCE}
  ...           AND             Instance edit "Unselect Checkbox" on "Enable faxing"
  ...           AND             Click Button    commit
  ...           AND             Ajax wait
  ...           AND             Turning "off;off" the "Manage faxes;Manage pharmacy orders" roles for "admin"
  ...           AND             Go To    ${BASE URL}${KONNECTORS}
  ...           AND             Loop deletion    Click Element    //a[.\='Top QA Pharmacy']/ancestor::td[1]/following-sibling::td[last()]/a
  ...           AND             Return to mainpage

*** Keywords ***
Start two user setup
  I hit the "username" tab
  I hit the "Messages" view
  Loop deletion    Click Element    //li[starts-with(@id,'message_thread_')]/div/div/a[2]
  Create a new user
  Start new window process    2700    20
  Switch Browser    2
  Start login    ${Find user}    ${Find pass}
  I am on the "patients" page
  Switch Browser    1

Clean the two user setup
  Switch Browser    2
  Exit system
  Switch Browser    1
  I hit the "username" tab
  I hit the "Messages" view
  Loop deletion    Click Element    //li[starts-with(@id,'message_thread_')]/div/div/a[2]
  Delete the new user
  I am on the "patients" page

Reset users to mainpage
  Switch Browser    2
  Return to mainpage
  Switch Browser    1
  Return to mainpage

Starting a new thread
  Click Link    /messages/threads/new
  Slow wait
  Input Text    //input[@class='default']    .
  Input Text    //input[@class='default']    ${Find first} ${Find last}
  Slow wait
  Press Key    //input[@class='default']    \\13
  Input Text    message_content    Ransom robot call
  Click Element    sendNewMessageButton

Starting a new patient thread
  Open message
  Slow wait
  Page Should Contain    Messages related to ${Test first} ${Test middle} ${Test last}
  Click Element    //a[@href='#newMessageOnThread']
  Slow wait
  Input Text    //input[@class='default']    .
  Input Text    //input[@class='default']    ${ADMIN FIRST} ${ADMIN LAST}
  Slow wait
  Press Key    //input[@class='default']    \\13
  Input Text    message_content    Ransom robot call
  Click Element    sendNewMessageButton

Open message
  Click Element    //a[${CSS SELECT} " kmcLinkableMessagesOpener ")]

Go to "${goto}" user messages loop containing "${first}" and "${last}"
  Run Keyword If    '${goto}'=='starting'    Run Keywords    Switch Browser    1
  ...                                        AND             Set Test Variable    ${goto}    ending
  ...               ELSE                     Run Keywords    Switch Browser    2
  ...                                        AND             Set Test Variable    ${goto}    starting
  Sleep    2
  Reload Page
  ${passes} =    Run Keyword And Return Status    I am on the "patients" page
  Run Keyword If    ${passes}    Run Keywords    Look for message
  ...                            AND             Page should have    ${first}    ${last}    Ransom robot call
  ...                            AND             Input Text    newMessage    Robot received
  ...                            AND             Click Element    pushNewMessage
  ...                            AND             Go to "${goto}" user messages loop containing "${first}" and "${last}"

Look for message
  Run Keyword If    '${TEST NAME}'=='Passing messages related to a patient'    Run Keywords    I select the "${_LOCATION 1}" location
  ...                                                                          AND             I select patient "${Test first}"
  ...                                                                          AND             Open message
  ...                                                                          AND             Slow wait
  ...               ELSE                                                       Click Link    /messages

Setup a pharmacy
  Click Button    commit
  Ajax wait
  &{locations hit} =    Create dict for locations    ${_LOCATION 1};${_LOCATION 2};${_LOCATION 3};${_LOCATION 5}
  Form fill    vendor    status:checkbox=x    contact name=Jason Markson    contact phone=800-555-8888    zip=33333
  ...          address|1=98 Coastal Street    city=Local    state:dropdown=Florida    company phone=800-555-8888
  ...          company fax=800-555-9999    pharmacy fax number=305-675-0322    &{locations hit}
  Click Button    commit
  Ajax wait
