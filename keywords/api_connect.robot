*** Settings ***
Documentation   Keywords designed to connect outside api points.
...
Library         RequestsLibrary

*** Keywords ***
Fakerjs << Create names
  [ARGUMENTS]    ${num}
  Create Session    faker    http://faker.hook.io
  @{names} =    Create List
  FOR    ${i}    IN RANGE    ${num}
      ${name} =    Fakerjs << Find name
      Append To List    ${names}    ${name}
  END
  Delete All Sessions
  [RETURN]    ${names}

Fakerjs << Find name
  &{params} =    Create Dictionary    property=name.findName
  ${resp} =    Get Request    faker    ${EMPTY}    params=${params}
  ${found} =    Set Variable If    200<=${resp.status_code}<300    ${true}    ${false}
  ${first} =    Run Keyword If    ${found}    Set Variable    ${resp.text.split()[0][1:]}
                ...               ELSE        Generate Random String    8    guillermo
  ${last} =    Run Keyword If    ${found}    Set Variable    ${resp.text.split()[1][:-1]}
               ...               ELSE        Generate Random String    8    torijano
  [RETURN]    ${first.title()} ${first[:1]}${last[:1]} ${last.title()}


Smoke << Reach all links
  [ARGUMENTS]    @{links}
  ${cookie} =    Get Cookie    _session_id
  ${session} =    Create Dictionary   _session_id=${cookie.value}
  Create Session    page    ${BASE URL}    verify=True    cookies=${session}
  FOR    ${link}    IN    @{links}
      Continue For Loop If    '${link[0]}'=='/users/sign_out'
      ${tag} =    Get From List    ${link}    2
      ${method} =    Get From List    ${link}    1
      ${link} =    Get From List    ${link}    0
      ${resp} =    Run Keyword If    '${tag}'=='//img'    Smoke << Reach asset    ${link}
                   ...               ELSE                 Run Keyword    ${method} Request    page    ${link}
      ${passes} =    Run Keyword And Return Status    Should Be True    200<=${resp.status_code}<300
      ${resp} =    Set Variable    ${resp.text}
      Run Keyword If    ${passes}          Run Keyword And Continue On Failure    Should Not Contain    ${resp}
      ...                                  <h2>Sign In and Accept Terms of Use</h2>
      ...    ELSE IF    '${tag}'=='//a'    Run Keyword And Continue On Failure    Smoke << Test ajax    ${cookie.value}
      ...                                                                         ${link}
      ...               ELSE               Run Keyword And Continue On Failure    Fail    Link is unreachable!
  END

Smoke << Reach asset
  [ARGUMENTS]    ${asset}
  Create Session    asset    ${asset}    verify=True
  ${resp} =    Get Request    asset    ${EMPTY}
  [RETURN]    ${resp}

Smoke << Test ajax
  [ARGUMENTS]    ${cookie}    ${link}
  ${return} =    Log Location
  Start new window process    2700    20    alias=2
  Switch Browser    2
  Add Cookie    _session_id    ${cookie}
  Go To    ${return}
  Click Link    default=${link}
  Ajax wait
  ${changed} =    Log Location
  Custom screenshot
  Should Be Equal As Strings    ${return}    ${changed}
  [TEARDOWN]    Run Keywords    Close Browser
  ...           AND             Switch Browser    1


Gtz << Setup api
  Create Session    google_tz    https://maps.googleapis.com/maps/api/timezone/json    verify=True
  ${key} =    Get Variable Value    ${TZ API KEY}    %{TZ_API_KEY}
  Set Suite Variable    ${Gtz key}    ${key}

Gtz << Call gtz
  [ARGUMENTS]    ${timestamp}    ${tz}=${${TEST TZ}}
  ${timestamp} =    Convert To String    ${timestamp}
  &{params} =    Create Dictionary    location=${tz.split()[0]}    timestamp=${timestamp}    key=${Gtz key}
  ${resp} =    Get Request    google_tz    ${EMPTY}    params=${params}
  ${passes} =    Run Keyword And Return Status    Should Be Equal As Strings    ${resp.status_code}    200
  &{resp} =    Run Keyword If    ${passes}    Set Variable    ${resp.json()}
               ...               ELSE         Create Dictionary    status=fail
  ${tz} =    Run Keyword If    '${resp.status}'=='OK'    Evaluate    (${resp.dstOffset}+${resp.rawOffset})/3600
             ...               ELSE                      Set Variable    ${tz.split()[1]}
  [RETURN]    ${tz}


