*** Settings ***
Documentation   .
...
Default Tags    acceptance    ac010    points    ntrdy
Resource        ../../suite.robot
Suite Setup     Setup master cas user and demo user
Suite Teardown  Exit all cas users

*** Variables ***
# ${CAS ENDPOINT}                   https://kscas.ksd1446.com
# ${CAS ENDPOINT}                   https://kscas-staging.ksp1446.com
${CAS ENDPOINT}                   https://cas-staging.kipuworks.com

*** Test Cases ***
Login demo
  Switch to cas    demo    ${true}
  Cas login    c_r@d.com    new_pass0    ${Demo 2fa}
  Custom screenshot
  Sleep    300
  Page should have    NOT|Two Factor Code
  Switch to cas    master    ${true}
  # -select demo
  # -add location
  # -add roles
  # -save?
  Switch to cas    demo
  # -select demo
  # -verify!
  Go To    ${BASE URL}
  Start login    c_r@d.com    new_pass0    ${true}    ${Demo 2fa}
  I hit the "username" tab
  # -verify!
  Sleep    30
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Switch to cas    demo
  ...           AND             Exit system    ${false}

*** Keywords ***
Setup master cas user and demo user
  ###SECRETS###
  # cursor = conn.cursor()
  # cursor.execute("""SELECT table_name FROM information_schema.tables
  #        WHERE table_schema = 'public'""")
  # for table in cursor.fetchall():
  #     print(table)
  # cursor.execute("""Select * FROM users""")
  # colnames = [desc[0] for desc in cursor.description]
  # cursor.execute("""SELECT second_factor_secure_code FROM users WHERE first_name='O' AND last_name='G'""")
  # cursor.fetchone()
  # cursor.close()
  # conn.close()
  Return to mainpage
  Pocket global vars    Admin First    Admin Last    Username
  Start new window process    2500    20    ${CAS ENDPOINT}    2    ${EMPTY}
  Start new window process    2800    20    ${CAS ENDPOINT}    3    ${EMPTY}
  ${code} =    Retrieve 2fa code    O    G
  Set Suite Variable    ${Master 2fa}    ${code}
  Switch to cas    master
  Cas login    superOG@kipu.health
  ###SECRETS###
  Page should have    NOT|Two Factor Code    ELEMENT|//h1[.='Users']
  Click Link    /organizations/1/users/new
  Wait Until Page Contains Element    //form[@id='new_user']
  Form fill    ${EMPTY}    user_first_name:direct_text=cas_robot    user_last_name:direct_text=cas_demo
  ...          user_email:direct_text=c_r@d.com    user_password:direct_text=new_pass0
  ...          user[use_yubikey]:direct_radio=false
  Sleep    20
  Click Button    Create
  Slow wait    5
  Click Element    //a[@title='user']
  Click Element    //a[@title='rel-test02']
  Sleep    10
  ${code} =    Retrieve 2fa code    cas_robot    cas_demo
  Set Suite Variable    ${Demo 2fa}    ${code}

Exit all cas users
  Pocket global vars    restore
  Switch to cas    demo    ${true}
  Click Link    /users/sign_out
  Custom screenshot
  Close Browser
  Switch to cas    master    ${true}
  Dialog action    Click Element    //td[@class='email' and .='c_r@d.com']/following-sibling::td[${CSS SELECT.replace('$CSS','buttons')}]/a[@data-method='delete' and .='Delete']
  Click Link    /users/sign_out
  Close Browser
  Switch to hm    ${true}

Retrieve 2fa code
  [ARGUMENTS]    ${first name}    ${last name}
  Connect To Database    psycopg2
  ###SECRETS###
  Check If Exists In Database    SELECT id FROM users WHERE first_name='O' AND last_name='G'    True
  @{code} =    Query    SELECT second_factor_secure_code FROM users WHERE first_name='${first name}' AND last_name='${last name}'
               ...      True
  Disconnect From Database
  Log To Console    ${code}
  [RETURN]    ${code[-1][0]}

Cas login
  [ARGUMENTS]    ${email}    ${password}    ${code}
  Input Password    user_email    ${email}
  Input Password    user_password    ${password}
  Click Button    Sign in
  Do two factor    ${code}

Switch to hm
  [ARGUMENTS]    ${mainpage}=${false}
  Switch Browser    1
  Run Keyword If    ${mainpage}    Return to mainpage

Switch to cas
  [ARGUMENTS]    ${user}    ${mainpage}=${false}
  Run Keyword If    '${user}'=='master'    Switch Browser    2
  ...               ELSE                   Switch Browser    3
  Run Keyword If    ${mainpage}    Run Keywords    Go To    ${CAS ENDPOINT}
  ...                              AND             Slow wait
