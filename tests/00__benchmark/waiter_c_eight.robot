*** Settings ***
Documentation   Tester for parallelization.
...
Default Tags    benchmark    be014(8)    points-8    parllz story
Resource        benchmark.robot

*** Test Cases ***
Waiter
  Click and wait for    ${144}
