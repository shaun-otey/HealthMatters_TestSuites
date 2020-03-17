*** Settings ***
Documentation   Print.
...
Library         Selenium2Library

*** Test Case ***
Start print
  # Select Window    id=print-preview
  ${brow} =    Open Browser    http://www.google.com    chrome
  @{win} =    List Windows
  @{wins} =    Get Window Identifiers
  Log To Console    @{win}
  Log To Console    @{wins}
  Log    ${name}
  Log    ${brow}
  Select Window    ${name}
  Click Element    //button[@class='destination-settings-change-button']
  Click Element    //span[@title='Save as PDF']
  Click Element    //button[@class='print default']
