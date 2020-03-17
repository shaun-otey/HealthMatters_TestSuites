*** Settings ***
Documentation   /spec/features/settings/patient_setting_spec.rb
...             As a super admin user I should be able to configure patient settings
...             All changes should be saved & applied throughout the application as seen in a pre-admission form / patient edit form
...
Default Tags    sanity    sa006    points-9    exceptions
Resource        ../../suite.robot
Suite Setup     Run Keywords    I select the "${_LOCATION 1}" location
...             AND             I hit the "settings" tab
Suite Teardown  Return to mainpage
Test Teardown   Run Keywords    Run Keyword If Test Failed    Custom screenshot
...             AND             Go To    ${BASE URL}${SETTINGS}
...             AND             Clean from client settings "${Client option}" this "${Client field}" name
...             AND             Reload Page

*** Test Cases ***
Super admin user edits patient pre-admission status
  Given I am on the "settings" page
  When adding to this option these statuses    pre admission status    Pre_admission TEST
  And return to mainpage
  And create a new patient    Settings    ${EMPTY}    Tester
  Then Page Should Contain    Pre_admission TEST
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Remove this patient    Settings Tester
  ...           AND             Go To    ${BASE URL}${SETTINGS}
  ...           AND             Loop deletion    Clean fields up
  ...           AND             Go To    ${BASE URL}${SETTINGS}

Super admin user edits discharge type
  [TAGS]    fixme
  Given I am on the "settings" page
  When adding to this option these statuses    discharge types    discharge TEST
  And travel "fast" to "tester" patients "discharge transfer" page in "null"
  And enter into the discharge summary form
  Then the "discharge_type_select" list will contain "discharge TEST"
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Travel "fast" to "tester" patients "discharge transfer" page in "null"
  ...           AND             Loop deletion    With this form "Inpatient Tx Discharge Summary" perform these actions "delete"
  ...           AND             Go To    ${BASE URL}${SETTINGS}
  ...           AND             Loop deletion    Clean fields up
  ...           AND             Go To    ${BASE URL}${SETTINGS}

Super admin user edits marital status
  # auto casing for inputs
  ### EX
  Given I am on the "settings" page
  When adding to this option these statuses    marital status    Married test
  And travel "slow" to "tester" patients "facesheet" page in "null"
  Then the "${PATIENT FACESHEET MARITIAL STATUS}" list will contain "Married test"

Super admin user edits payment method
  Given I am on the "settings" page
  When adding to this option these statuses    payment methods    Payment TEST    Non Insurance
  And travel "slow" to "tester" patients "facesheet" page in "null"
  Then Page Should Contain    Payment TEST

Super admin user edits food diet
  Given I am on the "settings" page
  When adding to this option these statuses    food diets    Diet TEST
  And travel "slow" to "tester" patients "facesheet" page in "null"
  Then Click Link    Add Diet
  And check adding statuses    Diet TEST
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             I hit the "Delete Diet" view
  ...           AND             Ajax wait
  ...           AND             Go To    ${BASE URL}${SETTINGS}
  ...           AND             Loop deletion    Clean fields up
  ...           AND             Go To    ${BASE URL}${SETTINGS}

Super admin user edits patient property condition
  Given I am on the "settings" page
  When adding to this option these statuses    patient property condition    condition TEST
  And travel "slow" to "tester" patients "admission" page in "null"
  And enter into the belongings form
  Then the "patient_evaluation[electronic_devices_attributes][0][condition1]" list will contain "condition TEST"
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Travel "fast" to "tester" patients "admission" page in "null"
  ...           AND             Loop deletion    With this form "Belongings Placed in the Safe" perform these actions "delete"
  ...           AND             Go To    ${BASE URL}${SETTINGS}
  ...           AND             Loop deletion    Clean fields up
  ...           AND             Go To    ${BASE URL}${SETTINGS}

Super admin user edits patient program
  # can add extra checks
  ### EX
  Given I am on the "settings" page
  When adding to this option these statuses    patient programs    Program TEST
  And travel "slow" to "tester" patients "facesheet" page in "null"
  # Then Page Should Contain    Program TEST
  Then the "${PATIENT FACESHEET PROGRAM}" list will contain "Program TEST"

