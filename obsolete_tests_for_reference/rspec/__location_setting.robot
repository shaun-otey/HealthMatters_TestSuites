*** Settings ***
Documentation   /spec/features/settings/location_setting_spec.rb
...             As a super admin user I should be able to have CRUD functionality of locations, buildings, rooms, and beds
...             beds should belong to rooms, rooms should belong to building, and building to location. However, location is not necessary.
...             Role restriction should still apply to sections of the patient chart
...
Resource        ../suite.robot
Suite Setup     Login to system
Suite Teardown  Run Keywords    Remove test patient
#...                             Remove test evaluation
...                             Exit system
Test Setup      Go to room
Test Teardown   Return to mainpage

*** Test Cases ***
RSpec.feature 'configurable location settings',  type: :feature, js: true do
given!(:company_setting) { FactoryGirl.create :company_setting }
let!(:site_setting) { FactoryGirl.create :site_setting, enable_two_factor_authentication: true }
given!(:patient_setting) { FactoryGirl.create :patient_setting }
given!(:patient) {FactoryGirl.create :complete_patient }
subject { FactoryGirl.create :user, roles: [:super_admin] }

before do
go_to_settings
visit rooms_path
end

scenario "super admin user adds new enabled building" do
  # click_link 'New building'
  # find('#building_building_name').set 'enabled building'
  # click_button 'Add'
  # visit occupancy_index_path
  # expect(page).to have_content('enabled building')
  Given I am on the "rooms" page
  When I hit the "New Building" view
  And

scenario "super admin user adds new disabled building" do
  click_link 'New building'
  find('#building_building_name').set 'disabled building'
  uncheck('building[enabled]')
  click_button 'Add'
  visit occupancy_index_path
  expect(page).not_to have_content('disabled building')

scenario "super admin user adds new room without bed" do
  click_link 'New room'
  find('#room_room_name').set 'new room'
  click_button 'Add'
  click_button 'Update'
  expect(page).to have_content('new room')

# scenario "super admin user adds new room with bed" do
#   click_link 'New room'
#   find('#room_room_name').set 'new room'
#   click_button 'Add'
#   click_link 'Add bed'
#   wait_for_ajax
#   find('#room_beds_attributes_0_bed_name').set 'new bed'
#   click_button 'Update'
#   visit rooms_path
#   expect(page).to have_content('new bed')
# end

context "facility with multiple locations" do
given!(:company_setting) { FactoryGirl.create :company_with_locations }
let(:building) { FactoryGirl.create :building }
pending("super admin user adds new building associated to location NEEDS FIX")
# scenario "super admin user adds new building associated to location" do
#   click_link 'New building'
#   find('#building_building_name').set 'enabled building'
#   select company_setting.locations.first.name, from: 'building_location_id'
#   click_button 'Add'
#   expect(page).to have_content('enabled building')
# end
pending("super admin user adds new building not associated to location NEEDS FIX")
# scenario "super admin user adds new building not associated to location" do
#   click_link 'New building'
#   find('#building_building_name').set 'enabled building'
#   click_button 'Add'
#   visit occupancy_index_path
#   expect(page).not_to have_content('enabled building')
# end

scenario "super admin user adds new room without bed" do
  click_link 'New room'
  find('#room_room_name').set 'new room'
  click_button 'Add'
  select building.building_name, from:  'room_building_id'
  click_button 'Update'
  visit rooms_path
  expect(page).to have_content('new room')

pending("super admin user adds new room with bed NEEDS FIX")
# scenario "super admin user adds new room with bed" do
#   click_link 'New room'
#   find('#room_room_name').set 'new room'
#   click_button 'Add'
#   select building.building_name, from: 'room_building_id'
#   click_link 'Add bed'
#   wait_for_ajax
#   find('#room_beds_attributes_0_bed_name').set 'new bed'
#   click_button 'Update'
#   visit rooms_path
#   expect(page).to have_content('new bed')
# end
end

*** Keywords ***
Go to room
  I am on the "patients" page
  I hit the "settings" tab
  I hit the "Rooms" view
