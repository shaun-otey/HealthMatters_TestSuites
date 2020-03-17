*** Settings ***
Documentation   Keywords designed to setup variables for test suites.
...

*** Variables ***
${TEST TZ}                        MIAMI
${MIAMI}                          25.7823907,-80.2996703 -5
${BOGOTA}                         4.6482836,-74.2482367 -5
${MID-ATLANTIC}                   37.7449602,-25.6959997 -2
${TIJUANA}                        32.4966814,-117.0882349 -8
${BERLIN}                         52.5065117,13.143869 +1

*** Keywords ***
Do teardown
  [ARGUMENTS]    @{action}
  ${passes}    ${status} =    Run Keyword And Ignore Error    @{action}
  Run Keyword If    '${passes}'=='FAIL'    Run Keywords    Set Global Variable    ${Escape Teardown}    ${true}
  ...                                      AND             Fail    End teardown!
  ...               ELSE                   Set Global Variable    ${Escape Teardown}    ${false}
  Return From Keyword    ${status}

Pocket global var
  [ARGUMENTS]    ${name}
  ${pocket} =    Run Keyword If    '${name}'!='restore'    Create List    ${name}    ${${name}}
  Run Keyword If    '${name}'=='restore'    Set Global Variable    ${${Pocket Var[0]}}    ${Pocket Var[1]}
  ...               ELSE                    Set Global Variable    ${Pocket Var}    ${pocket}
  [RETURN]    ${Pocket Var[1]}

Pocket global vars
  [ARGUMENTS]    @{names}
  ${pocket} =    Create Dictionary
  FOR    ${name}    IN    @{names}
      Exit For Loop If    "${name}"=="restore"
      Set To Dictionary    ${pocket}    ${name}=${${name}}
  END
  Run Keyword If    "${name}"!="restore"    Run Keywords    Set Global Variable    ${Pocket Var}    ${pocket}
  ...                                       AND             Return from Keyword
  @{names} =    Get Dictionary Keys    ${Pocket Var}
  FOR    ${name}    IN    @{names}
      Set Global Variable    ${${name}}    &{Pocket Var}[${name}]
  END

Get root directory and count id and empty test and clean me
  ${root} =    Remove String    ${EXECDIR}
  Set Global Variable    ${Root Dir}    ${root}
  Set count id
  Set Global Variable    ${Screenshot Index}    ${0}
  Set Global Variable    ${Test Mr}    ${EMPTY}
  Set Global Variable    ${Test Id}    ${EMPTY}
  Set Global Variable    ${Test First}    ${EMPTY}
  @{clean} =    Create List    ${EMPTY}
  Set Global Variable    ${Clean Me Up}    ${clean}

Set count id
  [ARGUMENTS]    ${id}=0
  ${numb}    @{plus} =    Split String From Right    ${id}    +
  ${numb}    @{minus} =    Split String From Right    ${numb}    -
  ${old id} =    Set Variable If    @{plus}==[ ] and @{minus}==[ ]    0    ${Cid}
  ${new id} =    Evaluate    ${old id}+${${id}}
  Set Global Variable    ${Cid}    ${new id}

Get todays date
  ${date} =    Get Current Date    result_format=%Y-%m-%d
  Set Global Variable    ${Todays Date}    ${date}

Increment Running Screenshot
  Set Global Variable    ${Screenshot Index}    ${Screenshot Index+1}
  [RETURN]    ${Screenshot Index}

Create download directory
  # ${path} =    Run Keyword If    '${UUID}'!='0'    Set Variable    Downloads/${UUID}
  #              ...               ELSE              Join Path    ${OUTPUT DIR}    Downloads
  ${path} =    Join Path    ${Root Dir}    Downloads/${UUID}
  Create Directory    ${path}
  Set Global Variable    ${Download Path}    ${path}

