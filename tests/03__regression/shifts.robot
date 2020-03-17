*** Settings ***
Documentation   Basic shift reports functionality.
...
Default Tags    regression    re019    points-2    notester    hasprint    cvcheck
Resource        ../../suite.robot
Suite Setup     Run Keywords    I hit the "shifts" tab
...                             I hit the "Shift Reports" view
...                             I select the "${_LOCATION 1}" location
...                             Create tester reports
Suite Teardown  Run Keywords    Clean up reports
...                             Return to mainpage
Test Teardown   Run Keywords    Run Keyword If Test Failed    Custom screenshot
...             AND             Go To    ${BASE URL}${SHIFTS}

*** Test Cases ***
If applicable, user can select location for new report button to generate
  Given I am on the "shifts" page
  When I select the "${_LOCATION 5}" location
  Then Page Should Contain    New report
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             I select the "${_LOCATION 1}" location
  ...           AND             Go To    ${BASE URL}${SHIFTS}

User can select radio button for new report and add text
  Given I am on the "shifts" page
  When I hit the "New report" view
  Then report box is up
  And add some text
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Cancel report
  ...           AND             Go To    ${BASE URL}${SHIFTS}

User can add attachment
  Given I am on the "shifts" page
  When I hit the "New report" view
  And report box is up
  And add some text
  And add an attachment
  And save report
  Then check for attachment
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Delete report
  ...           AND             Go To    ${BASE URL}${SHIFTS}

User can save report
  Given I am on the "shifts" page
  When I hit the "New report" view
  And report box is up
  And add some text
  Then save report
  And Page Should Contain    testing the report
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Delete report
  ...           AND             Go To    ${BASE URL}${SHIFTS}

User can cancel report
  Given I am on the "shifts" page
  When I hit the "New report" view
  And report box is up
  Then cancel report

User can edit report by clicking the pencil
  Given I select the "${_LOCATION 1}" location
  And I am on the "shifts" page
  When prepare report for editing    Edit Me
  And add some text    I Changed
  And update report
  Then Page Should Contain    I Changed
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Delete report    I Changed
  ...           AND             Go To    ${BASE URL}${SHIFTS}

User can delete report by clicking the red x
  Given I select the "${_LOCATION 1}" location
  And I am on the "shifts" page
  When delete report    Delete Me
  Then Page Should Not Contain    Delete Me

User can search shift reports in search box
  [TAGS]    needs a setup
  [SETUP]    I select the "${_LOCATION 1}" location
  [TEMPLATE]    Search for report containing ${text} should get me these ${names}
  david           David and Nolan got into an argument, however I saw that Nolan showed restraint.
  group session   Clients were rambunctious last night.\ \ Client James was attempting inappropriate relationship with female client.\ \ Please address this behavior tomorrow morning in group session.|Group Sessions 9/19/2015|Group Sessions 9/19/2015
  robby           Robby S. Stempler|Brian got into a fight with Chad.|jared got into a fight broke...

User can specify specific date range
  [TAGS]    needs a setup
  Given I am on the "shifts" page
  When I hit the "Date range" view
  And enter the date range between "11/01/2016" and "12/01/2016"
  Then Page Should Contain    David and Nolan got into an argument, however I saw that Nolan showed restraint.
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             I hit the "All" view
  ...           AND             Go To    ${BASE URL}${SHIFTS}

User can print shift reports through the printer icon
  [TAGS]    hasprint
  Given I am on the "shifts" page
  When create pdf print

User can PDF shift report through PDF icon
  [TAGS]    hasprint

User can toggle through page numbers
  [TAGS]    skip

*** Keywords ***
Create tester reports
  Clean up reports
  I hit the "New report" view
  Report box is up
  Add some text    Delete Me
  Save report
  I hit the "New report" view
  Report box is up
  Add some text    Edit Me
  Save report
  Page should have    Delete Me    Edit Me

Clean up reports
  Loop deletion    Dialog action    Click Element    //a[@data-method\='delete']

Report box is up
  Page Should Contain Element    //div[@aria-labelledby='ui-id-1']

Add an attachment
  Choose File    shift_report_image    ${Root dir}/61c8a5b82ac3a1e26d5db15341c1764a10258276b83652a0b896c8124d0e3218.jpg

Add some text
  [ARGUMENTS]    ${text}=testing the report
  Input Text    shift_report_note    ${text}

Save report
  Click Button    Save report
  Ajax wait

Update report
  Click Button    //button[.='Update report']
  Ajax wait

Cancel report
  Click Button    Cancel
  Ajax wait

Prepare report for editing
  [ARGUMENTS]    ${report}=testing the report
  ${report} =    Get report    ${report}
  Click Element    ${report.find_element_by_css_selector('a:first-child')}
  Ajax wait
  Report box is up

Delete report
  [ARGUMENTS]    ${report}=testing the report
  ${report} =    Get report    ${report}
  Dialog Action    Click Element    ${report.find_element_by_css_selector('a:last-child')}
  Ajax wait

Get report
  [ARGUMENTS]    ${report}
  ${report} =    Get Webelement    //*[contains(text(),'${report}')]/ancestor::div[1]/span
  [RETURN]    ${report}

Enter the date range between "${start date}" and "${end date}"
  Execute Javascript    $('#p_start_date').val('${start date}')
  Execute Javascript    $('#p_end_date').val('${end date}')
  Click Element At Coordinates    p_end_date    0    200
  Sleep    1
  Click Button    //button[.='Search']

Check for attachment
  [ARGUMENTS]    ${report}=testing the report
  # ${report} =    Get report    ${report}
  # Click Element    ${report.find_element_by_css_selector('a:first-child')}
  Click Link    ${report}
  Wait Until Keyword Succeeds    6x    4s
  ...                            Run Keywords    Reload Page
  ...                            AND             Slow wait    2
  ...                            AND             Page Should Not Contain Element    //img[@alt='Processing image']
  I hit the "Shift reports" text

# Search for report containing ${text} should get me these ${notes}
#   Searching for "${text}"
#   @{notes} =    Split String    ${notes}    |
#   Page should have    @{notes}
#   [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
#   ...           AND             Go To    ${BASE URL}${SHIFTS}
