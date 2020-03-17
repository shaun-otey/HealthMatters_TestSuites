*** Settings ***
Documentation   As a user they should be able to create reports.
...
Default Tags    regression    re032    addmore    exceptions    longl
Resource        ../../suite.robot
Suite Setup     Quick reports setup
Suite Teardown  Return to mainpage
Test Teardown   Run Keywords    Run Keyword If Test Failed    Custom screenshot
...             AND             Go To    ${BASE URL}${REPORTS}

*** Test Cases ***
Create a clinical report
  ### EX
  [TEMPLATE]    Create a clinical report with the ${template} type and the ${criteria} date
  Patients               Admission Date
  #^^^
  Patients               Discharge Date
  Patients               Census
  Patients               Pre Admission
  Stats                  Admission Date
  Stats                  Discharge Date
  Stats                  Census
  Stats                  Pre Admission
  #^^^
  Urgent Issues          Unresolved
  #^^^
  Urgent Issues          Resolved
  Urgent Issues          All Issues
  Patient Evaluations    Started
  Patient Evaluations    Ready For Review
  Patient Evaluations    Treatment Plan In Use
  Patient Evaluations    Completed
  Patient Evaluations    Incomplete
  #^^^
  Group Sessions         Completed
  #^^^
  Group Sessions         Incomplete
  Single Evaluation      Admission Date
  Single Evaluation      Discharge Date
  Single Evaluation      Census
  Single Evaluation      Pre Admission
  #^^^

Create a financial report
  [TEMPLATE]    Create a financial report with the ${template} type and the ${criteria} date
  Billable                    Billable Items
  #^^^
  Billable                    Admission Date
  Billable                    Discharge Date
  Billable                    Billable & Completed Items
  Insurance Authorizations    All Authorizations
  Insurance Authorizations    Admission Date
  Insurance Authorizations    Authorization Date
  Insurance Authorizations    Created Date
  Insurance Authorizations    Discharge Date
  Insurance Authorizations    Started Date
  #^^^

Create an operations report
  [TAGS]    skip
  [TEMPLATE]    Create an operations report with the ${template} type
  Standard Business Report
  Referral Business Report
  Length of Stay Report (UR)
  Occupancy Snapshot
  Therapist Discharge Report

Create an orders report
  [TEMPLATE]    Create an orders report with the ${template} type and the ${criteria} date
  Orders    All Orders
  Orders    Discontinued Orders
  Orders    Active Orders
  MARs      All
  MARs      Taken
  MARs      Not Taken
  MARs      N/A

*** Keywords ***
Quick reports setup
  # @{date range} =    Create List    Current Census    Current Week
  @{date range} =    Create List    Current Census    Current Week    Last Week    Last 2 Weeks    Current Month
	                   ...            Last Month    Last 3 Months    Last 6 Months    Current Year    Last Year
  #                        # Custom
  @{patient selection} =    Create List    All patients    Patients without MR    Patients with MR
  Set Suite Variable    ${Date ranges}    ${date range}
  Set Suite Variable    ${Patient selections}    ${patient selection}
  I hit the "reports" tab
  I select the "My Locations" location
  New report cleanup

Create an operations report with the ${template} type

Create a financial report with the ${template} type and the ${criteria} date
  New report create    financial_button    ${template}
  Date range loop    ${criteria}
  [TEARDOWN]    New report cleanup

Create a clinical report with the ${template} type and the ${criteria} date
  New report create    clinical_button    ${template}
  ${passes} =    Evaluate
  ...            '${template}'=='Urgent Issues' or '${template}'=='Group Sessions' or '${criteria}'=='Pre Admission'
  :FOR    ${patient selection}    IN    @{Patient selections}
  \    Run Keyword And Ignore Error    Form fill    reports    patient selection:dropdown=${patient selection}
  \    Date range loop    ${criteria}    ${template}
  \    Exit For Loop If    ${passes}
  [TEARDOWN]    New report cleanup

Create an orders report with the ${template} type and the ${criteria} date
  New report create    orders_button    ${template}
  ${passes} =    Evaluate
  ...            '${template}'=='Urgent Issues' or '${template}'=='Group Sessions' or '${criteria}'=='Pre Admission'
  :FOR    ${patient selection}    IN    @{Patient selections}
  \    Run Keyword And Ignore Error    Form fill    reports    patient selection:dropdown=${patient selection}
  \    Date range loop    ${criteria}    orders bypass
  \    Exit For Loop If    ${passes}
  [TEARDOWN]    New report cleanup

New report create
  [ARGUMENTS]    ${button}    ${template}
  I hit the "New Report" view
  Click Button    ${button}
  New report setup    ${template}