Set patient handle
  [ARGUMENTS]    ${handle}=${EMPTY}
  Run Keyword And Return If    '${handle}'!='${EMPTY}'    Set Global Variable    ${Patient Handle}    ${handle}
  ${handle} =    Get Text    //a[contains(@href,'${PATIENTS}')]
  Set Global Variable    ${Patient Handle}    ${handle[0:-1].title()}

Server testing startup
  # Set Global Variable    ${CURRENT USER}    ${HUG U}
  # Set Global Variable    ${CURRENT PASS}    ${HUG P}
  Start new window process
  # Maximize Browser Window
  # Create a master user    HugS    ServTester    HSTHUMAN    awsxd_awsxd_1
  # Set user search    admin    admin    ${EMPTY}    ${EMPTY}
  # I hit the "users" tab
  # The user is "in" the system
  # Click Link    Edit
  # Form fill    new user    password=password1234    password confirmation=password1234    current password=${CURRENT PASS}
  # Click Button    Update
  # Set Global Variable    ${HM USER}    HSTHUMAN
  # Set Global Variable    ${HM PASS}    awsxd_awsxd_1
  # Set Global Variable    ${CURRENT USER}    ${HM USER}
  # Set Global Variable    ${CURRENT PASS}    ${HM PASS}
  # Set Global Variable    ${Admin First}    HugS
  # Set Global Variable    ${Admin Last}    ServTester
  Start login    ${CURRENT USER}    ${CURRENT PASS}

Prepare variable locations
  I hit the "settings" tab
  I hit the "Instance" view
  Execute Javascript    document.getElementById("site_setting_number_of_locations").removeAttribute("disabled");
  ...                   document.getElementById("site_setting_enforce_locations").removeAttribute("disabled")
  ${number of locations} =    Instance edit "Input Text:20" on "Number of locations:text"
  ${enforce locations} =    Instance edit "Select Checkbox" on "Enforce locations"
  Click Button    commit
  Ajax wait
  I hit the "Company" view
  :FOR    ${name}    IN    ${_LOCATION ALT 1}    ${_LOCATION ALT 2}    ${_LOCATION ALT 3}    ${_LOCATION ALT 5}
  \    Loop deletion    Dialog action    Click Element    //a[.\='${name}']/../following-sibling::td/a[2]
  \    Ajax wait
  \    Page Should Not Contain    ${name}
  &{tz locations} =    Create Dictionary
  Set Global Variable    ${Tz Locations}    ${tz locations}
  :FOR    ${index}    ${d}    IN ENUMERATE
  ...     ${_LOCATION ALT 1}|(GMT-05:00) Eastern Time (US & Canada)    ${_LOCATION ALT 2}|(GMT-05:00) Bogota
  ...     ${_LOCATION ALT 3}|(GMT+01:00) Berlin    null    ${_LOCATION ALT 5}|(GMT-08:00) Tijuana
  \    Continue For Loop If    ${index}==3
  \    ${name}    ${timezone} =    Split String    ${d}    |
  \    ${passes} =    Run Keyword And Return Status    Page Should Have    ${_LOCATION ${index+1}}
  \    Run Keyword If    ${passes}    Continue For Loop If    ${index}==0
  \    ...               ELSE         Set Global Variable    ${_LOCATION ${index+1}}    ${_LOCATION ALT ${index+1}}
  \    Wait Until Page Contains Element    //a[@href='/company_settings/1/locations/new']
  \    Click Link    /company_settings/1/locations/new
  \    Page Should Contain    New location
  \    Form fill    new location    name=${name}    short name=tz ${name[:1]}    country=USA    phone=4441239586
  \    ...          city=Miami    state:dropdown=Florida    zip=33154    street address=123 KipuLane    fax=5553219568
  \    Click Button    Add
  \    Set To Dictionary    ${tz locations}    ${name}=${${timezone.split(maxsplit=1)[1]}}
  \    Set Global Variable    ${Tz Locations}    ${tz locations}
  \    Page Should Contain    ${_LOCATION ${index+1}}
  \    Click Link    ${name}
  \    Page Should Contain    Edit location
  \    Dialog action    Select From List By Label    ${NEW LOCATION TIMEZONE}    ${timezone}
  \    Click Button    Update
  \    Ajax wait
  Page should have    ${_LOCATION 1}    ${_LOCATION 2}    ${_LOCATION 3}    ${_LOCATION 5}
  I hit the "Instance" view
  Execute Javascript    document.getElementById("site_setting_number_of_locations").removeAttribute("disabled");
  ...                   document.getElementById("site_setting_enforce_locations").removeAttribute("disabled")
  Instance edit "Input Text:${number of locations}" on "Number of locations:text"
  Run Keyword If    '${enforce locations}'=='o'    Instance edit "Unselect Checkbox" on "Enforce locations"
  Click Button    commit
  Ajax wait
  Return to mainpage

