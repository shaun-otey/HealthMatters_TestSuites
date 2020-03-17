*** Settings ***
Documentation   Run through of the facesheet form.
...
Default Tags    regression    re011    points-4    patient chart story
Resource        ../../suite.robot
Suite Setup     Run Keywords    Create a patient to manipulate
...                             Set count id
Suite Teardown  Run Keywords    Set count id
...             AND             Remove this patient    ${Changing first} ${Changing middle} ${Changing last}
Test Teardown   Run Keywords    Run Keyword If Test Failed    Custom screenshot
...             AND             Go To    ${BASE URL}${PATIENTS}/${Current Id}${Patient Information}

*** Test Cases ***
Enter program
  [TAGS]    testmeblock
  # Enter program and case manager
  Given page should have    ${Test First}    Edit ${Patient Handle}
  And I hit the "Edit ${Patient Handle}" view
  When update facesheet    program:dropdown=${_PROGRAM FILTER 7}    case manager:dropdown=${_CASE MANAGER 1}
  Then I hit the "Show Facesheet" view
  And page should have    Program: ${_PROGRAM FILTER 7}    Case Manager: ${_CASE MANAGER 1}
  # And ...

Add statues
  [TAGS]    testmeblock
  Given page should have    ${Test First}    Edit ${Patient Handle}
  And I hit the "Edit ${Patient Handle}" view
  When add all the statuses
  Then I hit the "Show Facesheet" view
  And the status fields should be correct

Enter referrer
  [TAGS]    testmeblock
  Given page should have    ${Test First}    Edit ${Patient Handle}
  And I hit the "Edit ${Patient Handle}" view
  When update facesheet    referrer=Better Admin    referrer contact:checkbox=x
  Then I hit the "Show Facesheet" view
  And the referrer fields should be correct

Enter placement
  [TAGS]    testmeblock
  Given page should have    ${Test First}    Edit ${Patient Handle}
  And I hit the "Edit ${Patient Handle}" view
  When update facesheet    discharge=Addiction Helper    admission date:js=09/23/2008 10:10 AM
  ...                      discharge date:js=09/23/3008 10:10 AM    location:dropdown=${_LOCATION 1}    bed:dropdown=1-D
  Then I hit the "Show Facesheet" view
  And page should have    Addiction Helper    09/23/2008 10:10 AM    09/23/3008 10:10 AM    Location: ${_LOCATION 1}
  ...                     Bed: 1-D

Enable and check off recurring assesments
  [TAGS]    testmeblock
  Enable Recurring Assesments
  Check off recurring assessments

Check for a diagnosis box
  Given page should have    ${Changing first}    ${Changing middle}    ${Changing last}    Edit ${Patient Handle}
  When I hit the "Edit ${Patient Handle}" view
  Then Page Should Contain Element    ${PATIENT FACESHEET DIAGNOSIS}
# Input diagnosis
#   [TAGS]    skip

Modify patients name
  [TAGS]    testmeblock
  Given page should have    ${Changing first}    ${Changing middle}    ${Changing last}    Edit ${Patient Handle}
  And I hit the "Edit ${Patient Handle}" view
  When update facesheet    first name:focus_text=Mrthefirst    middle name=Agreatmid    last name:focus_text=Restisfree
  ...                      preferred name=Thesupertester
  Then I hit the "Show Facesheet" view
  And page should have    Mrthefirst Agreatmid Restisfree    "Thesupertester"
  [TEARDOWN]    Run Keywords    Run Keyword If Test Failed    Custom screenshot
  ...           AND             Default patient name

Modify patients bio info
  Given page should have    ${Changing first}    ${Changing middle}    ${Changing last}    Edit ${Patient Handle}
  And I hit the "Edit ${Patient Handle}" view
  When update facesheet    birth sex:radio=gender_female    gender identity:dropdown=male (FTM)
  ...                      maritial status:dropdown=Widowed    race:dropdown=Multi Racial
  ...                      ethnicity:dropdown=Other Not Listed
  And I hit the "Show Facesheet" view
  Then page should have    Birth Sex: Female    Gender Identity: Male    ♀/♂    Marital Status: Widowed
  ...                      Race: Multi-Racial    Ethnicity: Other not listed

