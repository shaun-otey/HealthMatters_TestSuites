*** Settings ***
Documentation   Basic contacts functionality.
...
Default Tags    regression    re018    points-1    notester    hasprint    exceptions
Resource        ../../suite.robot
Suite Setup     Run Keywords    I hit the "contacts" tab
...                             Create tester contacts
Suite Teardown  Run Keywords    Go To    ${BASE URL}${CONTACTS}/${Contact id}/edit
...             AND             Remove contact
...             AND             Return to mainpage
Test Teardown   Run Keywords    Run Keyword If Test Failed    Custom screenshot
...             AND             Go To    ${BASE URL}${CONTACTS}

*** Test Cases ***
User can export contacts to excel
  [TAGS]    hasprint
  Given I am on the "contacts" page

User can search for contacts based on name or number
  ### EX
  [TEMPLATE]    Search for this ${name or number} should get me these ${names}
  # 800 ABC 4567    ABC Recovery
  # 800 555 HELP    Call Center
  # 561             Joe Archer,Janet Archer,John Smith
  ABC Recovery    ABC Recovery
  # Marry Sampson   Marry Sampson
  # Archer          Joe Archer,Janet Archer
  Treatment       Delray Treatment Facility;Newark Treatment Center;Palm Beach Treatment

User can filter contacts based on categories
  ### EX
  Given I am on the "contacts" page
  # When I hit the "Provider" view
  # Then check within each page    Art Teacher    Yoga Teacher
  When I hit the "Referrer" view
  Then check within each page    Family Services    Safe Space Sober Living

# User can search for contacts based on pages of contacts
#   [TAGS]    skip
#   Given I am on the "contacts" page

User can PDF or print page
  [TAGS]    hasprint
  Given I am on the "contacts" page

User can update contact with contact type, name, address, phone, fax, website, and notes
  Given I am on the "contacts" page
  When searching for "Tester Change Me"
  And I hit the "Tester Change Me" text
  And I hit the "Edit" view
  And update contact
  Then searching for "Tester I Changed"
  And I hit the "Tester I Changed" text
  And page should have    Other    Tester I Changed    somewhere    123-456-7890    090-909-0909    somesite.com    testing

User can delete contact
  Given I am on the "contacts" page
  When searching for "Tester Delete Me"
  And I hit the "Tester Delete Me" text
  And I hit the "Edit" view
  And remove contact
  # Then searching for "Tester Delete Me"
  Then check removed in each page    Tester Delete Me

Click scroll to top
  Given I am on the "contacts" page
  When scrolling down
  And I hit the "top" tab
  Then Location Should Contain    \#

*** Keywords ***
Create tester contacts
  Creating a new contact    Tester Delete Me
  Creating a new contact    Tester Change Me
  I hit the "contacts" tab
  Check within each page    Tester Delete Me    Tester Change Me
  I hit the "contacts" tab

Update contact
  Form fill    contact form    contact type:dropdown=Other    company name=Tester I Changed
  ...          street address 1=somewhere    phone=123 456 7890    fax=090 909 0909
  ...          website=somesite.com    notes=testing
  Form fill    contact form    company name=Tester I Changed
  Click Button    Update
  Ajax wait
  Click Link    //a[@class='button_back']

Check within each page
  [ARGUMENTS]    @{items}
  :FOR    ${item}    IN    @{items}
  \    Reload Page
  \    Ajax wait
  \    ${passes} =    Run Keyword And Return Status    Page Should Contain    ${item}
  \    Run Keyword If    ${passes}    Run Keyword And Ignore Error    Click Element
  \    ...                            //a[@class='ajax_browser_history' and contains(text(),'First')]
  \    ...               ELSE         Run Keywords    Click Element    //a[@class='ajax_browser_history' and contains(text(),'Next')]
  \    ...                            AND             Check within each page    ${item}

Check removed in each page
  [ARGUMENTS]    @{items}
  :FOR    ${item}    IN    @{items}
  \    Reload Page
  \    Ajax wait
  \    ${continue} =    Page Should Contain Element    //a[@class='ajax_browser_history' and contains(text(),'Next')]
  \    ${passes} =    Run Keyword And Return Status    Page Should Not Contain    ${item}
  \    Run Keyword Unless    ${passes}    Fail    The item was not removed!
  \    Run Keyword If    ${continue}    Run Keywords    Click Element    //a[@class='ajax_browser_history' and contains(text(),'Next')]
  \    ...                              AND             Check removed in each page    ${item}
  \    ...               ELSE           Run Keyword And Ignore Error    Click Element
  \    ...                              //a[@class='ajax_browser_history' and contains(text(),'First')]

Search for this ${name or number} should get me these ${names}
  Searching for "${name or number}"
  @{names} =    Split String    ${names}    ;
  Page should have    @{names}
  Go Back
