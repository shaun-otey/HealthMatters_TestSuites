*** Settings ***
Documentation   Users are able to create an evaluation template by going to Templates>Evaluations>click creat new evaluation.
...             When creating an evaluation you are able to name the evaluation, place it in a tab to live in, mark it as billable,
...             select what type of evaluation it is and assign several staff signatures for permissions to the evaluation later on.
...
...             When creating a template, each sentence structure is seperated by evaluation items.
...             For example: if you are making a list of checkboxes you have to create an evaluation item that has the field type check_boxes
...
...             Evaluation Items are created by clicking "add item". Initially the item loads as a blank item and it is up to the super admin
...             or manager of templates to decide what goes in each item. Every item consists of a numerical name, a label, a label width,
...             a field type, a css style, record names, string values and matrix columns. Picking and choosing what you type
...             or use each field will determine how the sentence will look to the user in the front end.
...
...             Errors that occur when creating the evaluations are point items field type. Points items have to be created exactly as indicated,
...             if missing a coma or spacing incorrectly will cause an error 500 message when loading the form.
...
...             Test cases are based from -> /spec/features/patient_evaluations/update_spec.rb -> describe "Patient Evaluation Controller"
...
Default Tags    regression    re026    points-30    templates story    addmore
Resource        ../../suite.robot
Suite Setup     Run Keywords    I attempt to hit the "templates" tab
...             AND             I hit the "templates evaluations" tab
...             AND             Create tester template    evaluations    Testing Docker
...             AND             Setup evaluation form
...             AND             Set count id
Suite Teardown  Run Keywords    Set count id
...             AND             Delete tester template    evaluations
...             AND             Return to mainpage
Test Teardown   Run Keywords    Custom screenshot
...             AND             Remove evaluation form
...             AND             Go To    ${BASE URL}${TEMPLATES EVALUATIONS}

*** Test Cases ***
Attachment
  Given I am on the "templates evaluations" page
  When the evaluation template form of "Attachment" is created
  Then the form will be verified

Auto complete
  ### only screenshot
  Given I am on the "templates evaluations" page
  When the evaluation template form of "Auto complete optional" is created
  Then the form will be verified

# Care team aftercare coordinator optional

# Care team alumni coordinator optional

# Care team case manager optional

# Care team designated tech optional

# Care team primary nurse optional

# Care team primary physician optional

# Care team primary therapist optional

# Care team secondary therapist optional

Checkbox and checkbox first value
  Given I am on the "templates evaluations" page
  When the evaluation template form of "Checkbox and checkbox first value none" is created
  Then the form will be verified

Evaluation
  ### only screenshot
  Given I am on the "templates evaluations" page
  When the evaluation template form of "Evaluation" is created
  Then the form will be verified
  [TEARDOWN]    Run Keywords    Custom screenshot
  ...           AND             Pocket global vars    restore
  ...           AND             Remove evaluation form
  ...           AND             Go To    ${BASE URL}${TEMPLATES EVALUATIONS}
  ...           AND             I select the "My Locations" location
  ...           AND             Loop deletion    Remove old templates    Drank A
  ...           AND             Loop deletion    Remove old templates    Drank B

Drop down list
  Given I am on the "templates evaluations" page
  When the evaluation template form of "Drop down list" is created
  Then the form will be verified

Evaluation datetime and patient admission datetime and timestamp
  Given I am on the "templates evaluations" page
  When the evaluation template form of "Evaluation datetime and patient admission datetime optional and timestamp optional" is created
  Then the form will be verified

Evaluation start & end time and evaluation date and evaluation datetime and datestamp and timestamp
  ### timestamp optional and evaluation datetime ^^twice
  Given I am on the "templates evaluations" page
  When the evaluation template form of "Evaluation start & end time and evaluation date and evaluation datetime and datestamp optional and timestamp optional" is created
  Then the form will be verified

Evaluation name
  ### refine
  Given I am on the "templates evaluations" page
  When the evaluation template form of "Evaluation name" is created
  Then the form will be verified

# Evaluation name drop down

# Formatted text ?extra

# Golden thread tag

# Image

# Image with canvas

Matrix
  Given I am on the "templates evaluations" page
  When the evaluation template form of "Matrix optional" is created
  Then the form will be verified

# Notes

Patient allergies
  Given I am on the "templates evaluations" page
  When the evaluation template form of "Patient allergies" is created
  Then the form will be verified

# Patient anticipated discharge date ?check me

# Patient therapist !!!gone

# Patient bed optional

# Patient bmi

# Patient diagnosis code

# Patient diets

# Patient discharge date optional

# Patient discharge type

# Patient electronic devices

# Patient employer

# Patient ethnicity

# Patient glucose log

# Patient height weight

# Patient weight !!!gone

Patient loc clincial and ur
  Given I am on the "templates evaluations" page
  When the evaluation template form of "Patient loc clincial and ur" is created
  Then the form will be verified
  [TEARDOWN]    Run Keywords    Custom screenshot
  ...           AND             Remove this patient    Steak Shrimp Chicken
  ...           AND             Go To    ${BASE URL}${INSTANCE}
  ...           AND             Instance edit "Select From List By Label:show UR LOC${SPACE}" on "Show level of care:dropdown"
  ...           AND             Click Button    commit
  ...           AND             Ajax wait
  ...           AND             Go To    ${BASE URL}${TEMPLATES EVALUATIONS}

# Patient locker optional

# Patient marital status

Patient medication current
  ### refine
  Given I am on the "templates evaluations" page
  When the evaluation template form of "Patient medication current" is created
  Then the form will be verified
  [TEARDOWN]    Run Keywords    Custom screenshot
  ...           AND             Go To    ${comeback}
  ...           AND             Loop deletion    Remove any orders
  ...           AND             Remove evaluation form
  ...           AND             Go To    ${BASE URL}${TEMPLATES EVALUATIONS}

# Patient medication current and inventory and verification

# Patient medication inventory and verification

# Patient occupation

# Patient recurring forms

# Patient toggle mars generation ?check bottom

Patient vital signs
  ### refine
  Given I am on the "templates evaluations" page
  When the evaluation template form of "Patient vital signs" is created
  Then the form will be verified

Patient vital signs current
  ### only screenshot
  Given I am on the "templates evaluations" page
  When the evaluation template form of "Patient vital signs current" is created
  Then the form will be verified

Points and points total
  ### refine
  Given I am on the "templates evaluations" page
  When the evaluation template form of "Points optional and points total" is created
  Then the form will be verified

# Problem list

Progress note
  ### only screenshot
  Given I am on the "templates evaluations" page
  When the evaluation template form of "Progress note" is created
  Then the form will be verified

Radio button
  Given I am on the "templates evaluations" page
  When the evaluation template form of "Radio button" is created
  Then the form will be verified

# Rounds assignment

# String

Text
  Given I am on the "templates evaluations" page
  When the evaluation template form of "Text optional" is created
  Then the form will be verified

# Title

# Treatment plan column_titles

# Treatment plan goal ?extra

Treatment plan
  Given I am on the "templates evaluations" page
  When the evaluation template form of "Treatment plan" is created
  Then the form will be verified

# Treatment plan master_plan

# Treatment plan objective ?extra

# Treatment plan problem

Duplicate an item and make sure that it updates
  Given I am on the "templates evaluations" page
  And editing "evaluations" test template
  When add eval item
  And create checkbox and checkbox first value none item
  And duplicate and add an item
  Then page should have    ELEMENT|//input[@id='${EVALUATIONS FORM ITEM NAME.replace('$CID','${Cid}')}' and @value='ginger']
  ...                      ELEMENT|//input[@id='${EVALUATIONS FORM ITEM LABEL.replace('$CID','${Cid}')}' and @value='ale']
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Go To    ${BASE URL}${TEMPLATES EVALUATIONS}

Check for evaluation duplication
  Given I am on the "templates evaluations" page
  And editing "evaluations" test template
  When create an evaluation with all the items
  And save "evaluations" template
  And travel "fast" to "tester" patients "nursing" page in "${_LOCATION 1}"
  # 30x
  Then Repeat Keyword    3x    Run Keywords    Run Keyword And Continue On Failure
  ...                                          With this form "Testing Docker" perform these actions "wipe;add;view|check for simple evaluation duplication"
  ...                          AND             Go Back
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Go To    ${BASE URL}${TEMPLATES EVALUATIONS}

Evaluation linkage and version switching
  [SETUP]    Run Keywords    Connect pingmd
  ...        AND             Go To    ${BASE URL}${TEMPLATES EVALUATIONS}
  ...        AND             Setup three evaluations    Healthy Standard    Healthy Second    Healthy Pingmd
  Given I am on the "templates evaluations" page
  When I hit the "Healthy Standard" text
  Then link up with the "Healthy Second" evaluation and change versions
  When I hit the "Healthy Second" text
  Then link up with the "Healthy Standard" evaluation and change versions
  When I hit the "Healthy Standard" text
  Then link up with the "Healthy Pingmd" evaluation and change versions
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Destroy pingmd connector
  ...           AND             Go To    ${BASE URL}${TEMPLATES EVALUATIONS}
  ...           AND             Loop deletion    Remove old templates    Healthy Standard
  ...           AND             Loop deletion    Remove old templates    Healthy Second
  ...           AND             Loop deletion    Remove old templates    Healthy Pingmd
  ...           AND             Pocket global vars    restore

Auto populate a patient and check that all forms are reachable
  Given I am on the "templates evaluations" page
  And travel "slow" to "tester" patients "nursing" page in "${_LOCATION 1}"
  When with this form "null" perform these actions "wipe;auto"
  Then check that all forms are reachable
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Delete All Sessions
  ...           AND             With this form "null" perform these actions "wipe"
  ...           AND             Go To    ${BASE URL}${TEMPLATES EVALUATIONS}

Recurring assessment auto populate after 30 minutes
  [TAGS]    skip
  [SETUP]    Setup recurring evaluation    Long APH Wait
  Given I am on the "templates evaluations" page
  And editing "evaluations" test template
  When create an evaluation that is recurring
  # travel "slow" to "tester" patients "recurring assessments" page in "${_LOCATION 1}"
  And enable recurring assessment on the patient
  And I hit the "recurring assessments" patient tab
  # And travel "slow" to "tester" patients "facesheet" page in "${_LOCATION 1}"
  And with this form "Long APH Wait" perform these actions "add"
  Then Sleep    1m
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  # ...           AND             Default patient
  ...           AND             Delete tester template    evaluations
  ...           AND             Pocket global vars    restore

