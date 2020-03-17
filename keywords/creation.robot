*** Settings ***
Documentation   Keywords designed to create new items or remove them from HealthMatters.
...

*** Keywords ***
Full setup
  # Evaluate  pdb.Pdb(stdout=sys.__stdout__).set_trace()  pdb, sys
  No Operation
  Get root directory and count id and empty test and clean me
  Get todays date
  # Create download directory
  Run Keyword If    ${RF HUG}    Server testing startup
  ...               ELSE         Login to system
  Exclude tabs from needing to verify page
  Set patient handle
  Run Keyword If    ${_LOCATIONS ACTIVE}    Prepare variable locations
  I select the "${_LOCATION 1}" location
  Run Keyword If    ${TEST PATIENT}    Create test patient
  Figure out what view style I am in
  Get patient tabs
  Run Keyword And Ignore Error    Add tester to schedule
  Return to mainpage

Full teardown
  Run Keyword If    ${TEST PATIENT}    Run Keyword And Ignore Error    Remove test patient
  Run Keyword If    ${_LOCATIONS ACTIVE}    Run Keyword And Ignore Error    Remove variable locations
  Run Keyword And Ignore Error    Go To    ${BASE URL}?pp=enable
  Run Keyword And Ignore Error    Exit system
  Run Keyword If    ${RF HUG}    Run Keywords    Import Library    Process
  ...                            AND             Run Process    /bin/bash    chmod u+x    pather.sh
  ...                                            cwd=${OUTPUT DIR.replace('/${UUID}','')}


Start new window process
  [ARGUMENTS]    ${x}=-1    ${y}=-1    ${url}=${BASE URL}    ${alias}=None    ${pp}=?pp\=disable
  ${options} =    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
  Run Keyword If    ${RF HUG}    Run Keywords    Call Method    ${options}    add_argument    --no-sandbox
  ...                            AND             Call Method    ${options}    add_argument    --disable-setuid-sandbox
  ...                            AND             Call Method    ${options}    add_argument    --disable-infobars
  ...                            AND             Call Method    ${options}    add_argument    --disable-gpu
  ...                            AND             Call Method    ${options}    add_argument    --disable-dev-shm-usage
  ...                            AND             Call Method    ${options}    add_argument    --disable-browser-side-navigation
  ...                            AND             Create WebDriver    Chrome    ${alias}    chrome_options=${options}
  ...                            AND             Go To    ${url}${pp}
  ...                            AND             Set Window Size    ${1920}    ${1080}
  ...               ELSE         Open Browser    ${url}${pp}    ${BROWSER}    ${alias}
  Run Keyword If    ${x}!=-1 and ${y}!=-1    Set Window Position    ${x}    ${y}
  # // ChromeDriver is just AWFUL because every version or two it breaks unless you pass cryptic arguments
  # //AGRESSIVE: options.setPageLoadStrategy(PageLoadStrategy.NONE); // https://www.skptricks.com/2018/08/timed-out-receiving-message-from-renderer-selenium.html
  # options.addArguments("start-maximized"); // https://stackoverflow.com/a/26283818/1689770
  # options.addArguments("enable-automation"); // https://stackoverflow.com/a/43840128/1689770
  # options.addArguments("--headless"); // only if you are ACTUALLY running headless
  # options.addArguments("--no-sandbox"); //https://stackoverflow.com/a/50725918/1689770
  # options.addArguments("--disable-infobars"); //https://stackoverflow.com/a/43840128/1689770
  # options.addArguments("--disable-dev-shm-usage"); //https://stackoverflow.com/a/50725918/1689770
  # options.addArguments("--disable-browser-side-navigation"); //https://stackoverflow.com/a/49123152/1689770
  # options.addArguments("--disable-gpu"); //https://stackoverflow.com/questions/51959986/how-to-solve-selenium-chromedriver-timed-out-receiving-message-from-renderer-exc
  # driver = new ChromeDriver(options);


I create a valid patient
  [ARGUMENTS]    ${first name}    ${middle name}    ${last name}    ${date}=${EMPTY}    ${mr}=${true}
  ...            ${add more}=${true}    ${end}=${false}
  Create a new patient    ${first name}    ${middle name}    ${last name}    ${date}    ${end}
  ${passes} =    Run Keyword And Return Status    Page should have    NOT|A ${Patient Handle.lower()} with the same name is already in the system.
  Run Keyword If    ${passes}    Page should have    ${first name} ${middle name} ${last name}
  ...               ELSE         Try another name    ${first name}    ${middle name}    ${last name}    ${date}
  Return From Keyword If    ${end}
  Parse current id
  # Wait Until Keyword Succeeds    2m    5s
  # ...                            Run Keywords    Run Keyword If    ${mr}    Click Element
  # ...                                                                       //a[contains(text(),'Create MR')]
  # ...                            AND             Ajax wait
  # ...                            AND             Page should have    NOT|Create MR
  ${first name}    ${middle name}    ${last name} =    Default patient    ${add more}
  [RETURN]    ${first name}    ${middle name}    ${last name}

I create an invalid patient
  [ARGUMENTS]    ${first name}    ${middle name}    ${last name}    ${date}
  Create a new patient    ${first name}    ${middle name}    ${last name}    ${date}
  Page should have    ${first name} ${middle name} ${last name}
  Update facesheet    birth sex:radio=gender_male    dob:js=10/07/1991    validation type=failing

Create a new patient
  [ARGUMENTS]    ${first name}    ${middle name}    ${last name}    ${date}    ${do not repeat}=${false}
  Run Keyword Unless    ${do not repeat}    Run Keywords    Click Link    /patients/new
  ...                                       AND             Location Should Be    ${BASE URL}${PATIENTS}/new
  Page should have    New ${patient}
  Form fill    patient facesheet    first name=${first name}    middle name=${middle name}    last name=${last name}
  ...          admission date:js=${date}
  Click Button    patient[auto_submit]

Try another name
  [ARGUMENTS]    ${first}    ${middle}    ${last}    ${date}
  Append To List    ${Clean Me Up}    ${first} ${middle} ${last}
  ${first new} =    Set Variable    ${first}
  ${first replace} =    Generate Random String    5    ${first}
  ${middle} =    Generate Random String    1    [UPPER]
  ${last} =    Generate Random String    5    ${last}
  @{test names} =    Create List    Riki I Defend    Alvaro A Alvarez    Jimmy J Smith
  FOR    ${index}    ${name}    IN ENUMERATE    @{test names}
      Continue For Loop If    ${index}==0
      ${first new}    ${middle}    ${last} =    Run Keyword If    '${first new}' in '${name}'    Split String    @{test names}[${index-1}]
                                                ...               ELSE                           Set Variable
                                                ...                                              ${first new}
                                                ...                                              ${middle}    ${last}
  END
  ${first} =    Set Variable If    '${first new}'=='${first}'    ${first replace}    ${first new}
  Run Keyword If    '${SUITE NAME}'=='Tests'    Set test name    ${first.title()}    ${middle}    ${last.title()}
  Go Back
  I create a valid patient    ${first.title()}    ${middle}    ${last.title()}    ${date}    end=${true}

