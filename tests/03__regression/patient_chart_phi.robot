*** Settings ***
Documentation   Enter some phi information and see if it shows up.
...
Default Tags    regression    re022    points-1    patient chart story
Resource        ../../suite.robot
Suite Setup     Travel "slow" to "tester" patients "disclosure log" page in "${_LOCATION 1}"
Suite Teardown  Return to mainpage
Test Teardown   Run Keywords    Run Keyword If Test Failed    Custom screenshot
...             AND             Travel "fast" to "current" patients "disclosure log" page in "null"

*** Test Cases ***
Add a new phi entry
  Given I am on the "disclosure log" patient page
  When entering a new phi entry
  Then the entry fields should be correct

Click scroll to top
  Given I am on the "disclosure log" patient page
  When scrolling down
  And I hit the "top" tab
  Then Location Should Contain    \#

*** Keywords ***
Entering a new phi entry
	I hit the "Add PHI entry" text
	${date 1} =    Convert Date    ${Todays Date}    result_format=%m/%d/%Y
	${date 2} =    Add Time To Date    ${Todays Date}    5 days    result_format=%m/%d/%Y
	Form fill    new phi    date disclosure:js=${date 1}    date requested:js=${date 2}
	...					 request type:dropdown=verbal    name=Reaper    address=python 2376
	...					 discription=hard to make hug server auto start, javi hates python and lambs
	...					 purpose=use only python3    disclosed by=not guillo
  Click Element    //span[.='Submit']

The entry fields should be correct
	${date 1} =    Convert Date    ${Todays Date}    result_format=%m/%d/%Y
	${date 2} =    Add Time To Date    ${Todays Date}    5 days    result_format=%m/%d/%Y
	#Address is not shown
	Page should have    ${date 1}    ${date 2}    verbal    Reaper
	...									hard to make hug server auto start, javi hates python and lambs
	...									use only python3    not guillo
