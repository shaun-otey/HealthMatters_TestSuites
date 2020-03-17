*** Settings ***
Documentation   Basic functionality of creating doctor orders (standard and manual).
...
Default Tags    regression    re013    points-14    patient chart story
Resource        ../../suite.robot
Suite Setup     Travel "fast" to "tester" patients "medical orders" page in "${_LOCATION 1}"
Suite Teardown  Return to mainpage
Test Teardown   Run Keywords    Run Keyword If Test Failed    Custom screenshot
...             AND             Travel "fast" to "current" patients "medical orders" page in "null"
...             AND             Loop deletion    Remove any orders
...             AND             I hit the "medical orders" patient tab

*** Test Cases ***
Create orders from standard order
  Given I am on the "medical orders" patient page
  When creating standard orders
  Then confirm the orders show up    ${false}

Create order from manual medication order
  Given I am on the "medical orders" patient page
  When creating a manual medication order
  Then confirm the orders show up

Create order from manual action order
  Given I am on the "medical orders" patient page
  When creating a manual action order
  Then confirm the orders show up

Create a manual order and change its modal and date
  Given I am on the "medical orders" patient page
  When creating a soon to change medication order
  Then confirm the orders show up
  # fix orders for meds2
  And page should have    ELEMENT|//a[@class='change_order']
  When modifying the order
  Then I am on the "medical orders" patient page
  And page should have    STOP: @{Orders}[0]    Aspirin 500mg, oral every hour until further notice
  When modifying the orders date

Create a manual order without a route
  Given I am on the "medical orders" patient page
  When create a doctor order    medication    route=${EMPTY}
  Then page should have    Please complete the required fields.

Create a bulk order and verify that they are in order by default
  Given I am on the "medical orders" patient page
  When creating a bulk order
  Then bulk orders are in the correct order

Create a standard order with a half amount dispense
  Given I am on the "medical orders" patient page
  When creating a half dispensed order
  Then confirm the orders show up

Create a standard order with a quantity of one
  Given I am on the "medical orders" patient page
  When creating a "standard" order with a quantity of "1"
  Then confirm the order rounds the quantity "correctly" with "no trailing" zeroes

Create a standard order with a one tenth quantity
  Given I am on the "medical orders" patient page
  When creating a "standard" order with a quantity of "0.1"
  Then confirm the order rounds the quantity "correctly" with "leading" zeroes

Create a prn order with a quantity of one
  Given I am on the "medical orders" patient page
  When creating a "prn" order with a quantity of "1"
  Then confirm the order rounds the quantity "correctly" with "no trailing" zeroes

Create a prn order with a one tenth quantity
  Given I am on the "medical orders" patient page
  When creating a "prn" order with a quantity of "0.1"
  Then confirm the order rounds the quantity "correctly" with "leading" zeroes

Create a standard order that rounds to a quantity of one
  Given I am on the "medical orders" patient page
  When creating a "standard" order with a quantity of "1.0"
  Then confirm the order rounds the quantity "incorrectly" with "no trailing" zeroes

Create a standard order that leads with a zero with a one tenth quantity
  Given I am on the "medical orders" patient page
  When creating a "standard" order with a quantity of ".1"
  Then confirm the order rounds the quantity "incorrectly" with "leading" zeroes

Create a prn order that rounds to a quantity of one
  Given I am on the "medical orders" patient page
  When creating a "prn" order with a quantity of "1.0"
  Then confirm the order rounds the quantity "incorrectly" with "no trailing" zeroes

Create a prn order that leads with a zero with a one tenth quantity
  Given I am on the "medical orders" patient page
  When creating a "prn" order with a quantity of ".1"
  Then confirm the order rounds the quantity "incorrectly" with "leading" zeroes

Create a three day order
  [TAGS]    testmedev
  Given I am on the "medical orders" patient page
  When creating a long medication order
  Then page should have    @{Orders}
  When I hit the "@{Orders}[0]" text
  Then page should have    @{Orders}    ${Full length}
  And Go Back
  When I hit the "med log" patient tab
  Then page should have    ${Short order}
  # When Click Link    //a/span[${CSS SELECT.replace('$CSS','fa-arrow-left')}]
  Click Element    //*[@id="sub_nav_content"]/h2/a[1]
  Then page should have    ${Short order}
  And I hit the "med log" patient tab
  # When Click Link    //a/span[${CSS SELECT.replace('$CSS','fa-arrow-right')}]
  Click Element    //*[@id="sub_nav_content"]/h2/a[2]
  Then page should have    ${Short order}
  And I hit the "med log" patient tab
  When I hit the "Med Pass" text
  Then get final date on med pass

