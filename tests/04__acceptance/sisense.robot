*** Settings ***
Documentation   .
...
Default Tags    acceptance    ac008    points    ntrdy
Resource        ../../suite.robot
Suite Setup     Begin sisense api and webpage    https://einstein.bid1446.com/app    data
# Suite Setup     Begin sisense api and webpage    https://bsi.ksd1446.com/app    cops
# Suite Setup     Begin sisense api and webpage    https://sisense.ksp1446.com/app    kaws
Suite Teardown  End sisense webpage and api
Test Teardown   Run Keywords    Run Keyword If Test Failed    Custom screenshot
...             AND             Switch to hm    ${true}

*** Test Cases ***
Add a user and finally delete all
  [TAGS]    testmesis
  Given I am on the "patients" page
  And extract api    Sisense << User Management << Users    qt1    delete    front=${Front env}
  And extract api    Sisense << User Management << Users    qt1    delete    front=${Front env}
  When switch to sisense    ${true}
  And I hit the "Admin" sisense tab
  Then get doc ready    page should have    sisense-admins@kipu.health
  When searching for "qt1"
  Then get doc ready    page should have    NOT|something_one@tezty.com    NOT|sisense-admins@kipu.health
  When extract api    Sisense << User Management << Users    qt1    post    firstname=will    lastname=bull
  ...                 email=something_one@tezty.com    front=${Front env}
  Then get doc ready    Reload Page
  When searching for "qt1"
  Then get doc ready    page should have    something_one@tezty.com    NOT|sisense-admins@kipu.health
  When extract api    Sisense << User Management << Users    qt1    post    firstname=will    lastname=bull
  ...                 email=something_one@tezty.com    front=${Front env}
  Then get doc ready    Reload Page
  When searching for "qt1"
  Then get doc ready    page should have    something_one@tezty.com    NOT|sisense-admins@kipu.health
  When extract api    Sisense << User Management << Users    qt1    delete    front=${Front env}
  Then get doc ready    Reload Page
  When searching for "qt1"
  Then get doc ready    page should have    NOT|something_one@tezty.com.com    NOT|sisense-admins@kipu.health
  # When extract api    default    Sisense << User Management << Users    qt1    post    firstname=will    lastname=bull
  # ...                 email=something@1z.com    front=e    status_code=201
  # And switch to sisense    ${true}
  # Click Element    //a[@data-translate='windowBase.headerLink.Admin']
  # Slow wait
  # Custom screenshot
  # Click Element    //div[@data-model='mySearchText']
  # Slow wait
  # Custom screenshot
  # Form fill    ${EMPTY}    input-with-placeholder-1:direct_enter_text=qt1
  # Slow wait
  # Custom screenshot
  # Then page should have    something@1z.com    NOT|todd.lee@kipu.health
  # When extract api    default    Sisense << User Management << Users    qt1    delete    front=e    status_code=204
  # And Reload Page
  # Slow wait
  # Click Element    //div[@data-model='mySearchText']
  # Slow wait
  # Custom screenshot
  # Form fill    ${EMPTY}    input-with-placeholder-1:direct_enter_text=qt1
  # Slow wait
  # Custom screenshot
  # Then page should have    NOT|something@1z.com

