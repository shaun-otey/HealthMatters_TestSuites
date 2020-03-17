*** Settings ***
Documentation   Tester for parallelization.
...
Default Tags    benchmark    be013(6)    points-6    parllz story
Resource        benchmark.robot

*** Test Cases ***
Waiter
  Click and wait for    ${108}
