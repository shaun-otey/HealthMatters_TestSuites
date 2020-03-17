*** Settings ***
Documentation   Consent forms are created in templates>consents>click create new consent.
...
...             Consent forms has several information pulling mechanics.
...             Consents become especially usefull to automatically pull patient information from the facesheet automatically.
...             Consent forms can only be signed by the patient and/or Guardian/Guarantor.
...             This means that staff members do not sign the form and do not need to be given specific permissions to load consents (all staff can load).
...
...             Consent forms are built similar to a word document. It allows you to copy and paste entire documents. Formatting can be done via HTML.
...
...             Users with super admin or manage templates can create consents forms and write anything inside the form.
...             There are certain useful tools that consents have such as datafield and form fields.
...             Users can command consents to auto pull information from the facesheet via the data fields.
...             And they can build or created blank paragraph fields or text fields via form fields.
...
Default Tags    regression    re025    points-6    templates story
Resource        ../../suite.robot
Suite Setup     Run Keywords    I attempt to hit the "templates" tab
...             AND             Create tester template    consent forms    Board Games
...             AND             Editing "consent forms" test template
...             AND             Format the form
...             AND             Save "consent forms" template
Suite Teardown  Run Keywords    Delete tester template    consent forms
...             AND             Return to mainpage
Test Teardown   Run Keywords    Run Keyword If Test Failed    Custom screenshot
...             AND             Travel "fast" to "tester" patients "admission" page in "null"
...             AND             With this form "null" perform these actions "wipe"
...             AND             Go To    ${BASE URL}${TEMPLATES}

*** Test Cases ***
Manually attach the template
  Given I am on the "templates" page
  When travel "slow" to "tester" patients "admission" page in "${_LOCATION 1}"
  And add the template "manually"
  Then confirm data is pulled

Auto populate the template
  Given I am on the "templates" page
  When travel "slow" to "tester" patients "admission" page in "${_LOCATION 1}"
  And add the template "automatically"
  Then confirm data is pulled

Attach a template that contains a bullet list
  [SETUP]    Create a consent with a bullet list
  Given I am on the "templates" page
  When travel "slow" to "tester" patients "admission" page in "${_LOCATION 1}"
  And with this form "Why No AWS Placement" perform these actions "add;view"
  Then confirm bullet list is pulled
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Travel "fast" to "tester" patients "admission" page in "null"
  ...           AND             With this form "null" perform these actions "wipe"
  ...           AND             Delete tester template    consent forms
  ...           AND             Pocket global vars    restore

Complete a consent form without a signature
  [SETUP]    Run Keywords    Add additional contact signers
  ...                        Create a consent without signatures
  Given I am on the "templates" page
  And travel "slow" to "tester" patients "admission" page in "${_LOCATION 1}"
  When with this form "Mexican Commit" perform these actions "add;view"
  And fill in the texts
  And Reload Page
  And I hit the "admission" patient tab
  Then with this form "Mexican Commit" perform these actions "view"
  And page should have    _text-1:    _text-2:    ELEMENT|//input[@name='text1' and @value='gitflow']
  ...                     ELEMENT|//input[@name='text2' and @value='oneflow']
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Delete contact signers
  ...           AND             Travel "fast" to "tester" patients "admission" page in "null"
  ...           AND             With this form "null" perform these actions "wipe"
  ...           AND             Delete tester template    consent forms
  ...           AND             Pocket global vars    restore

Assign different gg forms to a patient without any gg
  [SETUP]    Create a consent for switching guardian and guarantor signatures
  [TEMPLATE]    Prep the form to use these ${signatures} and it will ${work}
  none                         none
  client                       work
  guardian                     not work
  guarantor                    not work
  client;guardian              work
  client;guarantor             work
  client;guardian;guarantor    work
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Go To    ${Comeback 2}
  ...           AND             With this form "null" perform these actions "wipe"
  ...           AND             Delete tester template    consent forms
  ...           AND             Pocket global vars    restore

