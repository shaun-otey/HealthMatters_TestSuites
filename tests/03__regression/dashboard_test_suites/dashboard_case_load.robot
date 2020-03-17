*** Settings ***
Documentation   Therapists with case loads.
...
Default Tags    regression    re004    dashboard story    hasprint
Resource        ../../../suite.robot
Suite Setup     Setup for case load
Suite Teardown  Return to mainpage

*** Test Cases ***
Click unassigned patients
  Given I am on the "dashboard therapist case load" page
  And I hit the "Unassigned ${Patient Handle}s" view
  And I hit the "${Test First}" text
  Then page should contain    ${Test First} ${Test Middle} ${Test Last}
  When Go Back
  Then check for all newly unassigned patients

Click Print/PDF
  [TAGS]    hasprint

Check current therapists
  Given I am on the "dashboard therapist case load" page
  When I hit the "All Therapists" view
  Then all the therapists should not have any case files assisgned

Add myself as a therapist
  Given I am on the "dashboard therapist case load" page
  When turning "on" the "Therapist" roles for "admin"
  And Go To    ${Comeback}
  Then verify all therapist role options are "shown"
  When turning "off" the "Therapist" roles for "admin"
  And Go To    ${Comeback}
  Then verify all therapist role options are "not shown"
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Turning "off" the "Therapist" roles for "admin"
  ...           AND             Go To    ${Comeback}

Assign patients to a therapist
  # [TAGS]    testmedev
  Given I am on the "dashboard therapist case load" page
  When assigning multiple patients
  And Go To    ${Comeback}
  Then confirm therapist has "some" patients
  And deassigning the patients
  And Go To    ${Comeback}
  Then confirm therapist has "no" patients
  # Ruthie R Tor caused a problem
  # Tamra R Tor caused a problem

Click scroll to top
  Given I am on the "dashboard therapist case load" page
  # And I select the "My Locations" location
  When scrolling down
  And I hit the "top" tab
  Then Location Should Contain    \#

*** Keywords ***
Setup for case load
  I hit the "dashboard" tab
  I hit the "Therapist Case Load" view
  ${comeback} =    Get Location
  Set Suite Variable    ${Comeback}    ${comeback}
  I select the "My Locations" location

Check for all newly unassigned patients
  FOR    ${name}    IN    @{Dashboard Names}
      Run Keyword And Continue On Failure    Page Should Contain    ${name.split('|')[1]}
  END

All the therapists should not have any case files assisgned
  Do search in    //td[@class='indent']    find_element_by_tag_name('span').get_attribute('innerHTML')
  ...             No Case Files Assigned

Verify all therapist role options are "${shown}"
  ${contains} =    Set Variable If    '${shown}'=='shown'    contain    not contain
  Run Keyword And Continue On Failure    Page Should ${contains} Element    //td[@class='bg_color_light']/strong[contains(text(),'${Admin First} ${Admin Last}')]
  Run Keyword And Continue On Failure    Page Should ${contains} Element    //span[contains(text(),'My case load')]

Assigning multiple patients
  ${therapist} =    Get Text    //table[@id='care-team-load-patient-table']//tr[1]//strong
  Set Test Variable    ${Main therapist}    ${therapist}
  I hit the "Unassigned ${Patient Handle}s" view
  @{names} =    Evaluate    random.sample(@{Dashboard Names},30)    random
  Set Test Variable    ${Seleceted patients}    ${names}
  FOR    ${name}    IN    @{names}
      I hit the "${name.split('|')[1]}" text
      Parse current id
      I hit the "admission" patient tab
      With this form "Assignment of Care Team" perform these actions "add;edit"
      Form fill    ct assign    primary therapist:dropdown=${Main therapist}
      Click Button    Update
      Go To    ${Comeback}
      I hit the "Unassigned ${Patient Handle}s" view
  END
  Go Back

Deassigning the patients
  FOR    ${name}    IN    @{Seleceted patients}
      I hit the "${name.split('|')[1]}" text
      Parse current id
      I hit the "admission" patient tab
      With this form "Assignment of Care Team" perform these actions "edit"
      Form fill    ct assign    primary therapist:dropdown=None
      Click Button    Update
      Ajax wait
      Dialog action    Click Element    //a[@data-method='delete']
      Go To    ${Comeback}
  END

Confirm therapist has "${value}" patients
  ${names} =    Set Variable    ${EMPTY}
  FOR    ${name}    IN    @{Seleceted patients}
      ${names} =    Catenate    ${names}    ;${name.split('|')[1]}
  END
  Run Keyword If    '${value}'=='some'    Run Keywords    Do search in    //td[@class='indent']/div[@class='wrap left']
  ...                                                     find_element_by_tag_name('a').get_attribute('innerHTML')
  ...                                                     ${names}
  ...                                     AND             Do search in    //td[@class='indent']/div[@class='wrap left']
  ...                                                     get_attribute('innerHTML')    ${Main therapist}
  ...                                     AND             Order for column is good    1
  ...                                                     null;//table[@id='care-team-load-patient-table']/tbody/tr[position()>1];//table[@id='care-team-load-patient-table']/tbody//strong[1]/ancestor::tr[1]/following-sibling::tr[1]/following::strong/ancestor::tr[1]
  ...               ELSE                  All the therapists should not have any case files assisgned
