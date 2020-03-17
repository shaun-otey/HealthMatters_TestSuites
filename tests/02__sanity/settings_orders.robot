*** Settings ***
Documentation   1. Orders is used for Super admins to be able to customize medical necessity statements and lab order frequencies.
...             2. When customizing an Order it is expected that the system picks up the correct intervals or type or occurrences.
...             3. Users are able to place a lab order and select the Lab order panel they want, select the date, select the frequency
...                and also weather to continue on admission or on discharge or both.
...
Default Tags    sanity    sa010    points-3    settings story    addmore
Resource        ../../suite.robot
Suite Setup     Run Keywords    I hit the "settings" tab
...                             I hit the "orders" tab
...                             I select the "My Locations" location
...                             Create a test statement
Suite Teardown  Run Keywords    Loop deletion    Leftover frequencies
...             AND             Return to mainpage
Test Teardown   Run Keywords    Run Keyword If Test Failed    Custom screenshot
...             AND             Go To    ${BASE URL}${ORDERS}
...             AND             I select the "My Locations" location

*** Test Cases ***
Move a statement
  Given I am on the "orders" page
  When moving the test statement
  Then check that the statement is moved to the top

Add an interval lab frequency
  ### needs lab integration
  Given I am on the "orders" page
  When setting a lab type frequency "Interval;20" with the name "Every 20/00 days"
  And travel "slow" to "tester" patients "medical orders" page in "null"
  Then verify for no bad page

Add an occurrence lab frequency
  ### needs lab integration
  Given I am on the "orders" page
  When setting a lab type frequency "Occurrence;Sunday;Saturday" with the name "When attending group (Sun, Sat)"
  And travel "slow" to "tester" patients "medical orders" page in "null"
  Then verify for no bad page

Add an as needed lab frequency
  ### needs lab integration
  Given I am on the "orders" page
  When setting a lab type frequency "As needed" with the name "Drink more"
  And travel "slow" to "tester" patients "medical orders" page in "null"
  Then verify for no bad page

Add a random lab frequency
  ### needs lab integration
  Given I am on the "orders" page
  When setting a lab type frequency "Random;Weekly" with the name "No days for me please"
  And travel "slow" to "tester" patients "medical orders" page in "null"
  Then verify for no bad page

Add an every med frequency
  Given I am on the "orders" page
  When setting a med type frequency "Every;2" with the name "Other Day"
  And travel "slow" to "tester" patients "medical orders" page in "null"
  Then create an order with the "Other Day" frequency
  And confirm the order is scheduled corretly for "2"
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Travel "fast" to "tester" patients "medical orders" page in "null"
  ...           AND             Loop deletion    Remove any orders
  ...           AND             Go To    ${BASE URL}${ORDERS}

Add an at med frequency
  Given I am on the "orders" page
  When setting a med type frequency "At;9-30-AM;12-0-PM" with the name "The Arrival"
  And travel "slow" to "tester" patients "medical orders" page in "null"
  Then create an order with the "The Arrival" frequency
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Travel "fast" to "tester" patients "medical orders" page in "null"
  ...           AND             Loop deletion    Remove any orders
  ...           AND             Go To    ${BASE URL}${ORDERS}

*** Keywords ***
Create a test statement
  Loop deletion    Leftover frequencies
  Click Link    /medical_necessity_note_templates/add
  Ajax wait
  ${id} =    Get Element Attribute    //ul[@data-update-url='/medical_necessity_note_templates/sort']/li[last()-1]    id
  ${mod id} =    Replace String    ${id}    template    templates
  Form fill    ${EMPTY}    ${mod id}_name:direct_text=Coffee Order Test
  ...          ${mod id}_content:direct_text=I am very tired, therefore, I will take lots of caffeine.
  Set Suite Variable    ${Test statement}    ${id}
  Click Element    //form[@action='/medical_necessity_note_templates/update_all']/input[@type='submit']
  Ajax wait
  Reload Page

Leftover frequencies
  @{freqs} =    Create List    Coffee Order Test    Every 20/00 days    When attending group (Sun, Sat)    Drink more
                ...            No days for me please    Other Day    The Arrival    ${EMPTY}    Order frequency name
  FOR    ${elements}                                                               ${search}                                          ${delete}    IN
  ...    [@action='/medical_necessity_note_templates/update_all']/ul/li            ul>li:first-of-type                                ul>li:nth-of-type(4)
  ...    [@action='/order_frequencies/update_all']/ul/li[position()>1]             ul>li:first-of-type                                ul>li[class~=inline][class~=right]
  ...    [@action='/medication_order_frequencies/update_all']/div[position()>1]    section>div:first-of-type                          section>div:last-of-type
  ...    [@action='/medication_order_frequencies/update_all']/table/tbody/tr       td:nth-of-type(2)>div>section>div:first-of-type    td:nth-of-type(2)>div>section>div:last-of-type
      ${cleaned} =    Inner loop    ${elements}    ${search}    ${delete}    ${freqs}
      Return From Keyword If    ${cleaned}    ${true}
  END
  Fail    No deletion!