Create a custom order with no frequency and edit it
  [SETUP]    Run Keywords    Go To    ${BASE URL}${TEMPLATES ORDERS}
  ...        AND             Make a custom order
  ...        AND             Travel "fast" to "current" patients "medical orders" page in "${_LOCATION 1}"
  Given I am on the "medical orders" patient page
  When creating an order that has no frequency
  Then confirm the orders show up    ${false}
  And Page Should Have    AAAyyyy lmao
  When modifying the orders frequency
  Then Page Should Have    AAAyyyy lmao, once

Doctor will sign all unreviewed orders
  [SETUP]    Run Keywords    Set Test Variable    ${Admin first original}    ${Admin First}
  ...        AND             Set Test Variable    ${Admin last original}    ${Admin First}
  ...        AND             Create a new user
  ...        AND             Travel "fast" to "current" patients "medical orders" page in "null"
  ...        AND             Creating a bulk order
  ...        AND             Turning "on" the "Doctor" roles for "${Find First};${Find Last}"
  ...        AND             Exit system    ${false}
  ...        AND             Start login    ${Find User}    ${Find Pass}
  ...        AND             Travel "slow" to "current" patients "medical orders" page in "${_LOCATION 1}"
  Given I am on the "medical orders" patient page
  When perform signature    I hit the "Sign Orders" text
  Then confirm all orders everywhere are signed
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Exit system    ${false}
  ...           AND             Start login    ${CURRENT USER}    ${CURRENT PASS}
  ...           AND             Delete the new user
  ...           AND             Travel "fast" to "current" patients "medical orders" page in "null"
  ...           AND             Loop deletion    Remove any orders
  ...           AND             I hit the "medical orders" patient tab

  # [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  # ...           AND             Delete tester template    orders
  # ...           AND             Travel "fast" to "current" patients "medical orders" page in "null"
  # ...           AND             Loop deletion    Remove any orders
  # ...           AND             I hit the "medical orders" patient tab

Show all orders
  [SETUP]    Creating all types of orders
  Given I am on the "medical orders" patient page
  When I hit the "Show all orders" text
  Then confirm the orders show up    ${false}

Discontinue orders
  [SETUP]    Creating a manual medication order
  Given I am on the "medical orders" patient page
  When I hit the "Discontinue orders" text
  Then discontinuing the order will stop it    QA Doc    fax

Discontinue orders wih a doctor
  [SETUP]    Run Keywords    Set Test Variable    ${Admin first original}    ${Admin First}
  ...        AND             Set Test Variable    ${Admin last original}    ${Admin First}
  ...        AND             Create a new user
  ...        AND             Travel "fast" to "current" patients "medical orders" page in "null"
  ...        AND             Creating a manual medication order
  ...        AND             Turning "on" the "Doctor" roles for "${Find First};${Find Last}"
  ...        AND             Exit system    ${false}
  ...        AND             Start login    ${Find User}    ${Find Pass}
  ...        AND             Travel "slow" to "current" patients "medical orders" page in "${_LOCATION 1}"
  Given I am on the "medical orders" patient page
  And confirm the order everywhere with pending values are correct
  And I hit the "Show current orders" text
  When I hit the "Discontinue orders" text
  And discontinuing the order will stop it
  Then confirm the order everywhere with discontinue values are correct
  When I hit the "Show current orders" text
  And I hit the "@{Orders}[0]" text
  Then page should have    Ordered by QA Doc    Entered by ${Admin First} ${Admin Last}
  ...                      Discontinued Ordered by ${Find First} ${Find Last}
  ...                      Discontinued Entered by ${Find First} ${Find Last}
  When perform signature    I hit the "Review Signature" text
  And I hit the "Medical Orders" text
  And Run Keyword And Ignore Error    I hit the "Show all orders" text
  Then page should have    Discontinued Ordered by ${Find First} ${Find Last}    Signed by ${Find First} ${Find Last}
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Exit system    ${false}
  ...           AND             Start login    ${CURRENT USER}    ${CURRENT PASS}
  ...           AND             Delete the new user
  ...           AND             Travel "fast" to "current" patients "medical orders" page in "null"
  ...           AND             Loop deletion    Remove any orders
  ...           AND             I hit the "medical orders" patient tab