*** Keywords ***
The evaluation template form of "${form}" is created
  Set Test Variable    ${Eval form}    ${form}
  Editing "evaluations" test template
  Add eval item
  Run Keyword    Create ${Eval form} item
  Save "evaluations" template

The form will be verified
  Set count id
  Run Keyword    Verify ${Eval form} item

Setup evaluation form
  [ARGUMENTS]    ${process}=Nursing    &{extras}
  Editing "evaluations" test template
  Run Keyword If    ${_LOCATIONS ACTIVE}    Set To Dictionary    ${extras}    all locations:checkbox=x
  Form fill    evaluations form    enabled:checkbox=x    patient process:dropdown=${process}    &{extras}
  Save "evaluations" template

Default fill
  [ARGUMENTS]    ${item}
  ${formatted item} =    Remove String    ${item}    \ optional    \ one    \ two    \ three
  FOR    ${name}                ${field}    IN
  ...    name                   ${item}
  ...    label                  ${item}
  ...    field type:dropdown    ${formatted item}
      Form fill    evaluations form item    ${name}=${field}
      Blur element    //body
  END
  Run Keyword If    ' optional' in '${item}'    Wait Until Keyword Succeeds    3x    1s
  ...                                           Run Keywords    Form fill    evaluations form item
  ...                                                           optional:checkbox=x
  ...                                           AND             Checkbox Should Be Selected
  ...                                                           ${EVALUATIONS FORM ITEM OPTIONAL.replace('$CID','${Cid}')}
  Set count id    +1
  Slow wait

Add evaluation form
  [ARGUMENTS]    ${dupe check}=${false}
  ${check} =    Set Variable If    ${dupe check}    |Duplication check for ${Eval form} item    ${EMPTY}
  Travel "fast" to "tester" patients "nursing" page in "${_LOCATION 1}"
  With this form "Testing Docker" perform these actions "add;view${check}"

Remove evaluation form
  Travel "fast" to "tester" patients "nursing" page in "${_LOCATION 1}"
  With this form "null" perform these actions "wipe"

Duplication check for "${item}" form
  FOR    ${i}    IN RANGE    3
      ${passes} =    Run Keyword And Return Status    Duplication check for ${item} item
      Exit For Loop If    ${passes}
      Run Keyword If    ${i}==2    Fail    Duplication always happening or bad functionality!
      Remove evaluation form
      Reload Page
      With this form "Testing Docker" perform these actions "add;view"
  END


Duplicate and add an item
  Click Element    //input[@type='submit']
  Ajax wait
  Click Element    //input[@id='evaluation_evaluation_items_attributes_${Cid-1}__destroy']/../following-sibling::div[1]/a
  Ajax wait
  Form fill    evaluations form item    name=ginger    label=ale
  Click Element    //input[@type='submit']
  Ajax wait
  Run Keyword And Ignore Error    Dialog action    Reload Page

Create an evaluation with all the items
  Loop deletion    Dialog action    Click Element
  ...              //input[starts-with(@id,'evaluation_evaluation_items_attributes_')]/following-sibling::a[1]
  Set count id
  FOR    ${item}    IN
  ...    attachment    auto complete optional    care team aftercare coordinator optional
  ...    care team alumni coordinator optional    care team case manager optional    care team designated tech optional
  ...    care team primary nurse optional    care team primary physician optional
  ...    care team primary therapist optional    care team secondary therapist optional
  ...    checkbox and checkbox first value none    drop down list
  ...    evaluation datetime and patient admission datetime optional and timestamp optional
  ...    evaluation start & end time and evaluation date and evaluation datetime and datestamp optional and timestamp optional
  ...    evaluation name    evaluation name drop down    formatted text    golden thread tag    image
  ...    image with canvas    matrix optional    notes    patient allergies    anticipated patient discharge date
  ...    patient bed optional    patient bmi    patient diagnosis code    patient diets
  ...    patient discharge date optional    patient discharge type    patient electronic devices    patient employer
  ...    patient ethnicity    patient glucose log    patient height weight    patient loc clincial and ur
  ...    patient locker optional    patient marital status    patient medication current    patient occupation
  ...    patient recurring forms    patient vital signs    patient vital signs current
  ...    points optional and points total    problem list    progress note    radio button    rounds assignment
  ...    string    text optional    title    treatment plan column titles    treatment plan goal    treatment plan
  ...    treatment plan master plan    treatment plan objective    treatment plan problem
      Add eval item    ${true}
      Run Keyword And Continue On Failure    Create ${item} item
  END

Check for simple evaluation duplication
  Page should have    ELEMENT|1x|//*[contains(text(),'auto_complete')]
  # Travel "fast" to "tester" patients "nursing" page in "${_LOCATION 1}"
  # Repeat Keyword    30x
  # FOR    ${i}    IN RANGE    30
  #     With this form "Testing Docker" perform these actions "add;view"
  #     ${passes} =    Run Keyword And Return Status    Xpath Should Match X Times
  #                    ...                              //*[contains(text(),'auto_complete')]    1
  #     Run Keyword Unless    ${passes}    Run Keyword And Continue On Failure    Fail    Duplication found!
  #     Go Back
  #     With this form "null" perform these actions "wipe"
  #     Reload Page
  # END

Setup three evaluations
  [ARGUMENTS]    ${name 1}    ${name 2}    ${name 3}
  Pocket global vars    Template Id
  Create tester template    evaluations    ${name 1}
  Setup evaluation form
  Create tester template    evaluations    ${name 2}
  # Setup evaluation form    load manually:checkbox=x
  Setup evaluation form    Pre-Admission
  Create tester template    pingmd evaluations    ${name 3}
  Setup evaluation form

Link up with the "${second eval}" evaluation and change versions
  Run Keyword And Ignore Error    Form fill    evaluations form    version use:checkbox=x
  I hit the "Link evaluation" view
  Slow wait
  Click Element    //div[@id='manage_template_versions_content']//label[.='${second eval}']
  Click Button    Submit
  Slow wait
  Wait Until Page Contains Element    ${EVALUATIONS FORM VERSION UNLINK}
  Run Keyword And Ignore Error    Form fill    evaluations form    version use:checkbox=x
  Form fill    evaluations form    version select:dropdown=Version 1
  Slow wait
  Page Should Contain Element    //h1[contains(text(),'${second eval}')]
  Form fill    evaluations form    version select:dropdown=In use version
  Slow wait
  Form fill    evaluations form    version unlink:checkbox=x
  Ajax wait
  [TEARDOWN]    Go To    ${BASE URL}${TEMPLATES EVALUATIONS}

Check that all forms are reachable
  ${cookie} =    Get Cookie    _session_id
  ${session} =    Create Dictionary    _session_id=${cookie.value}
  Create Session    te    ${BASE URL}    verify=True    cookies=${session}
  ${view links} =    Collect type of links    //div[@id='sub_nav_content']/table[@class='grid_index']/tbody/tr[position()>1]/td[1]/a
                     ...                      href
  ${edit links} =    Collect type of links    //div[@id='sub_nav_content']/table[@class='grid_index']/tbody/tr[position()>1]/td[last()]/span[1]/a[not(@data-method='delete')]
                     ...                      href
  ${links} =    Combine Lists    ${view links}    ${edit links}
  FOR    ${link}    IN    @{links}
      ${response} =    Run Keyword    ${link[1]} Request    te    ${link[0]}
      ${response} =    Set Variable    ${response.text}
      Log    ${response}
      Run Keyword And Continue On Failure    Should Not Contain Any    ${response}    @{500 ERRORS}
  END


Setup recurring evaluation
  [ARGUMENTS]    ${name}
  Pocket global vars    Template Id
  Create tester template    evaluations    ${name}

Create an evaluation that is recurring
  Form fill    evaluations form    enabled:checkbox=x    patient process:dropdown=Recurring Assessments
  ...          show p photo h:checkbox=x    load manually:checkbox=x    recurring:checkbox=x    interval in min=30
  ...          daily overview:checkbox=x
  Run Keyword If    ${_LOCATIONS ACTIVE}    Form fill    evaluations form    all locations:checkbox=x
  Save "evaluations" template

Enable recurring assessment on the patient
  Travel "slow" to "tester" patients "facesheet" page in "${_LOCATION 1}"
  Select Checkbox    //label[.='Long APH Wait']/following-sibling::input[1]
  Ajax wait
  Update facesheet    enable recurring:checkbox=x


Create attachment item
  Default fill    attachments

Duplication check for attachment item
  Page should have    ELEMENT|1x|//div[@class='button_add']/a/span[.='Add attachment']

Verify attachment item
  ${image} =    Set Variable    61c8a5b82ac3a1e26d5db15341c1764a10258276b83652a0b896c8124d0e3218.jpg
  Add evaluation form    ${true}
  Page should have    NOT|ELEMENT|//a/img[contains(@src,'images/item_attachments')]
  ...                 NOT|ELEMENT|//a[contains(text(),'Delete Attachment')]/img[@alt='Icon delete']    attachments
  I hit the "Add attachment" text
  Page should have    NOT|ELEMENT|//a/img[contains(@src,'images/item_attachments')]
  ...                 ELEMENT|//a[contains(text(),'Delete Attachment')]/img[@alt='Icon delete']
  I hit the "Nursing" text
  Reload Page
  With this form "Testing Docker" perform these actions "view"
  Form fill    ${EMPTY}    patient_evaluation_item_attachments_attributes_0_image:direct_attachment=${Root Dir}/${image}
  Wait Until Keyword Succeeds    5x    3s
  ...                            Page should have    ELEMENT|//a/img[contains(@src,'images/item_attachments')]
  ...                            ELEMENT|//a[contains(text(),'Delete Attachment')]/img[@alt='Icon delete']
  Custom screenshot
  Run Keyword And Continue On Failure    Fail    Fake screenshot!
  I hit the "Nursing" text
  Reload Page
  With this form "Testing Docker" perform these actions "view"
  Page should have    ELEMENT|//a/img[contains(@src,'images/item_attachments')]
  ...                 ELEMENT|//a[contains(text(),'Delete Attachment')]/img[@alt='Icon delete']
  I hit the "Delete Attachment" text
  Page should have    NOT|ELEMENT|//a/img[contains(@src,'images/item_attachments')]
  ...                 NOT|ELEMENT|//a[contains(text(),'Delete Attachment')]/img[@alt='Icon delete']
  I hit the "Nursing" text
  Reload Page
  With this form "Testing Docker" perform these actions "view"
  Page should have    NOT|ELEMENT|//a/img[contains(@src,'images/item_attachments')]
  ...                 NOT|ELEMENT|//a[contains(text(),'Delete Attachment')]/img[@alt='Icon delete']


