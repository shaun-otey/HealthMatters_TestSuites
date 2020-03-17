*** Settings ***
Documentation   Running tests on ${BASE URL} instance from RobotFramework Server.
...
...             Visit [https://kipusystems.atlassian.net/wiki/spaces/QA/pages/98173034/RobotFramework+Results|RobotFramework Results] for more info.
...
Resource        ../suite.robot
Suite Setup     Full setup
Suite Teardown  Full teardown
Test Teardown   Run Keywords    Run Keyword If Test Failed    Custom screenshot
...             AND             Return to mainpage