Add a user then a group then assign the user and finally delete all
  [TAGS]    testmesis
  [SETUP]    Name groups    pineapple gang
  Given I am on the "patients" page
  And extract api    Sisense << User Management << Users    qt2    delete    front=${Front env}
  And extract api    Sisense << User Management << Groups    ${Test group[0]}    delete    front=${Front env}
  And extract api    Sisense << User Management << Groups    ${Test group[0]}    delete    front=${Front env}
  When switch to sisense    ${true}
  And I hit the "Admin" sisense tab
  Then get doc ready    page should have    sisense-admins@kipu.health
  When searching for "qt2"
  Then get doc ready    page should have    NOT|something_two@tezty.com    NOT|sisense-admins@kipu.health
  When I hit the "Groups" admin nav
  Then get doc ready    page should have    Everyone
  When searching for "${Test group[0]}"
  Then get doc ready    page should have    NOT|${Test group[0]}    NOT|Everyone
  When extract api    Sisense << User Management << Users    qt2    post    firstname=will    lastname=bull
  ...                 email=something_two@tezty.com    front=${Front env}
  And extract api    Sisense << User Management << Groups    ${Test group[0]}    post    front=${Front env}
  And extract api    Sisense << User Management << Groups    ${Test group[0]}    post    front=${Front env}
  Then get doc ready    Reload Page
  When searching for "${Test group[0]}"
  Then get doc ready    page should have    ${Test group[0]}    NOT|Everyone
  And I edit the "${Test group[0]}" that should have "0" users
  And I hit the cancel button
  And I hit the "Users" admin nav
  When searching for "qt2"
  Then get doc ready    page should have    something_two@tezty.com    NOT|sisense-admins@kipu.health
  When extract api    Sisense << User Management << Groups    ${Test group[0]}    put    ext=removeuserfromgroup
  ...                 username=qt2    front=${Front env}
  And extract api    Sisense << User Management << Groups    ${Test group[0]}    put    ext=addusertogroup
  ...                username=qt2    front=${Front env}
  And extract api    Sisense << User Management << Groups    ${Test group[0]}    put    ext=addusertogroup
  ...                username=qt2    front=${Front env}
  Then I hit the "Groups" admin nav
  When searching for "${Test group[0]}"
  And get doc ready    page should have    ${Test group[0]}    NOT|Everyone
  Then I edit the "${Test group[0]}" that should have "something_two@tezty.com" users
  And I hit the cancel button
  When extract api    Sisense << User Management << Users    qt2    delete    front=${Front env}
  And get doc ready    Reload Page
  And searching for "${Test group[0]}"
  And get doc ready    page should have    ${Test group[0]}    NOT|Everyone
  Then I edit the "${Test group[0]}" that should have "0" users
  And I hit the cancel button
  When extract api    Sisense << User Management << Groups    ${Test group[0]}    delete    front=${Front env}
  And get doc ready    Reload Page
  And searching for "${Test group[0]}"
  Then get doc ready    page should have    NOT|${Test group[0]}    NOT|Everyone
  When extract api    Sisense << User Management << Users    qt2    delete    front=${Front env}
  And I hit the "Users" admin nav
  And searching for "qt2"
  Then get doc ready    page should have    NOT|something_two@tezty.com    NOT|sisense-admins@kipu.health

Add a group then a user to that group and finally delete all
  [TAGS]    testmesis
  [SETUP]    Name groups    watermelon gang
  Given I am on the "patients" page
  And extract api    Sisense << User Management << Users    qt3    delete    front=${Front env}
  And extract api    Sisense << User Management << Groups    ${Test group[0]}    delete    front=${Front env}
  When switch to sisense    ${true}
  And I hit the "Admin" sisense tab
  Then get doc ready    page should have    sisense-admins@kipu.health
  When searching for "qt3"
  Then get doc ready    page should have    NOT|something_three@tezty.com    NOT|sisense-admins@kipu.health
  When I hit the "Groups" admin nav
  Then get doc ready    page should have    Everyone
  When searching for "${Test group[0]}"
  Then get doc ready    page should have    NOT|${Test group[0]}    NOT|Everyone
  When extract api    Sisense << User Management << Groups    ${Test group[0]}    post    front=${Front env}
  And extract api    Sisense << User Management << Users    qt3    post    firstname=will    lastname=bull
  ...                email=something_three@tezty.com    groupnames=${Test group}    front=${Front env}
  And extract api    Sisense << User Management << Users    qt3    post    firstname=will    lastname=bull
  ...                email=something_three@tezty.com    groupnames=${Test group}    front=${Front env}
  Then get doc ready    Reload Page
  When searching for "${Test group[0]}"
  And get doc ready    page should have    ${Test group[0]}    NOT|Everyone
  Then I edit the "${Test group[0]}" that should have "1" users
  And I hit the cancel button
  And I hit the "Users" admin nav
  When searching for "qt3"
  Then get doc ready    page should have    something_three@tezty.com    NOT|sisense-admins@kipu.health
  When extract api    Sisense << User Management << Groups    ${Test group[0]}    delete    front=${Front env}
  Then get doc ready    Reload Page
  When searching for "qt3"
  Then get doc ready    page should have    something_three@tezty.com    NOT|sisense-admins@kipu.health
  And I hit the "Groups" admin nav
  When searching for "${Test group[0]}"
  Then get doc ready    page should have    NOT|${Test group[0]}    NOT|Everyone
  When extract api    Sisense << User Management << Users    qt3    delete    front=${Front env}
  And I hit the "Users" admin nav
  And searching for "qt3"
  Then get doc ready    page should have    NOT|something_three@tezty.com    NOT|sisense-admins@kipu.health

