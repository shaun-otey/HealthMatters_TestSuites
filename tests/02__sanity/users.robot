*** Settings ***
Documentation   Creates a user with limited access.
...             Makes sure this user cannot see certain features
...             Then properly deletes the user.
...
Default Tags    sanity    sa003    points-15    exceptions
Resource        ../../suite.robot
Suite Setup     Create a new user    locations=${_LOCATION 1};${_LOCATION 3};${_LOCATION 5}
Suite Teardown  Run Keywords    Exit system    ${false}
...             AND             Start login    ${CURRENT USER}    ${CURRENT PASS}
...             AND             Delete the new user
Test Setup      I select the "My Locations" location
Test Teardown   Login as admin user

*** Test Cases ***
Find the admin user
  Given I am on the "patients" page
  And set user search    ${Admin First}    ${Admin Last}
  When I hit the "users" tab
  Then the user is "in" the system
  [TEARDOWN]    Run Keywords    Login as admin user
  ...           AND             Set user search    robot    demo    new_user    new_pass0

Login as new user and look at what they can see
  Given I am on the "patients" page
  When exit system    ${false}
  And start login    ${Find User}    ${Find Pass}
  Then I will not see certain features

Do a bad login
  Given I am on the "patients" page
  When exit system    ${false}
  And start login    bad    login    ${false}
  Then page should have    Errors found    Invalid username or password
  ...                      If you’ve forgotten your password, please click the forgot password link below. If you continue to have trouble, please contact the designated Super Administrator for your facility.
  ...                      Kipu staff are not authorized to change user accounts and passwords.
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Start login    ${CURRENT USER}    ${CURRENT PASS}
  ...           AND             Return to mainpage

Active users
  Given I am on the "patients" page
  And I hit the "users" tab
  When I hit the "Active Users" view
  And I hit the "All" view
  Then verify that all search letters have names under them

Disabled users
  Given turning "on" the "user_disabled" roles for "${Find First};${Find Last}"
  And exit system    ${false}
  When start login    ${Find User}    ${Find Pass}    ${false}
  Then page should have    Errors found    User is Disabled/Locked
  ...                      Please contact the designated Super Administrator for your facility.
  ...                      Kipu staff are not authorized to re-enable locked or disabled user accounts.
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Start login    ${CURRENT USER}    ${CURRENT PASS}
  ...           AND             Turning "off" the "user_disabled" roles for "${Find First};${Find Last}"
  ...           AND             Return to mainpage

Assign roles
  ### EX
  Given I am on the "patients" page
  And I hit the "users" tab
  And I hit the "Assign Roles" view
  When going to "assign" the user "${Find First} ${Find Last}" to "auditor"
  And exit system    ${false}
  And start login    ${Find User}    ${Find Pass}
  Then Sleep    5

Unassign roles
  ### EX
  Given I am on the "patients" page
  And I hit the "users" tab
  And I hit the "Assign Roles" view
  When going to "unassign" the user "${Find First} ${Find Last}" to "doctor"
  And exit system    ${false}
  And start login    ${Find User}    ${Find Pass}
  Then Sleep    5

Assign locations
  Given I am on the "patients" page
  And I hit the "users" tab
  And I hit the "Assign Locations" view
  When going to "assign" the user "${Find First} ${Find Last}" to "${_LOCATION 2}"
  And exit system    ${false}
  And start login    ${Find User}    ${Find Pass}
  Then page should have    ${_LOCATION 1}    ${_LOCATION 3}    ${_LOCATION 2}

Unassign locations
  Given I am on the "patients" page
  And I hit the "users" tab
  And I hit the "Assign Locations" view
  When going to "unassign" the user "${Find First} ${Find Last}" to "${_LOCATION 5}"
  And exit system    ${false}
  And start login    ${Find User}    ${Find Pass}
  Then page should have    ${_LOCATION 1}    ${_LOCATION 3}    NOT|${_LOCATION 5}