Modify patients personal info
  [SETUP]    Setup random mr number
  Given page should have    ${Changing first}    ${Changing middle}    ${Changing last}    Edit ${Patient Handle}
  And I hit the "Edit ${Patient Handle}" view
  When update facesheet    oto:checkbox=x    mr=MR-2018-1${Rand}00    dob:js=01/01/1919    ssn=123 45 6789
  ...                      sobriety date:js=02/02/2000
  And I hit the "Show Facesheet" view
  Then page should have    OTO!    MR-2018-1${Rand}00    Birthdate: 01/01/1919    SSN: 123-45-6789
  ...                      Sobriety date: 02/02/2000

Check for correct format for ssn
  Given page should have    ${Changing first}    ${Changing middle}    ${Changing last}    Edit ${Patient Handle}
  And I hit the "Edit ${Patient Handle}" view
  When update facesheet    ssn=1234567890
  And I hit the "Show Facesheet" view
  Then page should have    SSN: 123-45-6789
  And I hit the "Edit ${Patient Handle}" view
  When update facesheet    ssn=mad drunk    validation type=failing
  # Then Page Should Contain    The Social Security Number is missing.
  Then Page Should Contain    The social security number (SSN) is missing.
  When Reload Page
  Then Run Keyword And Expect Error    *    update facesheet    ssn:js=0000 javascript bypass 0000
  ...                                  validation type=failing

Modify patients contact
  Given page should have    ${Changing first}    ${Changing middle}    ${Changing last}    Edit ${Patient Handle}
  And I hit the "Edit ${Patient Handle}" view
  When update facesheet    phone=800 234 9043    alt phone=800 945 8888    email=rad@megas.com
  And I hit the "Show Facesheet" view
  Then page should have    Phone: 800-234-9043    Alternate phone: 800-945-8888    Email: rad@megas.com

Check for correct format for phone number
  Given page should have    ${Changing first}    ${Changing middle}    ${Changing last}    Edit ${Patient Handle}
  And I hit the "Edit ${Patient Handle}" view
  When update facesheet    phone=60 29 38 47 51
  And I hit the "Show Facesheet" view
  Then page should have    Phone: 602-938-4751
  And I hit the "Edit ${Patient Handle}" view
  When update facesheet    phone=1zzzz80055513371337
  And I hit the "Show Facesheet" view
  Then page should have    Phone: 1-800-555-13371337
  When I hit the "Edit ${Patient Handle}" view
  Then Run Keyword And Expect Error    *    update facesheet    phone:js=0000 javascript bypass 0000
  ...                                  validation type=failing

Modify patients location
  Given page should have    ${Changing first}    ${Changing middle}    ${Changing last}    Edit ${Patient Handle}
  And I hit the "Edit ${Patient Handle}" view
  When update facesheet    street address 1=Not on my kipuLane    street address 2=5435 nw trueKipu    city=Brikell
  ...                      state:dropdown=American Samoa    zip=33333    country=Mexico
  And I hit the "Show Facesheet" view
  Then page should have    Not on my kipuLane    5435 nw trueKipu    Brikell, AS 33333    Mexico
  # Upload Patient Photo
  # Upload Patient ID

Enter occupation information
  Given page should have    ${Changing first}    ${Changing middle}    ${Changing last}    Edit ${Patient Handle}
  And I hit the "Edit ${Patient Handle}" view
  When update facesheet    occupation=desk cleaner    employer name=Not KipuLLC    employer phone=987 987 9879
  And I hit the "Show Facesheet" view
  Then page should have    desk cleaner    Not KipuLLC    987-987-9879