Add a user to a dashboard
  # [TAGS]    testmesis
  Given I am on the "patients" page
  And extract api    Sisense << User Management << Users    qt4    delete    front=${Front env}
  And switch to sisense    ${true}
  And create the "maracuya set" dashboard
  When I hit the "Admin" sisense tab
  Then get doc ready    page should have    sisense-admins@kipu.health
  When searching for "qt4"
  Then get doc ready    page should have    NOT|something_four@tezty.com    NOT|sisense-admins@kipu.health
  When extract api    Sisense << Dashboards    maracuya set    delete    ext=removeuserfromdashboard    username=qt4
  And extract api    Sisense << User Management << Users    qt4    post    firstname=will    lastname=bull
  ...                email=something_four@tezty.com    front=${Front env}
  And extract api    Sisense << Dashboards    maracuya set    delete    ext=removeuserfromdashboard    username=qt4
  And extract api    Sisense << Dashboards    maracuya set    post    ext=addusertodashboard    username=qt4
  And get doc ready    Reload Page
  Then searching for "qt4"
  And page should have    something_four@tezty.com    NOT|sisense-admins@kipu.health
  When set default password for "qt4"
  And sisense user login for "qt4"
  Then sleep    10
  When extract api    Sisense << Dashboards    maracuya set    delete    ext=removeuserfromdashboard    username=qt4
  And get doc ready    Reload Page
  Then sleep    10
  And sisense user logout
  When extract api    Sisense << User Management << Users    qt4    delete    front=${Front env}
  And get doc ready    Reload Page
  Then searching for "qt4"
  And get doc ready    page should have    NOT|something_four@tezty.com    NOT|sisense-admins@kipu.health
  # I hit the "Analytics" text
  # get doc ready    Click Link    /app/main#/home
  When I hit the "Analytics" sisense tab
  Then delete the "maracuya set" dashboard

Add groups to dashboards
  # [TAGS]    testmesis
  Given I am on the "patients" page
  extract api    Sisense << Dashboards    billing-purr    post    ext=addusertodashboard
  ...            username=Guillermo.Torijano@kipu.health    front=${Front env}
  extract api    Sisense << Dashboards    billing-purr    post    ext=addusertodashboard
  ...            username=Guillermo.Torijano@kipu.health    owner=guillermo.torijano@kipu.health    front=${Front env}
  extract api    Sisense << Dashboards    billing-purr    post    ext=addusertodashboard
  ...            username=Guillermo.Torijano@kipu.health    owner=guillermo.hernandez@kipu.health    front=p
  extract api    Sisense << Dashboards    xxxxxx-xx    post    ext=addusertodashboard
  ...            username=Guillermo.Torijano@kipu.health    owner=guillermo.hernandez@kipu.health    front=${Front env}
  extract api    Sisense << Dashboards    billing-purr    post    ext=addusertodashboard
  ...            username=Guillermo.Torijano@kipu.health    owner=guillermo.hernandez@kipu.health    front=${Front env}
  switch to sisense    ${true}
  Reload Page
  sleep    40
  extract api    Sisense << Dashboards    billing-purr    delete    ext=removeuserfromdashboard
  ...            username=Guillermo.Torijano@kipu.health    owner=guillermo.hernandez@kipu.health    front=${Front env}
  Reload Page
  sleep    10