Pingmd << Setup api
  &{headers} =    Create Dictionary    Content-Type=application/json    Accept=application/json
                  # ...                  secret=${PINGMD SECRET}
  Create Session    ping    http://sandbox.pingmd.com:8000/rest    ${headers}    verify=True    debug=1
  # &{ping params} =    Create Dictionary    secret=${PINGMD SECRET}
  # Set Suite Variable    ${Ping params}    ${ping params}
  Set Suite Variable    ${Secret auth}    ?secret=${PINGMD SECRET}

Pingmd << Create organization
  [DOCUMENTATION]    Allow: POST, OPTIONS
  [ARGUMENTS]    ${request}    ${name}    ${emr id}=${EMPTY}    ${street}=${EMPTY}    ${city}=${EMPTY}
  ...            ${province}=${EMPTY}    ${postal code}=${EMPTY}    ${phone}=${EMPTY}    ${hours}=${EMPTY}
  ...            ${badge}=${EMPTY}    ${allow user reregistration}=false
  ${ping data} =    Run Keyword If    '${request}'!='options'    Create Dictionary    name=${name}    emr_id=${emr id}
                    ...                                          street=${street}    city=${city}
                    ...                                          province=${province}    postal_code=${postal code}
                    ...                                          phone=${phone}    hours=${hours}    badge=${badge}
                    ...                                          allow_user_reregistration=${allow user reregistration}
  ...               ELSE                                         Set Variable    ${EMPTY}
  ${resp} =    Run Keyword    ${request} Request    ping    organization${Secret auth}    ${ping data}
               ...            allow_redirects=${true}
  [RETURN]    ${resp}

Pingmd << Assign memebership
  [DOCUMENTATION]    Allow: PUT, DELETE, OPTIONS
  [ARGUMENTS]    ${organization}    ${membership}    ${request}
  ${resp} =    Run Keyword    ${request} Request    ping
               ...            organization/${organization}/membership/${membership}${Secret auth}
               ...            allow_redirects=${true}
  [RETURN]    ${resp}

Pingmd << Register user
  [DOCUMENTATION]    Allow: POST, OPTIONS
  [ARGUMENTS]    ${request}    ${email}    ${first name}    ${last name}    ${role}    ${phone}=${EMPTY}
  ...            ${phone country code}=${EMPTY}    ${password}=${EMPTY}    ${gender}=${EMPTY}    ${birthday}=${null}
  ...            ${image}=${EMPTY}    ${push notifications enabled}=false    ${email notifications enabled}=false
  ...            ${sms notifications enabled}=false    ${organization}=${EMPTY}    ${organization identifier}=${EMPTY}
  ...            ${qualifications}=${EMPTY}    ${practitioners}=${EMPTY}
  ${qualifications} =    Run Keyword If    '${qualifications}'=='${EMPTY}'    Set Variable    ${qualifications}
                         ...               ELSE                               Split String
                         ...                                                  ${qualifications.__str__()}    ;
  ${practitioners} =    Run Keyword If    '${practitioners}'=='${EMPTY}'    Set Variable    ${practitioners}
                        ...               ELSE                              Split String
                        ...                                                 ${practitioners.__str__()}    ;
  ${ping data} =    Run Keyword If    '${request}'!='options'    Create Dictionary    email=${email}
                    ...                                          first_name=${first name}    last_name=${last name}
                    ...                                          phone=${phone}    organization=${organization}
                    ...                                          phone_country_code=${phone country code}
                    ...                                          password=${password}    gender=${gender}
                    ...                                          birthday=${birthday}    role=${role}    image=${image}
                    ...                                          push_notifications_enabled=${push notifications enabled}
                    ...                                          email_notifications_enabled=${email notifications enabled}
                    ...                                          sms_notifications_enabled=${sms notifications enabled}
                    ...                                          organization_identifier=${organization identifier}
                    ...                                          qualifications=${qualifications}
                    ...                                          practitioners=${practitioners}
  ...               ELSE                                         Set Variable    ${EMPTY}
  ${resp} =    Run Keyword    ${request} Request    ping    register${Secret auth}    ${ping data}
               ...            allow_redirects=${true}
  [RETURN]    ${resp}