Create auto complete optional item
  Form fill    evaluations form    item record names=Exam reveals a___ year old____ who is awake, alert, cooperative and friendly during exam. Skin is intact, warm and dry. Normal color. HEENT Eyes normal EOMI,PEARLA, normal conjunctivae, normal orpharynx. 20/20 vision right and left eye. Ears - hearing - normal whisper and Rinne test. Mouth and throat; mucus membrane color pink and moist, good dentition, no noted oral lesion Neck No thyromegaly, lymphadenopathy, masses, bruits. Lungs are clear to auscultation bilaterally. Good respiratory effort. The chest wall is symmetrical in nature and moves appropriately with respirations. Cardiovascular exam reveals the HEART to be regular in rate and rhythm. No murmur, gallops, rubs or thrills appreciated in sitting up position, leaning forward and patient to lateral decubitus. S1S2 are single, there is no S3,S4. no carotid bruit or thrills. Distal pulses are equal and intact bilaterally and are of normal amplitude. There are no chronic venous or arterial changes on the lower extemities. There is no peripheral edema. Abdominal exam was benign. Soft, non-distended, non-tender to soft and deep palpation. normal active bowel sounds x 4 quad. No noted bruits in aortic, renal, iliac area. non tender CVA percussion. GU/Rectal: NA Neurological: CN II-XII normal DTR normal Musculoskeletal: Gait normal, Motor strength 5/5 all joints
  Default fill    auto_complete

Verify auto complete optional item
  Add evaluation form
  Custom screenshot


Create care team aftercare coordinator optional item
  # Form fill    evaluations form    .
  Default fill    care_team.Aftercare_Coordinator

Verify care team aftercare coordinator optional item
  Add evaluation form
  Custom screenshot


Create care team alumni coordinator optional item
  # Form fill    evaluations form    .
  Default fill    care_team.Alumni_Coordinator

Verify care team alumni coordinator optional item
  Add evaluation form
  Custom screenshot


Create care team case manager optional item
  # Form fill    evaluations form    .
  Default fill    care_team.Case_Manager

Verify care team case manager optional item
  Add evaluation form
  Custom screenshot


Create care team designated tech optional item
  # Form fill    evaluations form    .
  Default fill    care_team.Designated_Tech

Verify care team designated tech optional item
  Add evaluation form
  Custom screenshot


Create care team primary nurse optional item
  # Form fill    evaluations form    .
  Default fill    care_team.Primary_Nurse

Verify care team primary nurse optional item
  Add evaluation form
  Custom screenshot


Create care team primary physician optional item
  # Form fill    evaluations form    .
  Default fill    care_team.Primary_Physician

Verify care team primary physician optional item
  Add evaluation form
  Custom screenshot


Create care team primary therapist optional item
  # Form fill    evaluations form    .
  Default fill    care_team.Primary_Therapist

Verify care team primary therapist optional item
  Add evaluation form
  Custom screenshot


Create care team secondary therapist optional item
  # Form fill    evaluations form    .
  Default fill    care_team.Secondary_Therapist

Verify care team secondary therapist optional item
  Add evaluation form
  Custom screenshot


Create checkbox and checkbox first value none item
  Set Test Variable    ${Long name 1}    Medical condition
  Set Test Variable    ${Long name 2}    Psychiatric diagnosis
  Set Test Variable    ${Long name 3}    Financial
  Set Test Variable    ${Long name 4}    Outside obligations
  Set Test Variable    ${Long name 5}    Language
  Set Test Variable    ${Long name 6}    Cultural
  Set Test Variable    ${Long name 7}    Family pressures
  Set Test Variable    ${Long name 8}    External forces:
  Set Test Variable    ${Long name 9}    Other:
  Set Test Variable    ${Long name 10}    None
  Set Test Variable    ${Long name 11}    Substance Abuse
  Set Test Variable    ${Long name 12}    Criminal Involvement
  Set Test Variable    ${Long name 13}    Mental Health Problems
  Form fill    evaluations form item    record names=${Long name 1}|${Long name 2}|${Long name 3}|${Long name 4}|${Long name 5}|${Long name 6}|${Long name 7}|${Long name 8}|${Long name 9}
  ...          show string=|||||||true|true    placeholder=|||||||Explain|Explain
  Default fill    check_box one
  Click Link    Add item
  Ajax wait
  Form fill    evaluations form item    record names=${Long name 1}|${Long name 2}|${Long name 3}|${Long name 4}|${Long name 5}|${Long name 6}|${Long name 7}|${Long name 8}|${Long name 9}
  ...          show string=|||||||true|true    placeholder=|||||||Explain|Explain
  ...          css style:dropdown=check_boxes_as_list
  Default fill    check_box two
  Click Link    Add item
  Ajax wait
  Form fill    evaluations form item    record names=${Long name 10}|${Long name 11}|${Long name 12}|${Long name 13}
  Default fill    check_box_first_value_none one
  Click Link    Add item
  Ajax wait
  Form fill    evaluations form item    record names=${Long name 10}|${Long name 11}|${Long name 12}|${Long name 13}
  ...          css style:dropdown=check_boxes_as_list
  Default fill    check_box_first_value_none two

Verify checkbox and checkbox first value none item
  Add evaluation form
  FOR    ${item}    IN
  ...    check_box one    check_box two    check_box_first_value_none one    check_box_first_value_none two
      Page should have    ${item}    ELEMENT|1x|//div[contains(text(),'${item}')]
  END
  FOR    ${item}    IN
  ...    ${Long name 1}    ${Long name 2}    ${Long name 3}    ${Long name 4}    ${Long name 5}    ${Long name 6}
  ...    ${Long name 7}    ${Long name 10}    ${Long name 11}    ${Long name 12}    ${Long name 13}
      Page should have    ${item}
      ...                 ELEMENT|1x|//label[contains(text(),'${item}')]/following-sibling::input[@type='checkbox' and ${CSS SELECT.replace('$CSS','center')}]
      ...                 ELEMENT|1x|//label[contains(text(),'${item}')]/preceding-sibling::input[@type='checkbox' and ${CSS SELECT.replace('$CSS','normal')}]
  END
  FOR    ${item}    IN    ${Long name 8}    ${Long name 9}
      Page should have    ${item}
      ...                 ELEMENT|2x|//label[contains(text(),'${item}')]/following-sibling::input[@placeholder='Explain']
      ...                 ELEMENT|1x|//label[contains(text(),'${item}')]/preceding-sibling::input[@type='checkbox' and ${CSS SELECT.replace('$CSS','normal')}]
  END
  Page should have    ELEMENT|2x|//label[contains(text(),'${Long name 10}')]/parent::div[1]/input[@type='checkbox' and starts-with(@onclick,'jqUnCheckAllButFirst')]
  FOR    ${item}    IN    ${Long name 11}    ${Long name 12}    ${Long name 13}
      Page should have    ELEMENT|2x|//label[contains(text(),'${item}')]/parent::div[1]/input[@type='checkbox' and starts-with(@onclick,'jqUnCheckFirst')]
  END


Create evaluation item
  Go Back
  Pocket global vars    Template Id
  Create tester template    evaluations    Drank A
  ${id a} =    Set Variable    ${Template Id}
  Create tester template    evaluations    Drank B
  ${id b} =    Set Variable    ${Template Id}
  Pocket global vars    restore
  Editing "evaluations" test template
  Add eval item
  FOR    ${index}    ${id}    IN ENUMERATE    ${id a}    ${id b}
      Run Keyword If    ${index}>0    Click Link    Add item
      Ajax wait
      Form fill    evaluations form    item matrix names=${id}
      Default fill    create_evaluation
  END