Add groups along with a user in one then modify the user and show the changes
  # [TAGS]    testmesis
  [SETUP]    Name groups    pecans gang;maple gang|waffle gang|maple gang|choco gang
  Given I am on the "patients" page
  And extract api    Sisense << User Management << Users    qt6    delete    front=${Front env}
  And extract api    Sisense << User Management << Users    n1 qt6    delete    front=${Front env}
  And extract api    Sisense << User Management << Users    n2 qt6    delete    front=${Front env}
  And extract api    Sisense << User Management << Users    n3 qt6    delete    front=${Front env}
  And extract api    Sisense << User Management << Users    n4 qt6    delete    front=${Front env}
  And extract api    Sisense << User Management << Groups    ${Test group 1[0]}    delete    front=${Front env}
  And extract api    Sisense << User Management << Groups    ${Test group 1[1]}    delete    front=${Front env}
  And extract api    Sisense << User Management << Groups    ${Test group 2[0]}    delete    front=${Front env}
  When switch to sisense    ${true}
  And I hit the "Admin" sisense tab
  Then get doc ready    page should have    sisense-admins@kipu.health
  When searching for "qt6"
  Then get doc ready    page should have    NOT|something_six@tezty.com    NOT|something_six_n2@tezty.com
  ...                   NOT|something_six_n3@tezty.com    NOT|something_six_n4@tezty.com
  ...                   NOT|sisense-admins@kipu.health
  When I hit the "Groups" admin nav
  Then get doc ready    page should have    Everyone
  When searching for "${Test group 1[0]}"
  Then get doc ready    page should have    NOT|${Test group 1[0]}    NOT|${Test group 1[1]}   NOT|${Test group 2[0]}
  ...                   NOT|Everyone
  When searching for "${Test group 1[1]}"
  Then get doc ready    page should have    NOT|${Test group 1[0]}    NOT|${Test group 1[1]}   NOT|${Test group 2[0]}
  ...                   NOT|Everyone
  When searching for "${Test group 2[0]}"
  Then get doc ready    page should have    NOT|${Test group 1[0]}    NOT|${Test group 1[1]}   NOT|${Test group 2[0]}
  ...                   NOT|Everyone
  When extract api    Sisense << User Management << Groups    ${Test group 1[0]}    post    front=${Front env}
  And extract api    Sisense << User Management << Groups    ${Test group 1[1]}    post    front=${Front env}
  And extract api    Sisense << User Management << Groups    ${Test group 2[0]}    post    front=${Front env}
  And extract api    Sisense << User Management << Users    qt6    post    firstname=will    lastname=bull
  ...                email=something_six@tezty.com    groupnames=${Test group 1}    front=${Front env}
  Then get doc ready    Reload Page
  When searching for "${Test group 1[0]}"
  And get doc ready    page should have    ${Test group 1[0]}    NOT|${Test group 1[1]}   NOT|${Test group 2[0]}
  ...                  NOT|Everyone
  Then I edit the "${Test group 1[0]}" that should have "something_six@tezty.com" users
  And I hit the cancel button
  When searching for "${Test group 1[1]}"
  And get doc ready    page should have    NOT|${Test group 1[0]}    ${Test group 1[1]}   NOT|${Test group 2[0]}
  ...                  NOT|Everyone
  Then I edit the "${Test group 1[1]}" that should have "something_six@tezty.com" users
  And I hit the cancel button
  When searching for "${Test group 2[0]}"
  And get doc ready    page should have    NOT|${Test group 1[0]}    NOT|${Test group 1[1]}   ${Test group 2[0]}
  ...                  NOT|Everyone
  Then I edit the "${Test group 2[0]}" that should have "0" users
  And I hit the cancel button
  When I hit the "Users" admin nav
  And searching for "qt6"
  Then get doc ready    page should have    will    bull    something_six@tezty.com    NOT|sisense-admins@kipu.health
  When extract api    Sisense << User Management << Users    qt6    put    firstname=n1 will    lastname=n1 bull
  ...                 newusername=n1 qt6    email=something_six_n1@tezty.com    front=${Front env}
  Then get doc ready    Reload Page
  When searching for "n1 qt6"
  Then get doc ready    page should have    n1 will    n1 bull    NOT|something_six@tezty.com
  ...                   something_six_n1@tezty.com    NOT|sisense-admins@kipu.health
  And I hit the "Groups" admin nav
  When searching for "${Test group 1[0]}"
  Then I edit the "${Test group 1[0]}" that should have "something_six_n1@tezty.com" users
  And I hit the cancel button
  When searching for "${Test group 1[1]}"
  Then I edit the "${Test group 1[1]}" that should have "something_six_n1@tezty.com" users
  And I hit the cancel button
  When searching for "${Test group 2[0]}"
  Then I edit the "${Test group 2[0]}" that should have "0" users
  And I hit the cancel button
  When extract api    Sisense << User Management << Users    n1 qt6    put    firstname=n2 will    lastname=n2 bull
  ...                 newusername=n2 qt6    email=something_six_n2@tezty.com    groupnames=${Test group 3}
  ...                 front=${Front env}
  Then get doc ready    Reload Page
  When searching for "${Test group 1[0]}"
  Then I edit the "${Test group 1[0]}" that should have "0" users
  And I hit the cancel button
  When searching for "${Test group 1[1]}"
  Then I edit the "${Test group 1[1]}" that should have "something_six_n2@tezty.com" users
  And I hit the cancel button
  When searching for "${Test group 2[0]}"
  Then I edit the "${Test group 2[0]}" that should have "0" users
  And I hit the cancel button
  When I hit the "Users" admin nav
  And searching for "n2 qt6"
  Then get doc ready    page should have    n2 will    n2 bull    NOT|something_six@tezty.com
  ...                   NOT|something_six_n1@tezty.com    something_six_n2@tezty.com    NOT|sisense-admins@kipu.health
  When extract api    Sisense << User Management << Users    n2 qt6    put    firstname=n3 will    lastname=n3 bull
  ...                 newusername=n3 qt6    email=something_six_n3@tezty.com    groupnames=${Test group 4}
  ...                 front=${Front env}
  And get doc ready    Reload Page
  And searching for "qt6"
  Then get doc ready    page should have    NOT|n3 will    NOT|n3 bull    n2 will    n2 bull
  ...                   NOT|something_six@tezty.com    something_six_n2@tezty.com    NOT|something_six_n3@tezty.com
  ...                   NOT|sisense-admins@kipu.health
  And I hit the "Groups" admin nav
  When searching for "${Test group 1[0]}"
  Then I edit the "${Test group 1[0]}" that should have "0" users
  And I hit the cancel button
  When searching for "${Test group 1[1]}"
  Then I edit the "${Test group 1[1]}" that should have "something_six_n2@tezty.com" users
  And I hit the cancel button
  When searching for "${Test group 2[0]}"
  Then I edit the "${Test group 2[0]}" that should have "0" users
  And I hit the cancel button
  When extract api    Sisense << User Management << Users    n2 qt6    put    firstname=n4 will    lastname=n4 bull
  ...                 newusername=n4 qt6    email=something_six_n4@tezty.com    groupnames=${Test group 2}
  ...                 front=${Front env}
  Then get doc ready    Reload Page
  When searching for "${Test group 1[0]}"
  Then I edit the "${Test group 1[0]}" that should have "0" users
  And I hit the cancel button
  When searching for "${Test group 1[1]}"
  Then I edit the "${Test group 1[1]}" that should have "0" users
  And I hit the cancel button
  When searching for "${Test group 2[0]}"
  Then I edit the "${Test group 2[0]}" that should have "something_six_n4@tezty.com" users
  And I hit the cancel button
  When I hit the "Users" admin nav
  And searching for "n4 qt6"
  Then get doc ready    page should have    n4 will    n4 bull    NOT|something_six@tezty.com
  ...                   NOT|something_six_n2@tezty.com    NOT|something_six_n3@tezty.com    something_six_n4@tezty.com
  ...                   NOT|sisense-admins@kipu.health
  When extract api    Sisense << User Management << Groups    ${Test group 1[0]}    delete    front=${Front env}
  And extract api    Sisense << User Management << Groups    ${Test group 1[1]}    delete    front=${Front env}
  And extract api    Sisense << User Management << Groups    ${Test group 2[0]}    delete    front=${Front env}
  And I hit the "Groups" admin nav
  When searching for "${Test group 1[0]}"
  And get doc ready    page should have    NOT|${Test group 1[0]}    NOT|${Test group 1[1]}   NOT|${Test group 2[0]}
  ...                  NOT|Everyone
  When searching for "${Test group 1[1]}"
  And get doc ready    page should have    NOT|${Test group 1[0]}    NOT|${Test group 1[1]}   NOT|${Test group 2[0]}
  ...                  NOT|Everyone
  When searching for "${Test group 2[0]}"
  And get doc ready    page should have    NOT|${Test group 1[0]}    NOT|${Test group 1[1]}   NOT|${Test group 2[0]}
  ...                  NOT|Everyone
  When I hit the "Users" admin nav
  And searching for "qt6"
  Then get doc ready    page should have    n4 will    n4 bull    NOT|something_six@tezty.com
  ...                   NOT|something_six_n2@tezty.com    NOT|something_six_n3@tezty.com    something_six_n4@tezty.com
  ...                   NOT|sisense-admins@kipu.health
  When extract api    Sisense << User Management << Users    qt6    delete    front=${Front env}
  And extract api    Sisense << User Management << Users    n1 qt6    delete    front=${Front env}
  And extract api    Sisense << User Management << Users    n2 qt6    delete    front=${Front env}
  And extract api    Sisense << User Management << Users    n3 qt6    delete    front=${Front env}
  And extract api    Sisense << User Management << Users    n4 qt6    delete    front=${Front env}
  Then get doc ready    Reload Page
  When searching for "qt6"
  Then get doc ready    page should have    NOT|something_six@tezty.com    NOT|something_six_n2@tezty.com
  ...                   NOT|something_six_n3@tezty.com    NOT|something_six_n4@tezty.com
  ...                   NOT|sisense-admins@kipu.health

