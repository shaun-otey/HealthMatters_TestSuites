*** Settings ***
Documentation   Keywords for future benchmarks.
...
Resource        ../../suite.robot

*** Variables ***
@{BENCHMARK TABS}    dashboard    patients    occupancy    schedules    shifts    contacts    lab interface    reports
...                  templates

*** Keywords ***
Click and wait for
  [ARGUMENTS]    ${time}
  Log To Console    ${EMPTY}
  FOR    ${i}    IN RANGE    0    ${time+1}    1
      ${tab} =    Evaluate    random.choice(@{BENCHMARK TABS})    random
      ${passes} =    Run Keyword And Return Status    I hit the "${tab}" tab
      Log To Console    ${SUITE NAME} ${i}${SPACE*4}${passes}${SPACE*4}${tab}
      Sleep    1
  END
