*** Settings ***
Documentation   Golden Thread enabled Treatment Plans are constructive in nature,
...             meaning that once the patient’s presenting problems are identified,
...             the user will build the treatment plan utilizing the pre-set elements,
...             such as Modalities, Goals, Objectives, and Interventions,
...             being able to customize them on-the-go, and free-typed content.
...
Default Tags    regression    re028    points-5    golden thread story
Resource        ../../suite.robot
Suite Setup     Set up a problem list
Suite Teardown  Run Keywords    Travel "fast" to "tester" patients "screens and assessments" page in "null"
...             AND             Loop deletion    With this form "Problem List" perform these actions "delete"
...             AND             Return to mainpage
Test Teardown   Run Keywords    Run Keyword If Test Failed    Custom screenshot
...             AND             Travel "fast" to "tester" patients "treatment plans" page in "null"
...             AND             Loop deletion    With this form "Treatment Plan" perform these actions "delete"

*** Test Cases ***
Treatment plan empty creation and deletion
  Given I am on the "treatment plans" patient page
  When adding the treatment plan
  And add and delete all fields
  Then confirm the empty treatment plan

Treatment plan simple creation
  Given I am on the "treatment plans" patient page
  When adding the treatment plan
  And adding the basic fields
  Then confirm the simple treatment plan

Treatment plan complex creation
  Given I am on the "treatment plans" patient page
  When adding the treatment plan
  And adding all the fields
  Then confirm the complex treatment plan

Treatment plan objective confirmation creation
  [TAGS]    skip
  Given I am on the "treatment plans" patient page
  When adding the treatment plan

Treatment plan all goals creation
  Given I am on the "treatment plans" patient page
  When adding a golden thread form    Treatment Plan
  Then check for empty goal
  When form fill    golden thread    modality:dropdown=Alternative    problem:dropdown=Chronic Pain
  And adding the fields for chronic pain
  Then confirm the all goals treatment plan

Check for treatment plan duplication
  Given I am on the "treatment plans" patient page
  When No Operation
  Then check for treatment plan duplication

*** Keywords ***
Set up a problem list
  Travel "slow" to "tester" patients "screens and assessments" page in "${_LOCATION 1}"
  Adding a golden thread form
  Click Element    //i[${CSS SELECT.replace('$CSS','glyphicon-list')}]
  Ajax wait
  Click Element    //div[contains(text(),'Chronic Pain')]
  Click Button    Submit
  Ajax wait
  Page Should Contain    Behavioral Definition/As evidenced by (Optional)
  Travel "slow" to "tester" patients "treatment plans" page in "null"

Adding the treatment plan
  Adding a golden thread form    Treatment Plan
  Form fill    golden thread    modality:dropdown=Alternative    problem:dropdown=Chronic Pain

Add and delete all fields
  Build the treatment    Goal 1:add=null    Goal 1:add=null    Goal 1>Objective 1:add=null
  ...                    Goal 1>Objective 1:add=null    Goal 2>Objective 1:add=null    Goal 2>Objective 1:add=null
  ...                    Goal 1>Objective 1>Plan 1:add=null    Goal 1>Objective 1>Plan 1:add=null
  ...                    Goal 1>Objective 2>Plan 1:add=null    Goal 1>Objective 2>Plan 1:add=null
  ...                    Goal 2>Objective 1>Plan 1:add=null    Goal 2>Objective 1>Plan 1:add=null
  ...                    Goal 2>Objective 2>Plan 1:add=null    Goal 2>Objective 2>Plan 1:add=null
  ...                    Goal 1>Objective 1>Status 1:add=null    Goal 1>Objective 1>Status 1:add=null
  ...                    Goal 1>Objective 2>Status 1:add=null    Goal 1>Objective 2>Status 1:add=null
  ...                    Goal 2>Objective 1>Status 1:add=null    Goal 2>Objective 1>Status 1:add=null
  ...                    Goal 2>Objective 2>Status 1:add=null    Goal 2>Objective 2>Status 1:add=null
  ...                    Goal 2>Objective 2>Status 2:delete=null    Goal 2>Objective 2>Status 1:delete=null
  ...                    Goal 2>Objective 1>Status 1:delete=null    Goal 2>Objective 1>Status 1:delete=null
  ...                    Goal 1>Objective 2>Plan 2:delete=null    Goal 1>Objective 2>Plan 1:delete=null
  ...                    Goal 2>Objective 1>Plan 1:delete=null    Goal 2>Objective 1>Plan 1:delete=null
  ...                    Goal 1>Objective 1:delete=null    Goal 1>Objective 1:delete=null
  ...                    Goal 2>Objective 2:delete=null    Goal 2>Objective 1:delete=null    Goal 2:delete=null
  ...                    Goal 1:delete=null