Super admin user edits calendar appointment type
  [TAGS]    skip
  Given I am on the "settings" page
  When adding to this option these statuses
  And travel "slow" to "tester" patients "facesheet" page in "null"
  Then

Super admin user edits calendar appointment status
  [TAGS]    skip
  Given I am on the "settings" page
  When adding to this option these statuses
  And travel "slow" to "tester" patients "facesheet" page in "null"
  Then

Super admin user edits patient status
  Given I am on the "settings" page
  When adding to this option these statuses    patient statuses    Color Status Test    \#0b8f8b    qa holdup
  And travel "slow" to "tester" patients "facesheet" page in "null"
  Then add the patient status and verify
  [TEARDOWN]   Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...          AND             Go To    ${BASE URL}${PATIENTS}/${Test Id}/edit
  ...          AND             Click Link    Clear Color Status Test
  ...          AND             Ajax wait
  ...          AND             Go To    ${BASE URL}${SETTINGS}
  ...          AND             Loop deletion    Clean fields up
  ...          AND             Go To    ${BASE URL}${SETTINGS}

Super admin user edits race
  # auto casing for inputs
  ### EX
  Given I am on the "settings" page
  When adding to this option these statuses    race    Race Test
  And travel "slow" to "tester" patients "facesheet" page in "null"
  Then the "${PATIENT FACESHEET RACE}" list will contain "Race Test"

Super admin user edits ethnicity
  # auto casing for inputs
  ### EX
  Given I am on the "settings" page
  When adding to this option these statuses    ethnicity    Ethnicity Test
  And travel "slow" to "tester" patients "facesheet" page in "null"
  Then the "${PATIENT FACESHEET ETHNICITY}" list will contain "Ethnicity Test"

  And travel "slow" to "tester" patients "facesheet" page in "null"
Super admin user edits levels of care and insurance benefits
  [SETUP]    Run Keywords    Set Test Variable    ${Client option 1}    levels of care
  ...        AND             Set Test Variable    ${Client field 1}    Level of CARETT
  ...        AND             Set Test Variable    ${Client option 2}    insurance benefits
  ...        AND             Set Test Variable    ${Client field 2}    Insurances b TEST
  Given I am on the "settings" page
  When adding into client settings "${Client option 1}" this "${Client field 1}" name
  Then the insurance benefits will have a new loc
  When adding to the insurance benefits option this "${Client field 2};Benefits;${Client field 1};Detox" name
  Then the insurance benefits that was created will have these "${Client field 1};Detox" selected
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Go To    ${BASE URL}${SETTINGS}
  ...           AND             Clean from client settings "${Client option 1}" this "${Client field 1}" name
  ...           AND             Reload Page
  ...           AND             Clean from client settings "${Client option 2}" this "${Client field 2}" name
  ...           AND             Reload Page

Super admin user edits insurance verifications
  Given I am on the "settings" page
  When adding to this option these statuses    insurance verification    is TEST verified?
  And travel "slow" to "tester" patients "facesheet" page in "null"
  And Click Link    Add insurance
  And ajax wait
  And I hit the "Insurance Verification" text
  Then Page Should Contain    is TEST verified?
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Travel "slow" to "tester" patients "facesheet" page in "null"
  ...           AND             I hit the "Delete Insurance" text
  ...           AND             Go To    ${BASE URL}${SETTINGS}
  ...           AND             Loop deletion    Clean fields up
  ...           AND             Go To    ${BASE URL}${SETTINGS}