Create test patient
  Set test name
  I create a valid patient    ${Test First}    ${Test Middle}    ${Test Last}
  # 03/16/2017
  Parse tester ids
  Return to mainpage

Set test name
  [ARGUMENTS]    ${first}=Jimmy    ${middle}=J    ${last}=Smith
  Set Global Variable    ${Test First}    ${first}
  Set Global Variable    ${Test Middle}    ${middle}
  Set Global Variable    ${Test Last}    ${last}

Set username id
  ${element} =    Set Variable    //div[@id='user_nav']//a[starts-with(@href,'/users') and contains(@href,'/edit')]
  ${passes}    ${username} =    Run Keyword And Ignore Error    Get Text    ${element}
  ${element} =     Set Variable If    '${passes}'=='PASS'    ${element}
                   ...                                       //div[@id='user_nav']//a[contains(@href,'/users/cas_user')]
  ${username} =    Get Text    ${element}
  ${first}    ${last} =    Split String    ${username}
  ${username} =    Get Element Attribute    ${element}    href
  ${username} =    Run Keyword If    '${BASE URL}'!='https://demo.kipuworks.com'    Fetch From Right    ${username}
                   ...                                                              ${BASE URL}
                   ...               ELSE                                           Set Variable    ${username}
  Set Global Variable    ${Admin First}    ${first}
  Set Global Variable    ${Admin Last}    ${last}
  Set Global Variable    ${Username}    ${username}

Parse tester ids
  Set List Value    ${Clean Me Up}    0    ${BASE URL}${PATIENTS}/${Current Id}/edit
  Set Global Variable    ${Clean Me Up}    ${Clean Me Up}
  Set Global Variable    ${Test Id}    ${Current Id}
  ${mr} =    Get Element Attribute    ${PATIENT FACESHEET MR}    value
  Set Global Variable    ${Test Mr}    ${mr}

Parse current id
  [ARGUMENTS]    ${fast id}=${false}
  ${id} =    Log Location
  ${id} =    Remove String    ${id}    ${BASE URL}${PATIENTS}/    ?p_selection=current    /edit?from=new    calendar/
  ${id} =    Set Variable If    not ${fast id}    ${id}    ${fast id}
  Set Global Variable    ${Current Id}    ${id}

Parse template id
  [ARGUMENTS]    ${template}
  ${id} =    Get Location
  ${id} =    Remove String    ${id}    ${BASE URL}    ${TEMPLATES}/    ${TEMPLATES ${template}}/    /edit    ?from=new
  Set Global Variable    ${Template Id}    ${id}

Figure out what view style I am in
  ${passes} =    Run Keyword And Return Status    Page Should Contain Element    //div[@class='pbottom40']/table
  Run Keyword If    ${passes}    Set Global Variable    ${View Style}    list
  ...               ELSE         Set Global Variable    ${View Style}    tile

