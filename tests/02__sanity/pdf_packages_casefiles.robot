*** Settings ***
Documentation   First create PDF package by clicking on your name on the top right>click PDF packages>Click New>
...             and create PDF package as needed. https://demo.kipuworks.com/pdf_packages/new
...             Once the package has been created then a user can use the package to extract data
...             from the patients charts (as specified by the items selected in the package)
...             click on Clients>click on a client>click the PDF icon on the top right (three sheets)> select which package to use and click submit.
...             User can see what packages they have downloaded by clicking their name
...             on the top right>click on downloads>open the package that is complete. https://demo.kipuworks.com/downloads
...
Default Tags    sanity    sa004    points-2    addmore
Resource        ../../suite.robot
Suite Setup     Run Keywords    Create tester pdf package
...                             Return to mainpage
...                             I select the "${_LOCATION 1}" location
Suite Teardown  Run Keywords    Return to mainpage
...             AND             I hit the "username" tab
...             AND             I hit the "PDF Packages" view
...             AND             Loop deletion    Destroy tester pdf package
...             AND             Return to mainpage

*** Test Cases ***
Generate a case file
  Given I am on the "patients" page
  And I select patient "${Test first}"
  When I hit the "gen casefile" tab
  And generate and confirm pdf with    ${EMPTY}    Facesheet Notes    PHI Forms    Page Numbers
  Then generation should be downloading

Generate a pdf
  Given I am on the "patients" page
  And I select patient "${Test first}"
  When I hit the "gen pdf" tab
  And generate and confirm pdf with    A Small Tester Package    Include Pending Forms
  Then generation should be downloading

Generate and delete a pdf
  Given I am on the "patients" page
  And I select patient "${Test first}"
  When I hit the "gen pdf" tab
  And generate and confirm pdf with    A Small Tester Package    Include Pending Forms
  Then delete the pdf

Edit a pdf package
  Given I am on the "patients" page
  And I hit the "username" tab
  And I hit the "PDF Packages" view
  When I hit the "A Small Tester Package" view
  And form fill    new pdf package    name=A Changed Tester Package
  And Click Button    Update Pdf package
  Then page should have    Notice    You have successfully updated    A Changed Tester Package
  And I hit the "PDF Packages" view
  And Page Should Contain    A Changed Tester Package
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             I hit the "A Changed Tester Package" view
  ...           AND             Form fill    new pdf package    name=A Small Tester Package
  ...           AND             Click Button    Update Pdf package
  ...           AND             Return to mainpage

*** Keywords ***
Create tester pdf package
  I hit the "username" tab
  I hit the "PDF Packages" view
  Loop deletion    Destroy tester pdf package
  Click Link    /pdf_packages/new
  Form fill    new pdf package    name=A Small Tester Package    enabled:checkbox=x    facesheet:checkbox=x
  ...          evaluations:checkbox=x    wiley:checkbox=x    body check:checkbox=x
  Click Button    Create Pdf package
  I am on the "account pdf packages" page
  Page should have    Notice    You have successfully created    A Small Tester Package

Destroy tester pdf package
  Dialog action    Click Link    //a[contains(text(),'A Small Tester Package')]/../following-sibling::td//a[2]
  I am on the "account pdf packages" page
  Page should have    Notice    Destroyed PDF Package    A Small Tester Package

Generation should be downloading
  I hit the "username" tab
  I hit the "Downloads" text
  Page should have    ${Mr Number}

Delete the pdf
  I hit the "username" tab
  I hit the "Downloads" text
  Wait Until Keyword Succeeds    24x    20s
  ...                            Run Keywords    Reload Page
  ...                            AND             Dialog action    Click Element    //a[@data-method='delete']
  Ajax wait
  Page Should Not Contain    Errors found