Adding the basic fields
  Build the treatment    Goal 1:add=null    Goal 1:select=5    Goal 1>Objective 1:add=null
  ...                    Goal 1>Objective 1:select=10

Adding all the fields
  ${date} =    Convert Date    ${Todays Date}    result_format=%m/%d/%Y
  Build the treatment    Goal 1:add=null    Goal 1:add=null    Goal 1:add=null    Goal 1:select=1
  ...                    Goal 2:text=Complete all termination    Goal 3:text=\    Goal 1>Objective 1:add=null
  ...                    Goal 2>Objective 1:add=null    Goal 2>Objective 1:add=null    Goal 3>Objective 1:add=null
  ...                    Goal 3>Objective 1:add=null    Goal 3>Objective 1:add=null    Goal 2>Objective 2:select=24
  ...                    Goal 2>Objective 2>Plan 1:add=null    Goal 2>Objective 2>Plan 1:add=null
  ...                    Goal 2>Objective 2>Plan 3:text=relax with a cookie
  ...                    Goal 3>Objective 1:text=do not eat lobster    Goal 3>Objective 1>Plan 1:add=null
  ...                    Goal 3>Objective 1>Plan 1:text=Imagine a heartburn deployment
  ...                    Goal 3>Objective 1>Plan 1:freq=5 x week    Goal 3>Objective 2:select=7
  ...                    Goal 3>Objective 2>Plan 1:delete=null    Goal 1>Objective 1>Status 1:add=null
  ...                    Goal 2>Objective 1>Status 1:add=null    Goal 3>Objective 3>Status 1:add=null
  ...                    Goal 1>Objective 1>Status 1:add=null    Goal 1>Objective 1>Status 1:add=null
  ...                    Goal 3>Objective 3>Status 1:add=null    Goal 1>Objective 1>Status 1:date=11/27/2020
  ...                    Goal 2>Objective 1>Status 1:date=11/27/2020
  ...                    Goal 2>Objective 1>Status 1:list=Did not complete
  ...                    Goal 3>Objective 3>Status 1:date=11/27/2020    Goal 3>Objective 3>Status 1:text=have 9 to go
  ...                    Goal 1>Objective 1>Status 2:date=11/27/2020    Goal 1>Objective 1>Status 2:list=Completed
  ...                    Goal 1>Objective 1>Status 2:text=have 8 to go    Goal 1>Objective 1>Status 3:date=${date}
  ...                    Goal 3>Objective 3>Status 2:date=${date}    Goal 3>Objective 3>Status 2:list=Deferred
  ...                    Goal 1>Objective 1:select=25    Goal 1>Objective 1>Plan 1:add=null
  ...                    Goal 1>Objective 1>Plan 1:add=null    Goal 1>Objective 1>Plan 3:text=break the cookie
  ...                    Goal 2>Objective 1:text=eat pork    Goal 2>Objective 1>Plan 1:add=null
  ...                    Goal 2>Objective 1>Plan 1:text=a good day at nv    Goal 2>Objective 1>Plan 1:freq=1 x year
  ...                    Goal 3>Objective 3:select=5    Goal 3>Objective 3>Plan 2:delete=null
  ...                    Goal 3>Objective 3>Plan 1:delete=null    Goal 3>Objective 3>Plan 5:delete=null
  ...                    Goal 2>Objective 2>Status 1:add=null    Goal 3>Objective 1>Status 1:add=null
  ...                    Goal 3>Objective 2>Status 1:add=null    Goal 3>Objective 1>Status 1:add=null
  ...                    Goal 3>Objective 2>Status 1:add=null    Goal 3>Objective 1>Status 1:add=null
  ...                    Goal 2>Objective 2>Status 1:date=${date}    Goal 2>Objective 2>Status 1:text=have 5 to go
  ...                    Goal 3>Objective 1>Status 1:date=${date}    Goal 3>Objective 1>Status 1:list=Extended
  ...                    Goal 3>Objective 1>Status 1:text=have 4 to go    Goal 3>Objective 2>Status 1:date=11/27/2007
  ...                    Goal 3>Objective 1>Status 2:date=11/27/2007    Goal 3>Objective 1>Status 2:list=Referred
  ...                    Goal 3>Objective 2>Status 2:date=11/27/2007    Goal 3>Objective 2>Status 2:text=have 1 to go
  ...                    Goal 3>Objective 1>Status 3:date=11/27/2007    Goal 3>Objective 1>Status 3:list=Revised
  ...                    Goal 3>Objective 1>Status 3:text=DONE
  # Build the treatment    Goal 1:add=null    Goal 1:add=null    Goal 1:add=null
  # ...                    Goal 1:select=1    Goal 2:text=Complete all termination    Goal 3:text=\
  # ...                    Goal 1>Objective 1:add=null    Goal 2>Objective 1:add=null    Goal 2>Objective 1:add=null
  # ...                    Goal 3>Objective 1:add=null    Goal 3>Objective 1:add=null    Goal 3>Objective 1:add=null
  # ...
  # ...                    Goal 2>Objective 2:select=24    Goal 2>Objective 2>Plan 1:add=null
  # ...                    Goal 2>Objective 2>Plan 1:add=null    Goal 2>Objective 2>Plan 3:text=relax with a cookie
  # ...                    Goal 3>Objective 1:text=do not eat lobster    Goal 3>Objective 1>Plan 1:add=null
  # ...                    Goal 3>Objective 1>Plan 1:text=Imagine a heartburn deployment    Goal 3>Objective 1>Plan 1:freq=5 x week
  # ...                    Goal 3>Objective 2:select=7    Goal 3>Objective 2>Plan 1:delete=null
  # # ...                    Goal 3>Objective 2>Plan 1:delete=null
  # ...                    Goal 1>Objective 1>Status 1:add=null    Goal 2>Objective 1>Status 1:add=null    Goal 3>Objective 3>Status 1:add=null
  # ...                    Goal 1>Objective 1>Status 1:add=null    Goal 1>Objective 1>Status 1:add=null    Goal 3>Objective 3>Status 1:add=null
  # ...
  # ...                    Goal 1>Objective 1>Status 1:date=11/27/2020
  # ...                    Goal 2>Objective 1>Status 1:date=11/27/2020    Goal 2>Objective 1>Status 1:list=Did not complete
  # ...                    Goal 3>Objective 3>Status 1:date=11/27/2020    Goal 3>Objective 3>Status 1:text=have 9 to go
  # ...                    Goal 1>Objective 1>Status 2:date=11/27/2020    Goal 1>Objective 1>Status 2:list=Completed    Goal 1>Objective 1>Status 2:text=have 8 to go
  # ...                    Goal 1>Objective 1>Status 3:date=${date}
  # ...                    Goal 3>Objective 3>Status 2:date=${date}    Goal 3>Objective 3>Status 2:list=Deferred
  # ...
  # ...                    Goal 1>Objective 1:select=25    Goal 1>Objective 1>Plan 1:add=null
  # ...                    Goal 1>Objective 1>Plan 1:add=null    Goal 1>Objective 1>Plan 3:text=break the cookie
  # ...                    Goal 2>Objective 1:text=eat pork    Goal 2>Objective 1>Plan 1:add=null
  # ...                    Goal 2>Objective 1>Plan 1:text=a good day at nv    Goal 2>Objective 1>Plan 1:freq=1 x year
  # ...                    Goal 3>Objective 3:select=5    Goal 3>Objective 3>Plan 2:delete=null
  # ...                    Goal 3>Objective 3>Plan 1:delete=null    Goal 3>Objective 3>Plan 5:delete=null
  # ...
  # ...                    Goal 2>Objective 2>Status 1:add=null    Goal 3>Objective 1>Status 1:add=null    Goal 3>Objective 2>Status 1:add=null
  # ...                    Goal 3>Objective 1>Status 1:add=null    Goal 3>Objective 2>Status 1:add=null    Goal 3>Objective 1>Status 1:add=null
  # ...
  # ...                    Goal 2>Objective 2>Status 1:date=${date}    Goal 2>Objective 2>Status 1:text=have 5 to go
  # ...                    Goal 3>Objective 1>Status 1:date=${date}    Goal 3>Objective 1>Status 1:list=Extended    Goal 3>Objective 1>Status 1:text=have 4 to go
  # ...                    Goal 3>Objective 2>Status 1:date=11/27/2007
  # ...                    Goal 3>Objective 1>Status 2:date=11/27/2007    Goal 3>Objective 1>Status 2:list=Referred
  # ...                    Goal 3>Objective 2>Status 2:date=11/27/2007    Goal 3>Objective 2>Status 2:text=have 1 to go
  # ...                    Goal 3>Objective 1>Status 3:date=11/27/2007    Goal 3>Objective 1>Status 3:list=Revised    Goal 3>Objective 1>Status 3:text=DONE

