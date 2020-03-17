*** Settings ***
Documentation   Testing for PingMD.
...
Default Tags    acceptance    ac003    points-1    notester    ntrdy
Resource        ../../suite.robot
Suite Setup     Setup api
Suite Teardown  Delete All Sessions
Test Teardown   Run Keyword If Test Failed    Catch error

*** Test Cases ***
Check each endpoint using the option method
  [SETUP]    Run Keywords    Register a new user    heavytraffic@yawn.com    Scratchy    Pink    custodian
  ...        AND             Register a new user    late@yawn.com    Slow    Dead    practitioner
  ...        AND             Create a new organization    TestHQ
  [TEMPLATE]    Verify the option request for the ${api} endpoint return correct defaults with these ${inputs}
  Pingmd << Create organization               options;${null}
  Pingmd << Assign memebership                ${Test ping organization};${Test ping prac};options
  Pingmd << Register user                     options;${null};${null};${null};${null};${null}
  Pingmd << Account status                    ${Test ping user};options
  Pingmd << Activate user                     ${Test ping user};options
  Pingmd << Deactivate user                   ${Test ping user};options;${null}
  Pingmd << Request survey                    ${Test ping user};options;${null};${null};${null}
  Pingmd << View patients for practitioner    ${Test ping user};options
  Pingmd << View practitioners for patient    ${Test ping user};options
  Pingmd << Request patient assessment        ${Test ping user};options;${null};${null};${null};${null};${null};${null};${null}

Verify user functionality
  Given create a full patient
  And check that user "${Test ping user}" is "deactivated"
  When pingmd << activate user    ${Test ping user}    post
  Then check that user "${Test ping user}" is "activated"
  When pingmd << deactivate user    ${Test ping user}    post    i cared
  Then check that user "${Test ping user}" is "deactivated"

Register a user under a practitioner and send them a survey
  Given register a new user    late@yawn.com    Slow    Dead    practitioner
  When register a new user    heavytraffic@yawn.com    Scratchy    Pink    custodian    practitioners=${Test ping prac}
  Then send a survey with "success"

Register a user under an organization and send them a survey
  Given create a new organization    TestHQ
  When register a new user    heavytraffic@yawn.com    Scratchy    Pink    custodian    organization=${Test ping organization}
  Then send a survey with "success"

Register a user then add them to a practitioner and send a survey
  Given register a new user    late@yawn.com    Slow    Dead    practitioner
  When register a new user    heavytraffic@yawn.com    Scratchy    Pink    custodian
  Then send a survey with "failure"
  When we will "add" these users "${Test ping user}" into the "practitioner" group
  Then send a survey with "success"
  And we will "view" these users "${Test ping prac}" into the "patient" group

Register a user then add them to an organization and send a survey
  [TAGS]    not in api
  Given create a new organization    TestHQ
  When register a new user    heavytraffic@yawn.com    Scratchy    Pink    custodian
  When register a new user    late@yawn.com    Slow    Dead    practitioner
  Then send a survey with "failure"
  When giving a "acceptance" of membership to user "${Test ping prac}"
  Then send a survey with "success"
  When giving a "removal" of membership to user "${Test ping prac}"
  Then send a survey with "failure"

Register a user under a practitioner and send them an assessment
  Given register a new user    late@yawn.com    Slow    Dead    practitioner
  When register a new user    heavytraffic@yawn.com    Scratchy    Pink    custodian    practitioners=${Test ping prac}
  Then send a patient assessment with "success"

Register a user under an organization and send them an assessment
  Given create a new organization    TestHQ
  When register a new user    heavytraffic@yawn.com    Scratchy    Pink    custodian    organization=${Test ping organization}
  Then send a patient assessment with "success"

Register a user then add them to a practitioner and send an assessment
  Given register a new user    late@yawn.com    Slow    Dead    practitioner
  When register a new user    heavytraffic@yawn.com    Scratchy    Pink    custodian
  Then send a patient assessment with "failure"
  When we will "add" these users "${Test ping user}" into the "practitioner" group
  Then send a patient assessment with "success"
  And we will "view" these users "${Test ping prac}" into the "patient" group

*** Keywords ***
Catch error
  &{resp} =    Set Variable    ${Last response.json()}
  Log Many    &{resp}

Setup api
  ${resp} =    Create Dictionary
  Set Suite Variable    ${Last response}    ${resp}
  Pingmd << Setup api

Extract api
  [ARGUMENTS]    @{api}    &{optional fields}
  ${resp} =    Run Keyword    @{api}    &{optional fields}
  Set Suite Variable    ${Last response}    ${resp}
  Run Keyword And Continue On Failure    Should Be True    200<=${resp.status_code}<300
  &{resp} =    Set Variable    ${resp.json()}
  &{resp} =    Set Variable If    'data' in ${resp}    ${resp.data}    &{resp}
  Log Many    &{resp}
  [RETURN]    ${resp}

Create a full patient
  Register a new user    heavytraffic@yawn.com    Scratchy    Pink    custodian
  # ...

