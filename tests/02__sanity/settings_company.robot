*** Settings ***
Documentation   Modify company and adds a location.
...
Default Tags    sanity    sa008    points-1    settings story    notester    addmore    cvcheck
Resource        ../../suite.robot
Suite Setup     Run Keywords    I hit the "settings" tab
...                             I hit the "Company" view
...                             Edit company information
# Suite Teardown  Run Keywords    Remove the "Cortadito Suite" location
# ...                             Return to mainpage

*** Test Cases ***
Edit location
  ### EX
  Given I am on the "company" page
  # When editing the "Cortadito Suite" location
  # Then Page Should Contain    Edit location
  # And form should have these elements    value    new location    name=Cortadito Suite    short name=CS    street address=123 KipuLane    city=Miami    zip=33154    country=USA    phone=444-123-9586    fax=555-321-9568
  # [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  # ...           AND             Go Back

# You may designate a building location

# Edit the MR format and add a different logo

*** Keywords ***
Edit company information
  Click Link    /company_settings/1/edit
  Page Should Contain    Edit Company
  ${passes} =    Run Keyword And Return Status    Page Should Contain Link    /company_settings/1/destroy_logo
  Run Keyword If    ${passes}    Dialog Action    Click Link    /company_settings/1/destroy_logo
  Form fill    edit company    company=The Tired Place
  ...          logo:attachment=${Root dir}/61c8a5b82ac3a1e26d5db15341c1764a10258276b83652a0b896c8124d0e3218.jpg
  Click Button    Submit
  I am on the "company" page
  # Wait Until Page Contains Element    //a[@href='/company_settings/1/locations/new']
  # Click Link    /company_settings/1/locations/new
  # Page Should Contain    New location
  # Form fill    new location    name=Cortadito Suite    short name=CS    street address=123 KipuLane    city=Miami
  # ...          state:dropdown=Florida    zip=33154    country=USA    phone=4441239586    fax=5553219568
  # Click Button    Add
  # Page should have    The Tired Place    Cortadito Suite

Remove the "${location}" location
  Dialog Action    Click Link    //a[contains(text(),'${location}')]/../following-sibling::td/a[2]

Editing the "${location}" location
  Click Link    //a[contains(text(),'${location}')]