Check for empty goal
  Run Keyword And Ignore Error    Build the treatment    Goal 1:add=null    Goal 1:select=1
  Page Should Contain Link    You can tag goals here
  Blur element    //div[starts-with(@id,'treatment_plan_goal_')]

Adding the fields for chronic pain
  Build the treatment    Goal 1:add=null    Goal 1:add=null    Goal 1:add=null    Goal 1:add=null    Goal 1:add=null
  ...                    Goal 1:add=null    Goal 1:select=1    Goal 2:select=2    Goal 3:select=3    Goal 4:select=4
  ...                    Goal 5:select=5    Goal 6:select=6    Goal 7:select=7

Validate the treatment plan
  [ARGUMENTS]    ${type}=normal
  Click Element    validate_patient_evaluation_fields
  Slow wait
  Click Element    validate_patient_evaluation_fields
  Ajax wait
  Wait Until Page Contains    Validated: no errors    1m
  Page should have    Notice    Validated: no errors
  Return From Keyword If    '${type}'=='empty'
  I hit the "Treatment Plan" text
  I hit the "Alternative Treatment Plan" text
  Custom screenshot

Confirm the empty treatment plan
  Validate the treatment plan    empty
  Page Should Not Contain Element    //div[starts-with(@id,'add_objectives_')]