Register a new user
  [ARGUMENTS]    ${email}    ${first name}    ${last name}    ${role}    &{optional fields}
  ${rand} =    Generate Random String    6    [UPPER][NUMBERS]
  ${resp} =    Extract api    Pingmd << Register user    post    ${email.replace('@','${rand}@')}    ${first name}
               ...            ${last name}    ${role}    &{optional fields}
  ${var} =    Set Variable If    '${role}'=='custodian'    user    prac
  Run Keyword If    ${resp.success}==${true}    Set Test Variable    ${Test ping ${var}}    ${resp.person_id}
  ...               ELSE                        Fail    User registration was unsuccessful!

Create a new organization
  [ARGUMENTS]    ${name}    &{optional fields}
  ${resp} =    Extract api    Pingmd << Create organization    post    TestHQ    &{optional fields}
  Set Test Variable    ${Test ping organization}    ${resp.id}

Giving a "${method}" of membership to user "${id}"
  ${method} =    Set Variable If    '${method}'=='acceptance'    put    delete
  ${resp} =    Extract api    Pingmd << Assign memebership    ${Test ping organization}    ${id}    ${method}

Check that user "${id}" is "${state}"
  ${resp} =    Extract api    Pingmd << Account status    ${id}    get
  Run Keyword If    '${state}'=='activated'    Should Be True    ${resp.is_active}
  ...               ELSE                       Should Not Be True    ${resp.is_active}

We will "${action}" these users "${ids}" into the "${group}" group
  ${users}    ${group id} =    Run Keyword If    '${group}'=='practitioner'    Set Variable    patients
                               ...                                             ${Test ping prac}
                               ...               ELSE                          Set Variable    practitioners
                               ...                                             ${Test ping user}
  ${method} =    Set Variable If    '${action}'=='add'    put    get
  ${resp} =    Extract api    Pingmd << View ${users} for ${group}    ${group id}    ${method}    ${ids}
  @{ids} =    Split String    ${ids.__str__()}    ;
  :FOR    ${id}    IN    @{ids}
  \    ${id} =    Convert To Integer    ${id}
  \    Run Keyword And Continue On Failure    List Should Contain Value    &{resp}[${users}]    ${id}

Send a survey with "${status}"
  ${resp} =    Pingmd << Request survey    ${Test ping user}    post    Test Survey    This is only a test
  ...          {"pages": [{"name": "page1", "questions": [{"type": "radiogroup", "choices": [{"value": "yes", "text": "Yes"}, {"value": "absolutely", "text": "Absolutely"}], "name": "Is medical software awesome?"}]}]}
  ...          http://whatever.com    {"hello": "world"}
  Set Suite Variable    ${Last response}    ${resp}
  Run Keyword If    '${status}'=='success'    Should Be True    200<=${resp.status_code}<300
  ...               ELSE                      Should Not Be True    200<=${resp.status_code}<300
  Catch error

Send a patient assessment with "${status}"
  ${rand} =    Generate Random String    5    [NUMBERS]
  ${resp} =    Pingmd << Request patient assessment    ${Test ping user}    post    test-${rand}    a-type
               ...                                     an-application-id    2007-07-07 22:51:05 UTC
               ...                                     {"id": "TestSurveyID-${rand}", "survey": {"pages": [{"name": "page1", "questions": [{"type": "radiogroup", "choices": [{"value": "yes", "text": "Yes"}, {"value": "absolutely", "text": "Absolutely"}], "name": "Is medical software awesome?"}]}]}}
               ...                                     A human readable name    A human readable description
               ...                                     http://whatever.com    {"hello": "world"}
  Set Suite Variable    ${Last response}    ${resp}
  Run Keyword If    '${status}'=='success'    Should Be True    200<=${resp.status_code}<300
  ...               ELSE                      Should Not Be True    200<=${resp.status_code}<300
  Catch error

Verify the option request for the ${api} endpoint return correct defaults with these ${inputs}
  @{inputs} =    Split String    ${inputs}    ;
  ${resp} =    Extract api    Run Keyword    ${api}    @{inputs}
  Run Keyword If    '${api}'=='Pingmd << Create organization'                Evaluate    '${resp.name}'=='Organization Create'
  ...    ELSE IF    '${api}'=='Pingmd << Assign memebership'                Evaluate    '${resp.name}'=='Membership'
  ...    ELSE IF    '${api}'=='Pingmd << Register user'                     Evaluate    '${resp.name}'=='Register'
  ...    ELSE IF    '${api}'=='Pingmd << Account status'                    Evaluate    '${resp.name}'=='Account Status'
  ...    ELSE IF    '${api}'=='Pingmd << Activate user'                     Evaluate    '${resp.name}'=='Activate User'
  ...    ELSE IF    '${api}'=='Pingmd << Deactivate user'                   Evaluate    '${resp.name}'=='Deactivate User'
  ...    ELSE IF    '${api}'=='Pingmd << Request survey'                    Evaluate    '${resp.name}'=='Request Single Use Survey'
  ...    ELSE IF    '${api}'=='Pingmd << View patients for practitioner'    Evaluate    '${resp.name}'=='Practitioner Patients'
  ...    ELSE IF    '${api}'=='Pingmd << View practitioners for patient'    Evaluate    '${resp.name}'=='Patient Practitioners'
  ...    ELSE IF    '${api}'=='Pingmd << Request patient assessment'        Evaluate    '${resp.name}'=='Patient Assessment'
  ...               ELSE                                                    Fail    Incorrect api call made!
  [TEARDOWN]    Catch error
