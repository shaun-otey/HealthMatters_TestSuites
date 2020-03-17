*** Settings ***
Documentation   Adds a contact type and confirms it by creating a contact with it.
...
Default Tags    sanity    sa009    points-1    settings story    notester
Resource        ../../suite.robot
Suite Setup     Run Keywords    I hit the "settings" tab
...                             I hit the "contact types" tab
Suite Teardown  Run Keywords    Go To    ${BASE URL}${CONTACT TYPES}
...             AND             Loop deletion    Remove contact type
...             AND             Return to mainpage

*** Test Cases ***
A user may add new contact types
  Given I am on the "contact types" page
  When adding a contact type    Mex Place
  And I hit the "contacts" tab
  And creating a new contact    Very Full
  Then Go To    ${BASE URL}${CONTACTS}/${Contact id}/edit
  And page should have    Mex Place    Very Full
  And remove contact

*** Keywords ***
Adding a contact type
  [ARGUMENTS]    ${type}
  Click Link    /contact_types/add_contact_type
  Ajax wait
  Input Text    //div[@id='contact_types']//p[1]/input    ${type}
  Click Button    Update
  Ajax wait

Remove contact type
  Dialog action    Click Element    //input[@value='Mex Place']/following-sibling::a[1]
