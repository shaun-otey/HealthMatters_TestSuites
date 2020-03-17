*** Settings ***
Documentation   Creates a Kipu instance and run smoke tests on the system.
...
Resource        suite.robot
#Resource        expectations.robot
Library         Process
Suite Setup     Create kipu instance
Suite Teardown  Finish smoke

*** Variables ***
${SOURCE}           /Volumes/bamboo/Development/Test Data/
${DUMP}             demo_2017-01-18

*** Test Cases ***
Test
  Run Process    python    -m    robot    -o    so.xml    -r    sr.html    -l    sl.html    tests/sanity/patients_functionality.robot

*** Keywords ***
Create kipu instance
  #We spin up an instance with baseline "${BASELINE}" with codebase version "${CODEBASE}"
  ${vc} =    Set Variable    ${CURDIR}/healthmatters_vc/healthmatters
  #Copy File    ${SOURCE}${DUMP}.dump    ${CURDIR}/healthmatters_db/
  #${vc} =    Set Variable    ${CURDIR}/healthmatters_vc/healthmatters
  ${result} =    Run Process    bundle    install    cwd=${vc}    stdout=${TEMPDIR}/stdout.txt    stderr=${TEMPDIR}/stderr.txt
  Log Many    stdout: ${result.stdout}    stderr: ${result.stderr}
  ${result} =    Run Process    rake    db:drop    cwd=${vc}    stdout=${TEMPDIR}/stdout.txt    stderr=${TEMPDIR}/stderr.txt
  Log Many    stdout: ${result.stdout}    stderr: ${result.stderr}
  ${result} =    Run Process    rake    db:create    cwd=${vc}    stdout=${TEMPDIR}/stdout.txt    stderr=${TEMPDIR}/stderr.txt
  Log Many    stdout: ${result.stdout}    stderr: ${result.stderr}
  ${result} =    Run Process    pg_restore    --verbose    --clean    --no-acl    --no-owner    -h    localhost    -U    guillermotorijano    -d    healthmatters_qa    ${SOURCE}${DUMP}.dump    stdout=${TEMPDIR}/stdout.txt    stderr=${TEMPDIR}/stderr.txt
  Log Many    stdout: ${result.stdout}    stderr: ${result.stderr}
  ${result} =    Run Process    rake    db:migrate    cwd=${vc}    stdout=${TEMPDIR}/stdout.txt    stderr=${TEMPDIR}/stderr.txt
  Log Many    stdout: ${result.stdout}    stderr: ${result.stderr}
  ${result} =    Run Process    rails    r    ${CURDIR}/initial_hm_db_setup.rb    cwd=${vc}    stdout=${TEMPDIR}/stdout.txt    stderr=${TEMPDIR}/stderr.txt
  Log Many    stdout: ${result.stdout}    stderr: ${result.stderr}
  Start Process    rails    s    cwd=${vc}    stdout=STDOUT
  Sleep    20
  Start Process    redis-server    cwd=${vc}    stdout=STDOUT
  Sleep    10
  Start Process    bundle    exec    sidekiq    cwd=${vc}    stdout=STDOUT
  Sleep    10
  #Login to system

Finish smoke
  Terminate All Processes
  #Run Process    python    -m    rebot    output.xml    so.xml
  #Run Process    python    -m    rebot    report.html    sr.html
  #Run Process    python    -m    rebot    log.html    sl.html

#Process wait
#  ${process} =    Set Variable    ${EMPTY}
  #Get Process Result    stdout=true
#  Sleep   5
  #Get Process Result    stdout=true
#  :FOR    ${i}    IN RANGE    1    5000
#  \    ${process} =    Run Keyword And Return Status    Is Process Running
#  \    Run Keyword If    ${process}==True    Exit For Loop

# python    -m    robot    --log    none    --report    none    --output    out/j.xml    --include    sanityORsmoke    --critical    sanity    --randomize    all    tests
# rebot    --critical    sanity    --name    HealthMatters    --outputdir    out    --output    output.xml    out/j.xml
# python -m robot -l none -r none -o out/j.xml --include sm006ORsm007ORsm008 --randomize all tests
# rebot --name HealthMatters --outputdir out --output output.xml out/j.xml out/j007.xml out/j008.xml
# python -m robot -l none -r none -o out/j006.xml --include sm006 --randomize all tests &
# python -m robot -l none -r none -o out/j007.xml --include sm007 --randomize all tests &
# python -m robot -l none -r none -o out/j008.xml --include sm008 --randomize all tests &
# wait
# rebot --name HealthMatters --outputdir out --output output.xml out/j006.xml out/j007.xml out/j008.xml

##golden thread evaluation
#problem list
#treatment plan_problem, evaluation
#progress report(note)
#golden thread tag