Pingmd << Account status
  [DOCUMENTATION]    Allow: GET, HEAD, OPTIONS
  [ARGUMENTS]    ${user}    ${request}
  ${resp} =    Run Keyword    ${request} Request    ping    user/${user}/status${Secret auth}    allow_redirects=${true}
  [RETURN]    ${resp}

Pingmd << Activate user
  [DOCUMENTATION]    Allow: POST, OPTIONS
  [ARGUMENTS]    ${user}    ${request}    ${override reason}=${EMPTY}
  ${ping data} =    Run Keyword If    '${request}'!='options'    Create Dictionary    override_reason=${override reason}
                    ...               ELSE                       Set Variable    ${EMPTY}
  ${resp} =    Run Keyword    ${request} Request    ping    user/${user}/activate${Secret auth}    ${ping data}
               ...            allow_redirects=${true}
  [RETURN]    ${resp}

Pingmd << Deactivate user
  [DOCUMENTATION]    Allow: POST, OPTIONS
  [ARGUMENTS]    ${user}    ${request}    ${reason}
  ${ping data} =    Run Keyword If    '${request}'!='options'    Create Dictionary    reason=${reason}
                    ...               ELSE                       Set Variable    ${EMPTY}
  ${resp} =    Run Keyword    ${request} Request    ping    user/${user}/deactivate${Secret auth}    ${ping data}
               ...            allow_redirects=${true}
  [RETURN]    ${resp}

Pingmd << Request survey
  [DOCUMENTATION]    Allow: POST, OPTIONS
  [ARGUMENTS]    ${user}    ${request}    ${name}    ${description}    ${data}    ${callback url}=${EMPTY}
  ...            ${callback data}=${EMPTY}
  ${ping data} =    Run Keyword If    '${request}'!='options'    Create Dictionary    name=${name}
                    ...                                          description=${description}    data=${data}
                    ...                                          callback_url=${callback url}
                    ...                                          callback_data=${callback data}    signature=${true}
  ...               ELSE                 Set Variable    ${EMPTY}
  ${resp} =    Run Keyword    ${request} Request    ping    user/${user}/survey-request${Secret auth}    ${ping data}
               ...            allow_redirects=${true}
  [RETURN]    ${resp}

Pingmd << View patients for practitioner
  [DOCUMENTATION]    Allow: GET, PUT, HEAD, OPTIONS
  [ARGUMENTS]    ${practitioner}    ${request}    ${patients}=${null}
  ${patients} =    Run Keyword If    '${patients}'=='${EMPTY}'    Set Variable    ${patients}
                   ...               ELSE                         Split String    ${patients.__str__()}    ;
  ${ping data} =    Run Keyword If    '${request}'=='put'    Create Dictionary    patients=${patients}
                    ...               ELSE                   Set Variable    ${EMPTY}
  ${resp} =    Run Keyword    ${request} Request    ping    practitioner/${practitioner}/patients${Secret auth}
               ...            ${ping data}    allow_redirects=True
  [RETURN]    ${resp}

Pingmd << View practitioners for patient
  [DOCUMENTATION]    Allow: GET, PUT, PATCH, HEAD, OPTIONS
  [ARGUMENTS]    ${patient}    ${request}    ${practitioners}=${null}
  ${practitioners} =    Run Keyword If    '${practitioners}'=='${EMPTY}'    Set Variable    ${practitioners}
                        ...               ELSE                              Split String
                        ...                                                 ${practitioners.__str__()}    ;
  ${ping data} =    Run Keyword If    '${request}'=='put' or '${request}'=='patch'
                    ...                                      Create Dictionary    practitioners=${practitioners}
                    ...               ELSE                   Set Variable    ${EMPTY}
  ${resp} =    Run Keyword    ${request} Request    ping    patient/${patient}/practitioners${Secret auth}
               ...            ${ping data}    allow_redirects=True
  [RETURN]    ${resp}