Stop mars generation and create orders that will not show
  [SETUP]    Turn off mars generation
  Given I am on the "medical orders" patient page
  When creating all types of orders
  Then confirm the orders do not show up in the med log
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Turn on mars generation
  ...           AND             Travel "fast" to "current" patients "medical orders" page in "null"
  ...           AND             Loop deletion    Remove any orders
  ...           AND             I hit the "medical orders" patient tab

Discharge a patient thus stopping medications
  [SETUP]    Run Keywords    Return to mainpage
  ...        AND             I select the "${_LOCATION 1}" location
  ...        AND             I create a valid patient    Mongolian    shrimp    tax    04/20/2018
  Given travel "slow" to "current" patients "medical orders" page in "null"
  When creating a manual medication order
  And I hit the "med log" patient tab
  And I am on the "med log" patient page
  Then confirm the orders show up without duration
  When travel "slow" to "current" patients "discharge transfer" page in "null"
  And with this form "Inpatient Tx Discharge Summary" perform these actions "add;edit"
  And discharge the patient
  Then confirm the orders do not show up in the med log
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Remove this patient    Mongolian shrimp tax
  ...           AND             Travel "fast" to "tester" patients "medical orders" page in "null"

# View vitals, glucose, weight

# Send orders to pharmacy

Click scroll to top
  Given I am on the "medical orders" patient page
  When scrolling down
  And I hit the "top" tab
  Then Location Should Contain    \#

*** Keywords ***
Check that testing is done in meds "${version}"
  ${passes} =    Run Keyword And Return Status    Page should have    Custom Order
  ${ver} =    Set Variable If    ${passes}    2    1
  Pass Execution If    '${version}'!='${ver}'    Test case only available for Meds${version}.0!

Creating standard orders
  ${passes} =    Run Keyword And Return Status    I hit the "Add standard order" text
  Run Keyword Unless    ${passes}    I hit the "Quick Order" text
  I hit the "Taper" text
  ${tapers} =    Hit order and store text    Taper
  I hit the prns text
  ${prns} =    Hit order and store text    PRN
  I hit either the other or standard text
  ${others} =    Hit order and store text    Standard
  Doctor "add" ordered by "QA Doc" via "fax"
  Click Element    //span[.='Submit']
  Save the orders    ${tapers}    ${prns}    ${others}

Creating a manual medication order
  ${orders} =    Create a doctor order    medication
  Save the orders    ${orders}

Creating a manual action order
  ${orders} =    Create a doctor order    action
  Save the orders    ${orders}

Creating a soon to change medication order
  ${orders} =    Create a doctor order    medication    meds=Aspirin    route=oral    form=tablet    dose=500mg    dur=3
                 ...                      freq=every hour
  Save the orders    ${orders}

Creating all types of orders
  Creating standard orders
  ${med} =    Create a doctor order    medication
  ${med prn} =    Create a doctor order    medication    meds=Drug with P    prn=x
  ${action} =    Create a doctor order    action
  ${action prn} =    Create a doctor order    action    meds=Slam with P    prn=x
  Append To List    ${Orders}    ${med}    ${med prn}    ${action}    ${action prn}

Creating a bulk order
  ${passes} =    Run Keyword And Return Status    I hit the "Add standard order" text
  Run Keyword Unless    ${passes}    I hit the "Quick Order" text
  I hit the "PRNs" text
  Click Element    //div[@id='dialog-modal-orders-addorder']//tr[@class='orders_prn'][1]//button[contains(@onclick,'selectAllOrders')]
  Doctor "add" ordered by "QA Doc" via "fax"
  Click Element    //span[.='Submit']

Creating a half dispensed order
  ${orders} =    Create a doctor order    medication    meds=Advil Allergy & Congestion    route=oral    form=tablet
                 ...                      just=test    dur=3    freq=every 2 hours    dose=4-10-200mg    quantity=0.5
                 ...                      dispense=5.5
  Save the orders    ${orders}

