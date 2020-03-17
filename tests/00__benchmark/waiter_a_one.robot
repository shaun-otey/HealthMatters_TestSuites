*** Settings ***
Documentation   Tester for parallelization.
...
Default Tags    benchmark    be001(1)    points-1    parllz story
Resource        benchmark.robot

*** Test Cases ***
Waiter
  Click and wait for    ${18}