Modify payment method
  Given page should have    ${Changing first}    ${Changing middle}    ${Changing last}    Edit ${Patient Handle}
  And I hit the "Edit ${Patient Handle}" view
  When update facesheet    payment method:radio=Scholarship
  And I hit the "Show Facesheet" view
  # Then page should have    ...

Enter insurance information with self subscriber
  [TAGS]    testmeblock
  [SETUP]    Set count id
  Given page should have    ${Test First}    Edit ${Patient Handle}
  And I hit the "Edit ${Patient Handle}" view
  When Click Link    Add insurance
  And input insurance company
  And fill out insurance info
  And update facesheet    subscriber rship:dropdown=Self    insurance notes=rock heavy
  # Then ...
  Then I hit the "Show Facesheet" view
  # And ...
  Sleep    60

Enter insurance information with some subscriber
  [TAGS]    testmeblock
  [SETUP]    Set count id
  Given page should have    ${Test First}    Edit ${Patient Handle}
  And I hit the "Edit ${Patient Handle}" view
  When Click Link    Add insurance
  And input insurance company
  And fill out insurance info
  And update subscriber info
  Then I hit the "Show Facesheet" view
  Sleep    60
  # And ...
  # Upload Insurnarce card front
  # Upload insruance card back
  # Click Insurance Verification
  # more

Enter contacts information
  Given page should have    ${Changing first}    ${Changing middle}    ${Changing last}    Edit ${Patient Handle}
  And I hit the "Edit ${Patient Handle}" view
  When Click Link    Add ${Patient Handle} contact
  And update contacts info
  And I hit the "Show Facesheet" view
  Then page should have    Javi Perez    Next of kin    Brother/Sister    102-293-4856    658-574-6853    jz@megas.com
  ...                      somewhere dont search him    the tests are failing

Enter no allergies with diets and restrictions
  Given page should have    ${Changing first}    ${Changing middle}    ${Changing last}    Edit ${Patient Handle}
  And I hit the "Edit ${Patient Handle}" view
  When Click Link    Add Diet
  And update with diet and restriction and no allergies
  And I hit the "Show Facesheet" view
  Then page should have    ELEMENT|//div[@id='allergies-history']//p[.='No Known Allergies/NKA']
  ...                      ELEMENT|//div[@id='allergies-history']//h3[.='Diets']/following::li[contains(text(),'Kosher (religious)')]
  ...                      ELEMENT|//div[@id='allergies-history']//h3[.='Other Restrictions']/following-sibling::p[.='do not feed this person']

Enter allergies
  Given page should have    ${Changing first}    ${Changing middle}    ${Changing last}    Edit ${Patient Handle}
  And I hit the "Edit ${Patient Handle}" view
  When Click Link    Add Allergy
  And update allergy info
  And I hit the "Show Facesheet" view
  Then the allergies table will show what is entered
  When I hit the "Edit ${Patient Handle}" view
  Then all entered allergy info is the same
  And update facesheet    ${EMPTY}=${EMPTY}
  When I hit the "Show Facesheet" view
  Then the allergies table will show what is entered

Click add external app
  [TAGS]    skip

Click scroll to top
  Given page should have    ${Changing first}    ${Changing middle}    ${Changing last}    Edit ${Patient Handle}
  And I hit the "Edit ${Patient Handle}" view
  When scrolling down
  And I hit the "top" tab
  Then Location Should Contain    \#

*** Keywords ***
Create a patient to manipulate
  I select the "${_LOCATION 1}" location
  I create a valid patient    Delta    Rcalm    Pplant    11/01/2018
  ${first} =    Get Element Attribute    ${PATIENT FACESHEET FIRST NAME}    value
  ${middle} =    Get Element Attribute    ${PATIENT FACESHEET MIDDLE NAME}    value
  ${last} =    Get Element Attribute    ${PATIENT FACESHEET LAST NAME}    value
  Set Suite Variable    ${Changing first}    ${first}
  Set Suite Variable    ${Changing middle}    ${middle}
  Set Suite Variable    ${Changing last}    ${last}
  I hit the "Show Facesheet" view