Creating a long medication order
  ${date} =    Convert Date    ${Todays Date}    %m/%d/%Y
  ${start date} =    Subtract Time From Date    ${date}    1d    %m/%d/%Y    False    %m/%d/%Y
  ${end date} =    Add Time To Date    ${date}    1d    %m/%d/%Y    False    %m/%d/%Y
  ${orders} =    Create a doctor order    medication    ${start date}    dur=3    freq=every hour
  Set Test Variable    ${Short order}    ${orders.split(',')[0]}
  Save the orders    ${orders}
  Set Test Variable    ${Start date}    ${start date}
  Set Test Variable    ${Full length}
  ...                  Duration: 3 days, start date: ${start date} 12:00 AM, end date: ${end date} 11:59 PM

Creating an order that has no frequency
  ${passes} =    Run Keyword And Return Status    I hit the "Add standard order" text
  Run Keyword Unless    ${passes}    I hit the "Quick Order" text
  I hit either the other or standard text
  ${others} =    Hit order and store text    Standard
  Doctor "add" ordered by "QA Doc" via "fax"
  Click Element    //span[.='Submit']
  Save the orders    ${others}

Creating a "${type}" order with a quantity of "${amount}"
  ${prn} =    Set Variable If    '${type}'=='standard'    o    x
  ${orders} =    Create a doctor order    medication    prn=${prn}    quantity=${amount}
  Save the orders    ${orders}

Save the orders
  [ARGUMENTS]    @{orders}
  @{orders} =    Create List    @{orders}
  Set Test Variable    ${Orders}    ${orders}

Make a custom order
  Create tester template    orders    AAAyyyy lmao
  Editing "orders" test template
  Run Keyword If    ${_LOCATIONS ACTIVE}    Form fill    orders form    all locations:checkbox=x
  I hit the "Add item" view
  Form fill    orders form    keep my order=${true}    dosage type:radio=0    medication=Ultra Nap
  ...          frequency:dropdown=no frequency/no mar    order enabled:checkbox=x    enabled:checkbox=x
  Save "orders" template

Make a custom prn
  Create tester template    orders    Plus two
  Editing "orders" test template
  Run Keyword If    ${_LOCATIONS ACTIVE}    Form fill    orders form    all locations:checkbox=x
  I hit the "Add item" view
  Form fill    orders form    keep my order=${true}    dosage type:radio=0    medication=Advil    route:dropdown=oral
  ...          dosage form:dropdown=tablet    dose:dropdown=200mg    frequency:dropdown=once a day, at bedtime
  ...          order enabled:checkbox=x    prn:checkbox=x    enabled:checkbox=x
  Save "orders" template

Modifying the order
  ${start date} =    Get Text    //div[@id='sub_nav_content']/table/tbody/tr[2]/td[2]/div
  ${start date} =    Line parser    ${start date.strip('\rStart:')}    0
  Set Test Variable    ${Start date}    ${start date}
  Basic change order check
  Form fill    add order change    duration days=${EMPTY}
  Doctor "change" ordered by "QA Doc" via "fax"
  Click Element    //button[.='Submit']
  Ajax wait

Modifying the orders date
  ${next date} =    Add Time To Date    ${Todays Date}    7 days    result_format=%m/%d/%Y
  ${next day} =    Set Variable    ${next date.split('/')[1]}
  Basic change order check
  Click Element    //input[@id='${ADD ORDER MEDICATION START DATE}']
  Run Keyword If    ${Todays Date.rsplit('-',1)[-1]} > ${next day}    Click Element
  ...                                                                 //span[@class='ui-icon ui-icon-circle-triangle-e']
  Calendar select day "${next day}"
  Click Element    //button[@data-handler='hide']
  Ajax wait
  Doctor "change" ordered by "QA Doc" via "fax"
  Click Element    //button[.='Submit']
  Ajax wait
  Basic change order check
  Page should have    ELEMENT|//*[@id='${ADD ORDER MEDICATION START DATE}' and contains(@value,'${next date}')]
  Click Element    //button[.='Cancel']

Modifying the orders frequency
  Basic change order check
  Form fill    add order change    frequency:dropdown=once
  Doctor "change" ordered by "QA Doc" via "fax"
  Click Element    //button[.='Submit']
  Ajax wait

