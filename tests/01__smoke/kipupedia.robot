*** Settings ***
Documentation   Runs through Kipupedia.
...
Default Tags    smoke    sm004    demo    ntrdy
Resource        ../../suite.robot
Suite Setup     Login into demo instance and hit help
Suite Teardown  Exit kipupedia
Test Teardown   Run Keywords    Run Keyword If Test Failed    Custom screenshot
...             AND             Return to kipupedia

*** Test Cases ***
A user can search the knowledge base
  Given I am on kipupedia
  When searching knowledge base for "super admin"
  Then Page Should Contain    First Time Super Admin

A user can view the calendar as a list and search by date/name
  Given I am on kipupedia
  When I hit the "kp calendar" kp tab
  And view the calendar in "list" mode
  And search on "2017-05-01" for "webinar"
  Then only "Webinar" events will show up in "list" mode
  And pick an event in "list" mode
  And confirm calendar is in "list" mode

A user can view the calendar as a month and search by date/name
  Given I am on kipupedia
  When I hit the "kp calendar" kp tab
  And view the calendar in "month" mode
  And search on "2017-05" for "train"
  Then only "Training" events will show up in "month" mode
  And pick an event in "month" mode
  And confirm calendar is in "month" mode

A user can view the calendar as a day and search by date/name
  Given I am on kipupedia
  When I hit the "kp calendar" kp tab
  And view the calendar in "day" mode
  And search on "2017-04-04" for ""
  Then only "" events will show up in "day" mode
  And pick an event in "day" mode
  And confirm calendar is in "day" mode

A user can click on any event in the calendar and register
  Given I am on kipupedia
  When I hit the "kp calendar" kp tab
  And view the calendar in "month" mode
  And search on "2017-05-24" for ""super admin class for beginners""
  And pick an event in "month" mode
  Then I should be able to register

A user can export the month's events to his own calendar
  [TAGS]    skip, starts an outside system event
  Given I am on kipupedia

A user can view the upcoming months
  Given I am on kipupedia
  When I hit the "kp calendar" kp tab
  And view the calendar in "month" mode
  And search on "2022-12" for ""
  Then Page Should Contain    Events for December 2022

A user can browse client services tab
  Given I am on kipupedia
  When I hit the "kp client services" kp tab
  Then page should have    Lester Toledo    Juliet Urbina    Monica Oriti    Joaquin Montero    Daylen Diaz    Melanie Orel

A user can browse kipu marktplace tab
  Given I am on kipupedia
  When I hit the "kp kipu marketplace" kp tab
  Then Page Should Have    KIPU Marketplace℠

A user can click on any link while browsing kipu marktplace tab
  [SETUP]    Run Keywords    I am on kipupedia
  ...                        I hit the "kp kipu marketplace" kp tab
  [TEMPLATE]    I click on this ${link} and I should be on that page
  Introduction
  Interface Supporting Labs
  Interface Supporting Analyzer Software
  VOBGetter℠ Konnector
  ePrescribe (coming soon)

A user can browse videos tab
  Given I am on kipupedia
  When I hit the "kp videos" kp tab
  Then Page Should Have    Coming soon…

A user can browse release notes tab and click on any release note
  Given I am on kipupedia
  When I hit the "kp release notes" kp tab
  Then Page Should Contain Element    //i[@class='fa fa-pencil-square-o']
  And select a release note

A user can go back and forward between the tabs
#No forward tab
  Given I am on kipupedia
  When I hit the "Getting Started" text
  And Page Should Contain    Getting Started
  And use the back tab
  Then I am on kipupedia

*** Keywords ***
Login into demo instance and hit help
  Execute Javascript    window.open('https://demo.kipuworks.com','_blank')
  Select Window    new
  Start login    ${CAS USER}    ${CAS PASS}
  I hit the "help" tab
  Select Window    new
  Set Window Position    2200    20
  I am on kipupedia

Exit kipupedia
  Close Window
  Select Window    url=https://demo.kipuworks.com${PATIENTS}
  Click Link    Sign out
  Close Window
  Select Window    main
  I am on the "patients" page

Return to kipupedia
  Click Element    //a[@title='Kipu Systems Wiki']
  I am on kipupedia

I am on kipupedia
  [ARGUMENTS]    ${page}=${EMPTY}
  Wait Until Page Contains Element    //img[@alt='Kipu Systems Wiki']
  Run Keyword If    '${page}'=='${EMPTY}'    Location Should Contain    ${HELP}
  ...               ELSE                     Location Should Contain    ${HELP}${${page}}

I hit the "${tab}" kp tab
  Click Link    ${HELP}${${tab}}
  I am on kipupedia    ${tab}

Searching knowledge base for "${search}"
  Form fill    ${EMPTY}    kb-s:direct_text=${search}
  Click Element    searchsubmit

View the calendar in "${view}" mode
  Click Element    //ul[@class='tribe-bar-views-list']
  Click Element    //ul[@class='tribe-bar-views-list']/li[@data-view='${view}']
  Run Keyword Unless    '${view}'=='month'    Click Element    tribe-bar-collapse-toggle
  Wait Until Element Is Visible    tribe-bar-search

Search on "${date}" for "${search}"
  Form fill    ${EMPTY}    tribe-bar-date:direct_text=${date}    tribe-bar-search:direct_text=${search}
  Click Element    //input[@value='Find Events']
  Ajax wait

Only "${event}" events will show up in "${view}" mode
  Run Keyword If    '${view}'=='list'    Do search in    //div[@class='tribe-events-loop']/div
  ...                                                    find_element_by_class_name('tribe-event-url').get_attribute('innerHTML')
  ...                                                    ${event}
  ...    ELSE IF    '${view}'=='month'   Do search in    //table[@class='tribe-events-calendar']/tbody/tr/td[${CSS SELECT.replace('$CSS','tribe-events-has-events')}]
  ...                                                    find_element_by_class_name('tribe-events-month-event-title').get_attribute('innerHTML')
  ...                                                    ${event}
  ...               ELSE                 Do search in    //div[@class='tribe-events-loop']/div[position()>1]
  ...                                                    find_element_by_class_name('url').get_attribute('innerHTML')
  ...                                                    ${event}

Pick an event in "${view}" mode
  Run Keyword If    '${view}'=='month'   Click Element    //div[contains(@id,'tribe-events-event-')]/h3/a[1]
  ...               ELSE                 Click Element    //div[contains(@id,'post-')]/h2/a[1]

Confirm calendar is in "${view}" mode
  Go Back
  ${view mode} =    Get Element Attribute    //ul[@class='tribe-bar-views-list']/li[1]    data-view
  Should Be Equal    ${view}    ${view mode}
  Pick an event in "${view}" mode
  Use the back tab
  ${view mode} =    Get Element Attribute    //ul[@class='tribe-bar-views-list']/li[1]    data-view
  Should Be Equal    ${view}    ${view mode}

I should be able to register
  ${current} =    Log Location
  Click Element    //*[@style='color: #0000ff;']
  ${new} =    Log Location
  Should Not Be Equal    ${current}    ${new}
  Go Back

I click on this ${link} and I should be on that page
  I hit the "${link}" view
  Page Should Have    ${link}
  Use the back tab

Select a release note
  Click Element    //article[contains(@id,'post-')]//h3/a[1]
  Page Should Contain    KIPU Release Notes for

Use the back tab
  Scrolling down
  Wait Until Element Is Visible    //a[@title='Back']
  Sleep    0.5
  Click Element    //a[@title='Back']
