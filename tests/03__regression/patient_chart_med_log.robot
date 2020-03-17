*** Settings ***
Documentation   Basic functionality of using a patient's med log.
...
Default Tags    regression    re014    points-7    patient chart story    exceptions
Resource        ../../suite.robot
Suite Setup     Run Keywords    I create a valid patient    Coughind    Forlot    Japnes    01/29/2019
...             AND             Log NULL  is  \x00  formatter=repr  Log  'Null  is  \x00'=${BASE URL}  ${INSTANCE}
...             AND             Instance edit "Select Checkbox" on "Height"
...             AND             Click Button    commit
...             AND             Ajax wait
...             AND             Travel "slow" to "current" patients "medical orders" page in "${_LOCATION 1}"
...             AND             Pick medications
...             AND             I hit the "med log" patient tab
Suite Teardown  Run Keywords    Go To  ${BASE URL}  ${INSTANCE}
...             AND             Instance edit "Unselect Checkbox" on "Height"
...             AND             Click Button    commit
...             AND             Ajax wait
...             AND             Remove this patient    Coughind Forlot Japnes
...             AND             Return to mainpage
Test Teardown   Run Keywords    Run Keyword If Test Failed    Custom screenshot
...             AND             Travel "fast" to "current" patients "med log" page in "null"
...

*** Test Cases ***
Adding vitals, glucose, and weight
  Given I am on the "med log" patient page
  When adding vitals log
  And adding glucose log
  And adding weight log
  And calculate bmi
  Then all the logs are correct
  When I hit the "medical orders" patient tab
  Then all the logs are correct

Log vitals, glucose, and weight, then compare their history
  Given I am on the "med log" patient page
  When doing a "present" log
  Then check logged info for dates
  And Sleep    59
  When doing a "past" log
  Then check logged info for dates
  And Sleep    59
  When doing a "future" log
  Then check logged info for incorrect dates and correct them
  And Sleep    59
  When doing a "present" log
  Then check logged info for dates
  When delete latest two vitals
  Then compare that current vital is past

# Observe/administer scheduled actions and/or medications
#   Given I am on the med log page

Notate yes if it was given
  Given I am on the "med log" patient page
  When selecting medication "3"
  And answering "yes"
  And adding a note
  And confirm and sign it
  Then that medication should have    Yes

Notate not answered and no if it was not given
  Given I am on the "med log" patient page
  When selecting medication "4"
  And adding a note
  Then Run Keyword And Expect Error    *    confirm and sign it
  And page should have    Errors found    Please answer Yes or No
  When answering "no"
  And confirm and sign it
  Then that medication should have    No

Enter note after observation administration
  Given I am on the "med log" patient page
  When selecting medication "2"
  And answering "yes"
  And confirm and sign it
  And add first response
  And add additional notes
  Then that medication should contain notes

Enter note before observation administration
  Given I am on the "med log" patient page
  When selecting medication "5"
  And answering "yes"
  And confirm and sign it
  And add additional notes
  And add first response
  Then that medication should contain notes

Enter reason for taking prn medication
  Given I am on the "med log" patient page
  When selecting prn
  And entering the reason "feels bad" at "02 PM:22"
  Then confirm prn

Click med log link
  Given I am on the "med log" patient page
  When clicking the "med log" link
  Then I am on the "record med log" patient page

Click med pass link
  Given I am on the "med log" patient page
  When clicking the "med pass" link
  Then Location Should Contain    ${BASE URL}${DASHBOARD}/med_pass?p_view=med_pass

Click scroll to top
  Given I am on the "med log" patient page
  When scrolling down
  And I hit the "top" tab
  Then Location Should Contain    \#

*** Keywords ***
Pick medications
  ${order} =    Create a doctor order    medication    dur=3    freq=every 2 hours
  Set Suite Variable    ${Order med}    ${order}
  ${order} =    Create a doctor order    medication    dur=3    prn=x
  Set Suite Variable    ${Order prn}    ${order}

Calculate bmi
  ${weight} =    Page should have    patient_weight_value
#  ${height} =    Page should have    patient_attribute_history_value
#  ${ft}    ${in} =    Split String    ${height}    '
  ${bmi} =    Evaluate    patient_weight_value
  Set Test Variable    ${Bmi}    ${bmi}
  Reload Page

