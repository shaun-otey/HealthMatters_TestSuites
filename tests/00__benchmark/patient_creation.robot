*** Settings ***
Documentation   Create x patients with different forms.
...
Default Tags    stress    st001    points-420
Resource        ../../suite.robot
Suite Setup     Run Keywords    Return to mainpage
...             AND             I select the "${_LOCATION 1}" location
Suite Teardown  Return to mainpage

*** Test Cases ***
Run creation process
  Create multiple patients with after actions    ${210}    Add phone number    Add bio psychosocial
  ...                                            Add medical intake    Add financial agreement

*** Keywords ***
Add phone number
  [ARGUMENTS]    ${patient}
  ${id} =    Set Variable    ${patient.split('|')[2]}
  ${x} =    Generate Random String    3    ${id}123
  ${y} =    Generate Random String    3    ${id}456
  ${z} =    Generate Random String    4    ${id}7890
  Update facesheet    phone=${x}-${y}-${z}

Add bio psychosocial
  [ARGUMENTS]    ${patient}
  Run Keyword And Continue On Failure    Add the "Bio-psychosocial Assessment" for this "${patient}" in "clinical assessments"

Add medical intake
  [ARGUMENTS]    ${patient}
  Run Keyword And Continue On Failure    Add the "Initial Psychiatric Evaluation" for this "${patient}" in "medical intake"

Add financial agreement
  [ARGUMENTS]    ${patient}
  Run Keyword And Continue On Failure    Add the "Attachment" for this "${patient}" in "financial intake"
  Return to mainpage

Add the "${form}" for this "${patient}" in "${process}"
  ${full name}    ${TRASH}    ${id} =    Split String    ${patient}    |
  Travel "fast" to "${id}" patients "${process}" page in "null"
  Page should have    ${full name.split()[0]}    ${full name.split()[1]}    ${full name.split()[2]}
  With this form "${form}" perform these actions "add"
