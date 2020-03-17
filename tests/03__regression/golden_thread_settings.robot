*** Settings ***
Documentation   Any user with the role Super Admin or the added feature Manage Golden Thread can manage
...             all the content in Settings/Golden Thread.
...
Default Tags    regression    re029    points-2    golden thread story
Resource        ../../suite.robot
Suite Setup     Run Keywords    I hit the "settings" tab
...                             I hit the "Golden Thread" view
Suite Teardown  Return to mainpage
Test Teardown   Run Keywords    Run Keyword If Test Failed    Custom screenshot
...             AND             Return assignments to normal

*** Test Cases ***
Change general settings
  Given I am on the "golden thread" page
  And I hit the "General" view
  When I edit the options
  # Then I should see the new changes
  [TEARDOWN]    Run Keywords    Return to original options
  ...                           Return to mainpage

Change goals settings
  [TAGS]    testmegtall
  Given I am on the "golden thread" page
  And I hit the "Goals" view
  When modifying assignments    for goals
  # Then

Change objectives settings
  Given I am on the "golden thread" page
  And I hit the "Objectives" view
  When modifying assignments    for objectives
  # Then

Change behavioral definitions settings
  Given I am on the "golden thread" page
  And I hit the "Behavioral Definitions" view
  When modifying assignments    for behavioral definitions
  # Then

Change interventions settings
  Given I am on the "golden thread" page
  And I hit the "Interventions" view
  When modifying assignments    for interventions
  # Then

Change diagnoses settings
  Given I am on the "golden thread" page
  And I hit the "Diagnoses" view
  When modifying assignments    for diagnoses
  # Then

*** Keywords ***
I edit the options
  # Set Test Variable    ${Clean option}    ${option}
  # Set Test Variable    ${Clean field}    @{items}[0]
  # Loop deletion    Clean fields up
  :FOR    ${add}    ${table}    ${items}    IN
  ...     master_treatment_plan_category    TREATMENT MODAL        In the air
  ...     treatment_plan_status             TREATMENT PLAN STAT    Late
  ...     null                              TREATMENT PLAN COL     Task;Action;Count
  ...     progress_note_component           PROGRESS NOTE COMP     What is staging
  \    Run Keyword Unless    '${add}'=='null'    Click Link    default=/golden_thread/add_item?related_field=${add}
  \    Ajax wait
  \    ${selection} =    Get Webelement    //div[@id="${GOLDEN THREAD ${table}}"]//form
  \    Log    ${selection.get_attribute('innerHTML')}
  \    ${new rows} =    Set Variable If    '${add}'=='progress_note_component'    ${selection.find_element_by_css_selector('div:nth-child(2)>textarea')}
  \                     ...                '${add}'!='null'    ${selection.find_element_by_css_selector('p>input')}
  \                     ...                True                ${selection.find_elements_by_css_selector('p>input')}
  \    ${items} =    Split String    ${items}    ;
  \    ${new rows} =    Run Keyword If    '${add}'!='null'    Create List    ${new rows}
  \                     ...               ELSE                Set Variable    ${new rows}
  \    ${items} =    Run Keyword If    '${add}'!='null'    Create List    ${items}
  \                  ...               ELSE                Set Variable    ${items}
  \    Input items    ${new rows}    ${items}
  \    Click Button    ${selection.find_element_by_name('commit')}
  \    Ajax wait

Input items
  [ARGUMENTS]    ${new rows}    ${items}
  :FOR    ${row}    ${item}    IN ZIP    ${new rows}    ${items}
  \    Input Text    ${row.get_attribute('id')}    ${item}

Return to original options
  Go To    ${BASE URL}/golden_thread/index
  ${selection} =    Get Webelement    //div[@id="${GOLDEN THREAD TREATMENT PLAN COL}"]//form
  Log    ${selection.get_attribute('innerHTML')}
  ${new rows} =    Set Variable    ${selection.find_elements_by_css_selector('p>input')}
  @{items} =    Create List    Objective    Plan    Frequency
  Input items    ${new rows}    ${items}
  Click Button    ${selection.find_element_by_name('commit')}
  Ajax wait

Return assignments to normal
  Go To    ${BASE URL}${GOLDEN THREAD}
  I hit the "New/Edit" view
  :FOR    ${disabled}    IN    @{Cleanup disabled}
  \    Unselect Checkbox    ${disabled}
  # ${side} =    Set Variable    left
  # \    Form fill    golden thread    ${side} side filter=ticket stuff
  :FOR    ${index}    ${addon}    IN ENUMERATE    @{Cleanup addon}
  \    ${i} =    Evaluate    ${index}+1
  \    Input Text    //div[@class='input-group mbottom08']/input[contains(@id,'filterInput') and position()=${i}]    ticket stuff
  \    Slow wait
  \    Wait Until Element Is Visible    //textarea[contains(text(),'${addon}')]/../following-sibling::div[@class='_5 no-margin-left']/a
  \    Click Element    //textarea[contains(text(),'${addon}')]/../following-sibling::div[@class='_5 no-margin-left']/a
  # \    ${side} =    Set Variable    right