Retrieve data from crm endpoint
  # [TAGS]    testmesis
  Given I am on the "patients" page
  When extract api    json dict    Sisense << Crm    e    patient_state=FL    facility_state=FL    envoy_id=87726
  Then No Operation

*** Keywords ***
Begin sisense api and webpage
  [ARGUMENTS]    ${front end}    ${front env}
  Set Suite Variable    ${Front end}    ${front end}
  Set Suite Variable    ${Front env}    ${front env}
  Return to mainpage
  Sisense << Setup api
  Start new window process    2700    20    ${Front end}/account#/login    2    ${EMPTY}
  Get doc ready    Switch to sisense
  Input Password    username    ${SISENSE USER}
  Input Password    password    ${SISENSE PASS ${Front env}}
  Get doc ready    Click Element    //span[@data-translate\='account.login.loginbtn']
  Switch to hm

End sisense webpage and api
  Switch to sisense    ${true}
  Get doc ready    Click Element    //a[${CSS SELECT.replace('$CSS','js--user-menu')}]
  I quickly hit the "Sign Out" text
  Close Browser
  Switch to hm    ${true}
  Delete All Sessions

Switch to sisense
  [ARGUMENTS]    ${mainpage}=${false}
  Switch Browser    2
  Run Keyword If    ${mainpage}    Get doc ready    Go To    ${Front end}/main#/home