Basic change order check
  Click Element    //a[@class='change_order']
  Ajax wait
  Element Text Should Be    patient_order_patient_order_item_medication    Aspirin
  Element Should Contain    change-order-mar-history    No history exists
  Page should have    ELEMENT|change-order-history
  ...                 ELEMENT|//*[@id='change-order-patient-order-history']/table//th[contains(text(),'Name')]
  ...                 ELEMENT|//*[@id='change-order-patient-order-history']/table//th[contains(text(),'Start Date')]
  ...                 ELEMENT|//*[@id='change-order-patient-order-history']/table//td[contains(text(),'${Start date.split()[0]}')]
  # Page Should Contain Element    //*[@id='change-order-patient-order-history']/table//td[contains(text(),'${Start date.split()[1]}')]
  ...                 ELEMENT|//*[@id='change-order-patient-order-history']/table//a[contains(text(),'@{Orders}[0]')]

I hit the prns text
  ${passes} =    Run Keyword And Return Status    I hit the "PRNs" text
  Run Keyword Unless    ${passes}    I hit the "PRN" text

I hit either the other or standard text
  ${passes} =    Run Keyword And Return Status    I hit the "Other" text
  Run Keyword Unless    ${passes}    I hit the "Standard" text

Hit order and store text
  [ARGUMENTS]    ${order}
  # ${passes 1} =    Run Keyword And Return Status    Page Should Contain Element    //div[@id='popup_form_tab_prn']
  # ${passes 2} =    Run Keyword And Return Status    Page Should Contain Element    //div[@id='popup_form_tab_other']
  # ${order} =    Run Keyword If    ${passes 1} and '${order}'=='PRN'         Set Variable    prns
  #               ...    ELSE IF    ${passes 2} and '${order}'=='Standard'    Set Variable    other
  #               ...               ELSE                                      Set Variable    ${order}
  ${passes} =    Run Keyword And Return Status    Page should have    ELEMENT|//div[@id='popup_form_tab_other']
  ${order} =    Run Keyword If    ${passes} and '${order}'=='Standard'    Set Variable    other
                ...               ELSE                                    Set Variable    ${order}
  ${order box type} =    Set Variable    //div[@id='dialog-modal-orders-addorder']//tr[@class='orders_${order.lower()}'][2]/td[2]
  ${order box name} =    Set Variable    //div[@id='dialog-modal-orders-addorder']//span[@class='ui-button-text' and .='${order}']
  ${passes 1} =    Run Keyword And Return Status    Click Element    ${order box type}
  ${passes 2} =    Run Keyword And Return Status    Click Element    ${order box name}
  ${text or order} =    Run Keyword If    ${passes 1}    Get Text    ${order box type}//span
                        ...    ELSE IF    ${passes 2}    Set Variable    ${order}
                        ...               ELSE           Set Variable
                        ...                              //b[.='${order}']/ancestor::tr[1]/following-sibling::tr[1]/td
  Run Keyword Unless    ${passes 1} or ${passes 2}    Click Element    ${text or order}
  ${text} =    Run Keyword If    ${passes 1} or ${passes 2}    Set Variable    ${text or order}
               ...               ELSE                          Get Text    ${text or order}
  [RETURN]    ${text.strip(' \t\n\r')}

Confirm the orders show up
  [ARGUMENTS]    ${confirm notes}=${true}
  Custom screenshot
  Page should have    @{Orders}
  Return From Keyword If    not ${confirm notes}
  FOR    ${order}    IN    @{Orders}
      I hit the "${order}" text
      Page should have    testing my meds on this man
      Go Back
  END
  Return From Keyword If    '${TEST NAME}'=='Create order from manual action order'
   # or '${TEST NAME}'=='Create a custom order with no frequency and edit it'
  I hit the "med log" patient tab
  Confirm the order notes show up in mars
  Go Back

Confirm the orders show up without duration
  FOR    ${index}    ${order}    IN ENUMERATE    @{Orders}
      Set List Value    ${orders}    ${index}    ${order.replace(',','').split(' every')[0]}
  END
  Set Test Variable    ${Orders}    ${orders}
  Page should have    @{Orders}
  Confirm the order notes show up in mars