*** Keywords ***
Add additional contact signers
  Travel "slow" to "tester" patients "facesheet" page in "${_LOCATION 1}"
  Set count id
  Click Link    Add ${Patient Handle.lower()} contact
  Ajax wait
  Update facesheet    contact full name=Keith Tang    contact rship:dropdown=Guarantor    contact phone=999 305 7777
  Set count id    +1
  Click Link    Add ${Patient Handle.lower()} contact
  Ajax wait
  Update facesheet    contact full name=Patricio De La Guardia    contact rship:dropdown=Guardian
  ...                 contact phone=999 305 7777

Delete contact signers
  Travel "slow" to "tester" patients "facesheet" page in "${_LOCATION 1}"
  Set count id
  Loop Deletion    I hit the "Delete Contact" text
  Update facesheet    ${EMPTY}=${EMPTY}

Format the form
  ${passes} =    Run Keyword And Return Status    Form fill    consent forms form    patient process:dropdown=Admission
  Run Keyword Unless    ${passes}    Form fill    consent forms form    patient process:dropdown=Admission/Consents
  Form fill    consent forms form    rules:dropdown=Only if patient is male    allow revocation:checkbox=x
  ...          enabled:checkbox=x    staff sig req:checkbox=x    patient sig req:checkbox=x    guart sig req:checkbox=x
  ...          guard sig req:checkbox=x
  Run Keyword If    ${_LOCATIONS ACTIVE}    Form fill    consent forms form    all locations:checkbox=x
  FOR    ${e}    IN
  ...    name: [data_field.patient.name]    id: [data_field.patient.id]    dob: [data_field.patient.dob]
  ...    gender: [data_field.patient.gender]    age: [data_field.patient.age]
  ...    admission date: [data_field.patient.admission_date]    address: [data_field.patient.address]
  ...    _list: [form_field.list list options(\\"chocolate\\",\\"vanilla\\")]    _text: [form_field.text text]
  ...    _80: [form_field.width8 text width=\\"80\\"]    _30: [form_field.width3 text width=\\"30\\"]
  ...    _textarea: [form_field.textarea textarea]    _date: [form_field.date date]    _on: [form_field.on checkbox_on]
  ...    _off: [form_field.off checkbox_off]    _radio: [form_field.radio radio_yes_no]    superscript: superduper
  ...    subscript: superduper    head1: heading 1    head2: heading 2    head3: heading 3    head4: heading 4
  ...    head5: heading 5    head6: heading 6
      ${script}    @{TRASH} =    Split String    ${e}    :
      ${node} =    Set Variable If    '${script}'=='superscript'    sup
                   ...                '${script}'=='subscript'      sub
                   ...                'head' in '${script}'         ${script[0]}${script[4]}
                   ...                True                          p
      Add node to form    ${e}    ${node}
  END

Add the template "${method}"
  Run Keyword If    '${method}'=='manually'    With this form "Board Games" perform these actions "add;view"
  ...               ELSE                       With this form "Board Games" perform these actions "auto;view"