Get patient tabs
  ${passes} =    Run Keyword And Return Status    I select patient "${Test First}"
  Run Keyword Unless    ${passes}    I select patient "3"
  Parse current id
  ${tabs} =    Get Webelements    //div[@id='sub_nav']/ul/li
  ${link} =    Set Variable    tab.find_element_by_tag_name('a').get_attribute('href')
  @{vars} =    Create List    Information    Pre-Admission    Admission    Financial    Screens &amp; Assessments
               ...            Nursing    Medical    Clinical    Case Management    Treatment Plans    Group Sessions
               ...            Assignments    ASAM    Recurring Assessments    Medical Orders    Lab Orders    Med Log
               ...            Lab Requisitions    Lab Results    Discharge/Transfer    PingMD Aftercare    External Hx
               ...            Disclosure Log    Appointments    Chart Summary    Clinical Intake    Medical Intake
               ...            Financial Intake    Clinical Assessments
  FOR    ${tab}    IN    @{tabs}
      ${handle} =    Set Variable    ${tab.find_element_by_tag_name('a').get_attribute('innerHTML')}
      ${handle} =    Get Line    ${handle.strip(' \t\n\r')}    0
      ${i} =    Get Index From List    ${vars}    ${handle}
      Log    ${Current Id}
      Log    ${${link}}
      ${l} =    Fetch From Right    ${${link}}    /${Current Id}
      Run Keyword If    ${i}==-1    Run Keywords    Extra get patient tabs    ${handle}    ${l}
      ...                           AND             Continue For Loop
      Run Keyword If    '@{vars}[${i}]'=='Pre-Admission'                Set Global Variable
      ...                                                               ${Patient Pre Admission}
      ...                                                               ${l}
      ...    ELSE IF    '@{vars}[${i}]'=='Screens &amp; Assessments'    Set Global Variable
      ...                                                               ${Patient Screens And Assessments}
      ...                                                               ${l}
      ...    ELSE IF    '@{vars}[${i}]'=='Med Log'                      Setup two med log tabs    ${l}
      ...    ELSE IF    '@{vars}[${i}]'=='Discharge/Transfer'           Set Global Variable
      ...                                                               ${Patient Discharge Transfer}
      ...                                                               ${l}
      ...    ELSE IF    '@{vars}[${i}]'=='Appointments'                 Set Global Variable    ${Patient @{vars}[${i}]}
      ...                                                               /calendar/$ID${l}
      ...               ELSE                                            Set Global Variable    ${Patient @{vars}[${i}]}
      ...                                                               ${l}
  END
  Treatment plan tab setup
  Return to mainpage

Extra get patient tabs
  [ARGUMENTS]    ${tab}    ${link}
  Run Keyword If    "${tab}"=="Admission/Consents"    Run Keywords    Set Global Variable    ${Patient Admission}
  ...                                                                 ${link}
  ...                                                 AND             Set Global Variable    ${Patient Consents}
  ...                                                                 ${link}
  ...    ELSE IF    "${tab}"=="Physician's Orders"    Set Global Variable    ${Patient Medical Orders}    ${link}
  ...    ELSE IF    "${tab}"=="Homework"              Set Global Variable    ${Patient Assignments}    ${link}
  ...    ELSE IF    "${tab}"=="ASAMs"                 Set Global Variable    ${Patient Asam}    ${link}
  ...    ELSE IF    "${tab}"=="Daily Updates"         Set Global Variable    ${Patient Recurring Assessments}    ${link}
  ...    ELSE IF    "${tab}"=="D/C / Transition"      Set Global Variable    ${Patient Discharge Transfer}    ${link}
  ...    ELSE IF    "${tab}"=="Pingmd Aftercare"      Set Global Variable    ${Patient ${tab}}    ${link}
  ...    ELSE IF    "${tab}"=="PHI"                   Set Global Variable    ${Patient Disclosure Log}    ${link}
  ...    ELSE IF    "${tab}"=="Treatment Plan"        Set Global Variable    ${Patient Treatment Plans}    ${link}

