*** Settings ***
Documentation   /spec/features/customization/dashboard_spec.rb
...
Resource        ../suite.robot
Suite Setup     Login to system
Suite Teardown  Exit system
Test Teardown   Go To    ${BASE URL}${SIGN IN}

*** Test Cases ***
Current census - show current census
  visit dashboard_index_path()
  expect(page).to have_text('Current Census:')

Current census - filter by patient, form should not show, not required by patient
  @eval.update_attributes(require_signature: true, require_patient_signature: false)
  visit dashboard_index_path(by_patient: true, p_view: 'current')
  expect(page).not_to have_css("a", :text => @eval.name)

Current census - filter by patient, form should not show 'already signed'
  @eval.update_attributes(require_signature: true, patient_signature_complete: true)
  visit dashboard_index_path(by_patient: true, p_view: 'current')
  expect(page).not_to have_css("a", :text => @eval.name)

Current census - filter by current user, form should show
  @eval.update_attributes(require_signature: true, require_patient_signature: true, staff_user_title_ids: [user.user_title_id])
  visit dashboard_index_path(by_patient: true, p_view: 'current')
  # find to wait until elem
  find("a", :text => @eval.name)
  expect(page).to have_css("a", :text => @eval.name)

Current census - filter by current user, form should not show 'not current_user title'
  @eval.update_attributes(require_signature: true)
  visit dashboard_index_path(by_role: true, p_view: 'current')
  find_link("btn_my_items").click
  expect(page).not_to have_css("a", :text => @eval.name)

Discharged clients - discharged clients
  visit dashboard_index_path(p_view: 'discharge')
  expect(page).to have_text('Discharged')

Discharged clients - filter by patient, form should not show
  @eval.update_attributes(require_signature: true)
  visit dashboard_index_path(p_view: 'discharge', by_patient: true)
  expect(page).not_to have_css("a", :text => @eval.name)

Discharged clients - filter by patient, form should not show 'already signed'
  @eval.update_attributes(require_signature: true, patient_signature_complete: true)
  visit dashboard_index_path(p_view: 'discharged', by_patient: true)
  expect(page).not_to have_css("a", :text => @eval.name)

Discharged clients - filter by current user, form should show
  @eval.update_attributes(require_signature: true, require_patient_signature: true, staff_user_title_ids: [user.user_title_id])
  visit dashboard_index_path(p_view: 'discharge')
  find("a", :text => @eval.name)
  expect(page).to have_css("a", :text => @eval.name)

Discharged clients - filter by current user, form should not show 'not current_user title'
  @eval.update_attributes(require_signature: true)
  visit dashboard_index_path(p_view: 'discharge', by_role: true)
  expect(page).not_to have_css("a", :text => @eval.name)