# Insurance counter
#   ${Cid} =    Set Variable    ${I cid}
#   ${i cid} =    Evaluate    ${I cid}+1
#   Set Suite Variable    ${I cid}    ${i cid}
#   # Start date: 05/08/2017

Add all the statuses
  ${date 1} =    Convert Date    ${Todays Date}    result_format=%m/%d/%Y
	${date 2} =    Add Time To Date    ${Todays Date}    5 days    result_format=%m/%d/%Y
  Click Link    Add Commitment
  Ajax wait
  Form fill    patient facesheet    commitment:dropdown=90 days commitment    commit start date:js=${date 1}
  Click Link    Add Approach
  Ajax wait
  Form fill    patient facesheet    approach:dropdown=Spiritual approach
  # Click Link    Add Car
  # Ajax wait
  # Form fill    patient facesheet    car:dropdown=Car Only for School    car start date:js=${date 1}    car end date:js=${date 2}
  Click Link    Add Curfew
  Ajax wait
  Form fill    patient facesheet    curfew:dropdown=9 PM curfew    curfew start date:js=${date 2}
  # Click Link    Add Language
  # Ajax wait
  # Form fill    patient facesheet    language:dropdown=Spanish
  Click Link    Add Pass
  Ajax wait
  Update facesheet    pass:dropdown=Weekend    pass start date:js=${date 1}    pass end date:js=${date 2}

The status fields should be correct
  ${date 1} =    Convert Date    ${Todays Date}    result_format=%m/%d/%Y
	${date 2} =    Add Time To Date    ${Todays Date}    5 days    result_format=%m/%d/%Y
  # Page should have    Start date: ${date 1}    Start date: ${date 2}    End date: ${date 2}
  # ...                 Spiritual    Car Only for School    9 PM    Spanish    Weekend
  Page should have    Start date: ${date 1}    Start date: ${date 2}    End date: ${date 2}    Spiritual approach
  ...                 9 PM curfew    Weekend

Setup random mr number
  ${rand} =    Generate Random String    4    [NUMBERS]
  Set Test Variable    ${Rand}    ${rand}

The referrer fields should be correct
  # ${ttt1} =    Run Keyword And Ignore Error    Get Webelement    //*[@id="patient_information"]/div[12]/div[1]/table/tbody/tr[1]/td[2]/div
  # ${ttt2} =    Run Keyword And Ignore Error    Get Webelement    //*[@id="patient_information"]/div[12]/div[1]/table/tbody/tr[1]/td[2]/text()
  # ${ttt3} =    Get Webelement    //div[.='Referrer']/../text()
  ${ttt3} =    Get Text    //div[.='Referrer']
  ${ttt4} =    Get Webelement    //div[.='Referrer']/..
  #Page Should Contain Element    //div[.='Referrer']
  # Run Keyword And Ignore Error    Log    ${ttt1.get_attribute('innerHTML')}
  # Run Keyword And Ignore Error    Log    ${ttt2.get_attribute('innerHTML')}
  Run Keyword And Ignore Error    Log    ${ttt3.find_element_by_xpath('/text()').get_attribute('textContent')}
  Run Keyword And Ignore Error    Log    ${ttt3.find_element_by_xpath('*/text()').get_attribute('textContent')}
  Run Keyword And Ignore Error    Log    ${ttt3.find_element_by_xpath('/text()').get_attribute('innerHTML')}
  Run Keyword And Ignore Error    Log    ${ttt3.find_element_by_xpath('*/text()').get_attribute('innerHTML')}
  Run Keyword And Ignore Error    Log    ${ttt3.find_element_by_xpath('//text()').text()}
  Run Keyword And Ignore Error    Log    ${ttt3.find_element_by_xpath('/text()').text()}
  Run Keyword And Ignore Error    Log    ${ttt3.find_element_by_xpath('/*').text()}
  Run Keyword And Ignore Error    Log    ${ttt3.find_element_by_xpath('*').text()}
  Run Keyword And Ignore Error    Log    ${ttt3.find_element_by_xpath('/*')}
  Run Keyword And Ignore Error    Log    ${ttt3.get_text()}
  Run Keyword And Ignore Error    Log    //div[.='Referrer'].text()
  Run Keyword And Ignore Error    Log    ${ttt3}
  Run Keyword And Ignore Error    Log    ${ttt4.get_attribute('innerHTML')}
  Run Keyword And Ignore Error    Log    ${ttt4.get_attribute('textContent')}
  Run Keyword And Ignore Error    Log    ${ttt4.get_attribute('text')}
  Run Keyword And Ignore Error    Log    ${ttt4.get_attribute('text()')}
  # Page Should Contain Element
  # page should have    Better Admin    ...

