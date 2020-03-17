*** Settings ***
Documentation   Tests for the billing report features.
...
Default Tags    acceptance    ac005    points-6
Resource        ../../suite.robot
Suite Setup     Full setup for billing testing
Suite Teardown  Full billing cleanup

*** Test Cases ***
Transmission interface
  [DOCUMENTATION]    Creating a patient and billable items to confirm billing report is picking up all billable items
  ...                Role Used: Super Admin
  [SETUP]    Run Keywords    Go To    ${BASE URL}${INSTANCE}
  ...        AND             Select code groups    F01-F99
  ...        AND             Click Button    commit
  ...        AND             Ajax wait
  ...        AND             Return to mainpage
  Given I am on the "patients" page
  And setup a patient
  And enter a dx code of "F10.20"
  And Click Link    Add insurance
  And setup insurance
  And I hit the "Show Facesheet" view
  And I hit the "Add review" view
  And enter review autorization
  When travel "slow" to "current" patients "medical" page in "null"
  And add multiple billing forms    Billing NTP
  And I hit the "medical" patient tab
  # And with this form "Psych Eval W/O Medical Services" perform these actions "add;edit"
  And with this form "Dont Random The Eval" perform these actions "add;edit"
  And form fill    ${EMPTY}    patient_evaluation_start_time:direct_js=03/01/2018 1:00pm
  ...              patient_evaluation_end_time:direct_js=03/01/2018 2:00pm
  And hit update
  And navigate to billing reports
  And enter in a billing start date of "03/01/2018"
  And enter in a billing end date of "03/10/2018"
  And hit go
  Then confirm that all days entered are present
  # And Confirm that all billing test NTP claims are showing with the Residential LOC billing codes/LOC attributes
  # And Confirm that the psych eval claim is showing the psych eval code from the template setup, as its own billable item
  [TEARDOWN]    Run Keywords    Custom screenshot
  ...           AND             I select the "${_LOCATION 3}" location
  ...           AND             Remove this patient    Ginger Apple Ale
  ...           AND             Return to mainpage

Hitting go on the transmission interface after switching to a location
  Given I am on the "patients" page
  And navigate to billing reports
  When I select the "My Locations" location
  And hit go
  Then page should have    Errors found    Please select a location
  When I select the "${_LOCATION 3}" location
  And hit go
  Then page should have    No billable items found in the date range.

*** Keywords ***
Codes
  [DOCUMENTATION]    Standard Testing - Adding a code w/expected values
  ...                Role Used:	Super Admin
  Set Suite Variable    ${Setup name}    Codes
  I am on the "patients" page
  Navigate to billing settings "Codes"
  FOR    ${code}    IN    HCode    CCode    CCode    RCode    Custom
      Preparing to add a "${code}"
      Select "Add item"
      Enter a random "5 digit number"
      Enter a description of test
      Enter a start date of "01/01/2018"
      Enter an end date of "12/31/2020"
      Hit save
      Confirm name appears in the "code" list
  END
  # Repeat Keyword    100x    just loop me
  # Just loop me
  #   select ${Add item}
  #   enter a random 5 digit number
  #   enter a description of test
  #   enter a start date of "01/01/2018"
  #   enter an end date of "12/31/2018"
  #   hit save

Services
  [DOCUMENTATION]    Ability to add a treatment service
  ...                Role Used:	Super Admin
  Set Suite Variable    ${Setup name}    Services
  Return to mainpage
  Navigate to billing settings "Services"
  Select "New Service"
  Enter a random "name"
  Click Button    Create
  # And enter a description of test
  Enter a start date of "01/01/2018"
  Enter an end date of "12/31/2020"
  # Select a service type of "Treatment"
  FOR    ${c}    IN    H    C    R
      Enter a "${c}" code of "auto"
  END
  # And enter a "H" code of "H0015" # And enter a "C" code of "99213" # And enter a "R" code of "0900"
  Check off locations
  Hit save
  I hit the "Services" text
  Confirm name appears in the "service" list