Security
  [TAGS]    skip
  Given turning "on" the "restrict device access" roles for "admin"
  And I hit the "users" tab
  And I hit the "Security" view
  When I hit the "Authorize this device" text
  And slow wait    5
  And I hit the "Enable Two Factor Authentication" text
  And slow wait    5
  And exit system    ${false}
  Then start login    ${Find User}    ${Find Pass}
  And Sleep    5
  And Run Keyword And Ignore Error    exit system    ${false}
  Then start login    ${CURRENT USER}    ${CURRENT PASS}
  And Sleep    5

Authorize ip numbers
  [TAGS]    skip

Template management
  [TEMPLATE]    Add the ${manage} template permissions and the user will see those templates
  all
  orders;group s;consent eval
  orders;group s
  orders;consent eval
  group s;consent eval
  consent eval
  group s
  orders
  none

Dea number shown for doctors
  [SETUP]    Run Keywords    I select the "My Locations" location
  ...                        Prepare signatures
  [TEMPLATE]    Verify when group session is ${gs switch}, evaluations is ${eval switch},
  ...           and doctor orders is ${doc switch}, that the dea number is properly presented
  npi    ${EMPTY}    ${EMPTY}
  on     on          on
  on     on          off
  on     off         on
  on     off         off
  off    on          on
  off    on          off
  off    off         on
  off    off         off
  [TEARDOWN]    Cleanup signatures

Setup a pin
  Given I am on the "patients" page
  And turning "on;MD;987654321;6544569871" the "Doctor;title;dea number:js;npi number" roles for "${Find First};${Find Last}"
  When exit system    ${false}
  And start login    ${Find User}    ${Find Pass}
  And I hit the "username" tab
  And Input Text    password    ${Find Pass}
  And Click Button    commit
  And form fill    new user    keep my order=${true}    sign pin:checkbox=x    pin=1234
  And perform signature    Click Element    open-signature-dialog
  Then verify for no bad page
  And Wait Until Page Contains    Notice
  [TEARDOWN]    Run Keywords    Login as admin user
  ...           AND             Turning "off;${EMPTY};${EMPTY};${EMPTY}" the "Doctor;title;dea number:js;npi number" roles for "${Find First};${Find Last}"
  ...           AND             Return to mainpage

Group sessions appear correctly for that users assigned locations
  [SETUP]    Run Keywords    I select the "My Locations" location
  ...                        Prepare the group session
  Given I am on the "schedules" page
  When completing a group session
  Then page should have    ${Gs name}
  And I hit the "past group sessions" tab
  And page should have    ${Gs name}
  When exit system    ${false}
  And start login    ${Find User}    ${Find Pass}
  And I hit the "schedules" tab
  Then page should have    NOT|${Gs name}
  And I hit the "past group sessions" tab
  And page should have    NOT|${Gs name}
  [TEARDOWN]    Run Keywords    Login as admin user
  ...           AND             Turning "off;off" the "Manage group sessions;Review group sessions" roles for "${Find First};${Find Last}"
  ...           AND             I hit the "schedules" tab
  ...           AND             Return "${Gs name}" to upcoming group sessions
  ...           AND             Delete tester template    group sessions
  ...           AND             Return to mainpage

User will login to their default location
  Given I am on the "patients" page
  When I select the "${_LOCATION 5}" location
  Then the location drop list will show "${_LOCATION 5}"
  When exit system    ${false}
  And start login    ${CURRENT USER}    ${CURRENT PASS}
  Then the location drop list will show "${_LOCATION 5}"
  When I hit the "username" tab
  And form fill    new user    default location:dropdown=${_LOCATION 3}
  And Click Button    Update
  And Wait Until Page Contains    Notice
  And exit system    ${false}
  And start login    ${CURRENT USER}    ${CURRENT PASS}
  Then the location drop list will show "${_LOCATION 3}"
  [TEARDOWN]    Run Keywords    Login as admin user
  ...           AND             I hit the "username" tab
  ...           AND             Form fill    new user    default location:dropdown=${EMPTY}
  ...           AND             Click Button    Update
  ...           AND             Wait Until Page Contains    Notice
  ...           AND             Return to mainpage