Create multiple patients with after actions
  [ARGUMENTS]    ${number of names or list}    @{actions}
  ${ff} =    Run Keyword And Return Status    List Should Contain Value    ${actions}    giveup
  Remove Values From List    ${actions}    giveup
  ${names list} =    Run Keyword If    """${number of names or list}""".isdigit()    Fakerjs << Create names
                     ...                                                             ${number of names or list}
                     ...               ELSE                                          Set Variable
                     ...                                                             ${number of names or list}
  @{name keys} =    Create List
  FOR    ${index}    ${full name}    IN ENUMERATE    @{names list}
      ${passes} =    Run Keyword And Return Status    I am on the "patients" page
      Run Keyword Unless    ${passes}    Return to mainpage
      ${first}    ${middle}    ${last}    @{ex} =    Split String    ${full name}
      Append To List    ${ex}    ${EMPTY}    ${EMPTY}    ${EMPTY}
      ${date} =    Set Variable If    '@{ex}[0]'!='${EMPTY}'    @{ex}[0]    ${EMPTY}
      ${mr} =    Set Variable If    '@{ex}[1]'!='${EMPTY}'    @{ex}[1]    ${true}
      ${add more} =    Set Variable If    '@{ex}[2]'!='${EMPTY}'    @{ex}[2]    ${true}
      ${passes}    @{name} =    Run Keyword And Ignore Error    I create a valid patient    ${first}    ${middle}
                                ...                             ${last}    ${date}    ${mr}    ${add more}
      Exit For Loop If    '${passes}'=='FAIL' and ${ff}
      Continue For Loop If    '${passes}'=='FAIL'
      ${first}    ${middle}    ${last} =    Set Variable    @{name}
      ${key} =    Set Variable    ${first} ${middle} ${last}|${first} ${last[:1]}|${Current Id}
      Append To List    ${name keys}    ${key}
      ${passes}    ${TRASH} =    Run Keyword And Ignore Error    Perform multi actions    ${key}    ${index}
                                 ...                             @{actions}
      Exit For Loop If    '${passes}'=='FAIL' and ${ff}
  END
  [RETURN]    ${name keys}

Perform multi actions
  [ARGUMENTS]    ${name}    ${index}    @{actions}
  FOR    ${action}    IN    @{actions}
      ${action}    @{ex} =    Split String    ${action}    |    max_split=1
      Run Keyword If    '''@{ex}'''=='[]'    Run Keywords    Run Keyword    ${action}    ${name}
      ...                                    AND             Continue For Loop
      ${ex} =    Get From List    ${ex}    0
      ${ex} =    Split String    ${ex}    \', \'
      ${ex} =    Get From List    ${ex}    ${index}
      Run Keyword    ${action}    ${name}    ${ex.replace('[\'','').replace('\']','')}
  END

Add tester to schedule
  Travel "fast" to "tester" patients "admission" page in "null"
  ${passes} =    Run Keyword And Return Status    With this form "Residential Schedule" perform these actions "add"
  Run Keyword Unless    ${passes}    Run Keywords    Reload Page
  ...                                                With this form "Schedule" perform these actions "add"

Remove test patient
  Return to mainpage
  I select the "My Locations" location
  FOR    ${clean}    IN    @{Clean Me Up}
      ${passes} =    Run Keyword And Return Status    Go To    ${clean}
      Run Keyword If    ${passes}    Run Keywords    Dialog action    Click Link    delete
      ...                            AND             Run Keyword And Continue On Failure    Wait Until Page Contains
      ...                                            Notice
      ...               ELSE         Remove this patient    ${clean}
  END

Remove this patient
  [ARGUMENTS]    ${name}
  Return to mainpage
  Searching for "${name}"
  Click Element    //ul[@id='search']/li/a
  # Click Link    Edit ${Patient Handle}
  I hit the "${Patient Handle}" view
  Dialog action    Click Link    delete
  Run Keyword And Continue On Failure    Wait Until Page Contains    Notice

Remove variable locations
  Return to mainpage
  I hit the "settings" tab
  I hit the "Company" view
  ${names} =    Get Dictionary Keys    ${Tz Locations}
  FOR    ${name}    IN    @{names}
      Dialog action    Click Element    //a[.='${name}']/../following-sibling::td/a[2]
      Page should have    NOT|${name}
  END


Create a new user
  [ARGUMENTS]    ${first}=robot    ${last}=demo    ${user}=new_user    ${pass}=new_pass0    ${email}=r@d.com
  ...            ${locations}=all    ${roles}=Tech
  Set user search    ${first}    ${last}    ${user}    ${pass}
  I hit the "users" tab
  I select the "My Locations" location
  ${passes} =    Run Keyword And Return Status    Delete a user
  Run Keyword Unless    ${passes}    Run Keywords    I hit the "Active Users" view
  ...                                                I am on the "users" page
  ${passes} =    Run Keyword And Return Status    Page Should Contain Link    Delete
  Run Keyword Unless    ${passes}    Run Keywords    I hit the "Disabled Users" view
  ...                                AND             Input Text    q    ${Find Last}, ${Find First}
  ...                                AND             Click Element    //button[@type='submit']
  Run Keyword And Ignore Error    Click Link    ${Find Last.title()[0]}
  ${ver} =    Run Keyword If    not ${passes}    Run Keyword And Return Status    Click Link    Edit
              ...               ELSE             Set Variable    ${false}
  Run Keyword Unless    ${ver}    Click Element    new-user-btn
  &{add locations} =     Create Dictionary
  @{locations} =    Run Keyword If    ${_LOCATIONS ACTIVE}    Split String    ${locations}    ;
                    ...               ELSE                    Create List    skip
  FOR    ${location}    IN    @{locations}
      Exit For Loop If    '${location}'=='skip'
      Run Keyword If    '${location}'=='all'    Run Keywords    Set To Dictionary    ${add locations}
      ...                                                       access all locations:checkbox=x
      ...                                       AND             Exit For Loop
      Set To Dictionary    ${add locations}    //label[contains(text(),'${location}')]/../input:direct_check=x
  END
  &{add roles} =    Create Dictionary
  @{roles} =    Split String    ${roles}    ;
  ${switches} =    Evaluate    ['on' for _ in ${roles}]+['off']
  Append To List    ${roles}    user_disabled
  FOR    ${switch}    ${role}    IN ZIP    ${switches}    ${roles}
      ${passes}    ${label} =    Run Keyword And Ignore Error    Capture empty label text    ${role}
                                 ...                             //li[starts-with(@id,'role_')]/label
                                 ...                             //input[starts-with(@id,'user_role_ids_')]/parent::label[1]
      ${role} =    Set Variable If    '${passes}'=='PASS'    ${label}    ${role}
      Run Keyword If    '${switch}'=='on'    Set To Dictionary    ${add roles}    ${role}:direct_check=x
      ...               ELSE                 Set To Dictionary    ${add roles}    ${role}:direct_check=o
  END
  Run Keyword If    ${ver}    New user wipe
  ...               ELSE      Set To Dictionary    ${add roles}    password:js=${Find Pass}
  ...                         password confirmation:js=${Find Pass}
  Form fill    new user    username:js=${Find User}    first name=${Find First}    last name=${Find Last}
  ...          mobile=4444444444    email=${email}    &{add locations}    &{add roles}
  Run Keyword If    ${ver}    Run Keywords    Click Button    Update
  ...                         AND             Verify for no bad page
  ...                         AND             Wait Until Page Contains    Notice
  ...                         AND             I hit the "Active Users" view
  ...               ELSE      Click Button    Register
  I am on the "users" page
  The user is "in" the system
  Return to mainpage

Create a master user
  [ARGUMENTS]    ${first}=robot    ${last}=demo    ${user}=new_user    ${pass}=new_pass0
  Set user search    ${first}    ${last}    ${user}    ${pass}
  I hit the "users" tab
  Click Element    new-user-btn
  Form fill    new user    username=${Find User}    first name=${Find First}    last name=${Find Last}
  ...          email=super@hug.com    mobile=4444444444    access all locations:checkbox=x    super admin:checkbox=x
  ...          master:checkbox=x    kipu staff:checkbox=x    password=${Find Pass}    password confirmation=${Find Pass}
  Click Button    Register
  I am on the "users" page
  The user is "in" the system
  Return to mainpage

New user wipe
  Run Keyword If    ${_LOCATIONS ACTIVE}    Run Keywords    Form fill    new user    access all locations:checkbox=x
  ...                                       AND             Form fill    new user    access all locations:checkbox=o
  ${wipe} =    Create Dictionary    middle name=${EMPTY}    title=${EMPTY}    npi number=${EMPTY}
               ...                  dea number:js=${EMPTY}    function:dropdown=${EMPTY}    locked:check=o
  ${roles} =    Capture empty label list    all    //li[starts-with(@id,'role_')]/label
                ...                         //input[starts-with(@id,'user_role_ids_')]/parent::label[1]
  FOR    ${role}    IN    @{roles}
      Set To Dictionary    ${wipe}    ${role}:direct_check=o
  END
  Form fill    new user    &{wipe}

