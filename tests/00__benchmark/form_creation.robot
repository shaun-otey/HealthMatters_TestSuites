*** Settings ***
Documentation   Attach x forms to a list of patients.
...
Default Tags    stress    st002    points-375
Resource        ../../suite.robot
Suite Setup     Run Keywords    Return to mainpage
...             AND             I select the "${_LOCATION 1}" location
Suite Teardown  Return to mainpage

*** Variables ***
${PATIENT ASAM TRANSFER}          /records?process=14

*** Test Cases ***
Run creation process
  ${escape} =    Set Variable    ${0}
  FOR    ${i}    IN RANGE    300
      ${id} =    PERFORM Queue Action    parllz-share-queue.fifo
      ${escape} =    Run Keyword If    '${id}'=='EMPTYQ'     Set Variable    ${escape+1}
                     ...    ELSE IF    '${id}'=='NOCREDS'    Exit For Loop
                     ...               ELSE                  Set Variable    ${0}
      Run Keyword If    ${escape}>=5    Exit For Loop
      ...    ELSE IF    ${escape}>0     Run Keywords    Sleep    60
      ...                               AND             Continue For Loop
      Run Keyword And Continue On Failure    Perform form actions    ${id}
      Return to mainpage
  END

*** Keywords ***
Perform form actions
  [ARGUMENTS]    ${id}
  ${eval} =    Set Variable    Client Outcome Survey
  Travel "fast" to "${id}" patients "ASAM TRANSFER" page in "null"
  ${passes} =    Run Keyword And Return Status    Page should have
                 ...                              ELEMENT|//a[contains(text(),'${eval}')]/../following-sibling::td[last()]/span
  Return From Keyword If    ${passes}
  ${chance} =    Evaluate    random.random()    random
  With this form "${eval}" perform these actions "add"
  Page should have    ELEMENT|//div[@class='small' and contains(text(),'open')]
  Run Keyword If    ${chance}<=0.2    Run Keywords   Log To Console    ${chance}
  ...                                 AND            Return From Keyword
  @{choices} =    Create List    0 (not present)    1    2   3   4    5 (extreme)
  With this form "${eval}" perform these actions "edit"
  FOR    ${attr}    IN RANGE    4
      ${choice} =    Evaluate    random.choice(@{choices})    random
      Form fill    ${EMPTY}    patient_evaluation[eval_strings_attributes][${attr}][description]:direct_radio=${choice}
  END
  I hit the "Validate assessment" text
  Page should have    Errors found
  Run Keyword If    ${chance}<=0.4    Run Keywords    I hit the "ASAM/Transfer" text
  ...                                 AND             Page should have    ELEMENT|//div[@class='small' and contains(text(),'in progress')]
  ...                                 AND             Log To Console    ${chance}
  ...                                 AND             Return From Keyword
  @{choices} =    Create List    0 (none)    1    2   3   4    5 (extreme)
  FOR    ${attr}    IN RANGE    4    10
      ${choice} =    Evaluate    random.choice(@{choices})    random
      Form fill    ${EMPTY}    patient_evaluation[eval_strings_attributes][${attr}][description]:direct_radio=${choice}
  END
  Form fill    ${EMPTY}    patient_evaluation_patient_evaluation_items_attributes_0_item_value:direct_check=x
  Click Button    Update
  Ajax wait
  Page should have    Notice    Validated: no errors
  Perform signature    I hit the "Sign & Submit" text
  Page should have    ELEMENT|//div[@class='small' and contains(text(),'in progress')]
  With this form "${eval}" perform these actions "edit"
  Perform signature    I hit the "Sign & Submit" text
  Page should have    ELEMENT|//div[@class='small' and contains(text(),'ready for review')]
  Run Keyword If    ${chance}<=0.6    Run Keywords   Log To Console    ${chance}
  ...                                 AND            Return From Keyword
  With this form "${eval}" perform these actions "edit"
  Perform signature    I hit the "Sign & Submit" text
  Page should have    ELEMENT|//div[@class='small' and contains(text(),'Completed')]
  Log To Console    ${chance}