Update subscriber info
  Ajax wait
  Update facesheet    subscriber rship:dropdown=Grandparent    subscriber first=Subs    subscriber middle=De
  ...                 subscriber last=Weak    subscriber ssn=666 77 6677    subscriber dob:js=01/01/1000
  ...                 subscriber emp=No Rest For the Dead

Update contacts info
  Ajax wait
  Update facesheet    contact full name=Javi Perez    contact phone=102 293 4856    contact notes=the tests are failing
  ...                 contact type:dropdown=Next of kin    contact alt phone=658 574 6853    contact email=jz@megas.com
  ...                 contact rship:dropdown=Brother/Sister    contact address=somewhere dont search him

Update with diet and restriction and no allergies
  Ajax wait
  Run Keyword And Ignore Error    I hit the "Delete Allergy" view
  Update facesheet    diets:dropdown=Kosher (religious)   other restrict=do not feed this person
  ...                 no allergy:checkbox=x

Update allergy info
  Ajax wait
  Update facesheet    allergen=Nuts    allergy type:dropdown=Food    reaction=Bad    reaction type:dropdown=Allergy
  ...                 onset:js=04/24/2019    treatment=Epi Pen    allergy status:dropdown=Active
  ...                 allergy source:dropdown=Verified/Tested

The allergies table will show what is entered
  Scrolling down
  ${table} =    Set Variable    //h3[.='Allergies']/following-sibling::table[1]/tbody
  FOR    ${index}    ${head}    ${body}    IN ENUMERATE
  ...     Allergen    Nuts          Allergy Type    Food       Reaction       Bad       Reaction Type    Allergy
  ...     Onset       04/24/2019    Treatment       Epi Pen    Status Type    Active    Source           Verified/Tested
      ${at head} =    Get Text    ${table}/tr[1]/th[${index+1}]
      ${at body} =    Get Text    ${table}/tr[2]/td[${index+1}]
      Run Keyword And Continue On Failure    Should Contain    ${at head}    ${head}
      Run Keyword And Continue On Failure    Should Contain    ${at body}    ${body}
  END

All entered allergy info is the same
  Scrolling down
  Page should have    ELEMENT|//input[@id='patient_allergies_attributes_0_allergen' and @value='Nuts']
  ...                 ELEMENT|//select[@id='patient_allergies_attributes_0_allergy_type']/option[@selected='selected' and @value='food']
  ...                 ELEMENT|//input[@id='patient_allergies_attributes_0_reaction' and @value='Bad']
  ...                 ELEMENT|//select[@id='patient_allergies_attributes_0_reaction_type']/option[@selected='selected' and @value='Allergy']
  ...                 ELEMENT|//input[@id='patient_allergies_attributes_0_onset' and @value='04/24/2019']
  ...                 ELEMENT|//input[@id='patient_allergies_attributes_0_treatment' and @value='Epi Pen']
  ...                 ELEMENT|//select[@id='patient_allergies_attributes_0_status_type']/option[@selected='selected' and @value='Active']
  ...                 ELEMENT|//select[@id='patient_allergies_attributes_0_source']/option[@selected='selected' and @value='Verified/Tested']
