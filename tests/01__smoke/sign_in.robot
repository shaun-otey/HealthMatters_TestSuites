*** Settings ***
Documentation   /spec/features/authentication/sign_in_spec.rb
...             As a registered user I should be able to sign in a secure manner
...             As a registered user I should have to provide two factor authentication when enabled
...             As a registered user I should not be able to surpass 2FA when enabled
...
Resource        ../../suite.robot
Suite Setup     Open Browser    ${BASE URL}${SIGN IN}    ${BROWSER}
Suite Teardown  Close Browser
Test Teardown   Go To    ${BASE URL}${SIGN IN}

*** Test Cases ***
Valid username & invalid password
  Given I am on the "sign in" page
  When I login with "${CAS USER}" and "123"
  Then Page Should Contain    Invalid Username or password.

Invalid username & valid password
  Given I am on the "sign in" page
  When I login with "123" and "${CAS PASS}"
  Then Page Should Contain    Invalid username or password.

Valid but disabled user cannot log in
  Given I am on the "sign in" page
  When I login with "${DIS USER}" and "${DIS PASS}"
  Then Page Should Contain    User is Disabled

#User with expired password
  #user = FactoryGirl.create(:user, password_changed_at: (Time.zone.now - 180.days))
  #sign_in_with user.username, user.password
  #expect(page).to have_content('Please update your password')

Valid username & password and then directed to 2FA form
  Given I am on the "sign in" page
  When I login with "${CAS USER}" and "${CAS PASS}"
  Then Page Should Contain    Enter Security Code
  And exit system    ${false}

Valid username, password, and 2FA code
  Given I am on the "sign in" page
  When I login with "${CAS USER}" and "${CAS PASS}"
  And Do two factor
  Then Page Should Contain    Patients
  And exit system    ${false}

Valid username, password, and invalid 2FA code
  Given I am on the "sign in" page
  When I login with "${CAS USER}" and "${CAS PASS}"
  And Input Text    code    1111
  And Click Element    commit
  Then Page Should Not Contain    Patients
  And exit system    ${false}

*** Keyword ***
I login with "${user}" and "${pass}"
  Start login    ${user}    ${pass}
