*** Settings ***
Documentation   Tester for parallelization.
...
Default Tags    benchmark    be017(2)    points-2    parllz story
Resource        benchmark.robot

*** Test Cases ***
Waiter
  Click and wait for    ${36}