Pingmd << Request patient assessment
  [DOCUMENTATION]    Allow: POST, OPTIONS
  [ARGUMENTS]    ${user}    ${request}    ${id}    ${type}    ${application id}    ${generated at}    ${assessment}
  ...            ${human readable name}    ${human readable description}    ${callback url}=${EMPTY}
  ...            ${callback data}=${EMPTY}
  ${ping data} =    Run Keyword If    '${request}'!='options'    Create Dictionary    id=${id}    type=${type}
                    ...                                          application_id=${application id}
                    ...                                          generated_at=${generated at}
                    ...                                          callback_url=${callback url}
                    ...                                          callback_data=${callback data}
                    ...                                          assessment=${assessment}
                    ...                                          human_readable_name=${human readable name}
                    ...                                          human_readable_description=${human readable description}
  ...               ELSE                                         Set Variable    ${EMPTY}
  ${resp} =    Run Keyword    ${request} Request    ping    user/${user}/patient-assessment${Secret auth}
               ...            ${ping data}    allow_redirects=${true}
  [RETURN]    ${resp}


Sisense << Setup api
  &{headers front} =    Create Dictionary    Content-Type=application/json    Accept=application/json
                        ...                  X-Api-Key=${SISENSE FRONT KEY}
  &{headers crm e} =    Create Dictionary    Content-Type=application/json    Accept=application/json
                        ...                  X-Api-Key=${SISENSE CRM E KEY}
  &{headers adm p} =    Create Dictionary    Content-Type=application/json    Accept=application/json
                        ...                  X-Api-Key=${SISENSE ADM P KEY}
  &{headers crm i} =    Create Dictionary    Content-Type=application/json    Accept=application/json
                        ...                  X-Api-Key=${SISENSE CRM I KEY}
  &{headers adm d} =    Create Dictionary    Content-Type=application/json    Accept=application/json
                        ...                  X-Api-Key=${SISENSE ADM D KEY}
  # Create Session    sisense data    https://bsi.ksd1446.com/dev    ${headers front}    verify=True    debug=1
  Create Session    sisense data    https://llyr8qs5lk.execute-api.us-east-1.amazonaws.com/dev    ${headers front}
  ...               verify=True    debug=1
  Create Session    sisense cops    https://sisense.ksd1446.com/dev    ${headers front}    verify=True    debug=1
  # Create Session    sisense cops    https://5qv99vg871.execute-api.us-east-1.amazonaws.com/dev    ${headers front}
  # ...               verify=True    debug=1
  Create Session    sisense kaws    https://bsi.ksp1446.com    ${headers front}    verify=True    debug=1
  # Create Session    sisense kaws    https://1pnn3ltnye.execute-api.us-east-1.amazonaws.com/production
  # ...               ${headers front}    verify=True    debug=1
  Create Session    sisense crm e    https://es1wc82m24.execute-api.us-east-1.amazonaws.com/dev    ${headers crm e}
  ...               verify=True    debug=1
  Create Session    sisense crm i    https://t3365mcycd.execute-api.us-east-1.amazonaws.com/Production
  ...               ${headers crm i}    verify=True    debug=1
  Create Session    sisense adm p    https://u43rv1xpac.execute-api.us-east-1.amazonaws.com/prod    ${headers adm p}
  ...               verify=True    debug=1
  Create Session    sisense adm d    https://3t32a6p7yi.execute-api.us-east-1.amazonaws.com/dev    ${headers adm d}
  ...               verify=True    debug=1
  # emr|sis/d -> bsi
  # emr|lly/d -> einstein
  # crm|es1/d -> einstein/crm
  # sad|u43/p -> admin
  # sap|3t3/d -> admin
  # icr|t33/p -> ?/crm

