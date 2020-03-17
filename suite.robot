*** Settings ***
Documentation   General keywords used throughout multiple test suites.
...             Loads necessary libraries and resources.
...
Library         String
Library         Collections
Library         DateTime
Library         OperatingSystem
Library         SeleniumLibrary    run_on_failure=Custom screenshot
Library         DatabaseLibrary
Library         ExtraLibrary.py
Resource        keywords/setup.robot
Resource        keywords/creation.robot
Resource        keywords/dom_var.robot
Resource        keywords/api_connect.robot
Resource        secret.robot
Resource        ${VARS}

*** Keywords ***
Return to mainpage
  Go To    ${BASE URL}
  Figure out what view style I am in
  I am on the "patients" page

### Refactor
I will see that patients information
  ${name} =    Run Keyword If    '${View Style}'=='tile'    Line parser    ${Selected name}    1
               ...               ELSE                       Set Variable    ${Selected name}
  Set Suite Variable    ${Selected name}    ${name}
  # Page Should Contain    ${assessments indicator}
  Page should have    ${Selected name}    ${Selected mr number}    ${Selected test Bed}

Scrolling down
  Ajax wait
  Execute Javascript    window.document.evaluate("//*[@id='${TOP}' or @id='${KP BOTTOM}']", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.scrollIntoView(true)

Toggle view
  Click Element    //a[contains(@href,'${VIEW TOGGLE}')]
  Ajax wait

# Create pdf print
#   Page Should Contain Element    ${PRINT}
#   Page Should Contain Element    ${PDF}
#   #Run    wkhtmltopdf http://localhost:3000/shift_reports google.pdf
#   #Run    python -m robot -l none -r none -o none print.robot
#   ${win} =    Set Variable    myWindowName
#   Execute Javascript    window.name = "myWindowName"
#   Start Process    python    -m    robot    -v    NAME:${win}    keywords/print.robot
#   Execute Javascript    window.print()
#   # Sleep    1
#   # #Unselect Frame
#   # Select Window    id=print-preview
#   # Click Element    //button[@class='destination-settings-change-button']
#   # Click Element    //span[@title='Save as PDF']
#   # Click Element    //button[@class='print default']

Ajax wait
  ${ajax} =    Set Variable    ${EMPTY}
  FOR    ${i}    IN RANGE    5000
      ${ajax} =    Execute JavaScript    return window.jQuery!=undefined && jQuery.active==0
      Run Keyword If    ${ajax}==True or '${ajax}'=='None'    Exit For Loop
  END

Basic duplication check
  No Operation


Check and wait
  [ARGUMENTS]    ${form}    ${action retry check}
  ${action}    @{retry check} =    Split String    ${action retry check}    |    max_split=2
  Append To List    ${retry check}    ${EMPTY}    ${EMPTY}
  ${retry}    ${check} =    Run Keyword If    ${retry check.__len__()}==4          Set Variable    @{retry check}[0]
                            ...                                                    @{retry check}[1]
                            ...    ELSE IF    ${retry check.__len__()}==2          Set Variable    3    ${EMPTY}
                            ...    ELSE IF    '''@{retry check}[0]'''.isdigit()    Set Variable    @{retry check}[0]
                            ...                                                    ${EMPTY}
                            ...               ELSE                                 Set Variable    3
                            ...                                                    @{retry check}[0]
  Verify for no bad page
  ${passes} =    Run Keyword And Return Status    Wait Until Page Contains Element
                 ...                              //div[@id='please_wait' and contains(@style,'display') and contains(@style,'none')]
                 ...                              1m
  Run Keyword Unless    ${passes}    Run Keywords    Run Keyword And Continue On Failure    Fail    Spinning wheel!
  ...                                AND             Sleep    10
  Run Keyword Unless    ${passes}    Wait Until Keyword Succeeds    2x    10s
  ...                                Run Keywords    Reload Page
  ...                                AND             Verify for no bad page
  ...                                AND             Wait Until Page Contains Element
  ...                                                //div[@id='please_wait' and contains(@style,'display') and contains(@style,'none')]
  ...                                                1m
  Verify for no bad page
  Custom screenshot
  ${passes} =    Run Keyword If    '''${check}'''=='${EMPTY}'    Run Keyword And Return Status
                 ...                                             Basic duplication check
                 ...               ELSE                          Run Keyword And Return Status    ${check}
  Return From Keyword If    ${passes}
  Run Keyword And Continue On Failure    Fail    Duplication found!
  ${retry} =    Run Keyword If    '${retry}'!='0'    Set Variable    ${${retry}-1}
                ...               ELSE               Fail    Duplication always happening or bad functionality!
  Go Back
  With this form "${form}" perform these actions "wipe;add;${action}|${retry}|${check}"

Slow wait
  [ARGUMENTS]    ${time}=1
  Ajax wait
  Sleep    ${time}
  Ajax wait

Dialog action
  [ARGUMENTS]    @{action}
  ${version} =    PYTHON Version
  ${passes} =    Run Keyword And Return Status    I am on the "company" page
  ${retry} =    Set Variable If    not ${passes}    3s    1x
  ${passes} =    Run Keyword And Return Status    Page should have    Edit location
  Run Keyword If    ${version}==2    Run Keywords    @{action}
  ...                                AND             Confirm Action
  ...               ELSE             Wait Until Keyword Succeeds    ${retry}    1s
  ...                                                               Run Keywords    @{action}
  ...                                                               AND             Alert Should Be Present
  ...                                                               AND             Sleep    0.2
  ### Very specific failsafe, monitor
  Run Keyword If    ${passes}    Run Keyword And Ignore Error    Confirm Action
  Ajax wait

Login to system
  [ARGUMENTS]    ${2FA}=${true}
  Start new window process    2200    20
  Run Keyword If    ${2FA}    Start login    ${CURRENT USER}    ${CURRENT PASS}
  ...               ELSE      Start login    ${LOCAL USER}    ${LOCAL PASS}

Start login
  [ARGUMENTS]    ${user}    ${pass}    ${success}=${true}    ${2fa}=CAS
  ${2fa} =    Run Keyword If    "${2fa}"=="CAS"    Get Variable Value    ${CAS TOKEN}    null
              ...               ELSE               Set Variable    ${2fa}
  Input Password    user_username    ${user}
  Input Password    user_password    ${pass}
  Click Element    //input[${CSS SELECT.replace('$CSS','sign-in-button')}]
  ${passes} =    Run Keyword And Return Status    Page Should Contain Element    code
  Run Keyword If    ${passes}    Do two factor    ${2fa}
  Run Keyword If    ${success}    Run Keywords    I am on the "patients" page
  ...                                             Set username id

Do two factor
  [ARGUMENTS]    ${code}
  ${code} =    GET Two Factor Auth    ${code}
  Input Password    code    ${code}
  Click Element    commit

Exit system
  [ARGUMENTS]    ${close}=${true}
  Return to mainpage
  Click Link    Sign out
  Location Should Be    ${BASE URL}${SIGN IN}
  Run Keyword If    ${close}    Close Browser

### Niche use
Do search in
  [ARGUMENTS]    ${collect}    ${search}    ${find}=filled
  @{find} =    Split String    ${find}    ;
  @{page} =    Get Webelements    ${collect}
  :FOR    ${selection}    IN    @{page}
  \    Run Keyword If    '@{find}[0]'=='filled'    Run Keyword And Continue On Failure    Should Not Be Empty
  \    ...                                         ${selection.${search}}
  \    ...               ELSE                      Run Keyword And Continue On Failure    Should Contain Any
  \    ...                                         ${selection.${search}}    @{find}

Page should have
  [ARGUMENTS]    @{items}
  FOR    ${item}    IN    @{items}
      ${should}    ${item} =    Run Keyword If    'NOT|' not in """${item}"""    Set Variable    Should    ${item}
                                ...               ELSE                           Set Variable    Should Not
                                ...                                              ${item.replace('NOT|','')}
      ${contain}    ${item} =    Run Keyword If    'ELEMENT|' not in """${item}"""    Set Variable    Contain    ${item}
                                 ...               ELSE                               Set Variable    Contain Element
                                 ...                                                  ${item.replace('ELEMENT|','')}
      ${xtimes}    ${item} =    Run Keyword If    'x|' not in """${item}"""    Set Variable    null    ${item}
                                ...               ELSE                         Split String    ${item}    x|
      @{page} =    Create List    Page ${should} ${contain}    ${item}
      Run Keyword Unless    '${xtimes}'=='null'    Append To List    ${page}    limit=${xtimes}
      Run Keyword And Continue On Failure    @{page}
  END

Perform signature
  [ARGUMENTS]    @{action}
  Run Keyword    @{action}
  Ajax wait
  ${w}    ${h} =    Get Element Size    //canvas
  ${p} =    Set Variable    ${0.5}
  ${w} =    Evaluate    ${w} * ${p} / 7
  ${h} =    Evaluate    ${h} * ${p} / 2
  ${s2l} =    Get Library Instance    SeleniumLibrary
  ${webdriver} =    Set Variable    ${s2l._drivers.current}
  FOR    ${x start}    ${y start}    ${x end}     ${y end}    IN
  ...    ${w * -3}     ${h * -1}     ${w * -2}    ${h * -1}
  ...    0             ${h * -1}     ${w * +1}    ${h * -1}
  ...    ${w * +2}     ${h * -1}     ${w * +4}    ${h * -1}
  ...    ${w * -2}     0             ${w * -1}    0
  ...    0             0             ${w * +1}    0
  ...    ${w * -3}     ${h * +1}     ${w * -1}    ${h * +1}
  ...    ${w * -3}     ${h * -1}     ${w * -3}    ${h * +1}
  ...    ${w * -1}     0             ${w * -1}    ${h * +1}
  ...    0             ${h * -1}     0            ${h * +1}
  ...    ${w * +1}     ${h * -1}     ${w * +1}    ${h * +1}
  ...    ${w * +3}     ${h * -1}     ${w * +3}    ${h * +1}
      LINE Segment    ${webdriver}    //canvas    ${x start}    ${y start}    ${x end}    ${y end}
  END
  Custom screenshot
  ${passes} =    Run Keyword And Return Status    Click Button    Submit
  Run Keyword Unless    ${passes}    Click Element
  ...                   //div[@id='signature-dialog']/following-sibling::div[1]//button[.='Submit']
  Ajax wait

### Niche use
Form should have these elements
  [ARGUMENTS]    ${attr}    ${form}    &{items}
  ${keys} =    Get Dictionary Keys    ${items}
  :FOR    ${k}    IN    @{keys}
  \    Do search in    //body    find_element_by_xpath("${${form} ${k}}").get_attribute('${attr}')    &{items}[${k}]

Select code groups
  [ARGUMENTS]    @{codes}
  Run Keyword If    '@{codes}[0]'=='none'    Run Keywords    Unselect Checkbox    site_setting_enable_icd
  ...                                        AND             Return From Keyword
  Select Checkbox    site_setting_enable_icd
  ${passes} =    Run Keyword And Return Status    Element Should Be Visible
  ...            dialog-modal-cancel-site_setting_enable_icd
  Run Keyword Unless    ${passes}    Click Button    icd_groups_button
  @{groups} =    Get Webelements    //div[@id='dialog-modal-cancel-site_setting_enable_icd']//ul
  FOR    ${group}    IN    @{groups}
      ${group} =    Set Variable    ${group.find_element_by_name('site_setting[icd_groups][]').get_attribute('value')}
      ${passes} =    Run Keyword And Return Status    List Should Contain Value    ${codes}    ${group}
      Run Keyword If    ${passes}    Select Checkbox    //input[@value='${group}']
      ...               ELSE         Unselect Checkbox    //input[@value='${group}']
  END
  # Click Element    //html/body/div[11]/div[3]/div/button
  FOR    ${i}    IN RANGE    9    15
      ${passes} =    Run Keyword And Return Status    Click Element    //html/body/div[${i}]/div[3]/div/button
      Exit For Loop If    ${passes}
  END

Order for column is good
  [ARGUMENTS]    ${col}    ${table}=//table/thead/tr;//table/tbody/tr;null    ${format}=${EMPTY}    ${rule}=${EMPTY}
  ...            ${direction}=up
  Verify for no bad page
  Custom screenshot
  ${head}    ${body}    ${termination} =    Split String    ${table}    ;
  @{head} =    Run Keyword If    '''${head}'''!='null'    Get Webelements    ${head}/th
               ...                ELSE                    Create List
  Run Keyword If    '''${head}'''!='[]'    Append To List    ${head}    ${EMPTY}
  ${end} =    Get Length    ${head}
  :FOR    ${index}    ${h}    IN ENUMERATE    @{head}
  \    Run Keyword If    ${index}==${end}    Fail    Column not in table!
  \    Log    ${h.get_attribute('innerHTML')}
  \    ${passes} =    Run Keyword And Return Status    Element Should Contain    ${h}    ${col}
  \    Continue For Loop If    not ${passes}
  \    ${col} =    Set Variable    ${index+1}
  \    Exit For Loop
  ${format} =    Catenate    SEPARATOR=;    ${format}    ${EMPTY}    ${EMPTY}    ${EMPTY}
  ${type}    @{format} =    Split String    ${format}    ;
  :FOR    ${index}    ${f}    IN ENUMERATE    @{format}
  \    Run Keyword If    '${f}'=='${EMPTY}'    Set List Value    ${format}    ${index}    <<><>>
  Log    ${format}
  ${termination} =    Run Keyword If    '''${termination}'''=='null'    Set Variable    ${termination}
                      ...               ELSE                            Get Webelement    ${termination}/td[${col}]
  Run Keyword And Ignore Error    Log    ${termination.get_attribute('innerHTML')}
  @{my set} =    Create List
  @{rows} =    Get Webelements    ${body}/td[${col}]
  :FOR    ${row}    IN    @{rows}
  \    Log    ${row.get_attribute('innerHTML')}
  \    ${passes} =    Run Keyword If    '${termination}'=='null'    Set Variable    ${false}
  \                   ...               ELSE                        Run Keyword And Return Status    Should Contain
  \                   ...                                           ${row.get_attribute('innerHTML')}
  \                   ...                                           ${termination.get_attribute('innerHTML')}
  \    Exit For Loop If    ${passes}
  \    ${passes} =    Run Keyword If    '''${rule}'''=='${EMPTY}'    Set Variable    ${true}
  \                   ...               ELSE                         Run Keyword And Return Status
  \                   ...                                            Should Not Be Empty
  \                   ...                                            ${row.find_elements_by_xpath("${rule}")}
  \    Run Keyword Unless    ${passes}    Continue For Loop
  \    ${row} =    Get Text    ${row}
  \    ${row} =    Run Keyword If    '@{format}[1]'!='<<><>>'    Fetch From Right    ${row}    @{format}[1]
  \                ...               ELSE                        Set Variable    ${row}
  \    ${row} =    Run Keyword If    '@{format}[2]'!='<<><>>'    Fetch From Left    ${row}    @{format}[2]
  \                ...               ELSE                        Set Variable    ${row}
  \    ${row} =    Run Keyword If    '${type}'=='date'      Convert Date    ${row}    epoch    False    @{format}[0]
  \    ...         ELSE IF           '${type}'=='number'    Convert To Integer    ${row}
  \    ...         ELSE                                     Convert To Lowercase    ${row}
  \    Append To List    ${my set}    ${row}
  #   \    ${r} =    Run Keyword If    '@{format}[1]'!='\\n'    Fetch From Right    ${r}    @{format}[1]
  #   \              ...               ELSE                     Set Variable    ${r.splitlines()[1]}
  #   \    ${r} =    Run Keyword If    '@{format}[2]'!='\\n'    Fetch From Left    ${r}    @{format}[2]
  #   \              ...               ELSE                     Set Variable    ${r.splitlines()[0]}
  #   \    ${return} =    Run Keyword If    '${rule}'!='${EMPTY}'    Run Keyword    ${rule}    ${r}
  #   \                   ...               ELSE                     Catenate    SEPARATOR=;    pass    ${r}
  #   \    ${r} =    Run Keyword If    '${return.split(';',1)[0]}'=='pass'    Set Variable    ${return.split(';',1)[1]}
  #   \              ...               ELSE                                   Continue For Loop
  @{ordered set} =    Copy List    ${my set}
  Sort List    ${ordered set}
  Run Keyword If    '${direction}'=='down'    Reverse List    ${ordered set}
  Run Keyword And Continue On Failure    Lists Should Be Equal    ${my set}    ${ordered set}
  :FOR    ${m}    ${o}    IN ZIP    ${my set}    ${ordered set}
  \    Run Keyword And Continue On Failure    Should Be Equal As Strings    ${m}    ${o}

Update facesheet
  [ARGUMENTS]    &{info}
  Page Should Contain    Show Facesheet
  ${passes} =    Pop From Dictionary    ${info}    validation type    passing
  Form fill    patient facesheet    &{info}
  Click Button    patient[auto_submit]
  Ajax wait
  Give a "${passes}" facesheet validation

Default patient
  [ARGUMENTS]    ${add more}=${true}
  ${passes} =    Run Keyword And Return Status    Page should have    Delete Allergy
  Run Keyword If    ${passes}    Click Element    //a[.='Delete Allergy']
  ${admission} =    Get Element Attribute    ${PATIENT FACESHEET ADMISSION DATE}    value
  Run Keyword If    '${admission}'=='${EMPTY}'    Default date to now    ${PATIENT FACESHEET ADMISSION DATE}
  ${passes} =    Run Keyword And Return Status    Click Element    //a[contains(text(),'Create MR')]
  Ajax wait
  Run Keyword If    ${passes}    Page should have    NOT|Create MR
  ${passes} =    Run Keyword If    '${Test Mr}'!='${EMPTY}'    Run Keyword And Return Status    Location Should Contain
                 ...                                           @{Clean Me Up}[0]
                 ...               ELSE                        Set Variable    ${false}
  Run Keyword If    ${passes}    Form fill    patient facesheet    mr=${Test Mr}
  Run Keyword And Ignore Error    Form fill    patient facesheet    keep my order=${true}    birth sex:radio=gender_male
  ...                             gender identity:dropdown=Birth Gender
  Update facesheet    ssn=777 77 7777    dob:js=10/07/1991    oto:checkbox=o    street address 1=123 KipuLane
  ...                 city=Miami    state:dropdown=Florida    zip=33154    payment method:radio=Insurance
  ...                 no allergy:checkbox=x
  # admission date:js=${date} 12:00 PM    mr=MR-2018-100
  ${first} =    Get Element Attribute    ${PATIENT FACESHEET FIRST NAME}    value
  ${middle} =    Get Element Attribute    ${PATIENT FACESHEET MIDDLE NAME}    value
  ${last} =    Get Element Attribute    ${PATIENT FACESHEET LAST NAME}    value
  Run Keyword Unless    ${add more}    Return to mainpage
  Return From Keyword    ${first}    ${middle}    ${last}

Default date to now
  [ARGUMENTS]    ${element}
  Click Element    ${element}
  Wait Until Element Is Visible    //button[@data-handler='today']
  Click Element    //button[@data-handler='today']
  Click Element    //button[@data-handler='hide']
  Wait Until Element Is Not Visible    //button[@data-handler='today']
  Slow wait

Form fill
  [ARGUMENTS]    ${form}    &{info}
  ${passes} =    Pop From Dictionary    ${info}    keep my order    ${false}
  ${keys} =    Run Keyword If    not ${passes}    Get Dictionary Keys    ${info}
               ...               ELSE             Keep info order    ${info}
  FOR    ${key}    IN    @{keys}
      ${input} =    Fetch From Right    ${key}    :
      ${k} =    Fetch From Left    ${key}    :
      ${k}    @{ex_i} =    Split String    ${k}    |
      Continue For Loop If    "${k}"=='${EMPTY}'
      ${field}    @{ex_f} =    Run Keyword If    'direct' in '${input}' or 'aria' in '${input}'    Split String    ${k}
                               ...                                                                 |
                               ...               ELSE                                              Split String
                               ...                                                                 ${${form} ${k}.replace('$CID','${Cid}')}
                               ...                                                                 |
      ${field} =    Zip extra ids into fields    ${field}    ${ex_i}    ${ex_f}
      Run Keyword If    'drop' in '${input}'          Select From List By Label    ${field}    &{info}[${key}]
      ...    ELSE IF    'check' in '${input}'         Run Keyword If    '&{info}[${key}]'=='x'    Select Checkbox
      ...                                                                                         ${field}
      ...                                                               ELSE                      Unselect Checkbox
      ...                                                                                         ${field}
      ...    ELSE IF    'radio' in '${input}'         Select Radio Button    ${field}    &{info}[${key}]
      ...    ELSE IF    'click' in '${input}'         Click Element    ${field}/small
      ...    ELSE IF    'aria' in '${input}'          Run Keyword If    '&{info}[${key}]'=='x'    Execute Javascript
      ...                                                                                         document.querySelector("${field}").className += " ui-state-active"
      ...                                                               ELSE                      Execute Javascript
      ...                                                                                         document.querySelector("${field}").className = document.querySelector("${field}").className.replace( /(?:^|\s)ui-state-active(?!\S)/g , '')
      ...    ELSE IF    'js' in '${input}'            Execute Javascript    $("#${field}").val("&{info}[${key}]")
      ...    ELSE IF    'attachment' in '${input}'    Choose File    ${field}    &{info}[${key}]
      ...    ELSE IF    'enter_text' in '${input}'    Run Keywords    Input Text    ${field}    &{info}[${key}]
      ...                                             AND             Slow wait
      ...                                             AND             Press Key    ${field}    \\13
      ...    ELSE IF    'quick_text' in '${input}'    Run Keywords    Input Text    ${field}    &{info}[${key}]
      ...                                             AND             Press Key    ${field}    \\13
      ...    ELSE IF    'focus_text' in '${input}'    Run Keywords    Input Text    ${field}    ${EMPTY}
      ...                                             AND             Slow wait
      ...                                             AND             Focus    ${field}
      ...                                             AND             Input Text    ${field}    &{info}[${key}]
      ...               ELSE                          Custom input or select fill    ${field}    &{info}[${key}]
      Run Keyword Unless    'quick_text' in '${input}'    Ajax wait
  END

Keep info order
  [ARGUMENTS]    ${info}
  ${od} =    Evaluate    sys.modules['robot.utils'].DotDict()    sys
  ${od} =    Copy Dictionary    ${info}
  Run Keyword And Return    Call Method    ${od}    keys

Zip extra ids into fields
  [ARGUMENTS]    ${field}    ${ex_i}    ${ex_f}    ${ex}=${EMPTY}
  FOR    ${i}    ${f}    IN ZIP    ${ex_i}    ${ex_f}
      ${ex} =    Set Variable   ${ex}${i}${f}
  END
  ${field} =    Run Keyword If    ${ex_i.__len__()}<${ex_f.__len__()}    Fail    Too many fields not enough ids
                ...    ELSE IF    ${ex_i.__len__()}>${ex_f.__len__()}    Set Variable    ${field}${ex}${ex_i[-1]}
                ...               ELSE                                   Set Variable    ${field}${ex}
  @{field} =    Split String    ${field}    **
  Run Keyword If    ${field.__len__()}==1                                   Return From Keyword    @{field}[0]
  ...    ELSE IF    ${field.__len__()}==2 and '@{field}[-1]'=='${EMPTY}'    Return From Keyword    @{field}[0]
  ...    ELSE IF    '@{field}[-1]'=='${EMPTY}'                              Remove From List    ${field}    -1
  FOR    ${index}    ${f}    IN ENUMERATE    @{field}
      Set List Value    ${field}    ${index}    contains(@id,'${f}')
  END
  ${field} =    Catenate    SEPARATOR=${SPACE}and${SPACE}    @{field}
  Return From Keyword    //*[${field}]

Custom input or select fill
  [ARGUMENTS]    ${field}    ${item}
  ${passes} =    Run Keyword And Return Status    Input Text    ${field}    ${item}
  Return From Keyword If    ${passes}
  Wait Until Keyword Succeeds    3x    5s    Blur element    ${field}
  ${passes} =    Run Keyword And Return Status    Input Text    ${field}    ${item}
  Return From Keyword If    ${passes}
  ${passes} =    Run Keyword And Return Status    Select From List By Label    ${field}    ${item}
  ${custom} =    Get Webelement    ${field}
  Run Keyword Unless    ${passes}    Run Keywords    Select From List By Label    ${field}
  ...                                                ${custom.find_element_by_css_selector('option:last-of-type').get_attribute('value')}
  ...                                AND             Finally do input otherwise select    ${field}    ${item}

Finally do input otherwise select
  [ARGUMENTS]    ${field}    ${item}
  Ajax wait
  ${passes} =    Run Keyword And Return Status    Input Text    ${field}    ${item}
  Run Keyword Unless    ${passes}    Select From List By Label    ${field}    ${item}

### May depreciate with new RF/Selenium upgrade
Blur element
  [ARGUMENTS]    ${element}
  ${w}    ${TRASH} =    Get Element Size    ${element}
  Run Keyword And Ignore Error    Click Element At Coordinates    ${element}    ${w * +0.52}    0
  Run Keyword And Ignore Error    Click Element At Coordinates    ${element}    ${w * -0.52}    0
  Slow wait

Capture empty label text
  [ARGUMENTS]    ${location}    @{search in}
  @{search} =    Create List
  FOR    ${group}    IN    @{search in}
      ${passes}    ${group} =    Run Keyword And Ignore Error    Get Webelements    ${group}
      ${search} =    Run Keyword If    '${passes}'=='PASS'    Combine Lists    ${search}    ${group}
                     ...               ELSE                   Set Variable    ${search}
  END
  FOR    ${item}    IN    @{search}
      ${passes} =    Run Keyword And Return Status    Should Be Equal As Strings    ${item.text.strip(' \t\n\r')}
      ...            ${location}
      Run Keyword And Return If    ${passes}    Set Variable    ${item.find_element_by_css_selector('input').get_attribute('id')}
  END
  Fail    Could not create mapping for locations!

Capture empty label list
  [ARGUMENTS]    ${locations}    @{search in}
  @{search} =    Create List
  FOR    ${group}    IN    @{search in}
      ${passes}    ${group} =    Run Keyword And Ignore Error    Get Webelements    ${group}
      ${search} =    Run Keyword If    '${passes}'=='PASS'    Combine Lists    ${search}    ${group}
                     ...               ELSE                   Set Variable    ${search}
  END
  @{located} =    Create List
  FOR    ${item}    IN    @{search}
      # Run Keyword If    (${item.text.strip(' \t\n\r')} in ${locations}) or ('${locations}'=='all')    Append To List
      # ...                                                                                             ${located}
      # ...                                                                                             ${item.find_element_by_css_selector('input').get_attribute('id')}
      Run Keyword If    '${locations}'=='all'    Append To List    ${located}
      ...                                        ${item.find_element_by_css_selector('input').get_attribute('id')}
  END
  Return From Keyword If    ${located}    ${located}
  Fail    Could not create mapping for locations!

Select location option for client settings
  [ARGUMENTS]    ${field id}    ${locations}=All Locations
  Click Element    //input[@id='${field id}']/following::a[1]
  Slow wait
  @{locations} =    Split String    ${locations}    ;
  ${location base} =    Set Variable    //input[@id='${field id}']/following::ul[@class='dropdown-menu']
  # [1]
  FOR    ${location}    IN    @{locations}
      Run Keyword If    '${location}'=='All Locations'    Select Checkbox    ${location base}/li/input
      ...               ELSE                              Select Checkbox    ${location base}//label[.='${location}']/preceding-sibling::input[1]
  END


Create dict for locations
  [ARGUMENTS]    ${locations}    ${empty search}=group_session_location_ids_
  @{locations} =    Split String    ${locations}    ;
  &{map} =    Create Dictionary
  :FOR    ${v}    IN    @{locations}
  \    ${passes}    ${k} =    Run Keyword And Ignore Error    Get Element Attribute    //input[contains(text(),'${v}')]
  \                           ...                             id
  \    ${passes}    ${k} =    Run Keyword If    '${passes}'=='PASS'    Set Variable    PASS    ${k}
  \                           ...               ELSE                   Run Keyword And Ignore Error
  \                           ...                                      Get Element Attribute
  \                           ...                                      //label[contains(text(),'${v}')]    for
  \    ${k} =    Run Keyword If    '${passes}'=='PASS'    Set Variable    ${k}
  \              ...               ELSE                   Capture empty label text    ${v}
  \              ...                                      //input['${empty search}']/ancestor::div[1]/div[@class='_25']
  \    Set To Dictionary    ${map}    ${k}:direct_check=x
  [RETURN]    &{map}

Collect type of links
  [ARGUMENTS]    ${tag}    ${attr}
  @{links}    Create List
  ${number of links} =    Get Element Count    ${tag}
  FOR    ${index}    IN RANGE    ${number of links}
      ${link} =    Get Element Attribute    xpath=(${tag})[${index+1}]    ${attr}
      Continue For Loop If    '${link}'=='None'
      ${method} =    Get Element Attribute    xpath=(${tag})[${index+1}]    data-method
      ${method} =    Set Variable If    '${method}'=='None'    get    ${method}
      @{tuple} =    Create List    ${link.replace('${BASE URL}','')}    ${method}    ${tag}
      Append To List    ${links}    ${tuple}
  END
  [RETURN]    ${links}

### Niche use
Line parser
  [ARGUMENTS]    ${name}    ${line}
  Log   ${name}
  ${name} =    Get Line    ${name}    ${line}
  ${name} =    Strip String    ${name}    characters=\t.
  ${name} =    Strip String    ${name}
  [RETURN]    ${name}

### Not in use
Lowercase all
  [ARGUMENTS]    ${list}
  :FOR    ${i}    ${l}    IN ENUMERATE    @{list}
  \    ${l} =    Convert To Lowercase    ${l}
  \    Set List Value    ${list}    ${i}    ${l}
  [RETURN]    ${list}

Patient selection by name
  [ARGUMENTS]    ${name}
  ${selection} =    Get Webelement    //div[@class='pbottom40']
  ${group} =    Run Keyword If    '${View Style}'=='tile'    Get Webelements    ${PATIENT ${View Style}}/a
                ...               ELSE                       Get Webelements    ${PATIENT ${View Style}}/td[1]/a
  ${index} =    Get Index From List    ${group}    ${selection.find_element_by_partial_link_text('${name}')}
  ${select} =    Get Webelement    ${PATIENT ${View Style}}\[${index+1}]
  [RETURN]    ${select}


### Refactor
I select patient "${index}"
  ${passes} =    Run Keyword And Return Status    Should Match Regexp    ${index}    \\d
  ${selection} =    Run Keyword If    ${passes}    Get Webelement    ${PATIENT ${View Style}}\[${index}]
                    ...               ELSE         Patient selection by name    ${index}
  Set Suite Variable    ${Selected name}    ${selection.${PATIENT ${View Style} NAME}}
  Set Suite Variable    ${Selected mr number}    ${selection.${PATIENT ${View Style} MR NUMBER}}
  Set Suite Variable    ${Selected test bed}    ${selection.${PATIENT ${View Style} BED}}
  Click Element    ${selection.find_element_by_css_selector('a')}
  Ajax wait
  Run Keyword And Ignore Error    Click Element    //html/body/div[10]/div[11]/div/button[1]

Travel "${speed}" to "${id}" patients "${tab}" page in "${location}"
  Return to mainpage
  Run Keyword Unless    '${location}'=='null'    I select the "${location}" location
  ${id} =    Set Variable If    '${id}'=='tester'    ${Test Id}
             ...                '${id}'=='current'   ${Current Id}
             ...                True                 ${id}
  Run Keyword If    '${speed}'=='fast'          Run Keywords    Go To    ${BASE URL}${PATIENTS}/${id}${Patient ${tab}}
  ...                                           AND             Parse current id    ${id}
  ...                                           AND             I am on the "${tab}" patient page
  ...                                           AND             Return From Keyword
  ...    ELSE IF    '${id}'=='${Test Id}'       I select patient "${Test First}"
  ...    ELSE IF    '${id}'=='${Current Id}'    Go To    ${BASE URL}${PATIENTS}/${id}${Patient Information}
  ...               ELSE                        Decide if patient "${id}"
  Parse current id
  # Run Keyword If    '${tab}'=='facesheet'      Click Link    Edit ${Patient Handle}
  Run Keyword If    '${tab}'=='facesheet'      I hit the "${Patient Handle}" view
  ...    ELSE IF    '${tab}'!='information'    I hit the "${tab}" patient tab

Decide if patient "${id}"
  ${passes} =    Run Keyword And Return Status    I select patient "${id}"
  Run Keyword Unless    ${passes}    Go To    ${BASE URL}${PATIENTS}/${id}${Patient Information}

Doctor "${type}" ordered by "${doctor}" via "${method}"
  ${order} =    Set Variable If    '${type}'=='medication'    add order medication
                ...                '${type}'=='action'        add order action
                ...                '${type}'=='dc'            add order dc
                ...                '${type}'=='change'        add order change
                ...                True                       add order
  ${passes} =    Run Keyword And Return Status    Click Element    //*[@id='${${order} ORDERED BY}']
  ${order} =    Set Variable If    ${passes}    ${order}    add orders
  Run Keyword And Ignore Error    I hit the "Review Orders" text
  ${passes} =    Run Keyword And Return Status    Page should have    ELEMENT|//select[@id='${${order} ORDERED BY}']
  ${passes} =    Run Keyword If    ${passes}    Run Keyword And Return Status    Form fill    ${order}
                 ...                            ordered by:dropdown=${doctor}
                 ...               ELSE         Run Keyword And Return Status    Form fill    ${order}
                 ...                            ordered by=${doctor}
  Run Keyword Unless    ${passes} or '${doctor}'=='null'    Form fill    ${order}    ordered by=${doctor}
  Run Keyword Unless    '${method}'=='null'    Form fill    ${order}    via:dropdown=${method}

Give a "${pass}" facesheet validation
  ${pass}    @{try once more} =    Split String    ${pass}    ;
  ${auto fail} =    Set Variable If    not ${try once more}    ${false}    ${true}
  Click Button    validate_fields
  Ajax wait
  ${passes} =    Run Keyword If    '${pass}'=='passing'    Run Keyword And Return Status    Wait Until Page Contains
                 ...                                       has validated
                 ...               ELSE                    Run Keyword And Return Status    Wait Until Page Contains
                 ...                                       Errors found
  ${passes} =    Run Keyword If    not ${passes} and '${pass}'=='passing'    Run Keyword And Return Status
                 ...                                                         Page should have    NOT|Errors found
                 ...    ELSE IF    not ${passes} and '${pass}'=='failing'    Run Keyword And Return Status
                 ...                                                         Page should have    NOT|has validated
                 ...               ELSE                                      Set Variable    ${true}
  Run Keyword And Return If    not ${passes} and ${auto fail}    Run Keyword And Ignore Error    Fail
  ...                                                            Incorrect ${pass} facesheet validation!
  ${mr recheck} =    Run Keyword And Return Status    Page should have    The MR Number of    is not unique
  Run Keyword Unless    ${passes}    Run Keywords    Reload Page
  ...                                AND             Scramble mr if "${mr recheck}"
  ...                                AND             Click Button    patient[auto_submit]
  ...                                AND             Ajax wait
  ...                                AND             Give a "${pass};try" facesheet validation

Scramble mr if "${recheck}"
  Return From Keyword If    not ${recheck}
  ${mr} =    Get Value    ${PATIENT FACESHEET MR}
  ${mr} =    Generate Random String    15    ${mr}
  Form fill    patient facesheet    mr=${mr}

I select the "${location}" location
  Return From Keyword If    not ${_LOCATIONS ACTIVE}
  ${passes} =    Run Keyword And Return Status    Page Should Contain Element
  ...            //form[@id='switch_my_location']/div[@class='selectContainer']/ul[@class='locationSelect']
  Run Keyword And Return If    ${passes}    Wait Until Keyword Succeeds    3x    5s
  ...                                       New location dropdown at "${location}"
  ${passes} =    Run Keyword And Return Status    Page Should Contain Element    client_selected_location
  Run Keyword If    ${passes}    Select From List By Label    client_selected_location    ${location}
  ...               ELSE         Select From List By Label    user_selected_location    ${location}
  Ajax wait
  ${passes} =    Run Keyword And Return Status    Element Should Contain    //option[@value='0']    ${location}
  Run Keyword Unless    ${passes}    Element Should Contain    //option[@selected='selected']    ${location}
  Set patient handle

New location dropdown at "${location}"
  ${current location} =    Set Variable    //form[@id='switch_my_location']/div[@class='currentValue']//div[@class='location']
  ${passes} =    Run Keyword And Return Status    Element Should Contain    ${current location}    ${location}
  Run Keyword And Return If    ${passes}    Set patient handle
  Click Element    switch_my_location
  Wait Until Element Is Visible    //ul[@class='locationSelect']//div[.='${location}']
  Slow wait
  Custom screenshot
  Click Element    //ul[@class='locationSelect']//div[.='${location}']
  Ajax wait
  ${passes} =    Run Keyword And Return Status    Element Should Contain    ${current location}    ${location}
  Run Keyword If    ${passes}    Set patient handle
  ...               ELSE         Run Keywords    Reload Page
  ...                            AND             Fail    Location select failed!
  # Element Should Contain    //form[@id='switch_my_location']/div[@class='currentValue']//div[@class='location']
  # ...                       ${location}
  # Set patient handle

### Niche use
Calendar select day "${day}"
  Ajax wait
  Click Element    //table[@class='ui-datepicker-calendar']/tbody//a[.='${day.lstrip('0')}']
  Slow wait

Toggle to "${view}" view
  Run Keyword Unless    '${View Style}'=='${view}'    Run Keywords    Toggle view
  ...                                                                 Figure out what view style I am in

Turning "${switches}" the "${roles}" roles for "${user}"
  @{switches} =    Split String    ${switches}    ;
  @{roles} =    Split String    ${roles}    ;
  Run Keyword If    '${user}'!='deletion'    Return to mainpage
  Run Keyword If    '${user}'=='admin'       I hit the "username" tab
  ...    ELSE IF    '${user}'=='deletion'    Run Keywords    Click Link    Edit
  ...                                        AND             Run Keyword And Ignore Error    Form fill    new user
  ...                                                        access all locations:checkbox=x
  ...               ELSE                     Run Keywords    I hit the "Users" view
  ...                                        AND             Set user search    ${user.split(';')[0]}
  ...                                                        ${user.split(';')[1]}    ${Find User}    ${Find Pass}
  ...                                        AND             The user is "in" the system
  ...                                        AND             Click Link    Edit
  FOR    ${switch}    ${role}    IN ZIP    ${switches}    ${roles}
      ${passes}    ${label} =    Run Keyword And Ignore Error    Capture empty label text    ${role}
                                 ...                             //li[starts-with(@id,'role_')]/label
                                 ...                             //input[starts-with(@id,'user_role_ids_')]/parent::label[1]
      ${role} =    Set Variable If    '${passes}'=='PASS'    ${label}    ${role}
      Run Keyword If    '${switch}'=='on'     Form fill    ${EMPTY}    ${role}:direct_check=x
      ...    ELSE IF    '${switch}'=='off'    Form fill    ${EMPTY}    ${role}:direct_check=o
      ...               ELSE                  Form fill    new user    ${role}=${switch}
      # ...               ELSE                  Form fill    new user    ${role}:dropdown=${switch}
  END
  Click Button    Update
  Verify for no bad page
  Wait Until Page Contains    Notice
  Run Keyword If    '${user}'!='deletion'    Return to mainpage

The "${option}" filter will work
  ${program} =    Retrieve "${option}" from color map
  ${color} =    Get From Dictionary    ${Color Map}    ${program}
  @{selections} =    Get Webelements    ${PATIENT ${View Style}}
  :FOR    ${selection}    IN    @{selections}
  \    ${style} =    Set Variable    ${selection.find_element_by_css_selector('a>div').get_attribute('style')}
  \    ${style} =    RGB To Hex    ${style}
  \    Should Contain    ${style}    ${color}

I hit the "${option}" program view
  ${program} =    Retrieve "${option}" from color map
  I hit the "${program}" view

Retrieve "${option}" from color map
  ${programs} =    Get Dictionary Keys    ${Color Map}
  ${program} =    Evaluate    [i for i, p in enumerate(${programs}) if '${option}' in p][0]
  Run Keyword And Return    Get From List    ${programs}    ${program}

The user is "${present}" the system
  ${user tab} =    Log Location
  ${user tab} =    Remove String    ${user tab}    ${BASE URL}${USERS}    ?    =true
  Input Text    q    ${Find Last}, ${Find First}
  Click Element    //button[@type='submit']
  Run Keyword And Ignore Error    Click Link    ${Find Last.title()[0]}
  ${passes} =    Run Keyword And Return Status    Page Should Contain Link    Delete
  ${ver} =    Set Variable If    ${passes}    ${1}    ${2}
  ${passes} =    Run Keyword And Return Status    Page should have    ${Find Last}, ${Find First}
  Run Keyword If    ${passes} and (${ver}==1 or '${user tab}'!='disabled')
  ...                                                  Run Keyword If    '${present}'=='out'    Fail    User is still in the system!
  ...    ELSE IF    '${user tab}'=='${EMPTY}'          Run Keywords    I hit the "Locked Users" view
  ...                                                                  The user is "${present}" the system
  ...    ELSE IF    '${user tab}'=='locked'            Run Keywords    I hit the "Disabled Users" view
  ...                                                                  The user is "${present}" the system
  ...    ELSE IF    ${ver}==2 and '${present}'=='out' and not ${passes}
  ...                                                  Fail    User is missing from the system!
  ...    ELSE IF    ${ver}==2 and '${present}'=='in'   Fail    User is either disable or not in the system!
  ...    ELSE IF    '${present}'=='in'                 Fail    User is not in the system!

Searching for "${name}"
  Input Text    term_form    ${name}
  Click Button    search

Bypass edit the "${session}" session
  ${passes} =    Run Keyword And Return Status    Click Element
  ...            //a[contains(text(),'${session}')]/../following-sibling::td[last()]/a[2]
  Run Keyword Unless    ${passes}    I hit the "${session}" view

The "${session}" session is in "${type}" group sessions
  ${type} =    Set Variable If    '${type}'=='upcoming'    /start_group_session
               ...                '${type}'=='progress'    /group_session_leaders
               # ...                True                     /review
  Page Should Contain Element    //a[contains(text(),'${session}') and contains(@href,'${type}')]

Return "${session}" to upcoming group sessions
  Dialog Action    Click Element    //a[contains(text(),'${session}')]/../following-sibling::td[last()]/a[1]
  Set Suite Variable    ${Current leader}    ${Admin First} ${Admin Last}
  The "${session}" session is in "upcoming" group sessions

Editing "${template}" test template
  ${formatted} =    Replace String    ${template}    ${SPACE}    _
  Click Link    /${formatted}/${Template Id}/edit

Save "${template}" template
  ${formatted} =    Replace String    ${template}    ${SPACE}    _
  Click Element    //input[@type='submit']
  Ajax wait
  Run Keyword If    '${template}'=='consent forms'       Click Element    ${formatted}
  ...    ELSE IF    '${template}'=='group sessions 2'    Click Link    /gs/${formatted.replace('_2','')}
  ...               ELSE                                 Click Link    /${formatted}

### Not in much use
There are "${number}" patients
  Page should have    ELEMENT|${number}x|//div[@class='pbottom40']/div[@class='left']

### Not in use
Return back slowly by "${time}" seconds
  Go Back
  Sleep    ${time}


Instance edit "${action}" on "${dom}"
  ${dom}    @{type} =    Split String    ${dom}    :    1
  ${type} =    Set Variable If    ${type}    @{type}[0]    checkbox
  ${dom} =    Set Variable If    '${type}'!='radio'    //*[contains(text(),'${dom}')]/ancestor::tr/td[2]//
              ...                True
  ${input} =    Set Variable If    '${type}'=='dropdown'    select    input
  ${dom} =    Set Variable If    '${input}'=='select'    ${dom}${input}
              ...                '${type}'=='radio'      ${dom}${input}\[@name='kipu_labs_lab_client_settings[use_label_printer]']
              ...                True                    ${dom}${input}\[@type='${type}']
  ${orig} =    Run Keyword If    '${type}'=='text'        Get Value    ${dom}
               ...    ELSE IF    '${type}'=='dropdown'    Get Text    ${dom}/option[@selected='selected']
               ...    ELSE IF    '${type}'=='radio'       null
               ...               ELSE                     Run Keyword And Return Status    Checkbox Should Be Selected
               ...                                        ${dom}
  ${orig} =    Set Variable If    '${orig}'=='True'    x
               ...                not '${orig}'        o
               ...                True                 ${orig}
  @{action} =    Split String    ${action}    :
  Insert Into List    ${action}    1    ${dom}
  Run Keyword    @{action}
  [RETURN]    ${orig}
