*** Settings ***
Documentation   Run through the top level tabs and verify
...             by url that the pages are correct.
...
Default Tags    smoke    sm003    points-1    notester
Resource        ../../suite.robot

*** Test Cases ***
Hit dashboard
  Given I am on the "patients" page
  When I hit the "dashboard" tab
  Then I am on the "dashboard" page

Hit patients
  Given I am on the "patients" page
  When I hit the "patients" tab
  Then I am on the "patients" page

Hit occupancy
  Given I am on the "patients" page
  When I hit the "occupancy" tab
  Then I am on the "occupancy" page

Hit schedules
  Given I am on the "patients" page
  When I hit the "schedules" tab
  Then I am on the "schedules" page

Hit shifts
  Given I am on the "patients" page
  When I hit the "shifts" tab
  Then I am on the "shifts" page

Hit contacts
  Given I am on the "patients" page
  When I hit the "contacts" tab
  Then I am on the "contacts" page

Hit lab interface today
  Given I am on the "patients" page
  When I hit the "lab interface" tab
  Then I am on the "lab interface" page

Hit reports
  Given I am on the "patients" page
  When I hit the "reports" tab
  Then I am on the "reports" page

Hit templates
  Given I am on the "patients" page
  When I hit the "templates" tab
  Then I am on the "templates" page
