*** Settings ***
Documentation   Tester for parallelization.
...
Default Tags    benchmark    be005(5)    points-5    parllz story
Resource        benchmark.robot

*** Test Cases ***
Waiter
  Click and wait for    ${90}