Levels of care
  [DOCUMENTATION]    Standard Testing - adding a level of care w/expected values
  ...                Role Used: Super Admin
  Set Suite Variable    ${Setup name}    Levels of care
  Return to mainpage
  I hit the "settings" tab
  Preparing a loc item    Not A Random Care
  Check off the billable loc checkbox
  Select a loc type of "Inpatient"
  # And enter an end date of "12/31/2018" # And select "H0010" for "H" code # And select "99213" for "C" Code # And select "0915" for "R" Code # And select "12345" for "Custom" Code
  Check off all days per week checkboxes
  FOR    ${c}    IN    H    C    R    Custom
      Select "auto" for "${c}" code
  END
  Enter "5.0" number of hours
  Select "Office" for place of service
  Select in claim format of "Institutional"
  Enter in type of bill "131"
  Hit loc update
  Refresh screen and ensure all values are saved

Templates
  [DOCUMENTATION]    Ability to mark evals as ancillary and add codes to the eval
  ...                Role Used: Super Admin
  Set Suite Variable    ${Setup name}    Templates
  Return to mainpage
  Navigate to templates evaluations
  Preparing an eval item    Billing NTP
  Check off the billable template checkbox
  Check off locations
  Add start and end time field
  Hit template update
  I hit the "Evaluations" text
  Refresh screen and confirm that selected attributes are present
  Preparing an eval item    Dont Random The Eval
  Check off the billable template checkbox
  Check off the ancillary checkbox
  Select the coding system "CCode"
  # And enter in the codes "99212;99213"
  Enter in the codes "auto"
  Check off locations
  Add start and end time field
  Hit template update
  I hit the "Evaluations" text
  Refresh screen and confirm that selected attributes are present

Group sessions
  [DOCUMENTATION]    The ability to add a code to a group session
  ...                Role Used: Super Admin
  Set Suite Variable    ${Setup name}    Group sessions
  Return to mainpage
  Navigate to templates group sessions two
  Preparing a group session item    Random Yerba Meet
  Check off the billable group session checkbox
  Select the coding system "CCode"
  # And enter in the codes "90853" # enter in the codes "98937"
  Enter in the codes "auto"
  Check off locations
  Add an occurrence
  Hit save
  Return back to group sessions 2
  Refresh screen

# All codes
# Current coding
# Loc item
# Refresh item
# Coding system
Full setup for billing testing
  &{dict} =    Create Dictionary
  Set Suite Variable    ${All codes}    ${dict}
  Turn "on" billing
  I select the "My Locations" location
  Codes
  Services
  Levels of care
  Templates
  Group sessions
  Return to mainpage

Full billing cleanup
  Go To    ${BASE URL}${SERVICES}
  Loop deletion    Dialog action    Click Element
  ...              //a[contains(text(),'${Current service}')]/preceding-sibling::div[1]/a[@data-method\='delete']
  Go To    ${BASE URL}${SETTINGS}
  Clean from client settings "levels of care" this "Not A Random Care" name
  Go To    ${BASE URL}${TEMPLATES EVALUATIONS}
  Loop deletion    Remove old templates    Billing NTP
  Loop deletion    Remove old templates    Dont Random The Eval
  Delete tester template    group sessions 2
  Turn "off" billing

Turn "${state}" billing
  ${state} =    Set Variable If    '${state}'=='on'    Select Checkbox    Unselect Checkbox
  Go To    ${BASE URL}${INSTANCE}
  Temporarily reveal billing options
  FOR    ${option}    IN    Enable Billing Interface    Enable Transmit/Download Billing Data    Enable Group Billing
      Instance edit "${state}" on "${option}"
  END
  Click Button    commit
  Ajax wait
  Return to mainpage

Navigate to billing settings "${tab}"
  I hit the "settings" tab
  I hit the "Billing" view
  I hit the "${tab}" view
  @{random} =    Create List
  Set Suite Variable    ${Random ${tab}}    ${random}
  Run Keyword If    '${tab}'=='Services'    Get current services
  I am on the "${tab}" page

Navigate to templates evaluations
  I attempt to hit the "templates" tab
  I hit the "templates evaluations" tab

Navigate to templates group sessions two
  I attempt to hit the "templates" tab
  I hit the "templates group sessions" tab
  I hit the "templates group sessions 2" tab

Navigate to billing reports
  I hit the "reports" tab
  I hit the "Billing" view