Confirm data is pulled
  I hit the "Add Guardian" text
  Ajax wait
  ${date} =    Convert Date    ${Todays Date}    result_format=%m/%d/%Y
  Page should have    name: ${Test first} ${Test middle} ${Test last}    id:    dob: 10/07/1991    gender: male    age:
  ...                 admission date: ${date}    address: 123 KipuLane    Miami, FL 33154    _list:    _text:    _80:
  ...                 _30:    _textarea:    _date:    _on:    _off:    _radio:    superscript:    subscript:    head1:
  ...                 head2:    head3:    head4:    head5:    head6:
  Run Keyword And Continue On Failure    Textarea Should Contain    textarea    ${EMPTY}
  Run Keyword And Continue On Failure    Checkbox Should Be Selected    on
  Run Keyword And Continue On Failure    Checkbox Should Not Be Selected    off
  Run Keyword And Continue On Failure    Page Should Contain List    list
  Run Keyword And Continue On Failure    Page Should Contain Button    sig
  Run Keyword And Continue On Failure    Page Should Contain Textfield    text
  Run Keyword And Continue On Failure    Page Should Contain Radio Button    radio
  FOR    ${element}    IN
  ...    //input[@name='width8' and @style='width:80%;']    //input[@name='width3' and @style='width:30%;']
  ...    //sup[contains(text(),'superduper')]    //sub[contains(text(),'superduper')]
  ...    //h1[contains(text(),'heading 1')]    //h2[contains(text(),'heading 2')]    //h3[contains(text(),'heading 3')]
  ...    //h4[contains(text(),'heading 4')]    //h5[contains(text(),'heading 5')]    //h6[contains(text(),'heading 6')]
  ...    //select[@name='list']/option[contains(text(),'vanilla')]
  ...    //select[@name='list']/option[contains(text(),'chocolate')]
  ...    //select[@id='required-signer']//option[@id='staff_signer']
  ...    //select[@id='required-signer']//option[@id='patient_signer']
  ...    //select[@id='required-signer']//option[@id='guarantor_signer']
  ...    //select[@id='required-signer']//option[@id='guardian_signer']
  ...    //input[@class='datepicker_us submittable_wait_bar hasDatepicker']
      Page should have    ELEMENT|${element}
  END
  ${TRASH}    ${sup height} =    Get Element Size    //sup[contains(text(),'superduper')]
  ${TRASH}    ${sup parent} =    Get Element Size    //sup[contains(text(),'superduper')]/parent::p[1]
  ${TRASH}    ${sub height} =    Get Element Size    //sub[contains(text(),'superduper')]
  ${TRASH}    ${sub parent} =    Get Element Size    //sub[contains(text(),'superduper')]/parent::p[1]
  Run Keyword And Continue On Failure    Should Not Be Equal As Integers    ${sup height}    ${sup parent}
  Run Keyword And Continue On Failure    Should Not Be Equal As Integers    ${sub height}    ${sub parent}
  Scrolling down
  Custom screenshot

Create a consent with a bullet list
  Pocket global vars    Template Id
  Go To    ${BASE URL}${TEMPLATES}
  Create tester template    consent forms    Why No AWS Placement
  Editing "consent forms" test template
  ${passes} =    Run Keyword And Return Status    Form fill    consent forms form    patient process:dropdown=Admission
  Run Keyword Unless    ${passes}    Form fill    consent forms form    patient process:dropdown=Admission/Consents
  Form fill    consent forms form    rules:dropdown=Only if patient is male    allow revocation:checkbox=x
  ...          enabled:checkbox=x    staff sig req:checkbox=x    patient sig req:checkbox=x    guart sig req:checkbox=x
  ...          guard sig req:checkbox=x
  Run Keyword If    ${_LOCATIONS ACTIVE}    Form fill    consent forms form    all locations:checkbox=x
  @{list elements} =    Create List
  @{append step} =    Create List
  FOR    ${index}    ${element}    IN ENUMERATE    One    Two    Three    Four    Five
      Append To List    ${list elements}    window.document.e${index} \= window.document.createTextNode("${element}");
      ...               window.document.s${index} \= window.document.createElement("li");
      Append To List    ${append step}    window.document.s${index}.appendChild(window.document.e${index});
      ...               window.document.l.appendChild(window.document.s${index});
  END
  Execute Javascript    @{list elements}    window.document.l = window.document.createElement("ul");
  ...                   window.document.n = window.document.getElementById("consent_form_content_ifr").contentWindow.document.getElementById("tinymce");
  ...                   @{append step}    window.document.n.appendChild(window.document.l)
  Save "consent forms" template

Confirm bullet list is pulled
  FOR    ${element}    IN
  ...    //ul/li[contains(text(),'One')]    //ul/li[contains(text(),'Two')]    //ul/li[contains(text(),'Three')]
  ...    //ul/li[contains(text(),'Four')]    //ul/li[contains(text(),'Five')]
      Page should have    ELEMENT|${element}
  END
  Scrolling down
  Custom screenshot

Create a consent without signatures
  Pocket global vars    Template Id
  Go To    ${BASE URL}${TEMPLATES}
  Create tester template    consent forms    Mexican Commit
  Editing "consent forms" test template
  ${passes} =    Run Keyword And Return Status    Form fill    consent forms form    patient process:dropdown=Admission
  Run Keyword Unless    ${passes}    Form fill    consent forms form    patient process:dropdown=Admission/Consents
  Form fill    consent forms form    rules:dropdown=Only if patient is male    allow revocation:checkbox=x
  ...          enabled:checkbox=x
  Run Keyword If    ${_LOCATIONS ACTIVE}    Form fill    consent forms form    all locations:checkbox=x
  FOR    ${e}    IN    _text-1: [form_field.text1 text]    _text-2: [form_field.text2 text]
      Add node to form    ${e}    p
  END
  Save "consent forms" template

