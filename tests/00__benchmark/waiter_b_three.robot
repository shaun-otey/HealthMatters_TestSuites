*** Settings ***
Documentation   Tester for parallelization.
...
Default Tags    benchmark    be008(3)    points-3    parllz story
Resource        benchmark.robot

*** Test Cases ***
Waiter
  Click and wait for    ${54}