Confirm the order notes show up in mars
  @{notes} =    Get Webelements    //table[${CSS SELECT.replace('$CSS','mar_medications_table_headers')}]/tbody/tr[contains(@id,'_patient_order_note')]
  FOR    ${note}    IN    @{notes}
      Run Keyword And Continue On Failure    Should Contain    ${note.get_attribute('innerHTML')}
      ...                                    testing my meds on this man
  END


Confirm all orders everywhere are signed
  ${date} =    Convert Date    ${Todays Date}    result_format=%m/%d/%Y
  ${table} =    Set Variable    //table[@class='grid_index']/tbody/tr[@id]
  @{list orders} =    Get Webelements    ${table}/td[1]/div/a
  FOR    ${index}    ${order}    IN ENUMERATE    @{list orders}
      Set List Value    ${list orders}    ${index}    ${order.get_attribute('innerHTML').split('<')[0]}
  END
  FOR    ${index}    ${order}    IN ENUMERATE    @{list orders}
      ${position} =    Set Variable    ${index+1}
      Page should have    ELEMENT|${table}\[${position}]/td[3]/ul/li[contains(text(),'Ordered by QA Doc')]
      ...                 ELEMENT|${table}\[${position}]/td[3]/ul/li[contains(text(),'Signed by ${Find First} ${Find Last}')]
      ...                 ELEMENT|${table}\[${position}]/td[3]/ul/li[contains(.,'${date}')]
      Click Element    ${table}\[${position}]//a
      Ajax wait
      Page should have    Entered by ${Admin first original} ${Admin last original}    Ordered by QA Doc    ${date}
      ...                 ${order}    ELEMENT|//img[@alt='signature']
      ...                 ELEMENT|//span[@class='border_top ' and contains(text(),'${Admin First} ${Admin Last}')]
      Go Back
  END

Confirm the order everywhere with pending values are correct
  ${date} =    Convert Date    ${Todays Date}    result_format=%m/%d/%Y
  ${table} =    Set Variable    //table[@class='grid_index']/tbody/tr[@id]
  @{list orders} =    Get Webelements    ${table}/td[1]/div/a
  FOR    ${index}    ${order}    IN ENUMERATE    @{list orders}
      ${position} =    Set Variable    ${index+1}
      ${passes} =    Run Keyword And Return Status    Should Be Equal As Strings    ${order.get_attribute('innerHTML')}
                     ...                              @{Orders}[0]
      Run Keyword If    ${passes}                                Exit For Loop
      ...    ELSE IF    ${list orders.__len__()}==${position}    Fail    Order was not found!
  END
  Page should have    ELEMENT|${table}\[${position}]/td[2]/div[contains(text(),'Start:')]
  ...                 ELEMENT|${table}\[${position}]/td[2]/div[contains(.,'${Admin first original[0]}${Admin last original[0]}')]
  ...                 ELEMENT|${table}\[${position}]/td[2]/div[contains(.,'${date}')]
  ...                 ELEMENT|${table}\[${position}]/td[3]/ul/li[contains(text(),'Ordered by QA Doc')]
  ...                 ELEMENT|${table}\[${position}]/td[3]/ul/li[contains(text(),'pending review')]
  I hit the "Show all orders" text
  @{list orders} =    Get Webelements    ${table}/td[1]/div/a
  FOR    ${index}    ${order}    IN ENUMERATE    @{list orders}
      ${position} =    Set Variable    ${index+1}
      ${passes} =    Run Keyword And Return Status    Should Be Equal As Strings    ${order.get_attribute('innerHTML')}
                     ...                              @{Orders}[0]
      Run Keyword If    ${passes}                                Exit For Loop
      ...    ELSE IF    ${list orders.__len__()}==${position}    Fail    Order was not found!
  END
  Page should have    ELEMENT|${table}\[${position}]/td[2]/div[contains(text(),'Start:')]
  ...                 ELEMENT|${table}\[${position}]/td[2]/div[contains(.,'${date}')]
  ...                 ELEMENT|${table}\[${position}]/td[2]/div[contains(.,'${Admin first original[0]}${Admin last original[0]}')]
  ...                 ELEMENT|${table}\[${position}]/td[3]/ul/li[contains(text(),'pending review')]