Delete a user
  ${passes} =    Run Keyword And Return Status    The user is "in" the system
  ${passes 2} =    Run Keyword And Return Status    Page Should Contain Link    Delete
  Run Keyword If    ${passes} and ${passes 2}    Dialog action    Click Link    Delete
  ...    ELSE IF    ${passes}                    Turning "on" the "user_disabled" roles for "deletion"
  I hit the "Active Users" view
  I am on the "users" page

Delete the new user
  I hit the "users" tab
  I select the "My Locations" location
  Delete a user
  I hit the "users" tab
  The user is "out" the system
  Return to mainpage


Create a new building with beds
  I hit the "settings" tab
  I hit the "Rooms" view
  Setting up building and beds
  Return to mainpage

Add a bed
  [ARGUMENTS]    ${name}    ${note}
  Click Link    Add bed
  Ajax wait
  Input Text    room_beds_attributes_0_notes    ${note}
  Click Element    room_beds_attributes_0_bed_name
  Ajax wait
  Input Text    room_beds_attributes_0_bed_name    ${name}
  Click Element    room_beds_attributes_0_notes
  Ajax wait

Remove building
  I hit the "settings" tab
  I hit the "Rooms" view
  Dialog action    Click Element    //strong[contains(text(),'${Test Building}')]/../following-sibling::td/a[2]
  Page Should Not Contain    ${Test Building}
  Return to mainpage


Create tester template
  [ARGUMENTS]    ${template}    ${name}    ${cleanup}=${true}
  ${pingmd state}    ${template} =    Run Keyword If    'pingmd' in '${template}'    Split String    ${template}
                                      ...                                            max_split=1
                                      ...               ELSE                         Set Variable    null    ${template}
  ${formatted} =    Replace String    ${template}    ${SPACE}    _
  ${formatted} =    Set Variable If    '${template}'!='group sessions 2'    ${formatted}
                    ...                                                     gs/${formatted.replace('_2','')}
  I select the "My Locations" location
  Run Keyword If    ${cleanup}    Loop deletion    Remove old templates    ${name}
  Run Keyword If    '${pingmd state}'=='null'    Click Link    /${formatted}/new
  ...               ELSE                         Click Link    default=/${formatted}/new?evaluation_type=pingmd_evaluation
  Form fill    ${template} form    name=${name}
  Run Keyword If    '${template}'=='consent forms'    Page should have    ELEMENT|${CONSENT FORMS FORM PATIENT SIG REQ}
  ...                                                 ELEMENT|${CONSENT FORMS FORM GUART SIG REQ}
  ...                                                 ELEMENT|${CONSENT FORMS FORM STAFF SIG REQ}
  Click Element    //input[@type='submit']
  Run Keyword If    '${template}'=='consent forms'    Click Element    //a[contains(text(),'${name}')]/../preceding-sibling::div[last()]/a[1]
  Parse template id    ${template}
  Click Element    //input[@type='submit']
  Ajax wait
  Run Keyword If    '${template}'=='consent forms'    Run Keywords    Click Element    ${formatted}
  ...                                                 AND             Page should have
  ...                                                                 ELEMENT|//span[@class='disabled']/a[@href='/${formatted}/${Template Id}']
  ...                                                 AND             I am on the "templates" page
  ...    ELSE IF    '${template}'=='rounds'           Run Keywords    Click Link    /${formatted}
  ...                                                 AND             Page should have
  ...                                                                 ELEMENT|//tr[${CSS SELECT.replace('$CSS','disabled')}]//a[@href='/${formatted}/${Template Id}']
  ...                                                 AND             I am on the "templates ${template}" page
  ...               ELSE                              Run Keywords    Click Link    /${formatted}
  ...                                                 AND             Page should have
  ...                                                                 ELEMENT|//a[@href='/${formatted}/${Template Id}/edit']/span[@class='disabled']
  ...                                                 AND             I am on the "templates ${template}" page
  Page should have    ${name}

Add eval item
  [ARGUMENTS]    ${multiple}=${false}
  Run Keyword Unless    ${multiple}    Run Keywords    Loop deletion    Dialog action    Click Element
  ...                                                  //input[starts-with(@id,'evaluation_evaluation_items_attributes_')]/following-sibling::a[1]
  ...                                  AND             Set count id
  Click Link    Add item
  Ajax wait

Delete tester template
  [ARGUMENTS]    ${template}
  ${formatted} =    Run Keyword If    '${template}'!='group sessions 2'    Replace String    ${template}    ${SPACE}
                    ...                                                    _
                    ...               ELSE                                 Set Variable    gs/group_sessions
  Run Keyword If    '${template}'!='consent forms'    Go To    ${BASE URL}${TEMPLATES ${template}}
  ...               ELSE                              Go To    ${BASE URL}${TEMPLATES}
  I select the "My Locations" location
  ${passes 1} =    Run Keyword And Return Status    Page should have
                   ...                              NOT|ELEMENT|//a[contains(@data-url,'destroy_multiple')]
  ${passes 2}    ${element} =    Run Keyword And Ignore Error    Get Webelement
                                 ...                             ${formatted.rstrip('s')}_${Template Id}
  Run Keyword If    ${passes 1}               Dialog action    Click Element
  ...                                         //a[@href='/${formatted}/${Template Id}/edit']/following-sibling::a[@data-method='delete']
  ...    ELSE IF    '${passes 2}'=='PASS'     Run Keywords    Select Checkbox    ${formatted.rstrip('s')}_${Template Id}
  ...                                         AND             Click Element
  ...                                                         //a[contains(@data-url,'destroy_multiple')]
  ...                                         AND             Ajax wait
  ${passes 1} =    Run Keyword And Return Status    I am on the "templates group sessions" page
  ${passes 2} =    Run Keyword And Return Status    I am on the "templates group sessions 2" page
  Run Keyword Unless    ${passes 1} or ${passes 2}    Wait Until Page Contains    Notice

Remove old templates
  [ARGUMENTS]    ${template}
  ${passes} =    Run Keyword And Return Status    Page should have    NOT|ELEMENT|//h1[.='Rounds']
  ${single delete} =    Set Variable If    ${passes}    //*[contains(text(),'${template}')]/ancestor::li[1]/div/a[@data-method='delete']
                        ...                             //*[contains(text(),'${template}')]/../following-sibling::td[last()]/a[@data-method='delete']
  ${passes} =    Run Keyword And Return Status    Page should have
                 ...                              NOT|ELEMENT|//a[contains(@data-url,'destroy_multiple')]
  Run Keyword If    ${passes}    Run Keywords    Do teardown    Dialog action    Click Element    ${single delete}
  ...                            AND             Return From Keyword If    ${Escape Teardown}
  ${elements} =    Run Keyword If    not ${passes}    Do teardown    Get Webelements
                   ...                                //*[contains(text(),'${template}')]/ancestor::li[1]//input[@type='checkbox']
                   ...               ELSE             Create List
  Return From Keyword If    ${Escape Teardown}
  FOR    ${element}    IN    @{elements}
      Select Checkbox    ${element}
  END
  Run Keyword Unless    ${passes}    Click Element    //a[contains(@data-url,'destroy_multiple')]
  Ajax wait
  ${passes 1} =    Run Keyword And Return Status    I am on the "templates group sessions" page
  ${passes 2} =    Run Keyword And Return Status    I am on the "templates group sessions 2" page
  Run Keyword Unless    ${passes 1} or ${passes 2}    Wait Until Page Contains    Notice

Delete a group sessions template
  [ARGUMENTS]    ${title}
  Dialog action    Click Element    //*[contains(text(),'${title}')]/ancestor::li[1]/div/a[2]