Modifying assignments
  [ARGUMENTS]    ${assignments}
  &{inputs} =    Run Keyword    ${assignments}
  Log Dictionary    ${inputs}
  I hit the "New/Edit" view
  @{items} =    Get Webelements    //li[@class='active _50']
  :FOR    ${index}    ${item}    IN ENUMERATE    @{items}
  \    Set List Value    ${items}    ${index}
  \    ...               ${item.find_element_by_tag_name('a').get_attribute('innerHTML').lower().replace(' ','_')}
  @{sides} =    Create List
  ${passes} =    Evaluate    ('@{items}[0]'=='problem_list') or ('@{items}[0]'=='objectives' and '@{items}[1]'=='interventions')
  Run Keyword If    ${passes}    Append To List    ${sides}    left    right
  ...               ELSE         Append To List    ${sides}    right    left
  :FOR    ${index}    ${item}    IN ENUMERATE    @{items}
  \    ${side} =    Get From List    ${sides}    ${index}
  \    Select Checkbox    &{inputs}[${side}_disabled]
  \    Click Link    default=/golden_thread/add_item?related_field=${item.rstrip('s')}&respond=js
  \    Ajax wait
  \    Input Text    //ul[contains(@id,'${item}_edit')]/form/div[@class='page']/div[1]/textarea
  \    ...           &{inputs}[${side}_addon]
  \    Click Element    //form[contains(@action,'${item.rstrip('s')}')]//input[@value='Update']
  \    Ajax wait
  I hit the "Assign" view
  Sleep    5

For goals
  @{addon} =    Create List    a problem of getting ticket stuff    a goal to right ticket stuff
  @{disabled} =    Create List    //textarea[contains(text(),'Anger')]/../following-sibling::div[1]/input
                   ...            //textarea[contains(text(),'Overcome fears of abandonment, loss, and neglect.')]/../following-sibling::div[1]/input
  &{inputs} =    Create Dictionary    left_disabled=@{disabled}[0]    right_disabled=@{disabled}[1]
                 ...                  left_addon=@{addon}[0]    right_addon=@{addon}[1]
  Set Test Variable    ${Cleanup addon}    ${addon}
  Set Test Variable    ${Cleanup disabled}    ${disabled}
  [RETURN]    ${inputs}

For objectives
  @{addon} =    Create List    a removal objective to get rid of ticket stuff    a goal to right ticket stuff again
  @{disabled} =    Create List    //textarea[contains(text(),'')]/../following-sibling::div[1]/input
                   ...            //textarea[contains(text(),'')]/../following-sibling::div[1]/input
  &{inputs} =    Create Dictionary    left_disabled=@{disabled}[0]    right_disabled=@{disabled}[1]
                 ...                  left_addon=@{addon}[0]    right_addon=@{addon}[1]
  Set Test Variable    ${Cleanup addon}    ${addon}
  Set Test Variable    ${Cleanup disabled}    ${disabled}
  [RETURN]    ${inputs}

For behavioral definitions
  @{addon} =    Create List    a good behavior will lead to better ticket stuff    a goal to no more ticket stuff
  @{disabled} =    Create List    //textarea[contains(text(),'')]/../following-sibling::div[1]/input
                   ...            //textarea[contains(text(),'')]/../following-sibling::div[1]/input
  &{inputs} =    Create Dictionary    left_disabled=@{disabled}[0]    right_disabled=@{disabled}[1]
                 ...                  left_addon=@{addon}[0]    right_addon=@{addon}[1]
  Set Test Variable    ${Cleanup addon}    ${addon}
  Set Test Variable    ${Cleanup disabled}    ${disabled}
  [RETURN]    ${inputs}

For interventions
  @{addon} =    Create List    a no no needed intervention for any ticket stuff    a goal towards ticket stuff
  @{disabled} =    Create List    //textarea[contains(text(),'')]/../following-sibling::div[1]/input
                   ...            //textarea[contains(text(),'')]/../following-sibling::div[1]/input
  &{inputs} =    Create Dictionary    left_disabled=@{disabled}[0]    right_disabled=@{disabled}[1]
                 ...                  left_addon=@{addon}[0]    right_addon=@{addon}[1]
  Set Test Variable    ${Cleanup addon}    ${addon}
  Set Test Variable    ${Cleanup disabled}    ${disabled}
  [RETURN]    ${inputs}

For diagnoses
  &{inputs} =    Create Dictionary    left_disabled=//textarea[contains(text(),'Anger')]/../following-sibling::div[1]/input
                 ...                  right_disabled=//textarea[contains(text(),'Overcome fears of abandonment, loss, and neglect.')]/../following-sibling::div[1]/input
                 ...                  left_addon=a problem stuff    right_addon=a goal stuff
  [RETURN]    ${inputs}