Confirm the order everywhere with discontinue values are correct
  ${date} =    Convert Date    ${Todays Date}    result_format=%m/%d/%Y
  ${table} =    Set Variable    //table[@class='grid_index']/tbody/tr[@id]
  @{list orders} =    Get Webelements    ${table}/td[1]/div/a
  FOR    ${index}    ${order}    IN ENUMERATE    @{list orders}
      ${position} =    Set Variable    ${index+1}
      ${passes} =    Run Keyword And Return Status    Should Be Equal As Strings    ${order.get_attribute('innerHTML')}
                     ...                              STOP: @{Orders}[0]
      Run Keyword If    ${passes}                                Exit For Loop
      ...    ELSE IF    ${list orders.__len__()}==${position}    Fail    Order was not found!
  END
  Page should have    ELEMENT|${table}\[${position}]/td[2]/div[contains(text(),'Stop:')]
  ...                 ELEMENT|${table}\[${position}]/td[2]/div[contains(.,'${date}')]
  ...                 ELEMENT|${table}\[${position}]/td[2]/div[contains(.,'${Admin First[0]}${Admin Last[0]}')]
  ...                 ELEMENT|${table}\[${position}]/td[3]/ul/li[contains(text(),'Discontinued Ordered by ${Find First} ${Find Last}.')]
  ...                 ELEMENT|${table}\[${position}]/td[3]/ul/li[contains(text(),'pending review')]
  I hit the "Show all orders" text
  @{list orders} =    Get Webelements    ${table}/td[1]/div/a
  FOR    ${index}    ${order}    IN ENUMERATE    @{list orders}
      ${position} =    Set Variable    ${index+1}
      ${passes} =    Run Keyword And Return Status    Should Be Equal As Strings
                     ...                              ${order.get_attribute('innerHTML').strip(' \t\n\r')}
                     ...                              STOP: @{Orders}[0]
      Run Keyword If    ${passes}                                Exit For Loop
      ...    ELSE IF    ${list orders.__len__()}==${position}    Fail    Order was not found!
  END
  Page should have    ELEMENT|${table}\[${position}]/td[2]/div[contains(text(),'Stop: ${date}')]
  ...                 ELEMENT|${table}\[${position}]/td[2]/div[contains(.,'${Admin First[0]}${Admin Last[0]}')]
  ...                 ELEMENT|${table}\[${position}]/td[3]/ul/li[contains(text(),'Discontinued Ordered by ${Find First} ${Find Last}.')]
  ...                 ELEMENT|${table}\[${position}]/td[3]/ul/li[contains(text(),'pending review')]

Confirm the orders do not show up in the med log
  I hit the "med log" patient tab
  I am on the "med log" patient page
  Scrolling down
  FOR    ${order}    IN    @{Orders}
      Page should have    NOT|${order}
  END

Confirm the order rounds the quantity "${correctness}" with "${placing}" zeroes
  Custom screenshot
  ${correctness} =    Set Variable If    '${correctness}'=='correctly'    ${EMPTY}    NOT|
  ${is}    ${amount} =    Run Keyword If    'trailing' in '${placing}'    Set Variable    NOT|    1.0
                          ...               ELSE                          Set Variable    ${EMPTY}    0.1
  Page should have    ${correctness}${Orders[0]}    ${is}${amount} cream
  I hit the "${Orders[0].split('topical')[0]}" text
  Page should have    ${correctness}${Orders[0]}    ${is}${amount} cream
  ...                 ${is}ELEMENT|//div[@id='patient-order-items-table']//div[.='Administer&nbsp;Amount]/parent::div[contains(.,'${amount}')]
  Go Back
  I hit the "med log" patient tab
  Page should have    ${is}x ${amount}
  Go Back

Bulk orders are in the correct order
  Order for column is good    Order
  ...                         //table[@class='grid_index']/tbody/tr[1];//table[@class='grid_index']/tbody/tr[position()>1 and @class='no-border'];null
  ...                         rule=./div[@class='mleft20px']

Discontinuing the order will stop it
  [ARGUMENTS]    ${doctor}=null    ${method}=null
  Page should have    NOT|No orders available
  Click Element    //div[@id='dialog-modal-discontinue-discontinueorder']//tr[1]/td[2]
  Doctor "dc" ordered by "${doctor}" via "${method}"
  Run Keyword And Ignore Error    Click Element    //span[.='Submit']
  Page should have    STOP: @{Orders}[0]