Verify evaluation item
  Add evaluation form
  # :FOR    ${item}    IN
  # ...     //input[@class='submittable_wait_bar eval_create_radios' and @type='radio' and contains(text(),'Totally')]
  # ...     //input[@class='submittable_wait_bar eval_create_radios' and @type='radio' and contains(text(),'Not Really')]
  # \    Run Keyword And Continue On Failure    Page Should Contain Element    ${item}
  # \    Run Keyword And Continue On Failure    Xpath Should Match X Times    ${item}    1
  Custom screenshot
  # Sleep    10
  # <form accept-charset="UTF-8" action="/patients/304/patient_evaluations/2606" class="edit_patient_evaluation" data-remote="true" enctype="multipart/form-data" id="edit_patient_evaluation_2606" method="post"><div style="display:none"><input name="utf8" type="hidden" value="✓"><input name="_method" type="hidden" value="put"><input name="authenticity_token" type="hidden" value="eTt189fqYKQH4FozP2JqItJtViSKY907w/bxOmIIxI8="></div>
  #   <br>
  #   <div class="flash-messages">
  # <div id="4060a697e2ed2729c98d3450494b1d36" class="notification-error mbottom1em">
  #   <h2>
  #     Errors found
  #     <a class="right" data-toggle="close" data-target="#4060a697e2ed2729c98d3450494b1d36"><b>x</b></a>
  #   </h2>
  #     <p>Evaluation #(849) contains an invalid create evaluation id or the evaluation to be created is not allowed for this patient location. Please contact your SUPER-ADMIN</p>
  # </div>
  #   </div>
  #   <div class="form_wrap">
  #       <div id="patient_evaluation_item_69586" class="patient_evaluation_item show " %="">
  #           <div class="item_title mleft10px">
  #                 create_evaluation
  #           </div>
  #     <div class="left">
  #         <div class="mtop03 mright10px">
  #           <input checked="checked" class="submittable_wait_bar" id="patient_evaluation_eval_creates_attributes_0_value_true" name="patient_evaluation[eval_creates_attributes][0][value]" type="radio" value="true">
  #           Yes
  #         </div>
  #     </div>
  #     <div class="left">
  #         <div class="mtop03 mright10px">
  #           <input class="submittable_wait_bar" id="patient_evaluation_eval_creates_attributes_0_value_false" name="patient_evaluation[eval_creates_attributes][0][value]" type="radio" value="false">
  #           No
  #         </div>
  #     </div>
  # <input id="patient_evaluation_eval_creates_attributes_0_id" name="patient_evaluation[eval_creates_attributes][0][id]" type="hidden" value="16">
  #         <div style="clear:both"></div>
  #       </div>
  #       <div id="patient_evaluation_item_69587" class="patient_evaluation_item show " %="">
  #           <div class="item_title mleft10px">
  #                 create_evaluation
  #           </div>
  #     <div class="left">
  #         <div class="mtop03 mright10px">
  #           <input checked="checked" class="submittable_wait_bar" id="patient_evaluation_eval_creates_attributes_1_value_true" name="patient_evaluation[eval_creates_attributes][1][value]" type="radio" value="true">
  #           Yes
  #         </div>
  #     </div>
  #     <div class="left">
  #         <div class="mtop03 mright10px">
  #           <input class="submittable_wait_bar" id="patient_evaluation_eval_creates_attributes_1_value_false" name="patient_evaluation[eval_creates_attributes][1][value]" type="radio" value="false">
  #           No
  #         </div>
  #     </div>
  # <input id="patient_evaluation_eval_creates_attributes_1_id" name="patient_evaluation[eval_creates_attributes][1][id]" type="hidden" value="17">
  #         <div style="clear:both"></div>
  #       </div>
  #     <input id="signature" name="signature" type="hidden">
  #     <input id="signature_pad_type" name="signature_pad_type" type="hidden">
  #     <input id="process" name="process" type="hidden" value="48">
  #     <input id="focus_field" name="focus_field" type="hidden" value="">
  #     <input id="reload_form" name="reload_form" type="hidden" value="false">
  #     <input id="guardian_id" name="guardian_id" type="hidden">
  #   </div>
  #   <!-- # show existing signatures -->
  #   <!-- render the patient signature -->
  # <br>
  #   <!-- This is for flash notice when signers are added/removed from the 'manage signer' dialog  -->
  #   <div class="_50">
  #     <div id="manage-signers-ajax-change"></div>
  #   </div>
  #   <div class="clear"></div>
  #   <p>
  #     <input class="submit_button ui-button ui-widget ui-state-default ui-corner-all" data-disable-with="Working..." id="form_submit" name="patient_evaluation[auto_submit]" type="submit" value="Update" role="button" aria-disabled="false">
  #   </p>
  #   <button id="validate_patient_evaluation_fields" class="ui_button ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" type="button" role="button" aria-disabled="false"><span class="ui-button-text">
  #     Validate assessment
  #   </span></button>
  #   <!-- optional patient signature -->
  #   <!-- end -->
  #   <!-- dont show manage signers if the patient evaluation is completed or does not require staff signatures -->
  #   <a class="ui_button ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" href="/patients/304/patient_evaluations/2606?process=48" role="button" aria-disabled="false"><span class="ui-button-text">Preview/print view</span></a>
  #   <div class="no_print right">
  #     <a data-confirm="Are you sure?" data-disable-with="Working..." data-method="delete" href="/patients/304/patient_evaluations/2606?patient=304&amp;process=48"><img alt="Icon delete" class="icon22" src="/assets/ui/icon_delete.png">delete </a>
  #   </div>
  #   <!-- we need this button to open the signature pad -->
  #     <button id="open-signature-dialog" ,="" style="display:none"></button>
  #     <!-- we need this, will render signature pad in here -->
  #     <div id="sign_pad">
  #     </div>
  # </form>


Create drop down list item
  Form fill    evaluations form    item record names=1 | 2 | 3
  Default fill    drop_down_list

Verify drop down list item
  Add evaluation form
  @{items} =    Get List Items    patient_evaluation_eval_strings_attributes_0_description
  @{compare} =    Create List    ${EMPTY}    1${SPACE}    ${SPACE}2${SPACE}    ${SPACE}3
  Lists Should Be Equal    ${items}    ${compare}
  FOR    ${item}    IN
  ...    //div[contains(text(),'drop_down_list')]
  ...    //select[@id='patient_evaluation_eval_strings_attributes_0_description']
      Page should have    ELEMENT|1x|${item}
  END


Create evaluation datetime and patient admission datetime optional and timestamp optional item
  FOR    ${type}    IN
  ...    evaluation_datetime    patient.admission_datetime    patient.admission_datetime optional    timestamp
  ...    timestamp optional
      Default fill    ${type}
      Run Keyword Unless    '${type}'=='timestamp optional'    Click Link    Add item
      Ajax wait
  END

Verify evaluation datetime and patient admission datetime optional and timestamp optional item
  Travel "fast" to "tester" patients "nursing" page in "${_LOCATION 1}"
  Slow wait    41
  Repeat Keyword    6x    Run Keywords    With this form "Testing Docker" perform these actions "add"
  ...                     AND             Run Keyword And Continue On Failure    Page Should Contain Element
  ...                                     //a[.='Testing Docker']
  ...                     AND             With this form "null" perform these actions "wipe"
  ...                     AND             Slow wait    10
  Add evaluation form
  &{dates} =    Create Dictionary
  FOR    ${item}    IN
  ...    evaluation_datetime    patient.admission_datetime    patient.admission_datetime optional    timestamp
  ...    timestamp optional
      Page should have    ${item}
      ${count} =    Set Variable If    '${item}'=='patient.admission_datetime' or '${item}'=='timestamp'    2    1
      Page should have    ELEMENT|${count}x|//div[contains(text(),'${item}')]
      ${date} =    Get Value    //div[contains(text(),'${item}')]/following-sibling::div[1]//input[@type='text']
      Run Keyword If    '${item}'=='evaluation_datetime'    Set To Dictionary    ${dates}    standard ${item}=${date}
      ${date} =    Convert Date    ${date}    epoch    False    %m/%d/%Y %I:%M %p
      Set To Dictionary    ${dates}    ${item}=${date}
  END
  Should Be Equal As Numbers    &{dates}[patient.admission_datetime]    &{dates}[patient.admission_datetime optional]
  Should Be Equal As Numbers    &{dates}[timestamp]    &{dates}[timestamp optional]
  Should Not Be Equal As Numbers    &{dates}[evaluation_datetime]    &{dates}[patient.admission_datetime]
  I hit the "Nursing" text
  Page should have    ELEMENT|//a[.='Testing Docker &{dates}[standard evaluation_datetime]']
  # Page should have    ...    ...
  # ${date} =    Convert Date    ${Todays Date}    result_format=%m/%d/%Y
  # ${date} =    Set Variable    ${date} 12:00 AM
  # Form fill    ${EMPTY}    ...=${date}    ...=${date}
  # Click Button    Update
  # Ajax wait
  # Custom screenshot
  # ... Preview
  # Page should have    ...    ...
  # Run Keyword And Continue On Failure    Page Should Contain    ${date}
  # Run Keyword And Continue On Failure    Xpath Should Match X Times    //*[contains(text(),'${date}')]    2
  # #   visit edit_patient_patient_evaluation_path(patient_id: @patient.id, id: @patient_evaluation.id, override: true, process: @patient_process.id)
  # #   # fill_in 'patient_evaluation_eval_timestamps_attributes_4_timestamp', with: '12/02/2016 12:29PM'
  # #   page.execute_script("$('#patient_evaluation_eval_timestamps_attributes_4_timestamp').datepicker('setDate', '12/05/2016 08:33AM')")
  # #   # page.execute_script("$('#patient_evaluation_eval_timestamps_attributes_4_timestamp').val('12/05/2016 08:33AM')")
  # #   page.execute_script("$('input[name=\"patient_evaluation[auto_submit]\"]').click()")
  # #   save_and_open_page
  # #   page.execute_script("$('input[type=\"submit\"]').click()")
  # #   # visit edit_patient_patient_evaluation_path(patient_id: @patient.id, id: @patient_evaluation.id, override: true, process: @patient_process.id)
  # #   expect(page).to have_field('patient_evaluation_eval_timestamps_attributes_4_timestamp', with: '12/05/2016 08:33AM')
  # # end
  # Verify patient admission datetime optional item
  # #   visit edit_patient_patient_evaluation_path(patient_id: @patient.id, id: @patient_evaluation.id, override: true, process: @patient_process.id)
  # #   fill_in 'patient_evaluation_eval_timestamps_attributes_1_timestamp', with: '11/15/2016 12:00 AM6'
  # #   find("input[id='form_submit']").click
  # #   visit edit_patient_patient_evaluation_path(patient_id: @patient.id, id: @patient_evaluation.id, override: true, process: @patient_process.id)
  # #   expect(page).to have_field('patient_evaluation_eval_timestamps_attributes_1_timestamp', with: '11/15/2016 12:00 AM')
  # # end
  # Verify timestamp optional item
  # #   visit edit_patient_patient_evaluation_path(patient_id: @patient.id, id: @patient_evaluation.id, override: true, process: @patient_process.id)
  # #   # fill_in 'patient_evaluation_eval_timestamps_attributes_4_timestamp', with: '12/02/2016 12:29PM'
  # #   page.execute_script("$('#patient_evaluation_eval_timestamps_attributes_4_timestamp').datepicker('setDate', '12/05/2016 08:33AM')")
  # #   # page.execute_script("$('#patient_evaluation_eval_timestamps_attributes_4_timestamp').val('12/05/2016 08:33AM')")
  # #   page.execute_script("$('input[name=\"patient_evaluation[auto_submit]\"]').click()")
  # #   save_and_open_page
  # #   page.execute_script("$('input[type=\"submit\"]').click()")
  # #   # visit edit_patient_patient_evaluation_path(patient_id: @patient.id, id: @patient_evaluation.id, override: true, process: @patient_process.id)
  # #   expect(page).to have_field('patient_evaluation_eval_timestamps_attributes_4_timestamp', with: '12/05/2016 08:33AM')
  # # end


Create evaluation start & end time and evaluation date and evaluation datetime and datestamp optional and timestamp optional item
  FOR    ${type}    IN
  ...    evaluation_start_and_end_time    evaluation_date    evaluation_datetime    datestamp    datestamp optional
  ...    timestamp    timestamp optional
      Default fill    ${type}
      Run Keyword Unless    '${type}'=='timestamp optional'    Click Link    Add item
      Ajax wait
  END