Confirm the simple treatment plan
  Validate the treatment plan
  Page should have    Modality: Alternative    Problem: Chronic Pain    Goal 1    Objective 1    Plan 1

Confirm the complex treatment plan
  Validate the treatment plan
  Page should have    Modality: Alternative    Problem: Chronic Pain    Complete all termination    relax with a cookie
  ...                 do not eat lobster    Imagine a heartburn deployment    have 9 to go    have 8 to go
  ...                 break the cookie    eat pork    a good day at nv    have 5 to go    have 4 to go    have 1 to go
  ...                 DONE
  ### ^ADD MORE PLUS XPATH^

Confirm the objective refresh treatment plan
  Validate the treatment plan
  ### ^ADD MORE PLUS XPATH^

Confirm the all goals treatment plan
  Validate the treatment plan
  Page should have    Modality: Alternative    Problem: Chronic Pain
  ...                 Discontinue opioid abuse and begin a program of recovery using the 12-step process as well as necessary pain management skills.
  ...                 Regulate pain without addictive medications.
  ...                 Find relief from pain and build renewed contentment and joy in performing activities of life.
  ...                 Develop healthy options to deal with chronic pain.
  ...                 Practice a program of recovery, including 12-step involvement and pain management skills.
  ...                 Less daily suffering from pain and from substance abuse.
  ...                 Accept chronic pain and engage in life as much as possible.
  ### ^ADD MORE PLUS XPATH^

# Confirm the "${state}" treatment plan
#   Click Element    validate_patient_evaluation_fields
#   Ajax wait
#   Click Element    validate_patient_evaluation_fields
#   Ajax wait
#   Page should have    Notice    Validated: no errors
#   Run Keyword If    '${state}'=='empty'    Run Keywords    Page Should Not Contain Element    //div[starts-with(@id,'add_objectives_')]
#   ...                                      AND             Pass Execution    Treatment plan deletion options work!
#   I hit the "Treatment Plan" text
#   I hit the "Alternative Treatment Plan" text
#   Custom screenshot
#   # Run Keyword If    '${state}'=='complex'    Sleep    200

Check for treatment plan duplication
  :FOR    ${index}    IN RANGE    10
  \    Adding a golden thread form    Treatment Plan
  \    ${passes} =    Run Keyword And Return Status    Xpath Should Match X Times
  \    ...            //*[@id='${GOLDEN THREAD DATE OF SERVICES}']    1
  \    Run Keyword Unless    ${passes}    Fail    Duplication found!
  \    Go Back
  \    Loop deletion    With this form "Treatment Plan" perform these actions "delete"