Switch to hm
  [ARGUMENTS]    ${mainpage}=${false}
  Switch Browser    1
  Run Keyword If    ${mainpage}    Return to mainpage

Sisense user login for "${user}"
  Start new window process    2700    20    ${Front end}/account#/login    3    ${EMPTY}
  Get doc ready    Switch Browser    3
  Input Password    username    ${user}
  Input Password    password    Kipu123!
  Get doc ready    Click Element    //span[@data-translate\='account.login.loginbtn']

Sisense user logout
  Get doc ready    Go To    ${Front end}/main#/home
  Get doc ready    Click Element    //a[${CSS SELECT.replace('$CSS','js--user-menu')}]
  I quickly hit the "Sign Out" text
  Sleep    2
  Close Browser
  Switch to sisense

Set default password for "${user}"
  Get doc ready    Click Element    //span[@title\='${user}']/../../following-sibling::div[last()]/div/button[@title\='Modify user settings']
  I quickly hit the "Change Password" text
  Get doc ready    Form fill    \${EMPTY}    //input[@data-ng-model\='pass']:direct_text=Kipu123!
  ...              //input[@data-ng-model\='repass']:direct_enter_text=Kipu123!

Searching for "${input}"
  Get doc ready    Click Element    //div[${CSS SELECT.replace('$CSS','toolbar-searchbox')}]
  Get doc ready    Form fill    \${EMPTY}
  ...              //div[@class\='toolbar-searchbox__fields']/div/input:direct_quick_text=${input}