Fill in the texts
  Form fill    ${EMPTY}    //div[@id\='custom-form']/p[2]/input:direct_text=gitflow
  ...          //div[@id\='custom-form']/p[3]/input:direct_text=oneflow
  Click Button    Update
  Ajax wait

Create a consent for switching guardian and guarantor signatures
  Pocket global vars    Template Id
  Create tester template    consent forms    Hardest Tools
  Editing "consent forms" test template
  ${comeback} =    Get Location
  Set Suite Variable    ${Comeback}    ${comeback}
  ${passes} =    Run Keyword And Return Status    Form fill    consent forms form    patient process:dropdown=Admission
  Run Keyword Unless    ${passes}    Form fill    consent forms form    patient process:dropdown=Admission/Consents
  Form fill    consent forms form    rules:dropdown=Only if patient is male    allow revocation:checkbox=x
  ...          enabled:checkbox=x
  Run Keyword If    ${_LOCATIONS ACTIVE}    Form fill    consent forms form    all locations:checkbox=x
  FOR    ${e}    IN    name: [data_field.patient.name]
      Add node to form    ${e}    p
  END
  Save "consent forms" template
  I am on the "templates" page
  Travel "slow" to "tester" patients "admission" page in "${_LOCATION 1}"
  ${comeback} =    Get Location
  Set Suite Variable    ${Comeback 2}    ${comeback}

Add node to form
  [ARGUMENTS]    ${element}    ${node}
  Execute Javascript    window.document.e = window.document.createTextNode("${element}");
  ...                   window.document.s = window.document.createElement("${node}");
  ...                   window.document.p = window.document.createElement("p");
  ...                   window.document.n = window.document.getElementById("consent_form_content_ifr").contentWindow.document.getElementById("tinymce");
  ...                   window.document.s.appendChild(window.document.e);
  ...                   window.document.p.appendChild(window.document.s);
  ...                   window.document.n.appendChild(window.document.p)

Prep the form to use these ${signatures} and it will ${work}
  @{signatures} =    Split String    ${signatures}    ;
  &{sig required} =    Create Dictionary    patient sig req:checkbox=o    guart sig req:checkbox=o
                       ...                  guard sig req:checkbox=o
  FOR    ${sig}    IN    @{signatures}
      Run Keyword If    '${sig}'=='client'       Set To Dictionary    ${sig required}    patient sig req:checkbox=x
      ...    ELSE IF    '${sig}'=='guardian'     Set To Dictionary    ${sig required}    guard sig req:checkbox=x
      ...    ELSE IF    '${sig}'=='guarantor'    Set To Dictionary    ${sig required}    guart sig req:checkbox=x
      ...               ELSE                     With this form "Hardest Tools" perform these actions "add;view"
  END
  Run Keyword Unless    '${signatures[0]}'=='none'    Run Keywords    Go To    ${Comeback}
  ...                                                 AND             Form fill    consent forms form    &{sig required}
  ...                                                 AND             Save "consent forms" template
  ...                                                 AND             Go To    ${Comeback 2}
  ...                                                 AND             With this form "Hardest Tools" perform these actions "wipe;add"
  Custom screenshot
  Run Keyword If    '${work}'=='work'        Run Keywords    With this form "Hardest Tools" perform these actions "view"
  ...                                        AND             Page should have
  ...                                                        name: ${Test first} ${Test middle} ${Test last}
  ...                                        AND             Perform signature    I hit the "Sign & submit" text
  ...                                        AND             Page should have    Signed
  ...    ELSE IF    '${work}'=='not work'    Page should have    Errors found
  ...                                        Form not added: please add a ${signatures[-1]} contact to this patient.
  ...               ELSE                     Page should have    name: ${Test first} ${Test middle} ${Test last}
  [TEARDOWN]    Go To    ${Comeback 2}