Preparing to add a "${code}"
  Set Suite Variable    ${Current coding}    ${code}
  Form fill    billing settings codes    coding:dropdown=${code}
  I hit the "All ${code} codes" view
  ${passes}    ${codes} =    Run Keyword And Ignore Error    Get Webelements    //div[@id='codes']/div[last()]/div[.='${code}']/following-sibling::div[1]
  ${codes} =    Run Keyword If    '${passes}'=='PASS'    Set Variable    ${codes}
                ...               ELSE                   Create List
  FOR    ${number}    IN    @{codes}
      Append To List    ${Random codes}    ${number.get_attribute('innerHTML')}
  END

Preparing a loc item
  [ARGUMENTS]    ${name}
  ${loc item} =    Adding into client settings "levels of care" this "${name}" name
  Run Keyword If    not ${_LOCATIONS ACTIVE}    Select location option for client settings    ${loc item}
  ...               ELSE                        Select location option for client settings    ${loc item}
  ...                                           ${_LOCATION 1};${_LOCATION 2};${_LOCATION 3};${_LOCATION 5}
  ${loc item} =    Get Element Attribute    //input[@id='${loc item}']/ancestor::li[1]    id
  Set Suite Variable    ${Loc item}    ${loc item}
  Set Suite Variable    ${Refresh item}    ${Loc item}

Preparing an eval item
  [ARGUMENTS]    ${name}
  Create tester template    evaluations    ${name}
  Editing "evaluations" test template
  Form fill    evaluations form    enabled:checkbox=x    patient process:dropdown=Medical    patient sig:checkbox=x
  Run Keyword If    ${_LOCATIONS ACTIVE}    Form fill    evaluations form    all locations:checkbox=x
  Set Suite Variable    ${Refresh item}    ${name}
  ${evals} =    Pop From Dictionary    ${All codes}    Evals    ${EMPTY}
  ${evals} =    Run Keyword If    '''${evals}'''!='${EMPTY}'    Set Variable    ${evals}
                ...               ELSE                          Create List
  Append To List    ${evals}    ${name}
  Set To Dictionary    ${All codes}    Evals=${evals}

Preparing a group session item
  [ARGUMENTS]    ${name}
  Create tester template    group sessions 2    ${name}
  Editing "gs/group sessions" test template
  Form fill    group sessions 2 form    enabled:checkbox=x
  Set Suite Variable    ${Refresh item}    ${name}

Setup a patient
  I select the "${_LOCATION 3}" location
  Run Keyword And Ignore Error    Remove this patient    Ginger Apple Ale
  Return to mainpage
  I create a valid patient    Ginger    Apple    Ale    03/01/2018
  Update facesheet    birth sex:radio=gender_female    dob:js=01/01/1987    street address 1=123 Recovery St
  ...                 city=Fort Lauderdale    zip=33304    admission date:js=03/01/2018 12:00 AM

Setup insurance
  Input insurance company    UHC
  # Update facesheet    policy no=453535    group id=4557    insurance status:dropdown=Active
  # ...                 subscriber rship:dropdown=Self
  Update facesheet    policy no=XJBH70446457    group id=B7955    insurance status:dropdown=Active
  ...                 subscriber rship:dropdown=Self

Add start and end time field
  Add eval item
  Form fill    evaluations form    enabled:checkbox=x    item name=Start End    item label=Start End
  ...          item field type:dropdown=evaluation_start_and_end_time

Add an occurrence
  I hit the "Add Occurrence" view
  ${day} =    Convert Date    ${Todays Date}    %A    False    %Y-%m-%d
  Form fill    group sessions 2 form    week day:dropdown=${day}    start hr:dropdown=12 AM    start min:dropdown=00
  ...          end hr:dropdown=11 PM    end min:dropdown=59

Add multiple billing forms
  [ARGUMENTS]    ${form}
  FOR    ${index}    IN RANGE    7
      I hit the "medical" patient tab
      With this form "${form}" perform these actions "add;edit"
      Run Keyword And Continue On Failure    Locator Should Match X Times    patient_evaluation_start_time    1
      Form fill    ${EMPTY}    patient_evaluation_start_time:direct_js=03/0${1+${index}}/2018 2:00pm
      ...          patient_evaluation_end_time:direct_js=03/0${1+${index}}/2018 7:00pm
      Hit update
  END