User as a super admin with no locations assigned can check their profile
  [SETUP]    Run Keywords    Pocket global vars    Find First    Find Last    Find User    Find Pass
  ...        AND             Create a new user    ultar    amind    new_user_sa    new_pass_3    sup@min.com
  ...                        ${_LOCATION 1}    Super admin
  Given I am on the "patients" page
  And exit system    ${false}
  And start login    ${Find User}    ${Find Pass}
  When I hit the "username" tab
  Then verify for no bad page
  When unassigning my location
  And Run Keyword And Continue On Failure    I hit the "username" tab
  Then verify for no bad page
  When Click Link    Sign out
  And Location Should Be    ${BASE URL}${SIGN IN}
  And start login    ${Find User}    ${Find Pass}    ${false}
  Then page should have    Errors found    Your account must have at least one (1) location assigned. Please contact your facility's Kipu administrator.
  And custom screenshot
  [TEARDOWN]    Run Keywords    Go Back
  ...           AND             Run Keyword And Ignore Error    Login as admin user
  ...           AND             Delete the new user
  ...           AND             Pocket global vars    restore

User as a records admin will be able to modify facesheet contacts
  [SETUP]    Run Keywords    I select the "My Locations" location
  ...                        Turning "on" the "Records admin" roles for "${Find First};${Find Last}"
  ...                        Travel "slow" to "tester" patients "facesheet" page in "${_LOCATION 1}"
  ...                        Update contacts info first time
  ...                        Return to mainpage
  Given I am on the "patients" page
  And exit system    ${false}
  And start login    ${Find User}    ${Find Pass}
  When travel "slow" to "tester" patients "facesheet" page in "${_LOCATION 1}"
  Then page should have    ELEMENT|patient_contact
  When update contacts info second time
  And I hit the "Show Facesheet" view
  Then verify updated contacts info
  [TEARDOWN]    Run Keywords    Login as admin user
  ...                           Turning "off" the "Records admin" roles for "${Find First};${Find Last}"
  ...                           Travel "slow" to "tester" patients "facesheet" page in "null"
  ...                           Remove contact
  ...                           Return to mainpage

User as a records admin will be able to modify eval notes
  [SETUP]    Run Keywords    I select the "My Locations" location
  ...                        Turning "on" the "Records admin" roles for "${Find First};${Find Last}"
  ...                        Do a quick notes evaluation setup
  ...                        Travel "fast" to "tester" patients "nursing" page in "${_LOCATION 1}"
  ...                        With this form "Kyle Has Left Me" perform these actions "add"
  ...                        Return to mainpage
  Given I am on the "patients" page
  And exit system    ${false}
  And start login    ${Find User}    ${Find Pass}
  When travel "slow" to "tester" patients "nursing" page in "${_LOCATION 1}"
  Then with this form "Kyle Has Left Me" perform these actions "edit"
  [TEARDOWN]    Run Keywords    Login as admin user
  ...                           Turning "off" the "Records admin" roles for "${Find First};${Find Last}"
  ...                           Remove quick template
  ...                           Return to mainpage

User as a records admin will be able to search for patients
  [SETUP]    Run Keywords    I select the "My Locations" location
  ...                        Turning "on" the "Records admin" roles for "${Find First};${Find Last}"
  ...                        Return to mainpage
  Given I am on the "patients" page
  And exit system    ${false}
  And start login    ${Find User}    ${Find Pass}
  When searching for "${Test First}"
  Then page should have    NOT|Access denied    Results
  [TEARDOWN]    Run Keywords    Login as admin user
  ...                           Turning "off" the "Records admin" roles for "${Find First};${Find Last}"
  ...                           Return to mainpage