Days should auto populate
  Blur element    //div[@id='order_item']
  Ajax wait
  Page should have    ELEMENT|3x|//div[@id='order_item']/div

Turn off mars generation
  Go To    ${BASE URL}${TEMPLATES EVALUATIONS}
  Create tester template    evaluations    Turn Mars Off/On
  Editing "evaluations" test template
  Run Keyword If    ${_LOCATIONS ACTIVE}    Form fill    evaluations form    all locations:checkbox=x
  Set count id
  Click Link    Add item
  Ajax wait
  Form fill    evaluations form    enabled:checkbox=x    load manually:checkbox=x    patient process:dropdown=Nursing
  ...          item name=Pause MAR Generation    item label=Pause MAR Generation    item label width:dropdown=20%
  ...          item field type:dropdown=patient.toggle_mars_generation
  Save "evaluations" template
  I am on the "templates evaluations" page
  Travel "fast" to "current" patients "nursing" page in "null"
  With this form "Turn Mars Off/On" perform these actions "add;edit"
  Wait Until Element Is Visible    patient_evaluation_eval_timestamps_attributes_0_timestamp
  Default date to now    patient_evaluation_eval_timestamps_attributes_0_timestamp
  Form fill    ${EMPTY}    toggle_mars_generation_check_box:direct_check=o
  Click Element    validate_patient_evaluation_fields
  Ajax wait
  Travel "fast" to "current" patients "medical orders" page in "null"

Turn on mars generation
  Travel "fast" to "current" patients "nursing" page in "null"
  Loop deletion    With this form "Turn Mars Off/On" perform these actions "delete"
  With this form "Turn Mars Off/On" perform these actions "add;edit"
  Wait Until Element Is Visible    patient_evaluation_eval_timestamps_attributes_0_timestamp
  Default date to now    patient_evaluation_eval_timestamps_attributes_0_timestamp
  Form fill    ${EMPTY}    toggle_mars_generation_check_box:direct_check=x
  Click Element    validate_patient_evaluation_fields
  Ajax wait
  Loop deletion    With this form "Turn Mars Off/On" perform these actions "delete"
  Delete tester template    evaluations

Discharge the patient
  Form fill    ${EMPTY}    patient_evaluation[eval_strings_attributes][0][description]:direct_radio=Discharge
  ...          patient_evaluation_eval_timestamps_attributes_1_timestamp:direct_js=01/01/2001 01:10 PM
  # ...          patient_evaluation_eval_timestamps_attributes_1_timestamp:direct_js=10/17/2018 06:48 PM
  ...          discharge_type_select:direct_drop=Deceased
  ...          patient_evaluation[eval_strings_attributes][1][description]:direct_radio=No
  ...          patient_evaluation[eval_strings_attributes][2][description]:direct_radio=No
  ...          patient_evaluation_eval_texts_attributes_0_description:direct_text=N/A
  ...          patient_evaluation_eval_texts_attributes_1_description:direct_text=N/A
  ...          patient_evaluation_eval_texts_attributes_2_description:direct_text=N/A
  Click Element    validate_patient_evaluation_fields
  Slow wait
  Click Element    validate_patient_evaluation_fields
  Ajax wait
  Wait Until Page Contains    Validated: no errors    1m
  Page should have    Notice    Validated: no errors
  Perform signature    I hit the "Sign & Submit" text

Get final date on med pass
  ${current date} =    Get Text    //div[@id='sub_nav_content']/h2[1]
  ${current date} =    Convert Date    ${current date.split(' E')[0]} E    epoch    False
                       ...             Med Pass, %B %d, %Y at %I:%M %p E
                       # DT (+/- 24 hours)
  Run Keyword And Ignore Error    Click Element    //a[@class='ajax_browser_history' and starts-with(text(),'Last')]
  ${final date} =    Get Text    //div[@class='wrap left _70']/div[@class='block'][last()]/span
  ${final date} =    Convert Date    ${final date}    epoch    False    %b %d, %Y at %I:%M %p
  ${full day} =    Add Time To Date    ${current date}    1d    epoch
  Should Be True    ${current date}<${final date}<=${full day}