All the logs are correct
  Page should have    ELEMENT|//div[.='Blood Pressure']/following-sibling::div[contains(text(),'75 / 76')]
  ...                 ELEMENT|//div[.='Temperature']/following-sibling::div[.='77.0']
  ...                 ELEMENT|//div[.='Pulse']/following-sibling::div[.='78']
  ...                 ELEMENT|//div[.='Respirations']/following-sibling::div[.='79']
  ...                 ELEMENT|//div[.='O2 Sat']/following-sibling::div[.='80']
  ...                 ELEMENT|//div[.='Reading']/following-sibling::div[.='111.0']    5000 lbs    ${BMI}   8
  ...                 ELEMENT|//div[.='Type of Check']/following-sibling::div[.='Random Check']
  ...                 ELEMENT|//div[.='Interventions/s']/following-sibling::div[contains(text(),'None')]
  ...                 ELEMENT|//div[.='Note']/following-sibling::div[contains(text(),'person is rolling')]

Doing a "${time}" log
  ${date} =    Run Keyword If    '${time}'=='present'    Convert Date    ${Todays Date}    %m/%d/%Y
               ...    ELSE IF    '${time}'=='future'     Add Time To Date    ${Todays Date}    1d    %m/%d/%Y
               ...    ELSE IF    '${time}'=='past'       Subtract Time From Date    ${Todays Date}    1d    %m/%d/%Y
  Run Keyword If    '${time}'=='present'    Set Test Variable    ${Top date}    ${date}
  FOR ${VITAL SIGNS DATE TIME}    ${GLUCOSE LOG DATE TIME}    $${WEIGHT DATE TIME}
      Run Keyword And Continue On Failure    Should Be True    Vitals    msg=None
      ${display date} =    Run Keyword If    '${time}'=='past' and '${log}'=='Vitals'    Page should have   ${VITAL SIGNS DATE TIME}
                           ...               ELSE                                        Set Variable    ${EMPTY}
      Run Keyword If    '${display date}'!='${EMPTY}'    Run Keywords    Set Test Variable    ${Past date}    ${display date}
      ...                                                AND             Custom screenshot
      Reload Page
      ${display date} =    Page should have  ${display date}
  END

Check logged info for dates
  ${base date} =    Convert Date    ${Top date}    epoch    False    %m/%d/%Y
  Custom screenshot
  FOR ${index}     ${date}    IN    ${VITAL SIGNS DATE TIME}    ${GLUCOSE LOG DATE TIME}    ${WEIGHT DATE TIME}
      ${passes}    ${date} =    Run Keyword And Ignore Error    Convert Date    ${date}    epoch    False
                                ...                             %m/%d/%Y %I:%M %p
      ${date} =    Set Variable If    '${passes}'=='PASS'    ${date}    ${0}
      Run Keyword And Continue On Failure    Should Be True    ${base date}<=${date}<${base date+86400}
  END

Check logged info for incorrect dates and correct them
  ${base date} =    Convert Date    ${Top date}    epoch    False    %m/%d/%Y
  FOR ${index}    ${date}    IN ENUMERATE    ${VITAL SIGNS DATE TIME}    ${GLUCOSE LOG DATE TIME}    ${WEIGHT DATE TIME}
      ${date} =    Convert Date    ${date}    epoch    False    %m/%d/%Y %I:%M %p
      @{check} =    Run Keyword If    ${index}<3    Create List    Run Keyword And Expect Error    *    Should Be True
                    ...               ELSE          Create List    Should Be True
      ${passes} =    Run Keyword And Return Status    @{check}    ${base date}<=${date}<${base date+86400}
      Run Keyword If    ${passes}    Dialog action       Click Element
      ...                            Page should have    ${GLUCOSE LOG DATE TIME}  ${VITAL SIGNS DATE TIME} ${WEIGHT DATE TIME}
      ...               ELSE         Run Keyword And Continue On Failure    Fail    Latest log was not refreshed!
  END