User as a doctor can see all patient tabs
  [SETUP]    Run Keywords    I select the "My Locations" location
  ...                        Turning "on" the "Doctor" roles for "${Find First};${Find Last}"
  ...                        Return to mainpage
  Given I am on the "patients" page
  And exit system    ${false}
  And start login    ${Find User}    ${Find Pass}
  When I select patient "1"
  Then hit all available patient tabs
  [TEARDOWN]    Run Keywords    Login as admin user
  ...                           Turning "off" the "Doctor" roles for "${Find First};${Find Last}"
  ...                           Return to mainpage

User with the manage users feature can add new users
  Given turning "on" the "Manage users" roles for "${Find First};${Find Last}"
  And exit system    ${false}
  And start login    ${Find User}    ${Find Pass}
  When creating a new user from a manage user role
  And exit system    ${false}
  Then start login    ${Find User}    ${Find Pass}
  [TEARDOWN]    Run Keywords    Login as admin user
  ...           AND             Delete the new user
  ...           AND             Pocket global vars    restore
  ...           AND             Turning "off" the "Manage users" roles for "${Find First};${Find Last}"

User as just a tech can only view mars when administer only is set
  Given I am on the "patients" page
  And I hit the "settings" tab
  And I hit the "Instance" view
  When marking all mars as administered
  And travel "slow" to "tester" patients "medical orders" page in "null"
  And create a doctor order    medication
  Then I hit the "med log" patient tab
  And I "can" save the mars
  When exit system    ${false}
  And start login    ${Find User}    ${Find Pass}
  And travel "slow" to "tester" patients "med log" page in "null"
  Then I "cannot" save the mars

*** Keywords ***
Login as admin user
  Run Keyword If Test Failed    Custom screenshot
  Exit system    ${false}
  Start login    ${CURRENT USER}    ${CURRENT PASS}
  Return to mainpage

I will not see certain features
  Page Should Not Contain Link    ${SETTINGS}

Verify that all search letters have names under them
  @{alpha nav} =    Get Webelements    //div[@id='sub_nav_content']/ul[1]/li[position()>1]/a
  FOR    ${index}    ${letter}    IN ENUMERATE    @{alpha nav}
      ${letter} =    Convert To Lowercase    ${letter.get_attribute('innerHTML')}
      Set List Value    ${alpha nav}    ${index}    ${letter}
  END
  @{user names} =    Get Webelements    //table[@id='users']/tbody/tr/td[1]/a
  FOR    ${index}    ${name}    IN ENUMERATE    @{user names}
      ${name} =    Convert To Lowercase    ${name.get_attribute('innerHTML')}
      Set List Value    ${user names}    ${index}    ${name[0]}
  END
  @{user names} =    Remove Duplicates    ${user names}
  Lists Should Be Equal    ${alpha nav}    ${user names}

Going to "${assignment}" the user "${user}" to "${role}"
  ${user} =    Set Variable    //label[starts-with(@for,'${TEST NAME.replace('s','').split()[1]}_${TEST NAME.split()[1]}_users_attributes_') and contains(text(),'${user}')]
  Click Element    //a[contains(text(),'${role}')]
  Run Keyword If    '${assignment}'=='assign'    Run Keywords    Select Checkbox    ${user}/preceding-sibling::input[1]
  ...                                            AND             Click Button    Assign Selected
  ...               ELSE                         Run Keywords    Select Checkbox    ${user}/preceding-sibling::input[1]
  ...                                            AND             Click Button    Unassign Selected

The location drop list will show "${location}"
  Element Should Contain    //form[@id='switch_my_location']/div[@class='currentValue']//div[@class='location']
  ...                       ${location}

