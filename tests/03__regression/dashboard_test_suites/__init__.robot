*** Settings ***
Documentation   Special patient fill initialization for testing the dashboard test suites.
...
# Default Tags    regression    dashboard story    points-30    notester    hasprint    jtst
Resource        ../../../suite.robot
Suite Setup     Initialization dashboard patients
Suite Teardown  Devalue dashboard patients
Test Teardown   Run Keywords    Run Keyword If Test Failed    Custom screenshot
...             AND             Go To    ${Comeback}

*** Keywords ***
Initialization dashboard patients
  Set Global Variable    ${Dashboard Debug}    ${false}
  I select the "${_LOCATION 1}" location
  ${date} =    Convert Date    ${Todays Date}    result_format=%m/%d/%Y
  @{data} =    Run Keyword If    ${Dashboard Debug}    Create List
               ...               ELSE                  Create List    Season R Tor    Loreta R Tor    Glenn R Tor
               ...                                     Domenica R Tor    Delfina R Tor    Tran R Tor    Birdie R Tor
               ...                                     Forrest R Tor    Aida R Tor    Bea R Tor    Billie R Tor
               ...                                     Alyce R Tor    Evie R Tor    Chery R Tor    Taunya R Tor
               ...                                     Ruthie R Tor    Corey R Tor    Lucila R Tor    Dusti R Tor
               ...                                     Tamra R Tor    Leonel R Tor    Reyna R Tor    Kellie R Tor
               ...                                     Shin R Tor    Tamela R Tor    Colin R Tor    Vanetta R Tor
               ...                                     Jess R Tor    Sacha R Tor    Hilary R Tor    William R Tor
  FOR    ${index}    ${full name}    IN ENUMERATE    @{data}
      Set List Value    ${data}    ${index}    ${full name} ${date}
  END
  @{ids} =    Create List
  @{names} =    Create List
  ${ids}    ${names} =    Run Keyword If    ${Dashboard Debug}    Debug mode
                          ...               ELSE        Set Variable    ${ids}    ${names}
  Set Global Variable    ${Dashboard Ids}    ${ids}
  Set Global Variable    ${Dashboard Names}    ${names}
  Run Keyword If    not ${Dashboard Debug}    Create multiple patients with after actions    ${data}
  ...                                         Create dashboard medical orders
  Log Many    ${Dashboard Ids}
  Log Many    ${Dashboard Names}

Create dashboard medical orders
  [ARGUMENTS]    ${key}
  ${full name}    ${name}    ${id} =    Split String    ${key}    |
  Append To List    ${Dashboard Names}    ${full name}|${name}
  Run Keyword Unless    '${id}' in ${Dashboard Ids}    Append To List    ${Dashboard Ids}    ${id}
  Travel "slow" to "${name}" patients "medical orders" page in "null"
  ${passes} =    Run Keyword And Return Status    Page Should Contain Element
                 ...                              //div[@id='sub_nav_content']/table[@class='grid_index']
  Run Keyword Unless    ${passes}    Create a doctor order    medication
  Custom screenshot
  Return to mainpage

Devalue dashboard patients
  Run Keyword And Ignore Error    I select the "${_LOCATION 1}" location
  FOR    ${id}    IN    @{Dashboard Ids}
      Exit For Loop If    ${Dashboard Debug}
      Run Keyword And Ignore Error    Go To    ${BASE URL}${PATIENTS}/${id}/edit
      Run Keyword And Ignore Error    Dialog action    Click Link    delete
      Run Keyword And Ignore Error    Wait Until Page Contains    Notice
  END

Debug mode
  [DOCUMENTATION]    Change ids when debugging
  # @{ids} =    Create List    3975    3976    3977    3978    3979    3980    3981    3982    3983    3984    3985
  #             ...            3986    3987    3988    3989    3990    3991    3992    3993    3994    3995    3996
  #             ...            3997    3998    3999    4000    4001    4002    4003    4004    4005
  @{names} =    Create List    Season R Tor|Season T    Loreta R Tor|Loreta T    Glenn R Tor|Glenn T
                ...            Domenica R Tor|Domenica T    Delfina R Tor|Delfina T    Tran R Tor|Tran T
                ...            Birdie R Tor|Birdie T    Forrest R Tor|Forrest T    Aida R Tor|Aida T    Bea R Tor|Bea T
                ...            Billie R Tor|Billie T    Alyce R Tor|Alyce T    Evie R Tor|Evie T    Chery R Tor|Chery T
                ...            Taunya R Tor|Taunya T    Ruthie R Tor|Ruthie T    Corey R Tor|Corey T
                ...            Lucila R Tor|Lucila T    Dusti R Tor|Dusti T    Tamra R Tor|Tamra T
                ...            Leonel R Tor|Leonel T    Reyna R Tor|Reyna T    Kellie R Tor|Kellie T
                ...            Shin R Tor|Shin T    Tamela R Tor|Tamela T    Colin R Tor|Colin T
                ...            Vanetta R Tor|Vanetta T    Jess R Tor|Jess T    Sacha R Tor|Sacha T
                ...            Hilary R Tor|Hilary T    William R Tor|William T
  Return From Keyword    ${ids}    ${names}