Name groups
  [ARGUMENTS]    ${names}
  @{groups} =    Split String    ${names}    |
  FOR    ${index}    ${group}    IN ENUMERATE    @{groups}
      @{name} =    Split String    ${group}    ;
      Run Keyword If    len(${groups})==1    Run Keywords    Set Test Variable    ${Test group}    ${name}
      ...                                    AND             Return From Keyword
      Set Test Variable    ${Test group ${index+1}}    ${name}
  END
  # @{group} =    Create List    ${name}
  # FOR    ${name}    IN    @{names}
  #     Run Keyword If    isinstance(${name},int)    Create List    ${name}
  # END
  # @{group} =    Create List    ${name}
  # Set Test Variable    ${Test group}    ${group}

Create the "${named}" dashboard
  Delete the "${named}" dashboard
  I quickly hit the "To Create Your Dashboard" text
  Get doc ready    Click Element    //div[@class\='datasource-selector']
  I quickly hit the "billing-sandbox" text
  Get doc ready    Form fill    \${EMPTY}    //input[@data-ng-model\='form.title']:direct_enter_text=${named}
  # # I hit the "Analytics" text
  # Get doc ready    Click Link    /app/main#/home
  I hit the "Analytics" sisense tab
  Page should have    ${named}

Delete the "${named}" dashboard
  Get doc ready    Click Element    //span[@data-icon-name\="'general-selected'"]
  @{elements} =    Get Webelements    //a[.='${named}']/ancestor::div[${CSS SELECT.replace('$CSS','list-item')}]/div[${CSS SELECT.replace('$CSS','navver-checkbox-holder')}]
  ${passes} =    Run Keyword And Return Status    Length Should Be    ${elements}    0
  Return From Keyword If    ${passes}
  FOR    ${element}    IN    @{elements}
      Select Checkbox    ${element}
  END
  # Click Element    //span[@data-icon-name="'general-delete'"]
  Get doc ready    Click Element    //button[@action\='Delete']
  Get doc ready    Click Element    //button[${CSS SELECT.replace('$CSS','conf-btn-ok')}]
  Page should have    NOT|${named}

I hit the "${tab}" sisense tab
  Get doc ready    Click Element    //a[@data-translate\='windowBase.headerLink.${tab}']

I hit the "${nav}" admin nav
  Get doc ready    Click Element    //div[@class\='set-nav-text' and @title\='${nav}']

I quickly hit the "${text}" text
  Get doc ready    Click Element    //*[.\='${text}' or contains(text(),'${text}')]

# Verify this email "${email}" on table
#   Get doc ready    Page should have
#   ...              //div[@class\='members-list']/div[last()]//div[@class\='email-text' and .\='${email}']

I edit the "${group}" that should have "${number}" users
  Get doc ready    Click Element    //span[@title\='${group}']/../../following-sibling::div[last()]/div/button[@title\='Modify group settings']
  Return From Keyword If    '${number}'=='skip'
  @{members} =    Get Webelements    //div[@class='members-list']/div[last()]/div
  ${users} =    Split String    ${number}    ;
  ${passes} =    Run Keyword And Return Status    Evaluate    int(${users[0]})
  # ${users} =    Run Keyword If    ';' in "${number}"    Split String    ${number}    ;
  #               ...               ELSE                  Set Variable    ${number}
  # ${number} =    Run Keyword If    isinstance(${users},list)    Get Length    ${users}
  #                ...               ELSE                         Set Variable    ${users}
  ${number} =    Run Keyword If    ${passes}    Set Variable    ${users[0]}
                 ...               ELSE         Get Length    ${users}
  Run Keyword And Continue On Failure    Length Should Be    ${members}    ${number}
  # Return From Keyword If    not isinstance(${users},list)
  Return From Keyword If    ${passes}
  FOR    ${member}    IN    @{members}
      # ${member} =    Set Variable    ${member.find_element_by_css_selector('div>div.member-details-holder>div').get_attribute('innerHTML')}
      Run Keyword And Continue On Failure    Remove Values From List    ${users}
      ...                                    ${member.find_element_by_css_selector('div>div.member-details-holder>div').get_attribute('innerHTML')}
  END
  Run Keyword And Continue On Failure    Length Should Be    ${users}    0

