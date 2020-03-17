*** Settings ***
Documentation   /spec/features/customization/role_restriction_spec.rb
...             As a super admin user I should be able to edit & update site settings & company settings
...             As a non-super admin user I should not be able to edit or update settings
...
Resource        ../suite.robot
Suite Setup     Login to system
Suite Teardown  Exit system
Test Teardown   Go To    ${BASE URL}${SIGN IN}

*** Test Cases ***
Any other user does not have access to settings
  ## TODO: need to randomize role assignment ##
  sign_in_with other_user.username, other_user.password
  authenticate_with_2fa other_user
  expect(page).to_not have_content("Settings")

Super admin should have access to settings
  sign_in_with subject.username, subject.password
  authenticate_with_2fa subject
  click_link 'Settings'
  expect(page).to have_content("Settings")
