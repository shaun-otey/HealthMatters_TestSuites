*** Settings ***
Documentation   .
...
Default Tags    regression    re031    ntrdy
Resource        ../../suite.robot
# Suite Setup     Run Keywords    Connect lab two
# ...                             Return to mainpage
# Suite Setup     I hit the "settings" tab
# Suite Teardown  Return to mainpage
# Test Teardown   ...

*** Test Cases ***
Labs setup
  Begin labs connection

*** Keywords ***
Connect lab two
  I hit the "settings" tab
  I hit the "Instance" view
  Instance edit "Select Radio Button:true" on "Kipu Labs:radio"
  Instance edit "Select Checkbox" on "HL7 Lab Interface"
  Instance edit "Select Checkbox" on "Allow image upload for requisitions"
  Click Button    commit
  Ajax wait
  I hit the "Konnectors" view
  Loop deletion    Click Element    //a[.='labtwo']/ancestor::td[1]/following-sibling::td[last()]/a
  I hit the "New Konnector" text
  Form fill    vendor    name=labtwo    type:dropdown=Lab
  Click Button    commit
  &{locations hit} =    Create dict for locations    ${_LOCATION 1};${_LOCATION 2};${_LOCATION 3};${_LOCATION 5}
  Form fill    vendor    status:checkbox=x    contact name=Joe Markson    contact phone=901-123-4567    city=San Pedro
  ...          state:dropdown=Alaska    zip=00001    company phone=305-898-9999    company fax=305-123-9991
  ...          lab results:checkbox=x    lab orders:checkbox=x    lab order prod mode=x    lab req patient diag code=o
  ...          lab send medical necessity:checkbox=x    lab facilty id=QA1    lab code=TESTINGQA
  ...          sftp server=bamboo.kipuworks.com    sftp port=115    sftp user name=sftp_userx2
  ...          sftp password=B~NNKEJ[lM@IG)(YOxZ{1    sftp results=/bamboo/sftp2/1-BestToxLab/results/
  ...          sftp orders=/bamboo/sftp2/1-BestToxLab/orders/

Connect lab
  ...

Begin labs connection
  ${virtual lab setup} =    Run Keyword And Return Status    Should Not Be Equal As Strings    ${BASE URL}
  ...                                                                                          ${BASE URL TEST}
  Set Suite Variable    ${Virtual lab setup}    ${virtual lab setup}
  Run Keyword If    ${Virtual lab setup}    Change staging url
  I hit the "settings" tab
  I hit the "Kipu Labs" view
  I hit the "Lab Client Settings" view
  # ${rand} =    Generate Random String    4    [NUMBERS]
  Form fill    lab client    code=GUILLERMO    send lab test req:radio=true    notify reviewed reports:radio=true
  ...          label printer:radio=false    working mode:dropdown=Production    import lab reports:radio=true
  ...          processing period=30    sync lab client info:radio=true    notify assigned report:radio=true
  ...          notify medical review:radio=true    sync labs platform info:radio=true
  ...          notify unassigned report:radio=true
  Click Element    //input[@type='submit']
  I hit the "Lab Client Status" view
  Wait Until Keyword Succeeds    12x    10s
  ...                            Run Keywords    Reload Page
  ...                            AND             Custom screenshot
  ...                            AND             Dialog action    Click Link
  ...                                            /kipu_labs/lab_client_status/synchronize_lab_client_info
  # Wait Until Keyword Succeeds    15x    20s
  Wait Until Keyword Succeeds    15x    8s
  ...                            Run Keywords    Reload Page
  ...                            AND             Custom screenshot
  ...                            AND             Element Should Contain    //span[@class='label label-success']    Yes
  # ...                            AND             Element Should Contain    //span[@class='label label-danger']    Yes
  # check konnectors for lab verify
  #
  # return to mainpage
  # select test patient
  # lab orders
  # ...
  [TEARDOWN]    Run Keyword If    ${Virtual lab setup}    Default staging url
  # kill ngrok

Change staging url
  ${port} =    Set Variable    ${BASE URL.rsplit(':',1)[-1]}
  Import Library    Process
  Start Process    ngrok    http    -inspect\=false    -bind-tls\=true    ${port}
  Sleep    5
  ${virtual url} =    Run Process    curl    --silent    --show-error    http://127.0.0.1:4040/api/tunnels
  # ${virtual url} =    Create Dictionary    ${virtual url.stdout}
  # &{virtual url} =    Set Variable    ${virtual url.json()}
  @{virtual url} =    Split String    ${virtual url.stdout}    ,
  @{virtual url} =    Get Matches    ${virtual url}    "public_url"*
  # ${virtual url} =    Fetch From Right    @{virtual url[0].replace('\"','')}    https://
  ${virtual url} =    Fetch From Right    @{virtual url}[0]    https://
  Log    ${virtual url}
  # ${virtual url} =    Run Process    sed    -nE    's/.*public_url":"https:..([^"]*).*/\\1/p'    ${virtual url.stdout}
  # Log    ${virtual url.tunnels[0].public_url}
  Login into kis labs staging    https://${virtual url.replace('\"','')}

Default staging url
  Terminate Process
  Login into kis labs staging    ${BASE URL TEST}

Login into kis labs staging
  [ARGUMENTS]    ${url}
  Start new window process    2700    20    https://kis-labs-staging.herokuapp.com/admin/apps/43/edit    2
  Switch Browser    2
  ${pass} =    Get Variable Value    ${API TOKEN}    %{API_TOKEN}
  Input Password    user_email    guillermo.torijano@kipusystems.com
  Input Password    user_password    ${pass}
  Click Element    //input[@type='submit']
  Input Text    app_url    ${url}
  # Form fill    kis labs staging    urls=https://${virtual url.stdout}
  Custom screenshot
  # Sleep    10
  Click Element    //input[@type='submit']
  Click Link    /users/sign_out
  Close Browser
  Switch Browser    1
  # begin ngrok static ip