Get current services
  ${passes}    ${services} =    Run Keyword And Ignore Error    Get Webelements    //ul[@id='group_session_list']/li/a
  ${services} =    Run Keyword If    '${passes}'=='PASS'    Set Variable    ${services}
                   ...               ELSE                   Create List
  FOR    ${name}    IN    @{services}
      Append To List    ${Random services}    ${name.get_attribute('innerHTML')}
  END

Select "${action}"
  I hit the "${action}" view

Select a service type of "${type}"
  Form fill    billing settings services    type:dropdown=${type}

Select a loc type of "${type}"
  Select From List By Label    //li[@id='${Loc item}']/div[3]/div[1]/select    ${type}

Select "${code}" for "${letter}" code
  ${code} =    Run Keyword If    '${code}'!='auto'        Set Variable    ${code}
               ...    ELSE IF    '${letter}'!='Custom'    Set Variable    ${All codes.${letter}Code[0]}
               ...               ELSE                     Set Variable    ${All codes.${letter}\[0]}
  Select From List By Label    //li[@id='${Loc item}']/div[3]//label[.='${letter}Code' or .='${letter}']/following-sibling::select[1]
  ...                          ${code}

Select "${place}" for place of service
  Select From List By Label    //li[@id='${Loc item}']/div[3]/div[14]/select    ${place}

Select in claim format of "${format}"
  Select From List By Label    //li[@id='${Loc item}']/div[3]/div[15]/select    ${format}

Select the coding system "${coding system}"
  Form fill    evaluations form    coding system:dropdown=${coding system}
  Set Suite Variable    ${Coding system}    ${coding system}

Enter a random "${string}"
  @{string} =    Run Keyword If    '${string}'=='5 digit number'    Create List    5    [NUMBERS]
                 ...               ELSE                             Create List    8    [UPPER]
  FOR    ${i}    IN RANGE    5000
      ${rand} =    Generate Random String    @{string}
      Continue For Loop If    '${rand}' in @{Random ${Setup name}}
      Append To List    ${Random ${Setup name}}    ${rand}
      Exit For Loop
  END
  Run Keyword If    '${Setup name}'=='Codes'    Form fill    billing settings codes    code=${rand}
  ...               ELSE                        Form fill    billing settings services    name=${rand}
  Set Suite Variable    ${Current data}    ${rand}

Enter a description of test
  Form fill    billing settings codes    description=too many lobsters

Enter a start date of "${date}"
  Form fill    billing settings ${Setup name}    start d:js=${date}

Enter an end date of "${date}"
  Form fill    billing settings ${Setup name}    end d:js=${date}

Enter a "${letter}" code of "${code}"
  ${code} =    Run Keyword If    '${code}'=='auto'    Set Variable    ${All codes.${letter}Code[0]}
               ...               ELSE                 Set Variable    ${code}
  # Run Keyword And Return If    '${code}'!='auto'    Form fill    billing settings services    ${letter}code=${code}
  Form fill    billing settings services    ${letter}code=${code}
  ${passes} =    Run Keyword And Return Status    Wait Until Keyword Succeeds    3x    0.5
                 ...                              Click Element    //div[@class='token-input-dropdown']//li[1]/p
  Run Keyword Unless    ${passes}    Press Key    token-input-dropdown    \\13
  Ajax wait

Enter "${time}" number of hours
  Input Text    //li[@id='${Loc item}']/div[3]/div[13]/input    ${time}

Enter in type of bill "${type}"
  # Input Text    //li[@id='${Loc item}']/div[3]/div[16]/input    ${type}
  Input Text    //li[@id='${Loc item}']/div[3]/div[17]/input    ${type}

Enter in the codes "${codes}"
  @{codes} =    Run Keyword If    '${codes}'=='auto'    Set Variable    ${All codes.CCode}
                ...               ELSE                  Split String    ${codes}    ;
  ${codes} =    Run Keyword If    '${Setup name}'!='Group sessions'    Set Variable    ${codes}
                ...               ELSE                                 Get Slice From List    ${codes}    end=-1
  FOR    ${code}    IN    @{codes}
      Input Text    token-input-txtcodes${Coding system}    ${code}
      ${passes} =    Run Keyword And Return Status    Wait Until Keyword Succeeds    3x    0.5
      ...            Click Element    //li[@class='token-input-dropdown-item2']/p
      Run Keyword Unless    ${passes}    Press Key    token-input-txtcodes${Coding system}    \\13
      Ajax wait
  END

