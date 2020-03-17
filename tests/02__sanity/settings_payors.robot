*** Settings ***
Documentation   Add a Payor
...             1. In Settings – Instance = Click the checkbox corresponding to Kipu Insurance Services. (This will generate a "blue" tab under Settings, next to the Instance tab.)
...             2. Click on the "Payors" tab to enter:
...             a. Payor Shortcode – a unique code you assign to an insurance company
...             b. Payor Synonym – The full insurance name
...             The Payor Name and Kipu Insurance ID will automatically generate in your Kipu Instance
...
Default Tags    sanity    sa014    points-1    settings story    addmore
Resource        ../../suite.robot
Suite Setup     Run Keywords    I hit the "settings" tab
...                             I hit the "Payors" view
Suite Teardown  Return to mainpage

*** Test Cases ***
Add a Payor
  Given I am on the "payors" page
  When I add a new payor
  And travel "fast" to "tester" patients "information" page in "${_LOCATION 1}"
  And I hit the "Edit ${Patient Handle}" view
  Then payor will show up in the insurance field
  # And new payor will have data generated
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Remove our payors

*** Keywords ***
I add a new payor
  Set Test Variable    ${T}    1
  Loop deletion    Leftover payors    sushi    ${EMPTY}
  Click Link    Add item
  Ajax wait
  Input Text    //form[@action='/payers/update_payers']//tr[last()]/td[1]/input    sushi
  Input Text    //form[@action='/payers/update_payers']//tr[last()]/td[2]/input    Chocolate Car Insurance
  Click Button    Update
  Ajax wait
  Page Should Not Contain    Errors found

Payor will show up in the insurance field
  Click Link    Add insurance
  Ajax wait
  Input Text    //div[@id='insurance']/div[@class='fields'][last()]/div/div[1]/input[1]    sushi
  Wait Until Element Is Visible    //font[contains(text(),'Chocolate Car Insurance')]
  Press Key    //div[@id='insurance']/div[@class='fields'][last()]/div/div[1]/input[1]    \\9
  ${passes} =    Run Keyword And Return Status    Get Alert Message    False
  Run Keyword If    ${passes}    Dialog action    No Operation
  Click Element    //a[contains(text(),'Delete Insurance')][last()]
  Ajax wait
  Wait Until Element Is Not Visible    //label[starts-with(@for,'patient_insurances_attributes_') and contains(@for,'_insurance_company')]
  Give a "passing" facesheet validation

New payor will have data generated
  Go To    ${BASE URL}${PAYORS}
  Do search in    //input[@value='sushi' and contains(@id,'synonym')]/ancestor::tr/td[position()!=last()]
  ...             find_element_by_tag_name('input').get_attribute('value')

Leftover payors
  [ARGUMENTS]    @{inputs}
  Page Should Contain Element    //form[@action='/payers/update_payers']//tr[position()>${T}]
  @{rows} =    Get Webelements    //form[@action='/payers/update_payers']//tr[position()>${T}]
  :FOR    ${row}    IN    @{rows}
  \    Log    ${row.get_attribute('innerHTML')}
  \    ${blank} =    Set Variable    ${row.find_element_by_css_selector('td:first-child>input').get_attribute('value')}
  \    ${passes} =    Run Keyword And Return Status    Should Contain Match    ${inputs}    ${blank}
  \    Run Keyword If    ${passes}    Run Keywords    Dialog action    Click Element
  \    ...                                            ${row.find_element_by_css_selector('td:last-child>a')}
  \    ...                            AND             Set Test Variable    ${T}    2
  \    ...                            AND             Return From Keyword
  Fail    No deletion!

Remove our payors
  Go To    ${BASE URL}${PAYORS}
  Set Test Variable    ${T}    1
  Loop deletion    Leftover payors    sushi
