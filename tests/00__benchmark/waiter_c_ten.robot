*** Settings ***
Documentation   Tester for parallelization.
...
Default Tags    benchmark    be015(10)    points-10    parllz story
Resource        benchmark.robot

*** Test Cases ***
Waiter
  Click and wait for    ${180}
