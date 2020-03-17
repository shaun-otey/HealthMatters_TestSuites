*** Settings ***
Documentation   Tester for parallelization.
...
Default Tags    benchmark    be009(4)    points-4    parllz story
Resource        benchmark.robot

*** Test Cases ***
Waiter
  Click and wait for    ${72}