Temporarily reveal billing options
  @{options} =    Create List
  ${passes} =    Run Keyword And Return Status    Page should have    Enable Billing Interface
  Run Keyword Unless    ${passes}    Append To List    ${options}
  ...                                b += '<tr><td><label class="normal" for="site_setting_enable_billing_interface">&nbsp;&nbsp;&nbsp;Enable Billing Interface</label></td><td><input name="site_setting[enable_billing_interface]" type="hidden" value="0"><input id="site_setting_enable_billing_interface" name="site_setting[enable_billing_interface]" type="checkbox" value="1"></td></tr>';
  ${passes} =    Run Keyword And Return Status    Page should have    Enable Transmit/Download Billing Data
  Run Keyword Unless    ${passes}    Append To List    ${options}
  ...                                b += '<tr><td><label class="normal" for="site_setting_enable_transmit_download_billing_interface">&nbsp;&nbsp;&nbsp;Enable Transmit/Download Billing Data</label></td><td><input name="site_setting[enable_transmit_download_billing_interface]" type="hidden" value="0"><input id="site_setting_enable_transmit_download_billing_interface" name="site_setting[enable_transmit_download_billing_interface]" type="checkbox" value="1"></td></tr>';
  ${passes} =    Run Keyword And Return Status    Page should have    Enable Group Billing
  Run Keyword Unless    ${passes}    Append To List    ${options}
  ...                                b += '<tr><td><label class="normal" for="site_setting_enable_group_billing">&nbsp;&nbsp;&nbsp;Enable Group Billing </label></td><td><input name="site_setting[enable_group_billing]" type="hidden" value="0"><input id="site_setting_enable_group_billing" name="site_setting[enable_group_billing]" type="checkbox" value="1"></td></tr>';
  Execute Javascript    var b = '<tr><td colspan="2"><p><strong><br>Billing Interface</strong></p></td></tr>';
  ...                   @{options}    document.getElementsByTagName("TBODY")[0].innerHTML += b
  # <tr><td><label class="normal" for="site_setting_enable_group_billing">&nbsp;&nbsp;&nbsp;Enable Group Billing </label></td><td><input name="site_setting[enable_group_billing]" type="hidden" value="0"><input id="site_setting_enable_group_billing" name="site_setting[enable_group_billing]" type="checkbox" value="1"></td></tr>
  # <tr><td><label class="normal" for="site_setting_use_initial_signer_as_rendering_provider">&nbsp;&nbsp;&nbsp;Use Initial Signer As Rendering Provider </label></td><td><input name="site_setting[use_initial_signer_as_rendering_provider]" type="hidden" value="0"><input id="site_setting_use_initial_signer_as_rendering_provider" name="site_setting[use_initial_signer_as_rendering_provider]" type="checkbox" value="1"></td></tr>

Temporarily reveal eprescribe options
  ${passes} =    Run Keyword And Return Status    Page should have    ePrescribe
  Return From Keyword If    ${passes}
  Execute Javascript    var b = '<tr><td colspan="2"><strong><br>ePrescribe</strong></td></tr>';
  ...                   b += '<tr><td><label class="normal" for="site_setting_use_e_prescribe">&nbsp;&nbsp;&nbsp;Enable ePrescribe</label></td><td><input name="site_setting[use_e_prescribe]" type="hidden" value="0"><input data-e-prescribe-setting="false" id="site_setting_use_e_prescribe" name="site_setting[use_e_prescribe]" type="checkbox" value="1"></td></tr>';
  ...                   document.getElementsByTagName("TBODY")[0].innerHTML += b

Input insurance company
  [ARGUMENTS]    ${name}=Protect Me Protect Us
  Ajax wait
  Input Text    ${PATIENT FACESHEET INSURANCE COMPANY.replace('$CID','${Cid}')}    ${name}
  Press Key    ${PATIENT FACESHEET INSURANCE COMPANY.replace('$CID','${Cid}')}    \\9
  ${passes} =    Run Keyword And Return Status    Get Alert Message    False
  Run Keyword If    ${passes}    Dialog action    No Operation

Fill out insurance info
  Form fill    patient facesheet    policy no=453535    group id=4557    insurance status:dropdown=Inactive
  ...          insurance phone=636 643 0357    insurance type:dropdown=Rx insurance    insurance plan:dropdown=POS2
  ...          rx=Rupees    rx phone=866-123-4567    rx group=26-1234    rx bin=999    rx pcn=A4


Connect pingmd
  I hit the "settings" tab
  I hit the "Konnectors" view
  Loop deletion    Click Element    //a[.\='pingmd']/ancestor::td[1]/following-sibling::td[last()]/a
  I hit the "New Konnector" text
  Form fill    vendor    name=pingmd    type:dropdown=Ping MD
  Click Button    commit
  Form fill    vendor    status:checkbox=x
  Click Button    commit
  Wait Until Keyword Succeeds    3x    5s
  ...                            Run Keywords    Reload Page
  ...                            AND             Page should have    ELEMENT|//input[@id='${VENDOR PINGMD ID}' and @value]

Destroy pingmd connector
  Go To    ${BASE URL}${KONNECTORS}
  Loop deletion    Click Element    //a[.\='pingmd']/ancestor::td[1]/following-sibling::td[last()]/a


Generate and confirm pdf with
  [ARGUMENTS]    ${package}    @{labels}
  ${items} =    Set Variable    //table[@id='casefile_sections']//div[@style='margin-bottom: 10px;']
  ${passes} =    Run Keyword And Return Status    Page should have    ELEMENT|${items}
  @{items} =    Run Keyword If    ${passes}    Get Webelements    ${items}
                ...               ELSE         Create List    transfer
  &{map} =    Run Keyword If    '${package}'=='${EMPTY}' or '@{items}[0]'=='transfer'    Create Dictionary
              ...               ELSE                                                     Create Dictionary    casefile_options_pdf_package_id:direct_drop=${package}
  FOR    ${item}    IN    @{items}
      Exit For Loop If    '${item}'=='transfer'
      ${i} =    Set Variable    ${item.find_element_by_css_selector("label>span").get_attribute("innerHTML").strip()}
      ${id} =    Set Variable    input#${item.find_element_by_css_selector("input[type='checkbox']").get_attribute("id")} + label
      ${passes} =    Run Keyword And Return Status    List Should Contain Value    ${labels}    ${i}
      Run Keyword If    ${passes}    Set To Dictionary    ${map}    ${id}:aria=x
      ...               ELSE         Set To Dictionary    ${map}    ${id}:aria=o
  END
  Run Keyword If    '@{items}[0]'!='transfer'    Run Keywords    Form fill    ${EMPTY}    &{map}
  ...                                            AND             Click Button    Submit
  ...                                            AND             Ajax wait
  ...                                            AND             Page should have    is now being generated
  ...                                            AND             Click Button    Ok
  ...               ELSE                         Run Keywords    Click Element
  ...                                                            //select[@id='share_to_app_id']/optgroup[@label='Locations']/option[.='${package}']
  ...                                            AND             Click Button    Send
  ...                                            AND             Ajax wait
  ...                                            AND             Page should have    Notice
  ...                                                            Patient facesheet successfully moved to ${package} and is now

Create a "${note}" with "${message}"
  # Click Link    ${note.title()}
  I hit the "${note.title()}" view
  Run Keyword If    '${note}'=='notes'    Run Keywords    Click Link    New ${note[0:4]}
  ...                                     AND             Ajax wait
  ...                                     AND             Input Text    patient_note_note    ${message}
  ...                                     AND             Click Button    Save Note
  ...               ELSE                  Run Keywords    Click Link    New ${note}
  ...                                     AND             Ajax wait
  ...                                     AND             Input Text    urgent_issue_urgent_issue_text   ${message}
  ...                                     AND             Click Button    Save Issue
  Ajax wait

Remove contact
  Dialog action    Click Link    delete
  I am on the "contacts" page