New report setup
  [ARGUMENTS]    ${template}
  Ajax wait
  Form fill    reports    name=court and anger and phone    template:dropdown=${template}
  Run Keyword And Ignore Error    Dialog action    Click Button    Continue
  @{data fields} =    Return items    //a[starts-with(@id,'ui-id-')]
  :FOR    ${data field}    IN    @{data fields}
  \    Click Element    ${data field}
  \    ${id} =    Set Variable    ${data field.get_attribute('id')}
  \    ${selections} =    Return items    //div[@aria-labelledby='${id}']//input[starts-with(@id,'report_field_')]
  \    Check all selections    ${selections}
  Ajax wait
  # :FOR    ${index}    IN RANGE    1    7
  # \    Click Element    ui-id-${index}
  # \    Run Keyword If    ${index}==${1}    Run Keywords    Select Checkbox    report_field_170
  # \    ...                                 AND             Select Checkbox    report_field_176
  # \    ...    ELSE IF    ${index}==${2}    Select Checkbox    report_field_283
  # \    ...    ELSE IF    ${index}==${3}    Select Checkbox    report_field_309
  # \    ...    ELSE IF    ${index}==${4}    Select Checkbox    report_field_324
  # \    ...    ELSE IF    ${index}==${5}    Select Checkbox    report_field_392
  # \    ...               ELSE              Select Checkbox    report_field_371

New report cleanup
  Go To    ${BASE URL}${REPORTS}
  Loop deletion    Dialog action    Click Element
  ...              //a[contains(text(),'court and anger and phone')]/ancestor::tr[1]/td[last()]/a[last()]

Check all selections
  [ARGUMENTS]    ${selections}
  :FOR    ${selection}    IN    @{selections}
  \    Select Checkbox    ${selection}

Return items
  [ARGUMENTS]    ${find}
  ${passes}    ${items} =    Run Keyword And Ignore Error    Get Webelements    ${find}
  ${items} =    Run Keyword If    '${passes}'=='PASS'    Set Variable    ${items}
                ...               ELSE                   Create List
  [RETURN]    ${items}

Date range loop
  [ARGUMENTS]    ${criteria}    ${template}=${EMPTY}
  ${wait done} =    Set Variable    //div[@id='please_wait' and contains(@style,'display') and contains(@style,'none')]
  :FOR    ${date range}    IN    @{Date ranges}
  \    Continue For Loop If    '${template}'=='Group Sessions'
  \    Run Keyword If    '${template}'=='orders bypass' or '${date range}'!='Current Census'
  \    ...               Form fill    reports    criteria:dropdown=${criteria}
  \    Form fill    reports    date range:dropdown=${date range}
  \    Run Keyword And Ignore Error    Dialog action    Click Button    Update
  \    Slow wait
  \    Verify for no bad page
  \    ${passes} =    Run Keyword And Return Status    Wait Until Page Contains Element    ${wait done}    2m
  \    Run Keyword Unless    ${passes}    Run Keywords    Reload Page
  \    ...                                AND             Slow wait
  \    ...                                AND             Verify for no bad page
  \    ...                                AND             Wait Until Page Contains Element    ${wait done}    5m
  \    Verify reports output    ${date range}
  \    I hit the "Edit Report" text

Verify reports output
  [ARGUMENTS]    ${date range}
  Verify table size    //div[@id='reportResults']/table/thead/tr/th    //div[@id='reportResults']/table/tbody/tr[1]/td
  Verify table size    //div[@id='reportResults']/table/tbody/tr[2]//table[@class='authorizations']/tbody/tr[1]
  ...                  //div[@id='reportResults']/table/tbody/tr[2]//table[@class='authorizations']/tbody/tr[2]
  Page should have    Report: court and anger and phone    ${date range}
  ${passes} =    Run Keyword And Return Status    Page Should Contain Link    /downloads
  Run Keyword If    ${passes}    Verify download complete

Verify download complete
  Click Link    /downloads
  Wait Until Keyword Succeeds    8x    5s
  ...                            Run Keywords    Reload Page
  ...                            AND             Page Should Contain    Completed
  Dialog action    Click Element    //a[@data-method='delete']
  Go Back
  Go Back

Verify table size
  [ARGUMENTS]    ${header}    ${data}
  @{partial sums} =    Create List
  ${header} =    Return items    ${header}
  :FOR    ${item}    IN    @{header}
  \    ${outside width}    ${TRASH} =    Get Element Size    ${item}
  \    ${inside width} =    Set Variable    ${item.value_of_css_property('width').replace('px','')}
  \    Should Be True    ${inside width}<=${outside width}
  \    Run Keyword If    ${partial sums}    Append To List    ${partial sums}    ${outside width + @{partial sums}[-1]}
  \    ...               ELSE               Append To List    ${partial sums}    ${outside width}
  ${data} =    Return items    ${data}
  :FOR    ${index}    ${item}    IN ENUMERATE    @{data}
  \    ${outside width}    ${TRASH} =    Get Element Size    ${item}
  \    ${inside width} =    Set Variable    ${item.value_of_css_property('width').replace('px','')}
  \    Should Be True    ${inside width}<=${outside width}
  \    Run Keyword If    ${index}==0    Should Be True    @{partial sums}[${index}]==${outside width}
  \    ...               ELSE           Should Be True    @{partial sums}[${index}]==${outside width + @{partial sums}[${index-1}]}