Verify evaluation start & end time and evaluation date and evaluation datetime and datestamp optional and timestamp optional item
  Add evaluation form
  &{dates} =    Create Dictionary
  FOR    ${item}    IN
  ...    evaluation_start_and_end_time    evaluation_date    evaluation_datetime    datestamp    datestamp optional
  ...    timestamp    timestamp optional
      Page should have    ${item}
      ${count} =    Set Variable If    '${item}'=='evaluation_date' or '${item}'=='datestamp' or '${item}'=='timestamp'
                    ...                2    1
      Page should have    ELEMENT|${count}x|//div[contains(text(),'${item}')]
      ${date} =    Get Value    //div[contains(text(),'${item}')]/following-sibling::div[1]//input[@type='text']
      Set To Dictionary    ${dates}    ${item}=${date}
  END
  Run Keyword And Continue On Failure    Convert Date    &{dates}[evaluation_start_and_end_time]
  ...                                    date_format=%m/%d/%Y %I:%M %p
  Run Keyword And Continue On Failure    Convert Date    &{dates}[evaluation_date]    date_format=%m/%d/%Y
  Run Keyword And Continue On Failure    Convert Date    &{dates}[evaluation_datetime]    date_format=%m/%d/%Y %I:%M %p
  Run Keyword And Continue On Failure    Should Be Empty    &{dates}[datestamp]
  Run Keyword And Continue On Failure    Should Be Empty    &{dates}[datestamp optional]
  Run Keyword And Continue On Failure    Should Be Empty    &{dates}[timestamp]
  Run Keyword And Continue On Failure    Should Be Empty    &{dates}[timestamp optional]
  # Verify evaluation start & end time item
  #   scenario 'Evaluation Start & End Time' do
  #   visit edit_patient_patient_evaluation_path(patient_id: @patient.id, id: @patient_evaluation.id, override: true, process: @patient_process.id)
  #   fill_in 'patient_evaluation[start_time]', with: '12/21/2016 09:20AM'
  #   find("input[id='form_submit']").click
  #   expect(page).to have_field('patient_evaluation[start_time]', with: '12/21/2016 09:20AM')
  #   save_and_open_page
  #   # visit edit_patient_patient_evaluation_path(patient_id: @patient.id, id: @patient_evaluation.id, override: true, process: @patient_process.id)
  # end
  # Verify evaluation date item
  #   visit edit_patient_patient_evaluation_path(patient_id: @patient.id, id: @patient_evaluation.id, override: true, process: @patient_process.id)
  #   # expect(@patient_evaluation.evaluation_date).to equal(nil)
  #   fill_in 'patient_evaluation_evaluation_date', with: '11/30/2016'
  #   find("input[id='form_submit']").click
  #   visit edit_patient_patient_evaluation_path(patient_id: @patient.id, id: @patient_evaluation.id, override: true, process: @patient_process.id)
  #   expect(page).to have_field('patient_evaluation_evaluation_date', with: '11/30/2016')
  # Verify datestamp optional item
  #   visit edit_patient_patient_evaluation_path(patient_id: @patient.id, id: @patient_evaluation.id, override: true, process: @patient_process.id)
  #   fill_in 'patient_evaluation_eval_timestamps_attributes_0_timestamp', with: '11/30/2016'
  #   find("input[id='form_submit']").click
  #   visit edit_patient_patient_evaluation_path(patient_id: @patient.id, id: @patient_evaluation.id, override: true, process: @patient_process.id)
  #   expect(page).to have_field('patient_evaluation_eval_timestamps_attributes_0_timestamp', with: '11/30/2016')
  #   Given I am on the "patients" page
  #   And I select patient "${TEST FIRST}"
  #   When I verify the datestamp


Create evaluation name item
  Form fill    evaluations form    item record names=Totally|Not Really    item matrix names=1 | 2
  Default fill    create_evaluation

Verify evaluation name item
  Add evaluation form
  Page should have    create_evaluation    Totally    Not Really
  # :FOR    ${item}    IN
  # ...     //div[contains(text(),'Totally')]
  # ...     //div[contains(text(),'Not Really')]
  # # ...     //div[contains(text(),'Totally')]//input[@class='submittable_wait_bar eval_create_radios' and @type='radio']
  # # ...     //div[contains(text(),'Not Really')]//input[@class='submittable_wait_bar eval_create_radios' and @type='radio']
  # \    Run Keyword And Continue On Failure    Page Should Contain Element    ${item}
  # \    Run Keyword And Continue On Failure    Xpath Should Match X Times    ${item}    1
  Custom screenshot
  #   visit edit_patient_patient_evaluation_path(patient_id: @patient.id, id: @patient_evaluation.id, override: true, process: @patient_process.id)
#   fill_in 'patient_evaluation_evaluation_name', with: 'Test Name'
#   find("input[id='form_submit']").click
#   visit edit_patient_patient_evaluation_path(patient_id: @patient.id, id: @patient_evaluation.id, override: true, process: @patient_process.id)
#   expect(page).to have_field('patient_evaluation_evaluation_name', with: 'Test Name')


Create evaluation name drop down item
  # Form fill    evaluations form    .
  Default fill    evaluation_name_drop_down

Verify evaluation name drop down item
  Add evaluation form
  Custom screenshot


Create formatted text item
  # Form fill    evaluations form    .
  Default fill    formatted_text

Verify formatted text item
  Add evaluation form
  Custom screenshot


Create golden thread tag item
  # Form fill    evaluations form    .
  Default fill    golden_thread_tag

Verify golden thread tag item
  Add evaluation form
  Custom screenshot


Create image item
  # Form fill    evaluations form    .
  Default fill    image

Verify image item
  Add evaluation form
  Custom screenshot


Create image with canvas item
  # Form fill    evaluations form    .
  Default fill    image_with_canvas

Verify image with canvas item
  Add evaluation form
  Custom screenshot


Create matrix optional item
  Set Test Variable    ${Long name 1}    Valium / Ativan
  Set Test Variable    ${Long name 2}    Librium / Klonopin
  Set Test Variable    ${Long name 3}    Other
  Set Test Variable    ${Matrix 1}    DRUG TYPE – SUBSTANCES
  Set Test Variable    ${Matrix 2}    AGE BEGAN FIRST USE
  Set Test Variable    ${Matrix 3}    LAST TIME USED
  Set Test Variable    ${Matrix 4}    FREQUENCY of Use
  Set Test Variable    ${Matrix 5}    AMOUNT OF USE / PATTERN OF USE
  Set Test Variable    ${Matrix 6}    ROUTE
  Set Test Variable    ${Matrix 7}    Date
  Set Test Variable    ${Matrix 8}    Charges
  Set Test Variable    ${Matrix 9}    Duration/Location
  Set Test Variable    ${Matrix 10}    Disposition
  Form fill    evaluations form    item record names=${Long name 1}| ${Long name 2}| ${Long name 3}
  ...          item matrix names=${Matrix 1}| ${Matrix 2}| ${Matrix 3}| ${Matrix 4}| ${Matrix 5}| ${Matrix 6}
  Default fill    matrix
  Click Link    Add item
  Ajax wait
  Form fill    evaluations form    item matrix names=${Matrix 7}|${Matrix 8}|${Matrix 9}|${Matrix 10}
  Default fill    matrix optional

Verify matrix optional item
  Add evaluation form
  Page should have    ELEMENT|22x|//textarea[starts-with(@id,'patient_evaluation_eval_matrices_attributes_')]
  ...                 matrix    matrix optional    ${Long name 1}    ${Long name 2}    ${Long name 3}    ${Matrix 1}
  ...                 ${Matrix 2}    ${Matrix 3}    ${Matrix 4}    ${Matrix 5}    ${Matrix 6}    ${Matrix 7}
  ...                 ${Matrix 8}    ${Matrix 9}    ${Matrix 10}
  FOR    ${index}    IN RANGE    18
      ${y} =    Evaluate    ${index}//6
      ${x} =    Evaluate    1 + ${index}%6
      Page should have    ELEMENT|patient_evaluation_eval_matrices_attributes_${y}_field${x}
  END
  # Xpath Should Match X Times    //textarea[starts-with(@id,'patient_evaluation_eval_matrices_attributes_')]    4
  FOR    ${index}    IN RANGE    4
      ${y} =    Evaluate    ${index}//4
      ${x} =    Evaluate    1 + ${index}%4
      Page should have    ELEMENT|patient_evaluation_eval_matrices_attributes_${y}_field${x}
  END


Create notes item
  # Form fill    evaluations form    .
  Default fill    notes

Verify notes item
  Add evaluation form
  Custom screenshot


Create patient allergies item
  Default fill    patient.allergies

Duplication check for patient allergies item
  FOR    ${element}    IN
  ...    //div[${CSS SELECT.replace('$CSS','item_title')} and contains(text(),'patient.allergies')]
  ...    //input[@checked='checked']/following-sibling::strong[.='No Known Allergies/NKA']
  ...    //div[@class='button_add']/a/span[.='Add Allergy']
      Page should have    ELEMENT|1x|${element}
  END