Create a doctor order
  [ARGUMENTS]    ${order}    ${start date}=today    ${shift}=0    ${meds}=Bently    ${route}=topical    ${form}=cream
  ...            ${dose}=200mg/1    ${just}=profound sadness    ${warn}=n0 curry    ${action}=take down    ${quantity}=2
  ...            ${freq}=every 8 hours    ${dur}=99    ${prn}=o    ${notes}=testing my meds on this man    ${dispense}=4
  ...            ${refills}=0    ${ordered by}=QA Doc    ${via}=fax    ${erx}=${false}    ${proper fill}=${true}
  ...            ${add more}=start;end
  ${start step}    ${end step} =    Split String    ${add more}    ;
  ${start date} =    Run Keyword If    '${start date}'=='today'    Convert Date    ${Todays Date}    %m/%d/%Y
                     ...               ELSE                        Set Variable    ${start date}
  FOR    ${step}    IN    ${start step}
      Exit For Loop If    '${step}'!='start'
      ${passes} =    Run Keyword And Return Status    I hit the "Add manual order" text
      Run Keyword If    ${passes}    Click Element    popup_form_tab_add_order_${order}
      ...               ELSE         Run Keywords    I hit the "Custom Order" text
      ...                            AND             Click Element    ${order}_tab
      ...                            AND             Ajax wait
  END
  ${passes}    ${id} =    Run Keyword And Ignore Error    Get Element Attribute
                          ...                             //div[contains(@id,'manual_${order}')]/div[contains(@id,'custom_')]/div[contains(@class,'_orders_main')][last()]
                          ...                             id
  ${id}    ${ver} =    Run Keyword If    '${passes}'=='PASS'    Set Variable    ${id.rsplit('_',1)[1]}    2
                       ...               ELSE                   Set Variable    ${EMPTY}    ${EMPTY}
  ${freq id} =    Run Keyword If    '${ver}'    Get Element Attribute    //select[contains(@id,'frequency_${id}_')]
                  ...                           id
  # ${freq val} =    Run Keyword If    '${ver}'    Get Element Attribute    //option[contains(.,'${freq}')]@value
  ${freq id}    ${freq val} =    Run Keyword If    '${passes}'=='PASS'    Set Variable    ${freq id.rsplit('_',1)[1]}
                                 ...                                      schedules_**
                                 ...               ELSE                   Set Variable    ${EMPTY}    ${EMPTY}
  &{prep dose} =    Run Keyword If    '${ver}'    Create Dictionary    warnings|${id}=${warn}
                    ...                           strength|${id}|${freq id}|${freq val}=${dose}
                    ...                           units|${id}|${freq id}|${freq val}=${form}
                    ...               ELSE        Create Dictionary    warnings=${warn}    dose=${dose}
  &{prep quantity} =    Run Keyword If    '${ver}'    Create Dictionary    quantity|${id}|${freq id}|${freq val}=${quantity}
                        ...               ELSE        Create Dictionary    quantity=${quantity}
  &{input dispense} =    Run Keyword If    'action' in '${order}'    Create Dictionary    ${EMPTY}=${EMPTY}
                         ...    ELSE IF    '${ver}' or ${erx}        Create Dictionary    &{prep dose}
                         ...                                         &{prep quantity}
                         ...                                         dispense|${id}|${dose.replace('/','_')}=${dispense}
                         ...                                         refills|${id}=${refills}
                         ...               ELSE                      Create Dictionary    &{prep dose}
                         ...                                         &{prep quantity}    dispense=${dispense}
                         ...                                         refills=${refills}
  &{input freq} =    Run Keyword If    '${ver}'    Create Dictionary    just|${id}=${just}    notes|${id}=${notes}
                     ...                           duration days|${id}=${dur}
                     ...                           frequency|${id}|${freq id}:dropdown=${freq}
                     ...               ELSE        Create Dictionary    just=${just}    notes=${notes}
                     ...                           frequency:dropdown=${freq}    duration days=${dur}
  &{input prn} =    Run Keyword If    '${order}'=='taper'      Create Dictionary
                    ...                                        prn|${id}|${freq id}|${freq val}:checkbox=${prn}
                    ...    ELSE IF    '${ver}'                 Create Dictionary    prn|${id}:checkbox=${prn}
                    ...               ELSE                     Create Dictionary    prn:checkbox=${prn}
  ${live date} =    Run Keyword If    '${start date}'=='live now'    Get the date now
                    ...                                              ${ADD ORDER ${order} START DATE}    ${shift}
                    ...               ELSE                           Form fill    add order ${order}${ver}
                    ...                                              start date|${id}:js=${start date}
  Slow wait
  Run Keyword If    '${order}'=='medication'    Form fill    add order medication${ver}    keep my order=${proper fill}
  ...                                           medication|${id}=${meds}    route|${id}=${route}
  ...                                           dosage form|${id}=${form}
  ...    ELSE IF    '${order}'=='taper'         Form fill    add order taper    keep my order=${proper fill}
  ...                                           medication|${id}=${meds}    route|${id}=${route}
  ...                                           dosage form|${id}=${form}
  ...    ELSE IF    '${order}'=='action'        Form fill    add order action${ver}    action|${id}=${action}
  Custom screenshot
  Form fill    add order ${order}${ver}    keep my order=${true}    &{input freq}    &{input dispense}    &{input prn}
  Custom screenshot
  ${duration} =    Set Variable    ${SPACE}for ${dur} day
  ${dur} =    Run Keyword If    '${dur}'!='${EMPTY}'    Set Variable If    ${${dur}}>1    ${duration}s    ${duration}
              ...               ELSE                    Set Variable    ${dur}
  ${med order} =    Set Variable If    '${ver}'=='${EMPTY}'    ${meds} ${dose}, ${route}, ${quantity} ${form} ${freq}${dur}
                    ...                                        ${meds}, ${quantity} x ${dose}, ${route}, ${form}, ${freq},${dur}
  # Bently 200mg/1, topical, 2 cream Other Day for 45 days
  # Bently, 2 x 200mg/1, topical, cream, Other Day, for 45 days
  # ${med order} =    Set Variable If    ${erx}    ${meds} ${dose}, ${route}, ${quantity} ${form} ${freq}${dur}
  #                   ...                          ${meds} ${dose}, ${route} ${freq}${dur}
  Run Keyword If    '${end step}'=='end'    Doctor "${order}" ordered by "${ordered by}" via "${via}"
  Run Keyword If    '${end step}'=='medication'    I hit the "Add Medication" text
  ...    ELSE IF    ${erx}                         Attempt erx submit    ${med order}
  ...               ELSE                           Click Element    //span[.='Submit']
  Ajax wait
  Return From Keyword If    '${start date}'=='live now'    ${live date}
  Return From Keyword If    '${order}'=='medication'    ${med order}
  # Return From Keyword If    '${order}'=='action'    ${action} ,\ \ until further notice
  Return From Keyword If    '${order}'=='action'    ${action} ,\ ${dur}

Attempt erx submit
  [ARGUMENTS]    ${order}
  ${passes} =    Run Keyword And Return Status    Click Element    //span[.='eRx Submit']
  Return From Keyword If    ${passes}
  Click Element    //span[.='Submit']
  Ajax wait
  Click Element    //a[contains(.,'${order}')]/ancestor::tr[1]/td[last()]/div[@id='erx-sbt-btn']/a
  Ajax wait