Enter a dx code of "${code}"
  Input Text    token-input-diagnosis_code    ${code}
  Slow wait
  Wait Until Keyword Succeeds    3x    0.5
  ...                            Click Element    //div[@class='token-input-dropdown']//li[1]/p
  Slow wait

Enter review autorization
  # Form fill    review authorization    date:js=03/01/2018    days=7    level of care:dropdown=Residential
  # ...          number=1122    status:dropdown=approved    managed:dropdown=Managed
  Form fill    review authorization    date:js=03/01/2018    days=7    level of care:dropdown=Not A Random Care
  ...          number=ZX229988    status:dropdown=Approved    managed:dropdown=Managed
  Click Element    //div[@id='insurance-authorization-dialog']/following-sibling::div[last()]//div[@class='ui-dialog-buttonset']/button[2]
  Ajax wait

Enter in a billing start date of "${date}"
  Form fill    billing reports    start date:js=${date}

Enter in a billing end date of "${date}"
  Form fill    billing reports    end date:js=${date}

Check off locations
  Run Keyword If    not ${_LOCATIONS ACTIVE}        Return From Keyword
  ...    ELSE IF    '${Setup name}'=='Templates'    Run Keywords    Form fill    evaluations form
  ...                                                               all locations:checkbox=x
  ...                                               AND             Return From Keyword
  ${locations} =    Set Variable    ${_LOCATION 1};${_LOCATION 2};${_LOCATION 3};${_LOCATION 5}
  &{locations hit} =    Run Keyword If    '${Setup name}'=='Services'    Create dict for locations    ${locations}
                        ...                                              service_location_ids_
                        ...               ELSE                           Create dict for locations    ${locations}
                        ...                                              gs_group_session_location_ids_
  Form fill    ${EMPTY}    &{locations hit}

Check off the billable loc checkbox
  Select Checkbox    //li[@id='${Loc item}']/div[2]/input[@type='checkbox']

Check off all days per week checkboxes
  FOR    ${index}    IN RANGE    2    9
      Select Checkbox    //li[@id='${Loc item}']/div[3]/div[${index}]/input[@type='checkbox']
  END

Check off the billable template checkbox
  Dialog action    Select Checkbox    ${EVALUATIONS FORM BILLABLE}
  Page should have    ELEMENT|//select[@id='${EVALUATIONS FORM CLAIM FORMAT}']/option[@value='Professional' and @selected='selected']

Check off the ancillary checkbox
  Form fill    evaluations form    ancillary:checkbox=x

Check off the billable group session checkbox
  Form fill    group sessions 2 form    billable:checkbox=x

Hit save
  ${passes} =    Run Keyword And Return Status    Click Button    Submit
  Run Keyword Unless    ${passes}    Click Button    Save
  Ajax wait

Hit loc update
  Click Element    //li[@id='${Loc item}']/ancestor::form[1]/input[@name='commit']
  Ajax wait

Hit template update
  Save "evaluations" template

Hit update
  Click Button    Update
  Ajax wait

Hit go
  Click Button    Go
  Slow wait    5

Return back to group sessions 2
  Click Link    /gs/group_sessions

Confirm name appears in the "${type}" list
  Run Keyword If    '${type}'=='code'    I hit the "All ${Current coding} codes" view
  Page should have    ${Current data}
  Run Keyword And Return If    '${type}'=='service'    Set Suite Variable    ${Current service}    ${Current data}
  ${codes} =    Pop From Dictionary    ${All codes}    ${Current coding}    ${EMPTY}
  ${codes} =    Run Keyword If    '''${codes}'''!='${EMPTY}'    Set Variable    ${codes}
                ...               ELSE                          Create List
  Append To List    ${codes}    ${Current data}
  Set To Dictionary    ${All codes}    ${Current coding}=${codes}
  Log Many    ${All codes}

Confirm that all days entered are present
  Page should have    ELEMENT|8x|//table[@id='billing_items_display']/tbody/tr

Refresh screen and ensure all values are saved
  Reload Page
  Page should have    ELEMENT|${Refresh item}

Refresh screen and confirm that selected attributes are present
  Reload Page
  Page should have    ${Refresh item}

Refresh screen
  Page should have    ${Refresh item}${SPACE*3}- billable