Prepare signatures
  Set Test Variable    ${Dea number}    GG1234563
  Set Test Variable    ${Npi number}    2712345697
  # Set Test Variable    ${Dea number}    8954587966
  # Set Test Variable    ${Npi number}    1247895898
  I hit the "username" tab
  ${passes 1} =    Run Keyword And Return Status    Element Should Contain    //label[@for='user_npi_number']
                   ...                              NPI Number
  ${passes 2} =    Run Keyword And Return Status    Element Should Not Contain    //label[@for='user_npi_number']
                   ...                              For physicians:
  ${npi check} =    Set Variable If    ${passes 1} and ${passes 2}    ${true}    ${false}
  Set Test Variable    ${Npi check}    ${npi check}
  Turning "on;${Dea number};${Npi number}" the "Doctor;dea number:js;npi number" roles for "admin"
  Go To    ${BASE URL}${TEMPLATES EVALUATIONS}
  Create tester template    evaluations    Shakey Pdf
  Editing "evaluations" test template
  Form fill    evaluations form    enabled:checkbox=x    patient process:dropdown=Nursing
  ...          staff_user_title_16:direct_check=x
  Run Keyword If    ${_LOCATIONS ACTIVE}    Form fill    evaluations form    all locations:checkbox=x
  Save "evaluations" template
  Group session signature
  Evaluations signature
  Doctor orders session signature
  Return to mainpage

Group session signature
  Go To    ${BASE URL}${SCHEDULES}
  I hit the "Living Skills:" text
  Click Element    form_submit
  Ajax wait
  Click Button    Group leader sign off & submit
  Ajax wait
  Click Element    //canvas
  Click Button    Submit
  Ajax wait

Evaluations signature
  Travel "fast" to "tester" patients "nursing" page in "${_LOCATION 1}"
  With this form "Shakey Pdf" perform these actions "add;edit"
  I hit the "Sign & Submit" text
  Ajax wait
  Click Element    //canvas
  Click Button    Submit
  Ajax wait

Doctor orders session signature
  Travel "fast" to "tester" patients "medical orders" page in "null"
  ${order} =    Create a doctor order    medication
  Set Test Variable    ${Order}    ${order}
  Click Element    open-signature-dialog
  Ajax wait
  Click Element    //canvas
  # Click Button    Submit
  Click Element    //div[@id='signature-dialog']/following-sibling::div[1]//button[.='Submit']
  Ajax wait

Cleanup signatures
  Run Keyword If Test Failed    Custom screenshot
  Go To    ${BASE URL}${SCHEDULES}
  Return "Living Skills:" to upcoming group sessions
  Travel "fast" to "tester" patients "nursing" page in "null"
  Loop deletion    With this form "Shakey Pdf" perform these actions "delete"
  Travel "fast" to "tester" patients "medical orders" page in "null"
  Loop deletion    Remove any orders
  Delete tester template    evaluations
  Turning "off;${EMPTY};${EMPTY}" the "Doctor;dea number:js;npi number" roles for "admin"
  Return to mainpage

Prepare the group session
  Set Test Variable    ${Gs name}    Keen Bruschwerst
  Turning "on;on" the "Manage group sessions;Review group sessions" roles for "${Find First};${Find Last}"
  Go To    ${BASE URL}${TEMPLATES GROUP SESSIONS}
  Create tester template    group sessions    ${Gs name}
  Editing "group sessions" test template
  ${day} =    Convert Date    ${Todays Date}    %A    False    %Y-%m-%d
  &{locations hit} =    Create dict for locations    ${_LOCATION 4}
  Form fill    group sessions form    enabled:checkbox=x    week day:dropdown=${day}    &{locations hit}
  Save "group sessions" template
  I hit the "schedules" tab
  Loop deletion    Return "${Gs name}" to upcoming group sessions

Completing a group session
  Bypass edit the "${Gs name}" session
  Click Element    form_submit
  Ajax wait
  Click Button    Group leader sign off & submit
  Click Element    //canvas
  Click Button    Submit
  Ajax wait