Inner loop
  [ARGUMENTS]    ${elements}    ${search}    ${delete}    ${inputs}
  @{action} =    Run Keyword If    'medication_' in '''${elements}'''    Create List    Click Element
                 ...               ELSE                                  Create List    Dialog action    Click Element
  ${passes} =    Run Keyword And Return Status    Page should have    ELEMENT|//form${elements}
  @{rows} =    Run Keyword If    ${passes}    Get Webelements    //form${elements}
               ...               ELSE         Return From Keyword    ${false}
  FOR    ${row}    IN    @{rows}
      Log    ${row.get_attribute('innerHTML')}
      ${passes} =    Run Keyword And Return Status    Set Variable
                     ...                              ${row.find_element_by_css_selector('${search}>input')}
      Continue For Loop If    not ${passes}
      ${blank} =    Set Variable    ${row.find_element_by_css_selector('${search}>input').get_attribute('value')}
      ${passes} =    Run Keyword And Return Status    Should Contain Match    ${inputs}    ${blank}
      ${passes} =    Run Keyword If    not ${passes}    Run Keyword And Return Status    Should Contain   ${blank}
                     ...                                @{inputs}[-1]
                     ...               ELSE             Set Variable    ${passes}
      Run Keyword If    ${passes}    Run Keywords    @{action}    ${row.find_element_by_css_selector('${delete}>a')}
      ...                            AND             Return From Keyword    ${passes}
  END
  [RETURN]    ${false}

Setting a lab type frequency "${freq}" with the name "${name}"
  Click Link    /order_frequencies/add
  Ajax wait
  ${id} =    Get Element Attribute    //form[@action='/order_frequencies/update_all']/ul/li[last()-1]    id
  ${id} =    Replace String    ${id}    y    ies
  ${freq}    @{intervals} =    Split String    ${freq}    ;
  Form fill    ${EMPTY}    ${id}_name:direct_text=${name}    ${id}_freq_type:direct_drop=${freq}
  FOR    ${interval}    IN    @{intervals}
      Run Keyword If    '${freq}'=='Interval'      Run Keywords    Element Should Contain
      ...                                                          //select[@id='${id}_unit']/option[@selected='selected']
      ...                                                          Day
      ...                                          AND             Form fill    ${EMPTY}
      ...                                                          ${id}_value:direct_text=${interval}
      ...    ELSE IF    '${freq}'=='Occurrence'    Run Keywords    Element Should Contain
      ...                                                          //select[@id='${id}_unit']/option[@selected='selected']
      ...                                                          Day of week
      ...                                          AND             Form fill    ${EMPTY}
      ...                                                          //input[@id\='${id}_occurrences_' and @value\='${interval}']:direct_check=x
      ...    ELSE IF    '${freq}'=='Random'        Run Keywords    Element Should Contain
      ...                                                          //select[@id='${id}_unit']/option[@selected='selected']
      ...                                                          Weekly
      ...                                          AND             Form fill    ${EMPTY}
      ...                                                          ${id}_unit:direct_text=${interval}
  END
  Click Element    //div[@id='order_frequencies']/form/input
  Ajax wait

Setting a med type frequency "${freqs}" with the name "${name}"
  Click Link    /medication_order_frequencies/add_frequency
  Ajax wait
  ${id} =    Get Element Attribute    //form[@action='/medication_order_frequencies/update_all']/div[last()-1]    id
  Form fill    ${EMPTY}    ${id}_name:direct_text=${name}
  ${type}    @{freqs} =    Split String    ${freqs}    ;
  FOR    ${freq}    IN    @{freqs}
      Click Link    /${id.replace('ies_','ies/')}/add_frequency_schedule
      Ajax wait
      ${type id} =    Get Element Attribute    //div[@id='${id}']/div[${CSS SELECT.replace('$CSS','medication_order_frequency_schedule')}]
                      ...                      id
      @{time} =    Split String    ${freq}    -
      Form fill    ${EMPTY}    ${id}_medication_order_frequency_schedules_${type id}_type:direct_drop=${type}
      Run Keyword If    '${type}'=='Every'    Form fill    ${EMPTY}
      ...                                     ${id}_medication_order_frequency_schedules_${type id}_days:direct_drop=@{time}[0]
      ...    ELSE IF    '${type}'=='At'       Form fill    ${EMPTY}
      ...                                     ${id}_medication_order_frequency_schedules_${type id}_hours:direct_drop=@{time}[0]
      ...                                     ${id}_medication_order_frequency_schedules_${type id}_minutes:direct_drop=@{time}[1]
      ...                                     ${id}_medication_order_frequency_schedules_${type id}_meridian:direct_drop=@{time}[2]
  END
  Form fill    ${EMPTY}    ${id}_enabled:direct_check=x
  Click Element    //div[@class='medication_order_frequencies_form']/form/input
  Ajax wait

Create an order with the "${freq}" frequency
  ${order} =    Create a doctor order    medication    freq=${freq}    dur=45
  Set Test Variable    ${Order}    ${order}

Confirm the order is scheduled corretly for "${interval}"
  Page should have    ${Order}
  I hit the "${Order}" text
  Page should have    testing my meds on this man
  @{days} =    Get Webelements    //div[@id='patient_order_form']/div[@id]
  ${days since} =    Get Line    ${days[0].find_element_by_css_selector('div>div:first-of-type').get_attribute('innerHTML').strip(' \t\n\r')}
                     ...         1
  ${days since} =    Set Variable    ${days since.strip(' \t\n\r</p>')}
  Set List Value    ${days}    0    ${days since}
  FOR    ${index}    ${day}    IN ENUMERATE    @{days}
      Continue For Loop If    ${index}==0
      ${days since} =    Add Time To Date    ${days since}    ${interval}d    %m/%d/%Y    False    %m/%d/%Y
      Set List Value    ${days}    ${index}    ${days since}
  END
  Page should have    @{days}

Moving the test statement
  Drag And Drop    //li[@id='${Test statement}']/ul/li[1]/label/span
  ...              //div[@id='medical_necessity_note_templates']/form/ul/li[1]
  Click Element    //form[@action='/medical_necessity_note_templates/update_all']/input[@type='submit']
  Slow wait
  Reload Page

Check that the statement is moved to the top
  ${id} =    Get Element Attribute    //div[@id='medical_necessity_note_templates']/form/ul/li[1]    id
  Should Be Equal As Strings    ${Test statement}    ${id}