Adding vitals log
  [ARGUMENTS]    ${date}=null    ${shift}=0    ${bp sy}=75    ${bp dia}=76    ${temp}=77    ${pulse}=78    ${resp}=79
  ...            ${o2}=80
  ${passes} =    Run Keyword And Return Status    I am on the "med log" patient page
  ${med_log_locator} =  Click Link  xpath:(.//a[contains(@class, "disable_click")])[17]
  Sleep    3
  Wait Until Page Contains Element  //i[@class="fa fa-plus"]
  Click Element  //i[@class="fa fa-plus"]
  Page should have  vital-signs-dialog
  ${time} =  Get Variable Value    time    default=None
  ${TRASH}    ${time} =    Split String    ${time}    max_split=1
  ${live date} =    Run Keyword If    '${date}'=='live now'    Get the date now    ${VITAL SIGNS DATE TIME}    ${shift}
                    ...    ELSE IF    '${date}'!='null'        Form fill    vital signs    date time:js=${date} ${time}
  Form fill    vital signs    bp systolic=${bp sy}    bp diastolic=${bp dia}    temperature=${temp}    pulse=${pulse}
  ...          respirations=${resp}    o2 saturation=${o2}
  Click Element   xpath=(//button)[2]
  Ajax wait
  Return From Keyword If    '${date}'=='live now'    ${live date}

Adding glucose log
  [ARGUMENTS]    ${date}=null    ${shift}=0    ${reading}=111    ${check}=Random Check    ${interv}=x
  ...            ${note}=person is rolling
  ${passes} =    Run Keyword And Return Status    I am on the "med log" patient page
  Run Keyword If    ${passes}    Click Link
  ...                xpath:(.//a[contains(@class, "disable_click")])[17]
  Ajax wait
  Wait Until Page Contains Element   xpath=(//i[@class="fa fa-plus"])[2]
  ${time} =    Get Variable Value    time    default=None
  ${TRASH}    ${time} =    Split String    ${time}    max_split=1
  ${live date} =    Run Keyword If    '${date}'=='live now'    Get the date now    ${GLUCOSE LOG DATE TIME}    ${shift}
                    ...    ELSE IF    '${date}'!='null'        Form fill    glucose log    date time:js=${date} ${time}
  Form fill    glucose log    reading=${reading}    type of check:dropdown=${check}    intervention:checkbox=${interv}
  ...          note=${note}
  Click Element  xpath=(//button)[6]
  Ajax wait
  Return From Keyword If    '${date}'=='live now'    ${live date}

Adding weight log
  [ARGUMENTS]    ${date}=null    ${shift}=0    ${weight}=5000
  ${passes} =    Run Keyword And Return Status    I am on the "med log" patient page
  Run Keyword If    ${passes}    Click Element
  ...                            xpath=(//i[@class="fa fa-plus"])[3]
  Ajax wait
  Page should have    patient_weight_value
  ${time} =    Get Variable Value    time    default=None
  ${TRASH}    ${time} =    Split String    ${time}    max_split=1
  ${live date} =    Run Keyword If    '${date}'=='live now'    Get the date now    ${WEIGHT DATE TIME}    ${shift}
                    ...    ELSE IF    '${date}'!='null'        Form fill    weight    date time:js=${date} ${time}
  Form fill    weight    weight=${weight}
  Click Element  xpath=(//button)[8]
  Ajax wait
  Return From Keyword If    '${date}'=='live now'    ${live date}

#Adding height log
#  [ARGUMENTS]    ${date}=null    ${shift}=0    ${height}=5'10"
#  ${passes} =    Run Keyword And Return Status    I am on the "med log" patient page
#  Run Keyword If    ${passes}    Click Element
#  ...                            xpath=(//i[@class="fa fa-plus"])[4]
#  Ajax wait
#  Page should have    patient_attribute_history_height
#  # ${time} =    Get Element Attribute    ${HEIGHT DATE TIME}@value
  # ${TRASH}    ${time} =    Split String    ${time}    max_split=1
  # ${live date} =    Run Keyword If    '${date}'=='live now'    Get the date now    ${HEIGHT DATE TIME}    ${shift}
  #                   ...    ELSE IF    '${date}'!='null'        Form fill    weight    date time:js=${date} ${time}
#  ${height} =    Evaluate    patient_attribute_history_height
#  Select From List By Value    ${HEIGHT HEIGHT}    ${height.__str__()}
  # Form fill    height    height:dropdown=${height}
#  Click Element   xpath=(//button)[12]
  #Ajax wait
  #Return From Keyword If    '${date}'=='live now'    ${live date}

Remove any orders
  ${passes} =    Run Keyword And Return Status    Dialog action    Click Element
                 ...                              //tr[starts-with(@id,'patient_order_')]//a[@data-method='delete']/*
  Run Keyword If    ${passes}    Wait Until Page Contains    Notice
  ...               ELSE         Fail    All orders have been removed!


Adding a golden thread form
  [ARGUMENTS]    ${form}=Problem List
  With this form "${form}" perform these actions "add;edit"
  Wait Until Element Is Visible    ${GOLDEN THREAD DATE OF SERVICES}
  ${date} =    Convert Date    ${Todays Date}    result_format=%m/%d/%Y
  Form fill    golden thread    date of services:js=${date}

Build the treatment
  [ARGUMENTS]    @{info}
  :FOR    ${item}    IN    @{info}
  \    ${input}    ${value} =    Split String    ${item}    =
  \    ${field}    ${input} =    Split String    ${input}    :
  \    ${goal}    @{rest} =    Split String    ${field}    >
  \    ${objective} =    Run Keyword If    ${rest}    Remove From List    ${rest}    0
  \                      ...               ELSE       Set Variable    null
  \    ${addon} =    Run Keyword If    ${rest}    Remove From List    ${rest}    0
  \                  ...               ELSE       Set Variable    null
  \    ${element} =    Run Keyword If    '${objective}'=='null'       Get up to goal    ${input}    ${goal}
  \                    ...    ELSE IF    '${addon}'=='null'           Get up to objective    ${input}    ${goal}
  \                    ...                                            ${objective}
  \                    ...    ELSE IF    ${addon.find('Plan')}!=-1    Get up to plan    ${input}    ${goal}
  \                    ...                                            ${objective}    ${addon}
  \                    ...               ELSE                         Get up to status    ${input}    ${goal}
  \                    ...                                            ${objective}    ${addon}
  \    ${popup} =    Fetch From Right    ${element}    <
  \    ${element} =    Fetch From Left    ${element}    <
  \    Page Should Contain Element    ${element}
  \    Run Keyword If    '${input}'=='select'    Run Keyword And Continue On Failure
  \    ...                                       Run Keywords    Click Element    ${element}
  \    ...                                       AND             Ajax wait
  \    ...                                       AND             Click Element    //div[@id='${popup}']//div[@class='row mbottom1em'][${value}]
  \    ...    ELSE IF    '${input}'=='add'       Run Keyword And Continue On Failure    Click Element    ${element}
  \    ...    ELSE IF    '${input}'=='delete'    Run Keyword And Continue On Failure
  \    ...                                       Run Keywords    Dialog action    Click Element    ${element}
  \    ...                                       AND             Page Should Not Contain Element    ${element}
  \    ...    ELSE IF    '${input}'=='date'      Run Keyword And Continue On Failure    Execute Javascript
  \    ...                                       $('#${element}').val('${value}')
  \    ...    ELSE IF    '${input}'=='list'      Run Keyword And Continue On Failure    Select From List By Label
  \    ...                                       ${element}    ${value}
  \    ...               ELSE                    Run Keyword And Continue On Failure    Input Text    ${element}
  \    ...                                       ${value}
  \    Ajax wait
  # \    Custom screenshot
  # \    Log To Console    ${item}
# \    ...                                       AND             Temp check "//div[@id='${popup}']//div[@class='row mbottom1em']"
# Temp check "${elm}"
#   @{elms} =    Get Webelements    ${elm}
#   :FOR    ${element}    IN    @{elms}
#   \    Log    ${element.get_attribute('innerHTML')}

Get up to goal
  [ARGUMENTS]    ${input}    ${goal}
  ${goal} =    Run Keyword Unless    '${input}'=='add'    Get Element Attribute
               ...                                        //label[contains(text(),'${goal}')]/following-sibling::input[1]
               ...                                        value
  ${goal} =    Set Variable If    '${input}'=='text'      goal_text_field_${goal}
               ...                '${input}'=='select'    //textarea[@id='goal_text_field_${goal}']/preceding-sibling::a[1]/i[${CSS SELECT.replace('$CSS','glyphicon-list')}][1]<treatment_plan_goal_${goal}
               ...                '${input}'=='delete'    //div[@id='related_items_goal_${goal}']/preceding-sibling::div[1]/a
               ...                True                    //a[contains(@id,'_add_goal_button')]/preceding-sibling::div[@class='button_add']/a
  [RETURN]    ${goal}

Get up to objective
  [ARGUMENTS]    ${input}    ${goal}    ${objective}
  ${goal} =    Get Element Attribute    //label[contains(text(),'${goal}')]/following-sibling::input[1]    value
  ${objective} =    Run Keyword Unless    '${input}'=='add'    Get Element Attribute
                    ...                                        //div[@id='add_objectives_${goal}']//div[contains(text(),'${objective}')]/preceding-sibling::input[2]
                    ...                                        value
  ${objective} =    Set Variable If    '${input}'=='text'      objective_text_field_${objective}
                    ...                '${input}'=='select'    //div[@id='treatment_plan_objective_${objective}']/preceding::i[${CSS SELECT.replace('$CSS','glyphicon-list')}][1]<treatment_plan_objective_${objective}
                    ...                '${input}'=='delete'    //div[@id='treatment_plan_objective_${objective}']/preceding::a[1]
                    ...                True                    //a[@id='${goal}_add_objective_button']/preceding-sibling::div[@class='button_add']/a
  [RETURN]    ${objective}

Get up to plan
  [ARGUMENTS]    ${input}    ${goal}    ${objective}    ${plan}
  ${goal} =    Get Element Attribute    //label[contains(text(),'${goal}')]/following-sibling::input[1]    value
  ${objective} =    Get Element Attribute    //div[@id='add_objectives_${goal}']//div[contains(text(),'${objective}')]/preceding-sibling::input[2]
                    ...                      value
  ${plan} =    Run Keyword Unless    '${input}'=='add'    Get Element Attribute
               ...                                        //div[@id='add_objectives_${goal}']//div[@id='intervention_fields_${objective}']//div[contains(text(),'${plan}')]/following-sibling::input[1]
               ...                                        value
  ${plan} =    Set Variable If    '${input}'=='text'      patient_evaluation[eval_treatment_plans_attributes[0]goals_attributes[${goal}]objectives_attributes[${objective}]interventions_attributes][${plan}][description]
               ...                '${input}'=='freq'      patient_evaluation_eval_treatment_plans_attributes_0_goals_attributes_${goal}_objectives_attributes_${objective}_interventions_attributes_${plan}_frequency
               ...                '${input}'=='delete'    //a[contains(@href,'item_id=${plan}&type=Intervention')]
               ...                True                    //div[@id='add_statuses_${objective}']/preceding-sibling::div[1]//div[@class='button_add']/a
  [RETURN]    ${plan}

Get up to status
  [ARGUMENTS]    ${input}    ${goal}    ${objective}    ${addon}
  ${goal} =      Get Element Attribute    //label[contains(text(),'${goal}')]/following-sibling::input[1]@value
  ${objective} =  Get Element Attribute    //div[@id='add_objectives_${goal}']//div[contains(text(),'${objective}')]/following-sibling::input[2]@value
  ${status} =    Run Keyword If    '${input}'!='add'    Get Element Attribute    //div[@id='add_statuses_${objective}']/div[${addon.replace('Status ','')}]/div/input[1]@value
  ${base} =      Set Variable    patient_evaluation_eval_treatment_plans_attributes_0_goals_attributes_${goal}_objectives_attributes_${objective}_objective_statuses_attributes_${status}
  ${status} =    Set Variable If    '${input}'=='date'      ${base}_item_date
                 ...                '${input}'=='list'      ${base}_status
                ...                '${input}'=='text'      ${base}_note
                ...                '${input}'=='delete'    //div[@id='show_patient_signature_${status}']/preceding-sibling::div[@class='_5']/a
                ...                True                    //div[@id='add_statuses_${objective}']/following-sibling::div[@class='button_add']/a
  [RETURN]    ${status}


Adding into client settings "${option}" this "${field}" name
  ${main input}    @{extra inputs} =    Split String    ${field}    ;
  Clean from client settings "${option}" this "${main input}" name
  ${field ids before add} =    Get client settings field ids    ${option}
  Click Link    ${${option} ADD}
  Ajax wait
  ${selection} =    Get Webelement    //div[@id='${${option} TABLE}']//form
  ${field ids after add} =    Get client settings field ids    ${option}
  Remove Values From List    ${field ids after add}    @{field ids before add}
  ${field id} =    Get From List    ${field ids after add}    0
  Input Text    ${field id}    ${main input}
  Run Keyword If    '${option}'=='payment methods'       Select From List By Label
  ...                                                    //input[@id='${field id}']/following-sibling::select[1]
  ...                                                    @{extra inputs}[0]
  ...    ELSE IF    '${option}'=='patient programs'      Run Keywords    Input Text
  ...                                                                    //input[@id='${field id}']/following::input[1]
  ...                                                                    @{extra inputs}[0]
  ...                                                    AND             Select location option for client settings
  ...                                                                    ${field id}
  ...    ELSE IF    '${option}'=='patient statuses'      Run Keywords    Input Text
  ...                                                                    //input[@id='${field id}']/following::input[1]
  ...                                                                    @{extra inputs}[0]
  ...                                                    AND             Select Checkbox    //input[@id='${field id}']/following::input[@type='checkbox'][1]
  ...                                                    AND             Select Checkbox    //input[@id='${field id}']/following::input[@type='checkbox'][2]
  ...                                                    AND             Select Checkbox    //input[@id='${field id}']/following::input[@type='checkbox'][3]
  ...                                                    AND             Input Text
  ...                                                                    //input[@id='${field id}']/following::input[@type='text'][2]
  ...                                                                    @{extra inputs}[1]
  ...    ELSE IF    '${option}'=='insurance benefits'    Run Keywords    Select Checkbox    //input[@id='${field id}']/../preceding-sibling::div[1]/input[@type='checkbox']
  ...                                                    AND             Input Text
  ...                                                                    //input[@id='${field id}']/../following-sibling::div[1]/input[1]
  ...                                                                    @{extra inputs}[0]
  ...                                                    AND             Extra client settings for insurance benefits
  ...                                                                    ${field id.rsplit('_benefit',1)[0]}_care_level_ids_
  ...                                                                    ${extra inputs}
  ...    ELSE IF    '${option}'=='patient processes' and """${extra inputs}"""!='[]'
  ...                                                    Run Keywords    Unselect Checkbox    //input[@id='${field id}']/../following-sibling::div[1]//label[contains(text(),'Forms/Eval.')]/following-sibling::input[@type='checkbox']
  ...                                                    AND             Select Checkbox    //input[@id='${field id}']/../following-sibling::div[1]//label[contains(text(),'@{extra inputs}[0]')]/following-sibling::input[@type='checkbox']
  # ...    ELSE IF    '${option}'=='levels of care'      Input Text    //input[@id='${field id}']/following::input[1]    @{extra inputs}[0]
  Click Button    ${selection.find_element_by_name('commit')}
  Ajax wait
  [RETURN]    ${field id}

Get client settings field ids
  [ARGUMENTS]    ${option}
  ${selection} =    Get Webelement    //div[@id='${${option} TABLE}']//form
  # no format: Calendar Appointment Types, Diagnoses
  # 27 in total
  ${containers} =    Set Variable If    '${option}'=='pre admission status' or '${option}'=='insurance verification'
                     ...                                                     li>input
                     ...                '${option}'=='discharge types'       p:not(:last-of-type)>input.input-label
                     ...                '${option}'=='patient programs'      li>div:nth-of-type(2)>input
                     ...                '${option}'=='calendar appointment statuses' or '${option}'=='patient statuses'
                     ...                                                     li>div:nth-of-type(2)>div:first-of-type>input
                     ...                '${option}'=='rounds activities' or '${option}'=='rounds locations' or '${option}'=='levels of care' or '${option}'=='patient processes'
                     ...                                                     li>div:first-of-type>input
                     ...                '${option}'=='insurance benefits'    div._40>input:first-of-type
                     # ...                '${option}'=='care team functions'    tr;:nth-of-type(3)>td[1]>input    NEEDS WORK
                     ...                True                                 p:not(:last-of-type)>input:first-of-type
                     # marital status, payment methods, food diets, patient property condition, race, ethnicity
                     # insurance types, insurance plan types, insurance subscriber relationship,
                     # utilization review frequencies, patient contact relationship, patient contact types, medication routes
  @{ids} =    Create List
  FOR    ${id}    IN    @{selection.find_elements_by_css_selector('${containers}')}
      Append To List    ${ids}    ${id.get_attribute('id')}
  END
  [RETURN]    ${ids}

Extra client settings for insurance benefits
  [ARGUMENTS]    ${id}    ${inputs}
  Return From Keyword If    ${inputs.__len__()} < 2
  FOR    ${input}    IN    @{inputs[1:]}
      Select Checkbox    //label[starts-with(@for,'ibs_care_level_ids_') and .='${input}']/following-sibling::input[@id='${id}']
  END

Clean from client settings "${option}" this "${field}" name
  # ${selection} =    Get Webelement    //div[@id='${${option} TABLE}']//form
  # ${containers} =    Get client settings field containers    ${option}
  # @{ids} =    ${selection.find_elements_by_css_selector('input').get_attribute('id')}
  # ${delete x} =    Set Variable    ${selection.find_element_by_xpath('.//input[@value="${input}"]/following::a[1]')}
  # \    # ...    ELSE IF    '${option}'=='patient programs'                 Dialog action    Click Element
  # \    # ...                                                               ${selection.find_element_by_xpath('.//input[@value="${input}"]/ancestor::li[1]/div[@class='_5']/a')}
  # \    # ...    ELSE IF    '${option}'=='calendar appointment statuses'    Dialog action    Click Element
  # \    # ...                                                               ${selection.find_element_by_xpath('.//input[@value="${input}"]/../following-sibling::div[@class='_5']/a')}
  # \    # ...    ELSE IF    '${option}'=='patient statuses'                 Dialog action    Click Element
  # \    # ...                                                               ${selection.find_element_by_xpath('.//input[@value="${input}"]/../following-sibling::div[@class='right']/a')}
  ${field ids} =    Get client settings field ids    ${option}
  FOR    ${id}    IN    @{field ids}
      ${input} =    Get Element Attribute    ${id}    value
      Continue For Loop If    not ('${input}'=='${field}' or '${input}'=='${EMPTY}' or '${input}'=='Program TEST')
      ${delete} =    Set Variable    //input[@id='${id}']/following::a[contains(@href,'destroy')][1]
      Run Keyword If    '${option}'=='discharge types'      Run Keywords    Click Element    ${delete}
      ...                                                   AND             Ajax wait
      ...    ELSE IF    '${option}'=='patient processes'    Run Keywords    Click Element    ${delete}
      ...                                                   AND             Ajax wait
      ...                                                   AND             Select From List By Label
      ...                                                                   new_patient_process_id    Nursing
      ...                                                   AND             Click Button    Update & delete
      ...                                                   AND             Ajax wait
      ...               ELSE                                Dialog action    Click Element    ${delete}
  END


With this form "${form}" perform these actions "${actions}"
  @{actions} =    Split String    ${actions}    ;
  # ${form text} =    Set Variable    ${form}
  # ${form}  =    Strip String    ${form text}    characters=|
  # ${form}    Set Variable    ${form text.strip('|')}
  ${form text}    ${form}    Set Variable    ${form}    ${form.strip('|')}
  ${form text} =    Set Variable If    '|' not in '${form text}'    contains(text(),'${form}')    .='${form} \xa0'
  ${link} =    Set Variable    //a[contains(text(),'${form}')]/../following-sibling::td[last()]
  # @{hit} =    Run Keyword If    '${form}'=='Treatment Plan'    Create List    Click Element
  #             ...                                              //div[@id='dialog-modal-cancel-addform']//a[1]
  #             ...    ELSE IF    'assign' in @{actions}         Create List    Click Element
  #             ...                                              //div[@id='add-rounds-dialog']//*[contains(text(),'${form}')]
  #             ...               ELSE                           Create List    Click Element
  #             ...                                              //div[@id='dialog-modal-cancel-addform']//*[contains(text(),'${form}')]
  @{hit} =    Run Keyword If    'assign' in @{actions}    Create List    Click Element
              ...                                         //div[@id='add-rounds-dialog']//*[${form text}]
              ...               ELSE                      Create List    Click Element
              ...                                         //div[@id='dialog-modal-cancel-addform']//*[${form text}]
  FOR    ${action}    IN    @{actions}
      Run Keyword If    '${action}'=='add'       Run Keywords    Click Element    addform
      ...                                        AND             Ajax wait
      ...                                        AND             Run Keyword    @{hit}
      ...    ELSE IF    '${action}'=='assign'    Run Keywords    Click Element
      ...                                                        //span[contains(text(),'Assign Rounds')]
      ...                                        AND             Ajax wait
      ...                                        AND             Run Keyword    @{hit}
      ...                                        AND             Click Button    Submit
      ...                                        AND             Ajax wait
      ...    ELSE IF    'view' in '${action}'    Run Keywords    I hit the "${form}" text
      ...                                        AND             Check and wait    ${form}    ${action}
      ...    ELSE IF    'edit' in '${action}'    Run Keywords    Click Element
      ...                                                        ${link}//a[contains(@href,'edit') and contains(@href,'override')]
      ...                                        AND             Check and wait    ${form}    ${action}
      ...    ELSE IF    '${action}'=='delete'    Run Keywords    Do teardown    Dialog action    Click Element
      ...                                                        ${link}//a[@data-method='delete']
      ...                                        AND             Return From Keyword If    ${Escape Teardown}
      ...                                        AND             Wait Until Page Contains Element
      ...                                                        //h2[contains(text(),'Notice')]
      ...                                        AND             Click Element    //a[@data-toggle='close']
      ...                                        AND             Page Should Not Contain Element
      ...                                                        //h2[contains(text(),'Notice')]
      ...    ELSE IF    '${action}'=='auto'      Run Keywords    Click Element    populate_forms_button
      ...                                        AND             Slow wait    4
      ...                                        AND             Wait Until Keyword Succeeds    6x    6s
      ...                                                        Wait Until Page Does Not Contain Element
      ...                                                        populate_forms_button
      ...    ELSE IF    '${action}'=='wipe'      Loop deletion    Remove all forms
      Ajax wait
  END

Remove all forms
  Do teardown    Remove all forms proxy
  Return From Keyword If    ${Escape Teardown}

Remove all forms proxy
  Dialog action    Click Element    //span[starts-with(@id,'patient_evaluation_edit_and_delete_links_') or starts-with(@id,'record_edit_and_delete_links')]/a[@data-method='delete']
  Wait Until Page Contains Element    //h2[contains(text(),'Notice')]


Loop deletion
  [ARGUMENTS]    @{action}    &{loops}
  Log    ${loops}
  ${loop} =    Set Variable If    ${loops}    &{loops}[loop]    ${1}
  ${mod loop} =    Evaluate    ${loop} % ${LOOP LIMIT}
  ${passes}    ${status} =    Run Keyword And Ignore Error    @{action}
  Ajax wait
  ${passes}    ${status} =    Run Keyword If    '${passes}'=='FAIL'    Return From Keyword    ${passes}    ${status}
                              ...    ELSE IF    ${loop}==40            Fail    Too much recursion!
                              ...    ELSE IF    ${mod loop}==0         Return From Keyword    FAIL    try again
                              ...               ELSE                   Loop deletion    @{action}    loop=${loop+1}
  Run Keyword If    ${mod loop}==1 and 'try again' in '''${status}'''    Loop deletion    @{action}
  ...                                                                    loop=${loop+${LOOP LIMIT}}
  ...               ELSE                                                 Return From Keyword    ${passes}    ${status}