Add the ${manage} template permissions and the user will see those templates
  ${roles} =    Run Keyword If    '${manage}'=='all'    Set Variable    on
                ...               ELSE                  Set Variable    off
  ${manage} =    Split String    ${manage}    ;
  FOR    ${permission}    IN    consent eval    group s    orders
      ${passes} =    Run Keyword And Return Status    List Should Contain Value    ${manage}    ${permission}
      ${roles} =    Run Keyword If    ${passes}    Catenate    SEPARATOR=;    ${roles}    on
                    ...               ELSE         Catenate    SEPARATOR=;    ${roles}    off
  END
  Turning "${roles}" the "Manage templates;Manage templates - consents and evaluations;Manage templates - group sessions;Manage templates - orders" roles for "${Find First};${Find Last}"
  Exit system    ${false}
  Start login    ${Find User}    ${Find Pass}
  Run Keyword If    '@{manage}[0]'=='none'    Run Keyword And Return    Page should have
  ...                                         NOT|ELEMENT|//a[.='Templates']
  ...               ELSE                      Page should have    ELEMENT|//a[.='Templates']
  # I attempt to hit the "templates" tab
  I hit the "Templates" text
  ${template link} =    Set Variable    //div[@id='sub_nav']//a[@href='/$TEMPLATE']
  Run Keyword And Return If    '@{manage}[0]'=='all'    Page should have
  ...                                                   ELEMENT|${template link.replace('$TEMPLATE','consent_forms')}
  ...                                                   ELEMENT|${template link.replace('$TEMPLATE','evaluations')}
  ...                                                   ELEMENT|${template link.replace('$TEMPLATE','orders')}
  ...                                                   ELEMENT|${template link.replace('$TEMPLATE','group_sessions')}
  ...                                                   ELEMENT|${template link.replace('$TEMPLATE','schedules')}
  Run Keyword If    'consent eval' in ${manage}    Page should have
  ...                                              ELEMENT|${template link.replace('$TEMPLATE','consent_forms')}
  ...                                              ELEMENT|${template link.replace('$TEMPLATE','evaluations')}
  ...               ELSE                           Page should have
  ...                                              NOT|ELEMENT|${template link.replace('$TEMPLATE','consent_forms')}
  ...                                              NOT|ELEMENT|${template link.replace('$TEMPLATE','evaluations')}
  Run Keyword If    'group s' in ${manage}    Page should have
  ...                                         ELEMENT|${template link.replace('$TEMPLATE','group_sessions')}
  ...                                         ELEMENT|${template link.replace('$TEMPLATE','schedules')}
  ...               ELSE                      Page should have
  ...                                         NOT|ELEMENT|${template link.replace('$TEMPLATE','group_sessions')}
  ...                                         NOT|ELEMENT|${template link.replace('$TEMPLATE','schedules')}
  Run Keyword If    'orders' in ${manage}    Page should have    ELEMENT|${template link.replace('$TEMPLATE','orders')}
  ...               ELSE                     Page should have
  ...                                        NOT|ELEMENT|${template link.replace('$TEMPLATE','orders')}
  [TEARDOWN]    Run Keywords    Exit system    ${false}
  ...           AND             Start login    ${CURRENT USER}    ${CURRENT PASS}

Verify when group session is ${gs switch}, evaluations is ${eval switch}, and doctor orders is ${doc switch}, that the dea number is properly presented
  Run Keyword And Return If    '${gs switch}'=='npi'    Should Be True    ${Npi check}    Bad NPI text check!
  Go To    ${BASE URL}${INSTANCE}
  @{switches} =    Create List    ${gs switch}    ${eval switch}    ${doc switch}
  @{options} =    Create List    Group Sessions    Evaluations    Doctor Orders
  @{actions} =    Create List    ${EMPTY}
  FOR    ${switch}    ${option}    IN ZIP    ${switches}    ${options}
      Run Keyword If    '${switch}'=='on'    Run Keywords    Set List Value    ${actions}    0    Select
      ...                                    AND             Append To List    ${actions}    ${EMPTY}
      ...               ELSE                 Run Keywords    Set List Value    ${actions}    0    Unselect
      ...                                    AND             Append To List    ${actions}    NOT|
      Instance edit "@{actions}[0] Checkbox" on "${option}"
  END
  Click Button    commit
  Ajax wait
  Go To    ${BASE URL}${SCHEDULES}
  I hit the "Living Skills:" text
  Page should have    @{actions}[1]DEA: ${Dea number}
  Custom screenshot
  Travel "fast" to "tester" patients "nursing" page in "null"
  I hit the "Shakey Pdf" text
  Page should have    @{actions}[2]DEA: ${Dea number}
  Custom screenshot
  Travel "fast" to "tester" patients "medical orders" page in "null"
  I hit the "${Order}" text
  Page should have    @{actions}[3]DEA: ${Dea number}
  Custom screenshot