Verify patient allergies item
  Add evaluation form    ${true}
  Page should have    patient.allergies    No Known Allergies/NKA    Add Allergy
  Duplication check for "patient allergies" form
  I hit the "Validate assessment" text
  Page should have    Notice    Validated: no errors
  Form fill    ${EMPTY}    patient_evaluation_patient_attributes_has_no_allergy:direct_check=o
  Click Button    Update
  Ajax wait
  I hit the "Validate assessment" text
  Page should have    Errors found
  ...                 patient.allergies: 'No Known Allergies/NKA' verification or at least one allergy.
  I hit the "Add Allergy" text
  Click Button    Update
  Ajax wait
  I hit the "Validate assessment" text
  Page should have    Errors found    allergies:    Allergen can't be blank
  Form fill    ${EMPTY}    patient_evaluation_allergies_attributes_0_allergen:direct_text=QualitySource
  ...          patient_evaluation_allergies_attributes_0_allergy_type:direct_drop=Environmental
  ...          patient_evaluation_allergies_attributes_0_reaction:direct_text=Apathy
  ...          patient_evaluation_allergies_attributes_0_reaction_type:direct_text=Adverse Reaction
  ...          patient_evaluation_allergies_attributes_0_onset:direct_js=01/24/2019
  ...          patient_evaluation_allergies_attributes_0_treatment:direct_text=Transfer Me Out
  ...          patient_evaluation_allergies_attributes_0_status_type:direct_drop=Inactive
  ...          patient_evaluation_allergies_attributes_0_source:direct_drop=Self-Reported
  Click Button    Update
  Ajax wait
  I hit the "Validate assessment" text
  Page should have    Notice    Validated: no errors\
  I hit the "information" patient tab
  Click Link    Edit ${Patient Handle}
  Page should have    ELEMENT|//input[@id='patient_allergies_attributes_0_allergen' and @value='QualitySource']
  ...                 ELEMENT|//select[@id='patient_allergies_attributes_0_allergy_type']/option[@selected='selected' and @value='environmental/seasonal']
  ...                 ELEMENT|//input[@id='patient_allergies_attributes_0_reaction' and @value='Apathy']
  ...                 ELEMENT|//select[@id='patient_allergies_attributes_0_reaction_type']/option[@selected='selected' and @value='Adverse Reaction']
  ...                 ELEMENT|//input[@id='patient_allergies_attributes_0_onset' and @value='01/24/2019']
  ...                 ELEMENT|//input[@id='patient_allergies_attributes_0_treatment' and @value='Transfer Me Out']
  ...                 ELEMENT|//select[@id='patient_allergies_attributes_0_status_type']/option[@selected='selected' and @value='Inactive']
  ...                 ELEMENT|//select[@id='patient_allergies_attributes_0_source']/option[@selected='selected' and @value='Self-Reported']
  Update facesheet    allergen=NoneType1179
  I hit the "nursing" patient tab
  With this form "Testing Docker" perform these actions "edit"
  Page should have    ELEMENT|//input[@id='patient_evaluation_allergies_attributes_0_allergen' and @value='NoneType1179']
  ...                 ELEMENT|//select[@id='patient_evaluation_allergies_attributes_0_allergy_type']/option[@selected='selected' and @value='environmental/seasonal']
  ...                 ELEMENT|//input[@id='patient_evaluation_allergies_attributes_0_reaction' and @value='Apathy']
  ...                 ELEMENT|//select[@id='patient_evaluation_allergies_attributes_0_reaction_type']/option[@selected='selected' and @value='Adverse Reaction']
  ...                 ELEMENT|//input[@id='patient_evaluation_allergies_attributes_0_onset' and @value='01/24/2019']
  ...                 ELEMENT|//input[@id='patient_evaluation_allergies_attributes_0_treatment' and @value='Transfer Me Out']
  ...                 ELEMENT|//select[@id='patient_evaluation_allergies_attributes_0_status_type']/option[@selected='selected' and @value='Inactive']
  ...                 ELEMENT|//select[@id='patient_evaluation_allergies_attributes_0_source']/option[@selected='selected' and @value='Self-Reported']
  Click Link    Delete Allergy
  Ajax wait
  Form fill    ${EMPTY}    patient_evaluation_patient_attributes_has_no_allergy:direct_check=x
  Click Button    Update
  Ajax wait
  I hit the "Validate assessment" text
  Page should have    Notice    Validated: no errors


Create anticipated patient discharge date item
  # Form fill    evaluations form    .
  Default fill    patient.anticipated_discharge_date

Verify anticipated patient discharge date item
  Add evaluation form
  Custom screenshot


# Create patient therapist item
#   Add eval item
#   Form fill    evaluations form    .
#   Default fill    .
#
# Verify patient therapist item
#   Add evaluation form
# #   @user = FactoryGirl.create :user, roles: [:super_admin, :therapist]
# #           FactoryGirl.create :user, roles: [:kipu_staff]
# #   visit edit_patient_patient_evaluation_path(patient_id: @patient.id, id: @patient_evaluation.id, override: true, process: @patient_process.id)
# #   select(@user.full_name, from: 'patient_evaluation_assigned_therapist_attributes_0_primary_therapist')
# #   visit edit_patient_patient_evaluation_path(patient_id: @patient.id, id: @patient_evaluation.id, override: true, process: @patient_process.id)
# #   expect(page).to have_select('patient_evaluation_assigned_therapist_attributes_0_primary_therapist', selected: @user.full_name)


Create patient bed optional item
  # Form fill    evaluations form    .
  Default fill    patient.bed
  # Click Link    Add item
  # Ajax wait
  # Form fill    evaluations form    .
  # Default fill    patient.bed optional

Verify patient bed optional item
  Add evaluation form
  Custom screenshot
#   location = FactoryGirl.create :location_with_buildings_rooms_beds
#   building = FactoryGirl.create :building
#   room = FactoryGirl.create :room, building_id: building.id, location_id: location.id
#   bed = FactoryGirl.create :bed, room_id: room.id, location_id: location.id
#   visit edit_patient_patient_evaluation_path(patient_id: @patient.id, id: @patient_evaluation.id, override: true, process: @patient_process.id)
#   select(bed.bed_name, from: 'patient_evaluation_patient_attributes_bed_name')
#   visit edit_patient_patient_evaluation_path(patient_id: @patient.id, id: @patient_evaluation.id, override: true, process: @patient_process.id)
#   expect(page).to have_select('patient_evaluation_patient_attributes_bed_name', selected: bed.bed_name)


Create patient bmi item
  # Form fill    evaluations form    .
  Default fill    patient.bmi

Verify patient bmi item
  Add evaluation form
  Custom screenshot


Create patient diagnosis code item
  # Form fill    evaluations form    .
  Default fill    patient.diagnosis_code

Verify patient diagnosis code item
  Add evaluation form
  Custom screenshot


Create patient diets item
  # Form fill    evaluations form    .
  Default fill    patient.diets

Verify patient diets item
  Add evaluation form
  Custom screenshot


Create patient discharge date optional item
  # Form fill    evaluations form    .
  Default fill    patient.discharge_datetime
  # Click Link    Add item
  # Ajax wait
  # Form fill    evaluations form    .
  # Default fill    patient.discharge_datetime optional

Verify patient discharge date optional item
  Add evaluation form
  Custom screenshot
# #   visit edit_patient_patient_evaluation_path(patient_id: @patient.id, id: @patient_evaluation.id, override: true, process: @patient_process.id)
# #   # fill_in 'patient_evaluation_eval_timestamps_attributes_2_timestamp', with: '11/30/2016'
# #   page.execute_script("$('#patient_evaluation_eval_timestamps_attributes_2_timestamp').val('11/30/2016')")
# #   find("input[id='form_submit']").click
# #   visit edit_patient_patient_evaluation_path(patient_id: @patient.id, id: @patient_evaluation.id, override: true, process: @patient_process.id)
# #   expect(page).to have_field('patient_evaluation_eval_timestamps_attributes_2_timestamp', with: '11/30/2016')
# # end


Create patient discharge type item
  # Form fill    evaluations form    .
  Default fill    patient.discharge_type

Verify patient discharge type item
  Add evaluation form
  Custom screenshot
#   discharge_type = FactoryGirl.create :patient_setting, related_field: 'discharge_type'
#   visit edit_patient_patient_evaluation_path(patient_id: @patient.id, id: @patient_evaluation.id, override: true, process: @patient_process.id)
#   select(discharge_type.name, from: 'discharge_type_select')
#   visit edit_patient_patient_evaluation_path(patient_id: @patient.id, id: @patient_evaluation.id, override: true, process: @patient_process.id)
#   expect(page).to have_select('discharge_type_select', selected: discharge_type.name)


Create patient electronic devices item
  # Form fill    evaluations form    .
  Default fill    patient.electronic_devices

Verify patient electronic devices item
  Add evaluation form
  Custom screenshot


Create patient employer item
  # Form fill    evaluations form    .
  Default fill    patient.employer

Verify patient employer item
  Add evaluation form
  Custom screenshot
#   visit edit_patient_patient_evaluation_path(patient_id: @patient.id, id: @patient_evaluation.id, override: true, process: @patient_process.id)
#   fill_in 'patient_evaluation_patient_attributes_employer_name', with: 'Test Employer'
#   find("input[id='form_submit']").click
#   visit edit_patient_patient_evaluation_path(patient_id: @patient.id, id: @patient_evaluation.id, override: true, process: @patient_process.id)
#   expect(page).to have_field('patient_evaluation_patient_attributes_employer_name', with: 'Test Employer')


Create patient ethnicity item
  # Form fill    evaluations form    .
  Default fill    patient.ethnicity

Verify patient ethnicity item
  Add evaluation form
  Custom screenshot
#   ethnicity = FactoryGirl.create :patient_setting, related_field: 'ethnicity'
#   visit edit_patient_patient_evaluation_path(patient_id: @patient.id, id: @patient_evaluation.id, override: true, process: @patient_process.id)
#   select(ethnicity.name.titleize, from: 'patient_evaluation_patient_attributes_ethnicity')
#   visit edit_patient_patient_evaluation_path(patient_id: @patient.id, id: @patient_evaluation.id, override: true, process: @patient_process.id)
#   expect(page).to have_select('patient_evaluation_patient_attributes_ethnicity', selected: ethnicity.name.titleize)


Create patient glucose log item
  # Form fill    evaluations form    .
  Default fill    patient.glucose_log

Verify patient glucose log item
  Add evaluation form
  Custom screenshot


Create patient height weight item
  # Form fill    evaluations form    .
  Default fill    patient.height_weight

Verify patient height weight item
  Add evaluation form
  Custom screenshot


# Create patient weight item
#   Add eval item
#   Form fill    evaluations form    .
#   Default fill    .
#
# Verify patient weight item
#   Add evaluation form
# #   visit edit_patient_patient_evaluation_path(patient_id: @patient.id, id: @patient_evaluation.id, override: true, process: @patient_process.id)
# #   fill_in 'patient_evaluation_patient_attribute_histories_attributes_0_value', with: '150'
# #   find("input[id='form_submit']").click
# #   visit edit_patient_patient_evaluation_path(patient_id: @patient.id, id: @patient_evaluation.id, override: true, process: @patient_process.id)
# #   expect(page).to have_field('patient_evaluation_patient_attribute_histories_attributes_0_value', with: '150')


Create patient loc clincial and ur item
  Default fill    patient.level_of_care_clinical
  Click Link    Add item
  Ajax wait
  Default fill    patient.level_of_care_ur