Super admin user edits insurance types, plan types, and subscriber relationship
  ### EX
  Given I am on the "settings" page
  When adding to this option these statuses    insurance types    position TEST
  And adding to this option these statuses    insurance plan types    hm TEST
  And adding to this option these statuses    insurance subs relationship    favorite sub TEST
  And travel "slow" to "tester" patients "facesheet" page in "null"
  Then Click Link    Add insurance
  And ajax wait
  And the "${PATIENT FACESHEET INSURANCE TYPE.replace('$CID','0')}" list will contain "position TEST"
  And the "${PATIENT FACESHEET INSURANCE PLAN.replace('$CID','0')}" list will contain "hm TEST"
  And the "${PATIENT FACESHEET SUBSCRIBER RSHIP.replace('$CID','0')}" list will contain "favorite sub TEST"
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Travel "slow" to "tester" patients "facesheet" page in "null"
  # ...           AND             Click Element    patient_insurances_attributes_0__destroy
  ...           AND             I hit the "Delete Insurance" text
  ...           AND             Go To    ${BASE URL}${SETTINGS}
  ...           AND             Loop deletion    Clean fields up
  ...           AND             Go To    ${BASE URL}${SETTINGS}
  ...           AND             Set Test Variable    ${Clean option}    insurance plan types
  ...           AND             Set Test Variable    ${Clean field}    hm TEST
  ...           AND             Go To    ${BASE URL}${SETTINGS}
  ...           AND             Loop deletion    Clean fields up
  ...           AND             Go To    ${BASE URL}${SETTINGS}
  ...           AND             Set Test Variable    ${Clean option}    insurance types
  ...           AND             Set Test Variable    ${Clean field}    position TEST
  ...           AND             Go To    ${BASE URL}${SETTINGS}
  ...           AND             Loop deletion    Clean fields up
  ...           AND             Go To    ${BASE URL}${SETTINGS}

Super admin user edits utilization review frequencies
  [TAGS]    not found
  Given I am on the "settings" page
  When adding to this option these statuses    utilization review freqs    too many TEST
  And travel "slow" to "tester" patients "facesheet" page in "null"
  Then

Super admin user edits patient contact relationship and type
  # [TAGS]    status change
  ### EX
  Given I am on the "settings" page
  When adding to this option these statuses    patient contact relationship    contact relationship TEST
  And adding to this option these statuses    patient contact types    contact type TEST
  And travel "slow" to "tester" patients "facesheet" page in "null"
  Then Click Link    Add ${Patient Handle} contact
  And check adding statuses    contact relationship TEST
  And check adding statuses    contact type TEST
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             I hit the "Delete Contact" view
  ...           AND             Ajax wait
  ...           AND             Go To    ${BASE URL}${SETTINGS}
  ...           AND             Loop deletion    Clean fields up
  ...           AND             Go To    ${BASE URL}${SETTINGS}
  ...           AND             Set Test Variable    ${Clean option}    patient contact relationship
  ...           AND             Set Test Variable    ${Clean field}    contact relationship TEST
  ...           AND             Go To    ${BASE URL}${SETTINGS}
  ...           AND             Loop deletion    Clean fields up
  ...           AND             Go To    ${BASE URL}${SETTINGS}

Super admin user edits patient process
  [TAGS]    skip
  Given I am on the "settings" page
  When adding to this option these statuses
  And travel "slow" to "tester" patients "facesheet" page in "null"
  Then

Super admin user edits medication route
  Given I am on the "settings" page
  When adding to this option these statuses    medication routes    stop changing title TEST
  And travel "slow" to "tester" patients "medical orders" page in "null"
  And I hit the "Add manual order" text
  Then the "${ADD ORDER MEDICATION ROUTE}" list will contain "stop changing title TEST"

Super admin user edits care team function
  [TAGS]    skip
  Given I am on the "settings" page
  When adding to this option these statuses
  And travel "fast" to "tester" patients "facesheet" page in "null"
  Then

Super admin user edits diagnosis
  [TAGS]    skip
#scenario "Super admin user edits patient diagnosis codes"
# , screenshot: true  do
#   go_to_settings
#   within('div#diagnosis_codes') do
#     within('form.edit_patient_setting') do
#       within('p') do
#         find("textarea[id='patient_setting_name']").set("F99.9")
#       end
#       click_button 'Update'
#       wait_for_ajax
#       save_and_open_page
#     end
#   end
#   # testing the JSON feed instead of the implementation of the JS auto-complete code
#   visit auto_complete_diag_code_patients_path
#   expect(page).to have_content('F99.9')
#   # visit edit_patient_path(patient.id)
#   # within('div#patient_sub_form') do
#     ## autocomplete requires 3 or more characters
#     # fill_in 'diagnosis_code', :with => "F99"
#     # wait_for_ajax
#     # page.execute_script('$(".patient_diagnosis_textarea").trigger("mouseenter").click()')
#     # page.execute_script ("$('.patient_diagnosis_textarea').text('F99')")
#     # save_and_open_screenshot
#     # selector = "ul.token-input-focused li.token-input-token:contains('F99.9 diag test')"
#   # end
# end