Sisense << User Management << Groups
  [DOCUMENTATION]    Allow: POST(200,201,400,403) -> body:groupname
  ...                       GET(200,400,403,404) -> headers:X-Sisense-Userid
  ...                       DELETE(200,204,400,403,404) -> body:groupname
  ...                       PUT(200,400,403,404) -> body:groupname,newgroupname
  ...                       + /addusertogroup -> body:groupname,username
  ...                       + /removeuserfromgroup -> body:groupname,username
  [ARGUMENTS]    ${groupname}    ${request}    &{params}
  ${request} =    Convert To Uppercase    ${request}
  ${ext} =    Pop From Dictionary    ${params}    ext    ${EMPTY}
  ${front} =    Pop From Dictionary    ${params}    front    kaws
  &{xheader} =    Run Keyword If    '${request}'!='GET'    Create Dictionary    groupname=${groupname}
                  ...               ELSE                   Create Dictionary    X-Sisense-Userid=${groupname}
  Set To Dictionary    ${params}    &{xheader}
  ${resp} =    Run Keyword If    '${request}'!='GET'    Run Keyword    ${request} Request    sisense ${front}
               ...                                      groups/${ext}    ${params}    allow_redirects=${true}
               ...               ELSE                   Get Request    sisense ${front}    groups/    headers=${params}
               ...                                      allow_redirects=${true}
  [RETURN]    ${resp}

Sisense << User Management << Users
  [DOCUMENTATION]    Allow: GET(200,404) -> headers:X-Sisense-Userid
  ...                       POST(201,400,404,422) -> body:username,email,firstname,lastname,groupnames[]
  # ...                       UPDATE(200,404)
  ...                       PUT(200,404) -> body:username,newusername,firstname,lastname,email,groupnames[]
  ...                       DELETE(204,400,404) -> body:username
  [ARGUMENTS]    ${user}    ${request}    &{params}
  ${request} =    Convert To Uppercase    ${request}
  ${front} =    Pop From Dictionary    ${params}    front    kaws
  ${groupnames} =    Run Keyword If    'groupnames' in ${params}    Pop From Dictionary    ${params}    groupnames
                     ...               ELSE                         Create List
  &{xheader} =    Run Keyword If    '${request}'!='GET'    Create Dictionary    username=${user}
                  ...                                      groupnames=${groupnames}
                  ...               ELSE                   Create Dictionary    X-Sisense-Userid=${user}
  Set To Dictionary    ${params}    &{xheader}
  ${resp} =    Run Keyword If    '${request}'!='GET'    Run Keyword    ${request} Request    sisense ${front}    users/
               ...                                      ${params}    allow_redirects=${true}
               ...               ELSE                   Get Request    sisense ${front}    users/    headers=${params}
               ...                                      allow_redirects=${true}
  [RETURN]    ${resp}

Sisense << Dashboards
  [DOCUMENTATION]    Allow: GET(200,404) -> headers:x-sisense-userid
  ...                       POST(204,404)
  ...                       + /addgrouptodashbboard -> body:dashboard_id,groupname
  ...                       + /addusertodashboard -> body:dashboardn_id,username
  ...                       DELETE(204,404)
  ...                       + /removegroupfromdashboard -> body:dashboard_id,groupname
  ...                       + /removeuserfromdashboard -> body:dashboard_id,username
  [ARGUMENTS]    ${name}    ${request}    &{params}
  ${request} =    Convert To Uppercase    ${request}
  ${ext} =    Pop From Dictionary    ${params}    ext    ${EMPTY}
  ${owner} =    Pop From Dictionary    ${params}    owner    null
  ${front} =    Pop From Dictionary    ${params}    front    kaws
  ${original resp} =    Run Keyword If    '${request}'!='GET'    Sisense << Dashboards    ${owner}    get
                        ...                                      front=${front}
                        ...               ELSE                   Create List    x-sisense-userid
  ${passes}    ${json} =    Run Keyword And Ignore Error    Set Variable    ${original resp.json()}
  ${resp} =    Set Variable If    '${passes}'=='PASS'    ${json}    ${original resp}
  Return From Keyword If    type(${resp}) is dict    ${original resp}
  &{xheader} =    Create Dictionary
  # &{error} =    Create Dictionary    error=Cannot find dashboard!    status_code=${404}
  # ${error} =    Evaluate    json.dumps(${error})    json
  ${error} =    Evaluate    json.dumps({'error':'Cannot find dashboard!','status_code':404})    json
  FOR    ${item}    IN    @{resp}
      Run Keyword If    '''${item}'''=='x-sisense-userid'    Run Keywords    Set To Dictionary    ${xheader}
      ...                                                                    ${item}=${name}
      ...                                                    AND             Exit For Loop
      Run Keyword If    '&{item}[title]'=='${name}'    Run Keywords    Set To Dictionary    ${xheader}
      ...                                                              dashboard_id=&{item}[id]
      ...                                             AND              Exit For Loop
  END
  Return From Keyword If    not &{xheader}    ${error}
  Set To Dictionary    ${params}    &{xheader}
  ${resp} =    Run Keyword If    '${request}'!='GET'    Run Keyword    ${request} Request    sisense ${front}
               ...                                      dashboards/${ext}    ${params}    allow_redirects=${true}
               ...               ELSE                   Get Request    sisense ${front}    dashboards/
               ...                                      headers=${params}    allow_redirects=${true}
  [RETURN]    ${resp}