Verify patient loc clincial and ur item
  Return to mainpage
  I select the "${_LOCATION 1}" location
  # I create a valid patient    Steak    Shrimp    Chicken    10/01/2018
  I create a valid patient    Steak    Shrimp    Chicken    03/29/2018
  Update facesheet    admission date:js=03/29/2018 12:00 PM    discharge date:js=06/27/2018 12:00 PM
  Travel "fast" to "current" patients "nursing" page in "null"
  With this form "Testing Docker" perform these actions "add;edit"
  Page should have
  FOR    ${item}    IN    patient.level_of_care_clinical    patient.level_of_care_ur
      Page should have    ${item}    ELEMENT|1x|//*[contains(text(),'${item}')]
  END
  Form fill    ${EMPTY}    patient_evaluation_patient_locs_attributes_0_care_level_date:direct_js=03/29/2018
  ...          patient_evaluation_patient_locs_attributes_0_care_level:direct_drop=Detox
  ...          patient_evaluation_patient_locs_attributes_1_care_level_date:direct_js=03/29/2018
  ...          patient_evaluation_patient_locs_attributes_1_care_level:direct_drop=IOP
  Click Button    Update
  Ajax wait
  ${clinical} =    Set Variable    //a[contains(text(),'Clinical LOC: Detox')]
  ${ur} =    Set Variable    //a[contains(text(),'UR LOC: IOP')]
  ${days} =    Set Variable    /span[contains(text(),'(90)')]
  FOR    ${index}    ${option}    IN ENUMERATE
  ...    hide LOC    show clinical LOC    show UR LOC${SPACE}    show clinical and UR LOC
      Go To    ${BASE URL}${INSTANCE}
      Instance edit "Select From List By Label:${option}" on "Show level of care:dropdown"
      Click Button    commit
      Ajax wait
      Travel "slow" to "current" patients "information" page in "null"
      Run Keyword If    ${index}==0    Page should have    NOT|ELEMENT|${clinical}    NOT|ELEMENT|${ur}
      ...    ELSE IF    ${index}==1    Page should have    ELEMENT|${clinical}    ELEMENT|${clinical}${days}
      ...    ELSE IF    ${index}==2    Page should have    ELEMENT|${ur}    ELEMENT|${ur}${days}
      ...               ELSE           Page should have    ELEMENT|${clinical}    ELEMENT|${clinical}${days}
      ...                              ELEMENT|${ur}    ELEMENT|${ur}${days}
  END


Create patient locker optional item
  # Form fill    evaluations form    .
  Default fill    patient.locker
  # Click Link    Add item
  # Ajax wait
  # Form fill    evaluations form    .
  # Default fill    patient.locker optional

Verify patient locker optional item
  Add evaluation form
  Custom screenshot
#   visit edit_patient_patient_evaluation_path(patient_id: @patient.id, id: @patient_evaluation.id, override: true, process: @patient_process.id)
#   fill_in 'patient_evaluation_patient_attributes_locker', with: '2'
#   find("input[id='form_submit']").click
#   visit edit_patient_patient_evaluation_path(patient_id: @patient.id, id: @patient_evaluation.id, override: true, process: @patient_process.id)
#   expect(page).to have_field('patient_evaluation_patient_attributes_locker', with: '2')


Create patient marital status item
  # Form fill    evaluations form    .
  Default fill    patient.marital_status

Verify patient marital status item
  Add evaluation form
  Custom screenshot
#   marital_status = FactoryGirl.create :patient_setting, related_field: 'marital_status'
#   visit edit_patient_patient_evaluation_path(patient_id: @patient.id, id: @patient_evaluation.id, override: true, process: @patient_process.id)
#   select(marital_status.name.capitalize, from: 'patient_evaluation_patient_attributes_marital_status')
#   visit edit_patient_patient_evaluation_path(patient_id: @patient.id, id: @patient_evaluation.id, override: true, process: @patient_process.id)
#   expect(page).to have_select('patient_evaluation_patient_attributes_marital_status', selected: marital_status.name.capitalize)


Create patient medication current item
  # Form fill    .
  Default fill    patient.medication_current

Verify patient medication current item
  Travel "fast" to "current" patients "medical orders" page in "${_LOCATION 1}"
  ${comeback} =    Log Location
  Create a doctor order    medication
  Add evaluation form
  Page should have    patient.medication_current    Bently 200mg/1, topical every 8 hours for 99 days
  Custom screenshot
  [TEARDOWN]    Run Keywords    Go To    ${comeback}
  ...           AND             Loop deletion    Remove any orders


Create patient medication inventory item
  # Form fill    .
  Default fill    patient.medication_inventory

Verify patient medication inventory item
  Add evaluation form
  Page should have    patient.medication_inventory
  Custom screenshot


Create patient medication verification item
  Default fill    patient.medication_verification

Verify patient medication verification item
  Add evaluation form
  I hit the "Add medication" text
  Form fill    ${EMPTY}    patient_evaluation_patient_orders_attributes_0_patient_order_items_attributes_0_medication:direct_text=Neurontin
  ...          patient_evaluation_patient_orders_attributes_0_patient_order_items_attributes_0_route:direct_drop=OPTH - Both
  ...          patient_evaluation_patient_orders_attributes_0_patient_order_items_attributes_0_dose:direct_text=200 mg
  ...          patient_evaluation_patient_orders_attributes_0_patient_order_items_attributes_0_patient_order_item_frequency:direct_drop=every 6 hours
  ...          patient_evaluation_patient_orders_attributes_0_brought_in_on_admission:direct_check=x
  ...          patient_evaluation_patient_orders_attributes_0_continue_on_admission:direct_check=x
  Form fill    ${EMPTY}    patient_evaluation_patient_orders_attributes_0_instructed_by:direct_text=QA Doc
  ...          patient_evaluation_patient_orders_attributes_0_instructed_via:direct_drop=previously prescribed medication approved by doctor
  Click Button    Update
  Ajax wait
  ${comeback} =    Log Location
  I hit the "medical orders" patient tab
  Run Keyword And Continue On Failure    Page Should Contain    Neurontin, 200 mg OPTH - Both every 6 hours
  I hit the "med log" patient tab
  Run Keyword And Continue On Failure    Page Should Contain    Neurontin 200 mg OPTH - Both
  Go To    ${comeback}
  Form fill    ${EMPTY}    patient_evaluation_patient_orders_attributes_0_continue_on_admission:direct_check=o
  Click Button    Update
  I hit the "medical orders" patient tab
  Run Keyword And Continue On Failure    Page Should Not Contain    Neurontin, 200 mg OPTH - Both every 6 hours
  I hit the "med log" patient tab
  Run Keyword And Continue On Failure    Page Should Not Contain    Neurontin 200 mg OPTH - Both


Create patient occupation item
  # Form fill    evaluations form    .
  Default fill    patient.occupation

Verify patient occupation item
  Add evaluation form
  Custom screenshot
#   visit edit_patient_patient_evaluation_path(patient_id: @patient.id, id: @patient_evaluation.id, override: true, process: @patient_process.id)
#   fill_in 'patient_evaluation_patient_attributes_occupation', with: 'Developer'
#   find("input[id='form_submit']").click
#   visit edit_patient_patient_evaluation_path(patient_id: @patient.id, id: @patient_evaluation.id, override: true, process: @patient_process.id)
#   expect(page).to have_field('patient_evaluation_patient_attributes_occupation', with: 'Developer')


Create patient recurring forms item
  # Form fill    evaluations form    .
  Default fill    patient.recurring_forms

Verify patient recurring forms item
  Add evaluation form
  Custom screenshot
#   evaluation = FactoryGirl.create :evaluation, recurring: true, enabled: true
#   visit edit_patient_patient_evaluation_path(patient_id: @patient.id, id: @patient_evaluation.id, override: true, process: @patient_process.id)
#   find(:css, "#patient_evaluation_ids_2").set(true)
#   visit edit_patient_patient_evaluation_path(patient_id: @patient.id, id: @patient_evaluation.id, override: true, process: @patient_process.id)
#   check_box_1 = find("#patient_evaluation_ids_2")
#   expect(check_box_1).to be_checked


Create patient toggle mars generation item
  Form fill    evaluations form    .
  Default fill    ...

Verify patient toggle mars generation item
  Add evaluation form
#   visit edit_patient_patient_evaluation_path(patient_id: @patient.id, id: @patient_evaluation.id, override: true, process: @patient_process.id)
#   find(:css, "#toggle_mars_generation_check_box").set(false)
#   visit edit_patient_patient_evaluation_path(patient_id: @patient.id, id: @patient_evaluation.id, override: true, process: @patient_process.id)
#   check_box_1 = find("#toggle_mars_generation_check_box")
#   expect(check_box_1).not_to be_checked


Create patient vital signs item
  # Form fill    evaluations form    .
  Default fill    patient.vital_signs