I hit the cancel button
  Get doc ready    Click Element    //span[@class\='btn__text' and .\='Cancel']

Get doc ready
  [ARGUMENTS]    @{action}    &{optional fields}
  ${body} =    Get Webelement    //body
  ${count} =    Set Variable    ${0}
  ${passes} =    Run Keyword And Return Status    Run Keyword    @{action}    &{optional fields}
  FOR    ${i}    IN RANGE    50
      Sleep    0.5
      ${TRASH}    ${catch} =    Run Keyword And Ignore Error    Evaluate    ${body.get_attribute('value')}
      ${count} =    Set Variable If    'StaleElementReferenceException' not in """${catch}"""    ${count+1}    ${0}
      Exit For Loop If    ${count}==3
      Continue For Loop If    ${count}!=0
      ${body} =    Get Webelement    //body
  END
  Wait For Condition    return window.document.readyState==="complete"    timeout=3
  Run Keyword Unless    ${passes}    Run Keywords    Sleep    1
  ...                                AND             @{action}    &{optional fields}

Extract api
  # [ARGUMENTS]    ${expect}    @{api}    &{optional fields}
  [ARGUMENTS]    @{api}    &{optional fields}
  ${status code} =    Pop From Dictionary    ${optional fields}    status_code    200
  ${resp} =    Run Keyword    @{api}    &{optional fields}
  ${passes}    ${decode} =    Run Keyword And Ignore Error    Evaluate    json.loads('''${resp.json()}''')    json
  ${passes}    @{decode} =    Run Keyword If    '${passes}'=='PASS'    Set Variable    PASS    string    ${decode}
                              ...               ELSE                   Run Keyword And Ignore Error    Set Variable
                              ...                                      json    ${resp.json()}
  ${passes}    ${decode} =    Run Keyword If    '${passes}'!='FAIL'    Set Variable    PASS    ${decode}
                              ...               ELSE                   Run Keyword And Ignore Error    Set Variable
                              ...                                      text    ${resp.text}
  Run Keyword If    '${passes}'=='FAIL'    Run Keywords    Run Keyword And Continue On Failure    Fail
  ...                                                      ${resp.status_code} Cannot parse json!
  ...                                      AND             Return From Keyword
  ${type 1}    ${decode} =    Set Variable    @{decode}
  # ${passes}    ${resp value} =    Run Keyword And Ignore Error    Get From List    ${resp string}    0
  # ${type 2}    ${resp value} =    Run Keyword If    '${passes}'=='PASS'    Set Variable    list    ${resp value}
  #                                 ...               ELSE                   Set Variable    dict    ${resp string}
  ${type 2} =     Set Variable If    '${type 1}'=='text'           text
                  ...                isinstance(${decode},dict)    dict
                  ...                True                          list
  # ${decode} =    Run Keyword If    '${type 2}'=='text'    Create List    ${decode}
  #                ...               ELSE                   Set Variable    ${decode}
  ${decode} =    Run Keyword If    '${type 2}'!='dict'    Create Dictionary    response=${decode}
                 ...               ELSE                   Set Variable    ${decode}
  &{response} =    Create Dictionary    object=${decode}    type=${type 1} ${type 2}    status_code=${resp.status_code}
  # Run Keyword If    '${expect}'!='default' and '${expect}'!='${type 1} ${type 2}'
  # ...                                        Run Keyword And Continue On Failure    Fail
  # ...                                        Response should be ${expect} but was ${type 1} ${type 2}!
  # Run Keyword And Continue On Failure    Should Be True    ${response.status_code}==${${status code}}
  # Run Keyword Unless    '${expect}'=='default'    Run Keyword And Continue On Failure    Should Be True
  # ...                                             '${response.type}'=='${expect}'
  Run Keyword And Continue On Failure    Fail    Catch response!
  Log Many    &{response}
  [RETURN]    ${response}