Sisense << Elasticube
  [DOCUMENTATION]    Allow: POST(200,403,404)
  ...                       + /buildelasticube -> body:cubename
  ...                       + /addgrouptocubedatasecurity -> body:cubename,column,datatype,groupname,table,value_members[]
  ...                       + /addusertocubedatasecurity -> body:cubename,column,datatype,username,table,value_members[]
  ...                       DELETE(200,400,403)
  ...                       + /removepartynametocubedatasecurity -> body:cubename,column,partyname,table
  [ARGUMENTS]    ${name}    ${request}    &{params}
  ${request} =    Convert To Uppercase    ${request}
  ${ext} =    Pop From Dictionary    ${params}    ext
  ${front} =    Pop From Dictionary    ${params}    front    kaws
  ${values} =    Run Keyword If    'values' in ${params}    Pop From Dictionary    ${params}    values
                 ...               ELSE                     Create List
  Set To Dictionary    ${params}    cubename=${name}
  # &{standard} =    Create Dictionary    column=${col}    table=${table}    cubename=${cubename}
  # &{data} =    Run Keyword If    'group' in '${function}'    Create Dictionary    groupname=${name}    &{standard}
  #              ...                                           datatype=${datatype}    value_members=${values}
  #              ...    ELSE IF    'user' in '${function}'     Create Dictionary    username=${name}    &{standard}
  #              ...                                           datatype=${datatype}    value_members=${values}
  #              ...    ELSE IF    'party' in '${function}'    Create Dictionary    partyname=${name}    &{standard}
  #              ...               ELSE                        Fail    Unknown function!
  ${resp} =    Run Keyword    ${request} Request    sisense ${front}    elasticube/${ext}    ${params}
               ...            allow_redirects=${true}
  [RETURN]    ${resp}

Sisense << Sso
  [DOCUMENTATION]    Allow: GET -> headers:email,referrer
  [ARGUMENTS]    ${email}    ${referer}    ${front}=kaws
  &{data} =    Create Dictionary    email=${email}    referer=${referer}
  ${resp} =    Get Request    sisense ${front}    sso/    headers=${data}    allow_redirects=${true}
  [RETURN]    ${resp}

Sisense << Crm
  [DOCUMENTATION]    Allow: POST -> body:where
  [ARGUMENTS]    ${crm}    &{query}
  ${query} =    Create Dictionary    where=${query}
  ${resp} =    Post Request    sisense crm ${crm}    sql/billingquery/    ${query}    allow_redirects=${true}
  [RETURN]    ${resp}

Sisense << Admin
  [DOCUMENTATION]    Allow: GET
  ...                       + /redshift-cleans3andtables -> _
  ...                       + /redshift-emr-etl-deploy -> _
  ...                       + /redshift-emr-etl-master -> _
  ...                       + /redshift-update-timezone -> _
  ...                       + /redshift-vacuum-analyze -> _
  ...                       POST
  ...                       + /redshift-emr-etl -> _
  [ARGUMENTS]    ${admin}    ${request}    ${ext}
  ${request} =    Convert To Uppercase    ${request}
  ${resp} =    ${request} Request    sisense adm ${admin}    admin/${ext}/    allow_redirects=${true}
  [RETURN]    ${resp}