Verify patient vital signs item
  Add evaluation form
  Form fill    ${EMPTY}    patient_evaluation_vital_signs_attributes_0_blood_pressure_systolic:direct_text=75
  ...          patient_evaluation_vital_signs_attributes_0_blood_pressure_diastolic:direct_text=76
  ...          patient_evaluation_vital_signs_attributes_0_temperature:direct_text=77
  ...          patient_evaluation_vital_signs_attributes_0_pulse:direct_text=78
  ...          patient_evaluation_vital_signs_attributes_0_respirations:direct_text=79
  ...          patient_evaluation_vital_signs_attributes_0_o2_saturation:direct_text=80
  Click Button    Update
  Ajax wait
  I hit the "med log" patient tab
  # //table[${CSS SELECT.replace('$CSS','vital_signs_data')}]//tr[1]/td[3]//a
  Click Element    //div[@id='${VITAL SIGNS}']/ancestor::tr[1]/td[2]//a
  Ajax wait
  Page should have    75    76    77.0    78    79    80
  Click Button    Close
  I hit the "nursing" patient tab
  With this form "Testing Docker" perform these actions "delete;add;view"
  I hit the "Hx" text
  Ajax wait
  Custom screenshot
  ${before date} =    Get Text    //table[@id='vital-signs-table']/tbody/tr[1]/td[last()]
  ${date}    ${time} =    Split To Lines    ${before date}
  ${before date} =    Convert Date    ${date} ${time.rsplit(maxsplit=1)[0]}    epoch    False    %m/%d/%y %I:%M %p
  Click Button    Close
  Form fill    ${EMPTY}    patient_evaluation_vital_signs_attributes_0_blood_pressure_systolic:direct_text=98
  ...          patient_evaluation_vital_signs_attributes_0_blood_pressure_diastolic:direct_text=97
  ...          patient_evaluation_vital_signs_attributes_0_temperature:direct_text=96
  ...          patient_evaluation_vital_signs_attributes_0_pulse:direct_text=95
  ...          patient_evaluation_vital_signs_attributes_0_respirations:direct_text=94
  ...          patient_evaluation_vital_signs_attributes_0_o2_saturation:direct_text=93
  Click Button    Update
  Slow wait    61
  I hit the "Hx" text
  Ajax wait
  Custom screenshot
  ${after date} =    Get Text    //table[@id='vital-signs-table']/tbody/tr[1]/td[last()]
  ${date}    ${time} =    Split To Lines    ${after date}
  ${after date} =    Convert Date    ${date} ${time.rsplit(maxsplit=1)[0]}    epoch    False    %m/%d/%y %I:%M %p
  Click Button    Close
  I hit the "med log" patient tab
  Click Element    //div[@id='${VITAL SIGNS}']/ancestor::tr[1]/td[2]//a
  Ajax wait
  Page should have    75    76    77.0    78    79    80    98    97    96.0    95    94    93
  Run Keyword And Continue On Failure    Should Not Be Equal As Integers    ${before date}    ${after date}
  Click Button    Close
  I hit the "nursing" patient tab
  Travel "fast" to "tester" patients "nursing" page in "${_LOCATION 1}"
  With this form "Testing Docker" perform these actions "delete;add;delete"
  I hit the "med log" patient tab
  Click Element    //div[@id='${VITAL SIGNS}']/ancestor::tr[1]/td[2]//a
  Ajax wait
  ${history} =    Get Webelements    //table[@id='vital-signs-table']/tbody/tr[1]/td
  Custom screenshot
  Run Keyword And Continue On Failure    Length Should Be    ${history}    2
  Click Button    Close


Create patient vital signs current item
  # Form fill    evaluations form    .
  Default fill    patient.vital_signs_current

Verify patient vital signs current item
  Add evaluation form
  Page should have    patient.vital_signs_current    no vital signs on file
  Custom screenshot


Create points optional and points total item
  Set Test Variable    ${Long name 1}    '0 – Not at all'\=>'0'
  Set Test Variable    ${Long name 2}    '1 – Slightly'\=>'1'
  Set Test Variable    ${Long name 3}    '2 – Moderately'\=>'2'
  Set Test Variable    ${Long name 4}    '3 – Considerably'\=>'3'
  Set Test Variable    ${Long name 5}    '4 – Extremely'\=>'4'
  Set Test Variable    ${Long name 6}    'Maybe'\=>'4'
  FOR    ${number}    IN    one    two    three
      Form fill    evaluations form    item points group=a
      ...          item record names=${Long name 1}, ${Long name 2}, ${Long name 3}, ${Long name 4}, ${Long name 5}, ${Long name 6}
      Default fill    points_item ${number}
      Click Link    Add item
      Ajax wait
  END
  Form fill    evaluations form    item points group=b
  ...          item record names=${Long name 1}, ${Long name 2}, ${Long name 3}, ${Long name 4}, ${Long name 5}, ${Long name 6}
  Default fill    points_item optional
  Click Link    Add item
  Ajax wait
  Form fill    evaluations form    item points group=a
  Default fill    points_total one
  Click Link    Add item
  Ajax wait
  Form fill    evaluations form    item points group=b
  Default fill    points_total two

Verify points optional and points total item
  Add evaluation form
  FOR    ${index}    ${item}    IN ENUMERATE    2 – Moderately    3 – Considerably    4 – Extremely    4 – Extremely
      Form fill    ${EMPTY}
      ...          patient_evaluation_patient_evaluation_items_attributes_${index}_points:direct_drop=${item}
  END
  Click Button    Update
  Reload Page
  FOR    ${item}    IN
  ...    points_item one    points_item one    points_item two    points_item three    points_total one
  ...    points_total two
      Page should have    ${item}    ELEMENT|1x|//*[contains(text(),'${item}')]
  END
  FOR    ${index}    ${item}    IN ENUMERATE    2 – Moderately    3 – Considerably    4 – Extremely    4 – Extremely
      Page should have    ELEMENT|//select[@id='patient_evaluation_patient_evaluation_items_attributes_${index}_points']/option[@selected='selected' and .='${item}']
  END
  FOR    ${index}    IN RANGE    4
      Page should have    NOT|ELEMENT|//select[@id='patient_evaluation_patient_evaluation_items_attributes_${index}_points']/option[@selected='selected' and .='Maybe']
  END
  Page should have    ELEMENT|//div[contains(text(),'points_total one')]/following-sibling::div[1]/div[contains(text(),'9')]
  ...                 ELEMENT|//div[contains(text(),'points_total two')]/following-sibling::div[1]/div[contains(text(),'4')]

Create problem list item
  # Form fill    evaluations form    .
  Default fill    problem_list

Verify problem list item
  Add evaluation form
  Custom screenshot


Create progress note item
  Default fill    progress_note

Duplication check for progress note item
  Page should have    ELEMENT|1x|//div[@class='button_add']/a/span[.='Golden Thread']
  ...                 ELEMENT|1x|//textarea[@id='progress_note_text_field']

Verify progress note item
  Travel "fast" to "tester" patients "nursing" page in "${_LOCATION 1}"
  Repeat Keyword    6x    Run Keywords    With this form "Testing Docker" perform these actions "add;edit|Duplication check for progress note item"
  ...                     AND             Go Back
  ...                     AND             With this form "null" perform these actions "wipe"
  ...                     AND             Slow wait    2
  Add evaluation form    ${true}
  Custom screenshot


Create radio button item
  Form fill    evaluations form    item record names=Yes|No
  Default fill    radio_buttons

Verify radio button item
  Add evaluation form
  Page should have    radio_buttons
  FOR    ${item}    IN
  ...    //input[@class='submittable_wait_bar' and @type='radio' and @value='Yes']
  ...    //input[@class='submittable_wait_bar' and @type='radio' and @value='No']
      Page should have    ELEMENT|1x|${item}
  END


Create rounds assignment item
  # Form fill    evaluations form    .
  Default fill    rounds_assignment

Verify rounds assignment item
  Add evaluation form
  Custom screenshot


Create string item
  # Form fill    evaluations form    .
  Default fill    string

Verify string item
  Add evaluation form
  Custom screenshot
#   visit edit_patient_patient_evaluation_path(patient_id: @patient.id, id: @patient_evaluation.id, override: true, process: @patient_process.id)
#   fill_in 'patient_evaluation_eval_strings_attributes_2_description', with: 'String Value'
#   find("input[id='form_submit']").click
#   visit edit_patient_patient_evaluation_path(patient_id: @patient.id, id: @patient_evaluation.id, override: true, process: @patient_process.id)
#   expect(page).to have_field('patient_evaluation_eval_strings_attributes_2_description', with: 'String Value')


Create text optional item
  Form fill    evaluations form    item record names=No    item placeholder=If Yes, elaborate
  Default fill    text
  Click Link    Add item
  Ajax wait
  Form fill    evaluations form    item record names=No    item placeholder=If Yes, elaborate
  Default fill    text optional

Verify text optional item
  Add evaluation form
  Select Checkbox    patient_evaluation_patient_evaluation_items_attributes_0_item_value
  Ajax wait
  Page should have    text    text optional    No
  Page should have    ELEMENT|2x|//textarea[contains(@placeholder,'If Yes, elaborate')]
  Element Should Not Be Visible    patient_evaluation_eval_texts_attributes_1_description


Create title item
  # Form fill    evaluations form    .
  Default fill    title

Verify title item
  Add evaluation form
  Custom screenshot


Create treatment plan column titles item
  # Form fill    evaluations form    .
  Default fill    treatment_plan_column_titles

Verify treatment plan column titles item
  Add evaluation form
  Custom screenshot


Create treatment plan goal item
  # Form fill    evaluations form    .
  Default fill    treatment_plan_goal

Verify treatment plan goal item
  Add evaluation form
  Custom screenshot


Create treatment plan item
  Set Test Variable    ${Long name 1}    I will describe current functioning in self-care, and how this relates to my substance abuse.
  Set Test Variable    ${Long name 2}    Request that the patient prepare an inventory of positive and negative functioning regarding self-care, including the relationship between lack of self-care and substance abuse. Ask the patient to identify a trusted individual from whom he/she can obtain helpful feedback regarding daily hygiene and cleanliness; coordinate feedback from this individual to the patient. Assess the patient’s basic nutritional knowledge and skills, usual diet, and nutritional deficiencies; refer to a dietitian, if necessary.
  Form fill    evaluations form    item record names=${Long name 1} | ${Long name 2}| |
  Default fill    treatment_plan_item

Verify treatment plan item
  Add evaluation form
  I hit the "Add status" text
  Ajax wait
  FOR    ${item}    IN
  ...    treatment_plan_item    Add status    Target date    Status    Date/Comment    ${Long name 1}    ${Long name 2}
      Page should have    ${item}
      ...                 ELEMENT|1x|//*[contains(text(),'${item}') and not(contains(@style,'overflow: hidden'))]
  END
  FOR    ${item}    IN
  ...    patient_evaluation_etp_item_statuses_attributes_0_item_date
  ...    patient_evaluation_etp_item_statuses_attributes_0_status
  ...    patient_evaluation_etp_item_statuses_attributes_0_note
      Page should have    ELEMENT|1x|//*[@id='${item}']
  END


Create treatment plan master plan item
  # Form fill    evaluations form    .
  Default fill    treatment_plan_master_plan

Verify treatment plan master plan item
  Add evaluation form
  Custom screenshot


Create treatment plan objective item
  # Form fill    evaluations form    .
  Default fill    treatment_plan_objective

Verify treatment plan objective item
  Add evaluation form
  Custom screenshot


Create treatment plan problem item
  # Form fill    evaluations form    .
  Default fill    treatment_plan_problem

Verify treatment plan problem item
  Add evaluation form
  Custom screenshot
