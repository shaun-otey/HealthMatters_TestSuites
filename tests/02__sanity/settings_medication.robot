*** Settings ***
Documentation   Users with Super Admin role can add entries to medication list.
...             The medications that are added to the medication list will appear automatically
...             when a user is typing in the medication in the front end under doctors orders.
...             For example a nurse is placing in a manual order and she types in "tylenol" the FDA database AND the Medication
...             list will be searched and drop a possible selection for the user.
...
Default Tags    sanity    sa011    points-1    settings story
Resource        ../../suite.robot
Suite Setup     Run Keywords    I hit the "settings" tab
...                             I hit the "medications" tab
...                             Clean up medications
Suite Teardown  Run Keywords    Clean up medications
...                             Return to mainpage

*** Test Cases ***
Check autocompletion of medication
  Given I am on the "medications" page
  When a new medication is added
  Then going to a doctors order to add a manual order
  And Wait Until Element Is Visible    //a[contains(text(),'MOBA')]    10s
  [TEARDOWN]    Go To    ${BASE URL}${MEDICATIONS}

*** Keywords ***
Clean up medications
  Loop deletion    Click Element    //input[@value\='MOBA']/following-sibling::a

A new medication is added
  Click Link    Add item
  Ajax wait
  Form fill    ${EMPTY}    //form[@action\='/medications/update_medications']/p[last()-1]/input[1]:direct_text=dota
  ...          //form[@action\='/medications/update_medications']/p[last()-1]/input[2]:direct_text=MOBA
  Click Button    Update
  Ajax wait

Going to a doctors order to add a manual order
  Travel "slow" to "tester" patients "medical orders" page in "${_LOCATION 1}"
  ${passes} =    Run Keyword And Return Status    Run Keywords    I hit the "Add manual order" text
                 ...                              AND             Click Element    popup_form_tab_add_order_medication
                 ...                              AND             Ajax wait
                 ...                              AND             Form fill    add order medication    medication=dot
  Run Keyword Unless    ${passes}    Run Keywords    I hit the "Custom Order" text
  ...                                AND             Click Element    medication_tab
  Ajax wait
  ${id} =    Get Element Attribute    //div[contains(@id,'manual_medication')]/div[contains(@id,'custom_')]/div[contains(@class,'_orders_main')][last()]
             ...                      id
  Form fill    add order medication2    medication|${id.rsplit('_',1)[1]}=dot