# def fill_autocomplete(field, options = {})
#   fill_in field, :with => options[:with]
#
#   page.execute_script ("$('##{field}').trigger('focus')")
#   page.execute_script ("$('##{field}').trigger('keydown')")
#   save_and_open_screenshot
#   selector = "ul.token-input-list li:contains('#{options[:select]}')"
#
#   expect(page).to have_selector selector
#   page.execute_script "$(\"#{selector}\").mouseenter().click()"
# end

Click scroll to top
  Given I am on the "settings" page
  When scrolling down
  And I hit the "top" tab
  Then Location Should Contain    \#

*** Keywords ***
The "${name}" list will contain "${item}"
  Ajax wait
  ${list} =    Set Variable If    '${name}'=='discharge types'                 //.
               ...                '${name}'=='food diets'                      patient_patient_diets_attributes_0_diet
               ...                '${name}'=='patient property condition'      patient_evaluation[electronic_devices_attributes][0][condition1]
               ...                '${name}'=='patient programs'                ${PATIENT FACESHEET PROGRAM}
               ...                '${name}'=='race'                            ${PATIENT FACESHEET RACE}
               ...                '${name}'=='ethnicity'                       ${PATIENT FACESHEET ETHNICITY}
               ...                '${name}'=='insurance types'                 ${PATIENT FACESHEET INSURANCE TYPE.replace('$CID','0')}
               ...                '${name}'=='insurance plan types'            ${PATIENT FACESHEET INSURANCE PLAN.replace('$CID','0')}
               ...                '${name}'=='insurance subs relationship'     ${PATIENT FACESHEET SUBSCRIBER RSHIP.replace('$CID','0')}
               ...                '${name}'=='patient contact relationship'    ${PATIENT FACESHEET CONTACT RSHIP.replace('$CID','0')}
               ...                '${name}'=='patient contact types'           ${PATIENT FACESHEET CONTACT TYPE.replace('$CID','0')}
               ...                '${name}'=='medication routes'               ${ADD ORDER MEDICATION ROUTE}
               # ...                '${name}'==''
               # ...                '${status}'=='contact relationship TEST'    //select[@id='patient_patient_contacts_attributes_0_relationship']
               # ...                '${status}'=='contact type TEST'            //select[@id='patient_patient_contacts_attributes_0_contact_type']
               ...                True                                       ${name}
  ${list items} =    Get List Items    ${list}
  # ${list} =    Lowercase all    ${list}
  Should Contain    ${list items}    ${item}
  Ajax wait
  Update facesheet    patient_patient_statuses_attributes_0_name:direct_drop=qa holdup
  ...                 patient_patient_statuses_attributes_0_start_date:direct_js=${month year.split()[0]}/01/${month year.split()[1]}
  ...                 patient_patient_statuses_attributes_0_end_date:direct_js=${month year.split()[0]}/28/${month year.split()[1]}
  I hit the "Show Facesheet" view
  Page should have    Color Status Test    qa holdup    Start date: ${month year.split()[0]}/01/${month year.split()[1]}
  ...                 Days: 27    End date: ${month year.split()[0]}/28/${month year.split()[1]}

The insurance benefits will have a new loc
  Page Should Contain Element    //label[starts-with(@for,'ibs_care_level_ids_') and .='${Client field 1}']

Adding to the insurance benefits option this "${field}" name
  ${id} =    Adding into client settings "${Client option 2}" this "${field}" name
  Set Test Variable    ${Option id}    ${id.rsplit('_benefit',1)[0]}_care_level_ids_

The insurance benefits that was created will have these "${locs}" selected
  @{locs} =    Split String    ${locs}    ;
  :FOR    ${loc}    IN    @{locs}
  \    Run Keyword And Continue On Failure    Page Should Contain Element    //label[starts-with(@for,'ibs_care_level_ids_') and .='${loc}']/following-sibling::input[@checked='checked' and @id='${Option id}']

Enter into the discharge summary form
  With this form "Inpatient Tx Discharge Summary" perform these actions "add;edit"