Setup two med log tabs
  [ARGUMENTS]    ${link}
  Set Global Variable    ${Med Log}    xpath:(.//a[contains(@class, "disable_click")])[10]
  # ${link} =    Fetch From Right    ${link}    &p_
  # Set Global Variable    ${Patient record med log}    /records?p_${link}
  ${link} =    Fetch From Right    ${link}    &
  Set Global Variable    ${Patient Record Med Log}    /records?${link}

Refresh chart summary tab
  ${tab} =    Get Element Attribute    //a[contains(text(),'Chart Summary')]    href
  ${tab} =    Fetch From Right    ${tab}    ${Current Id}
  Set Global Variable    ${Patient Chart Summary}    ${tab}

Treatment plan tab setup
  [DOCUMENTATION]    Special exception when no golden thread implementation
  ${passes} =    Run Keyword And Return Status    Variable Should Exist    ${Patient Treatment Plans}
  Return From Keyword If    ${passes}
  I hit the "settings" tab
  Unselect Checkbox    //input[contains(@value,'Treatment Plan')]/../following::label[contains(text(),'Protected')]/following-sibling::input[@type='checkbox']
  ${selection} =    Get Webelement    //div[@id="patient_processes"]//form
  Click Button    ${selection.find_element_by_name('commit')}
  Ajax wait

Exclude tabs from needing to verify page
  @{exclude here} =    Create List    ${HELP}    ${PRINT}    ${PDF}    ${GEN PDF}    ${GEN CASEFILE}    ${GEN TRANSFER}
                       ...            ${TOP}    ${KP BOTTOM}    ${SHIFTS}
  Set Global Variable    ${Exclude Here}    ${exclude here}

Setting up building and beds
  Set Global Variable    ${Test Building}    test house
  Set Global Variable    ${Test Room}    T1
  Set Global Variable    ${Test Bed 1}    ${Test Room}-A
  Set Global Variable    ${Test Bed 2}    ${Test Room}-B
  Set Global Variable    ${Test Bed 3}    ${Test Room}-C
  Loop deletion    Dialog action    Click Element
  ...              //strong[contains(text(),'${Test Building}')]/../following-sibling::td/a[2]
  Page Should Not Contain    ${Test Building}
  Click Link    /buildings/new
  Input Text    building_building_name    ${Test Building}
  Click Button    commit
  Click Link    /rooms/new
  Input Text    room_room_name    ${Test Room}
  Click Button    commit
  Select From List By Label    room_building_id    ${Test Building}
  :FOR    ${i}    IN RANGE    1    4
  \    Add a bed    ${Test Bed ${i}}    ${i}
  Click Button    commit
  Ajax wait
  I hit the "Rooms" view

Set user search
  [ARGUMENTS]    ${first}    ${last}    ${user}=${EMPTY}    ${pass}=${EMPTY}
  Set Global Variable    ${Find User}    ${user}
  Set Global Variable    ${Find Pass}    ${pass}
  Set Global Variable    ${Find First}    ${first}
  Set Global Variable    ${Find Last}    ${last}

Creating a new contact
  [ARGUMENTS]    ${name}
  I hit the "New contact" view
  Input Text    contact_company_name    ${name}
  Click Button    Add
  ${id} =    Get Location
  ${id} =    Remove String    ${id}    ${BASE URL}${CONTACTS}/    /edit?from=new
  Set Global Variable    ${Contact Id}    ${id}
  Click Link    //a[@class='button_back']
  I am on the "contacts" page

Go get the "${options}" options
  Go To    ${BASE URL}${SETTINGS}
  ${table} =    Get Webelement    //div[@id="${${options} TABLE}"]//form
  ${k list} =    Set Variable    ${table.find_elements_by_css_selector('div.left>input')}
  ${v list} =    Set Variable    ${table.find_elements_by_css_selector('div.left.mleft10px>span>input')}
  &{map} =    Create Dictionary
  :FOR    ${k}    ${v}    IN ZIP    ${k list}    ${v list}
  \    Set To Dictionary    ${map}    ${k.get_attribute('value')}=${v.get_attribute('value')}
  Set Global Variable    ${Color Map}    ${map}
  Go Back