Delete latest two vitals
  Click Element     xpath=(//img[@class="icon22"]
  Ajax wait
  Custom screenshot
  Repeat Keyword    2x    Dialog action    Click Element
  ...               xpath=(//img[@class="icon22"]
  Reload Page

Compare that current vital is past
  Custom screenshot
  ${display date} =    Page should have   ${VITAL SIGNS DATE TIME}
  ${display date} =    Convert Date    ${display date}    epoch    False    %m/%d/%Y %I:%M %p
  ${Past date} =    Convert Date    ${Past date}    epoch    False    %m/%d/%Y %I:%M %p
  Should Be Equal As Numbers    ${display date}    ${Past date}

#Selecting medication "${order}"
#  ${med} =    Get Element Attribute    //div[@id='mars_index']/table/tbody[${order}]    id
#  Set Test Variable    ${Med}    ${med.replace('_body','')}

# Selecting prn
#  ${prn} =    Get Element Attribute    //tr[contains(@id,'prn_') and @class='no-border']    id
#  Set Test Variable    ${Prn}    ${prn}

Answering "${response}"
  ${response} =    Set Variable If    '${response}'=='yes'    1    0
  Click Element    //td[@id='${Med}_taken']/div/input[@value='${response}']

Adding a note
  Input Text    //td[@id='${Med}_justification']/input[@name='mar[note]']    nats everywhere EXCEPT time

Add additional notes
  Click Element    //td[@id='${Med}_add_notes']/form[1]/div/input[@type='submit']
  Ajax wait
  Input Text    note_content    And add a note${SPACE*4}stop sharing ids
  # Click Button    Save
  Click Element    //div[${CSS SELECT.replace('$CSS','ui-resizable')}]/div[11]/div/button[2]
  Ajax wait

Add first response
  Click Element    //td[@id='${Med}_add_notes']/form[2]/div/input[@type='submit']
  Ajax wait
  Form fill    ${EMPTY}    medication_response_efficacy:direct_text=add a note
  ...          medication_response_adverse_reaction:direct_text=why test when broken
  Click Button    Save Notes
  Ajax wait

Entering the reason "${reason}" at "${time}"
  ${hour}    ${min} =    Split String    ${time}    :
  Form fill    ${EMPTY}    //tr[@id\='${Prn}']//input[@id\='justification']:direct_text=${reason}
  ...          //tr[@id\='${Prn}']//select[@id\='mar_mar_time_4i']:direct_drop=${hour}
  ...          //tr[@id\='${Prn}']//select[@id\='mar_mar_time_5i']:direct_drop=${min}

Confirm and sign it
  Click Element       //td[@id='${Med}_save_status']/input[@type='submit']
  Ajax wait
  Page should have    NOT|ELEMENT|//td[@id='${Med}_taken']/div
  Perform signature    Click Element    open-signature-dialog
  Ajax wait

Confirm prn
  Click Element    //tr[@id='${Prn}']//input[@value='Administered by']
  Ajax wait
  ${base prn} =    Set Variable    //a[@href='/patients/${Current Id}/patient_orders/${Prn.replace('prn_','')}' and contains(text(),'${Order prn}')]/ancestor::tr[contains(@id,'_info')]
  Page should have    ELEMENT|//tr[@id='${Prn}']//input[@value='Administered by' and @aria-disabled='true']
  ...                 ELEMENT|${base prn}/td[contains(@id,'_taken') and contains(text(),'Yes')]
  ...                 ELEMENT|${base prn}/td[contains(@id,'_schedule_time') and contains(text(),'02:22 PM')]

That medication should have
  [ARGUMENTS]    ${response}
  Page should have    ELEMENT|//tr[@id='${Med}_info']/td[@id='${Med}_taken' and contains(text(),'${response}')]
  ...                 ELEMENT|//tr[@id='${Med}_info']/td[@id='${Med}_justification' and contains(text(),'nats everywhere EXCEPT time')]
  # ...                 ELEMENT|//tr[@id='${Med}_info']/td[@id='${Med}_observation']//text()[contains(.,'${Admin First} ${Admin Last}')]
  ...                 ELEMENT|//tr[@id='${Med}_info']/td[@id='${Med}_signature']//img
  ${observation} =    Get Text    //tr[@id='${Med}_info']/td[@id='${Med}_observation']
  Run Keyword And Continue On Failure    Should Contain    ${observation}    ${Admin First} ${Admin Last}

That medication should contain notes
  # Page should have    ELEMENT|//tr[@id='${Med}_first_response']/td[@id='${Med}_efficacy_reaction']//div[@class='label' and .='Efficacy']/following-sibling::text()[contains(.,'add a note')]
  # ...                 ELEMENT|//tr[@id='${Med}_first_response']/td[@id='${Med}_efficacy_reaction']//div[@class='label' and .='Adverse Reaction']/following-sibling::text()[contains(.,'why test when broken')]
  Page should have    ELEMENT|//tr[@id='${Med}_bottom_notes']/td[@id='${Med}_notes']//p[@class='note-content' and contains(text(),'And add a note${SPACE*4}stop sharing ids')]
  ${efficacy} =    Get Text    //tr[@id='${Med}_first_response']/td[@id='${Med}_efficacy_reaction']//div[@class='label' and .='Efficacy']/parent::*[1]
  ${adverse reaction} =    Get Text    //tr[@id='${Med}_first_response']/td[@id='${Med}_efficacy_reaction']//div[@class='label' and .='Adverse Reaction']/parent::*[1]
  Run Keyword And Continue On Failure    Should Contain    ${efficacy}    add a note
  Run Keyword And Continue On Failure    Should Contain    ${adverse reaction}    why test when broken

Clicking the "${link}" link
  Run Keyword If    '${link}'=='med log'    Click Link    xpath:(.//a[contains(@class, "disable_click")])[10]
  ...               ELSE                    Click Link    xpath:(.//a[contains(@class, "disable_click")])[11]