Hit all available patient tabs
  ${tabs} =    Get Webelements    //div[@id='sub_nav']/ul/li
  ${link} =    Set Variable    tab.find_element_by_tag_name('a').get_attribute('href').split('${BASE URL}')[-1]
  FOR    ${index}    ${tab}   IN ENUMERATE    @{tabs}
      Set List Value    ${tabs}    ${index}    ${${link}}
  END
  FOR    ${tab}    IN    @{tabs}
      ${passes} =    Run Keyword And Return Status    Click Link    default=${tab}
      ${passes} =    Run Keyword And Return Status    Run Keyword Unless    ${passes}    Click Element
                     ...                              //*[contains(@href,'process=${tab.split('process=')[1]}')]
      Run Keyword Unless    ${passes}    Click Element
      ...                   //*[contains(@href,'end_time') and contains(@href,'start_time')]
      Verify for no bad page
  END

Creating a new user from a manage user role
  Pocket global vars    Find First    Find Last    Find User    Find Pass
  Create a new user    simple    elpmis    new_simple    new_simple_2    sim@ple.com    ${_LOCATION 3}
  Verify for no bad page

Unassigning my location
  Form fill    new user    //label[contains(text(),'${_LOCATION 1}')]/../input:direct_check=o
  Click Button    Update
  Verify for no bad page
  Run Keyword And Continue On Failure    Wait Until Page Contains    Notice

Update contacts info first time
  Click Link    Add ${Patient Handle.lower()} contact
  Ajax wait
  Update facesheet    contact full name=Javi Perez    contact phone=102 293 4856    contact notes=the tests are failing
  ...                 contact type:dropdown=Next of kin    contact alt phone=658 574 6853    contact email=jz@megas.com
  ...                 contact rship:dropdown=Brother/Sister    contact address=somewhere dont search him

Update contacts info second time
  Update facesheet    contact full name=True Perez    contact phone=658 439 2201    contact notes=somewhere testing
  ...                 contact type:dropdown=Legal    contact alt phone=658 000 000    contact email=get@megas.com
  ...                 contact rship:dropdown=Friend    contact address=far into Denver

Then verify updated contacts info
  Page should have    True Perez    658-439-2201    somewhere testing    Legal    658-000-000    get@megas.com    Friend
  ...                 far into Denver

Remove contact
  I hit the "Delete Contact" view
  Ajax wait
  Click Button    patient[auto_submit]
  Ajax wait
  Give a "passing" facesheet validation

Do a quick notes evaluation setup
  I attempt to hit the "templates" tab
  I hit the "templates evaluations" tab
  Create tester template    evaluations    Kyle Has Left Me
  Editing "evaluations" test template
  Run Keyword If    ${_LOCATIONS ACTIVE}    Form fill    evaluations form    all locations:checkbox=x
  Add eval item
  Form fill    evaluations form    enabled:checkbox=x    patient process:dropdown=Nursing    item name=notes
  ...          item label=notes    item field type:dropdown=notes
  Save "evaluations" template

Remove quick template
  Travel "fast" to "tester" patients "nursing" page in "null"
  With this form "Kyle Has Left Me" perform these actions "delete"
  Delete tester template    evaluations

Marking all mars as administered
  Instance edit "Select From List By Label:Mark all MARs as administered" on "Observation Status:dropdown"
  Click Button    commit
  Ajax wait

I "${status}" save the mars
  Run Keyword If    '${status}'=='can'    Page should have    ELEMENT|//input[@value='Save status']
  ...               ELSE                  Page should have    NOT|ELEMENT|//input[@value='Save status']
