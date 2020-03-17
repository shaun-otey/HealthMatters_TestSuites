*** Settings ***
Documentation   .
...
Default Tags    sanity    sa015    ntrdy
Resource        ../../suite.robot
Suite Setup     Create a vob getter konnector
Suite Teardown  Remove the vob getter konnector
# Test Teardown   ...

*** Test Cases ***
Disable/enable the konnector
  No Operation

Assign/unassign VOB Admin/User roles
  No Operation

Click VOB Getter Instant button
  No Operation

Check notifications
  No Operation

*** Keywords ***
Create a vob getter konnector
  I hit the "settings" tab
  I hit the "konnectors" tab
  Loop deletion    Click Element    //a[contains(text(),'VOBGetter QA Konnector')]/ancestor::td[1]/following-sibling::td[last()-1]//a
  I hit the "New Konnector" text
  Form fill    vendor    name=VOBGetter QA Konnector    type:dropdown=Vob Getter
  Click Button    commit
  Ajax wait
  Form fill    vendor    status:checkbox=x    locations|6:checkbox=x    facility name=Larkin Ink Inc
  ...          provider npi=2444534020    provider tax id=410236781    contact email=jaclyn@example.net
  ...          billing email=jaclyn@example.net    billing address|1=80610 Delfina Points    billing city=CLIFTON
  ...          billing state:dropdown=Texas    billing zip=76634    rendering address|1=101 McLaughlin Square
  ...          rendering city=Lake Wilson    rendering state:dropdown=Arkansas    rendering zip=96588
  ...          vob monitoring:radio=none    vob phone:radio=true
  # Click Element    vob-getter-terms-and-conditions-button

  # Execute Javascript    var e = document.evaluate("//*[@id='vob-getter-terms-and-conditions-button']", document, null, XPathResult.ANY_TYPE, null);
  # ...                   $(e).mousedown(function(){pressTimer = window.setTimeout(function() {e.click()},1000); return false;})
  # Wait Until Page Contains Element    //div[@class='WordSection1']
  # Slow wait    5
  Slow wait
  # Run Keyword And Ignore Error    Wait Until Page Contains    IS A LEGALLY BINDING AGREEMENT between Lee RCM LLC
  # Page Should Contain    IS A LEGALLY BINDING AGREEMENT between Lee RCM LLC
  # Click Button    Accept
  # Click Element    //html/body/div[10]/div[11]/div/button[1]
  # Click Element At Coordinates    //button[.='Accept']    0    0
  # Press Key    //button[.='Accept']    \\13
  # Press Key    //body    \\13
  # Execute Javascript    document.body.dispatchEvent(document.createEvent('KeyboardEvent').initKeyEvent('keydown', true, true, window, false, false, false, false, 13, 0))
  # Loop deletion    Run Keywords    Double Click Element    //button[.\='Accept']
  # ...              AND             Press Key    //button[.='Accept']    \\13
  # Loop deletion    Testsss
  # Drag And Drop By Offset    //button[.='Accept']    1    1
  Press Key    vob-getter-terms-and-conditions-button    \\13
  # Run Keyword And Ignore Error    Open Context Menu    //button[.='Accept']
  # Execute Javascript    var e = document.evaluate("//button[.='Accept']", document, null, XPathResult.ANY_TYPE, null);
  # ...                   $(e).mousedown(function(){pressTimer = window.setTimeout(function() {e.click()},1000); return false;})
  # # Run Keyword And Ignore Error    Execute Javascript    $("document.evaluate("//button[.='Accept']", document, null, XPathResult.ANY_TYPE, null)").mousedown(function(){pressTimer = window.setTimeout(function() {void(0)},1000); return false;})
  # # Ajax wait
  # Run Keyword And Ignore Error    Open Context Menu    //button[.='Accept']
  Slow wait    5
  Click Button    commit
  Ajax wait
  # Page should have    Notice    Active Interface
  I hit the "konnectors" tab
  Page Should Contain    VOBGetter QA Konnector
  Return to mainpage

Testsss
  Double Click Element    //button[.='Accept']
  Press Key    //button[.='Accept']    \\13

Remove the vob getter konnector
  Return to mainpage
  I hit the "settings" tab
  I hit the "konnectors" tab
  Loop deletion    Click Element    //a[contains(text(),'VOBGetter QA Konnector')]/ancestor::td[1]/following-sibling::td[last()-1]//a
  Return to mainpage
