*** Settings ***
Documentation   Test creating and modifying a template for orders.
...
Default Tags    regression    re016    points-1    templates story    notester    hasprint    addmore
Resource        ../../suite.robot
Suite Setup     Run Keywords    I attempt to hit the "templates" tab
...             AND             I hit the "templates orders" tab
...             AND             Create tester template    orders    No Coke
Suite Teardown  Run Keywords    Delete tester template    orders
...             AND             Return to mainpage
Test Teardown   Run Keywords    Run Keyword If Test Failed    Custom screenshot
...             AND             Go To    ${BASE URL}${TEMPLATES ORDERS}

*** Test Cases ***
User can drag the standard orders
  [TAGS]    skip
  Given I am on the "templates orders" page

User can PDF or print page
  [TAGS]    hasprint
  Given I am on the "templates orders" page

User can name order
  Given I am on the "templates orders" page
  When editing "orders" test template
  And form fill    orders form    name=Lime with Lechera
  And save "orders" template
  Then Page Should Contain    Lime with Lechera

User can enable order
  Given I am on the "templates orders" page
  When editing "orders" test template
  And fill in some items to allow enabling
  And save "orders" template
  Then Page Should Not Contain Element    //a[@href='${TEMPLATES ORDERS}/${Template Id}/edit']/span[@class='disabled']
  And Page Should Contain Element    //a[@href='${TEMPLATES ORDERS}/${Template Id}/edit']

User can identify if order is a PRN, taper, consistent dose, or open ended
  [TAGS]    skip
  Given I am on the "templates orders" page
  Then Fail    This cannot be checked from the outside, must be added to name!

User can fill out the text boxes for justification, duration, and note
  Given I am on the "templates orders" page
  When editing "orders" test template
  And form fill    orders form    justification=Need to stay awake    duration=3    note=Drink water instead
  And save "orders" template
  # Then ...

User can add order item filled out, identify the taper days, and delete the item
  [TAGS]    skip
  Given I am on the "templates orders" page
  When editing "orders" test template
  And add some order items
  And Click Link    ${TEMPLATES ORDERS}/${Template Id}
  And page should have ...
  And Click Link    ${TEMPLATES ORDERS}/${Template Id}/edit
  And delete order items
  And Click Link    ${TEMPLATES ORDERS}/${Template Id}
  Then ...

*** Keywords ***
Fill in some items to allow enabling
  Form fill    orders form    dosage type:radio=1
  I hit the "Add item" view
  Form fill    orders form    duration=2    day=1    medication=Silvadene    route:dropdown=buccal    dosage form=candy
  ...          dose=1mg/1    frequency:dropdown=every hour
  Form fill    orders form    order enabled:checkbox=x
  Form fill    orders form    enabled:checkbox=x

Add some order items
  Form fill    orders form    dosage type:radio=1   duration=2
  I hit the "Add item" view
  Set count id    0
  Form fill    orders form    order enabled:checkbox=x    day=1    medication=Silvadene
  ...          route:dropdown=buccal    dosage form=candy    dose=1mg/1    frequency:dropdown=every hour
  Set count id    1
  Form fill    orders form    order enabled:checkbox=x    day=2    medication=Silvadene
  ...          route:dropdown=buccal    dosage form=candy    dose=30mg/1    frequency:dropdown=every hour
  Set count id    0
