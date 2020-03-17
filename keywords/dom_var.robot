*** Settings ***
Documentation   List of DOM locators and selection keywords.
...

*** Variables ***
${BROWSER}                              Chrome
# ${BASE URL}                             https://demo.kipuworks.com
# ${BASE URL}                             http://192.168.97.1:3000
# ${BASE URL}                             http://localhost:3000
# ${BASE URL}                             http://0.0.0.0:3072
# ${BASE URL}                             https://kipu-rel-test02.herokuapp.com
# ${BASE URL}                             https://hm-ecs-001.ksd1446.com
# ${BASE URL}                             https://ecs-demo.kipuworks.com
# ${BASE URL}                             web://web:3000
# ${BASE URL}                             http://docker.for.mac.localhost:3072
# ${BASE URL}                             http://192.168.65.1:3072
${BASE URL}                              https://rel-test02.kipuworks.com
#${URL}                                    https://https://ks.ksp1446.com/users/sign_in
#${PASSWORD}                               HZnhDtKb
${RF HUG}                               ${false}
${TEST PATIENT}                         ${true}
${PROCESS TYPE}                         0
# ${SCREENSHOT PATH}                      ${EMPTY}
${COMEBACK}                             0
${UUID}                                 0
${CURRENT USER}                         ${HM USER}
${CURRENT PASS}                         ${HM PASS}
# ${CURRENT USER}                         ${CAS USER}
# ${CURRENT PASS}                         ${CAS PASS}
${TODAYS DATE}                          0
${COMEBACK}                             0
${LOOP LIMIT}                           ${10}


@{500 ERRORS}                           Routing Error    Toggle session dump    Kipu Records:    Internal server error
...                                     The page you were looking for doesn't exist    You need to sign in to continue
...                                     We're sorry, but something went wrong (500)


#                                   //*[contains(concat(" ", normalize-space(@class), " "), "class")]
${CSS SELECT}                           contains(concat(" ", normalize-space(@class), " "), "$CSS")
${HELP}                                 https://wiki.kipuworks.com
${PRINT}                                btn_print
${PDF}                                  btn_pdf
${GEN PDF}                              partial_casefile_btn
${GEN CASEFILE}                         full_casefile_btn
${GEN TRANSFER}                         chart_transfer
${TOP}                                  btn_to_top
${KP BOTTOM}                            footer-bottom


${DASHBOARD}                            /dashboard
${PATIENTS}                             /patients
${OCCUPANCY}                            /occupancy
${SCHEDULES}                            /group_session_leaders
${SHIFTS}                               /shift_reports
${CONTACTS}                             /contacts
${CONTACT TYPES}                        /contact_types
${LAB INTERFACE}                        /kipu_labs/lab_test_requisitions
${LAB INTERFACE MANUAL}                 /lab_requisitions.all
${REPORTS}                              /reports
${TEMPLATES}                            /consent_forms
${MEDS INVENTORY}                       /medication_inventories?type=facility
${SETTINGS}                             /settings
${USERS}                                /users
${SIGN IN}                              /users/sign_in
${KP CALENDAR}                          /events/
${KP CLIENT SERVICES}                   /client-services/
${KP KIPU MARKETPLACE}                  /kb/kipu-marketplace/
${KP VIDEOS}                            /videos/
${KP RELEASE NOTES}                     /release-notes/
${VIEW TOGGLE}                          /patients?p_selection=current&p_view=
${MEDICATIONS}                          /medications
${ORDERS}                               /orders_settings
${ROOMS}                                /rooms
${TAGS AND FILTERS}                     /patient_tags
${USER}                                 /user_titles
${COMPANY}                              /company_settings
${KONNECTORS}                           /vendors
${GOLDEN THREAD}                        /golden_thread/assign_golden_thread_patient_settings?item=goal
${INSTANCE}                             /site_settings/1/edit
${PAYORS}                               /payers
${KIPU ACCOUNT}                         /kipu_account
${RESTORE}                              /versions
${CALENDAR}                             /calendar
${KIPU LABS}                            /kipu_labs/lab_client_status
${SERVICES}                             /services
${CODES}                                /codes
${EPRESCRIBE}                           /e_prescribe_settings


${PRE ADMISSION STATUS ADD}             /settings/add_pre_admission_status
${PRE ADMISSION STATUS TABLE}           pre_admission_statuses
${DISCHARGE TYPES ADD}                  /settings/add_patient_discharge_type
${DISCHARGE TYPES TABLE}                discharge_types
${MARITAL STATUS ADD}                   /settings/add_marital_status
${MARITAL STATUS TABLE}                 marital_statuses
${PAYMENT METHODS ADD}                  /settings/add_payment_method
${PAYMENT METHODS TABLE}                payment_methods
${FOOD DIETS ADD}                       /settings/add_diet
${FOOD DIETS TABLE}                     diets
${PATIENT PROPERTY CONDITION ADD}       /settings/add_property_condition
${PATIENT PROPERTY CONDITION TABLE}     property_conditions
${PATIENT PROGRAMS ADD}                 /settings/add_patient_color
${PATIENT PROGRAMS TABLE}               patient_colors
${CALENDAR APPOINTMENT TYPES ADD}       /settings/add_appointment_type
${CALENDAR APPOINTMENT TYPES TABLE}     appointment_types
${CALENDAR APPOINTMENT STATUSES ADD}    /settings/add_appointment_status
${CALENDAR APPOINTMENT STATUSES TABLE}  appointment_statuses
${PATIENT STATUSES ADD}                 /settings/add_setting_status
${PATIENT STATUSES TABLE}               setting_statuses
${RACE ADD}                             /settings/add_race
${RACE TABLE}                           races
${ETHNICITY ADD}                        /settings/add_ethnicity
${ETHNICITY TABLE}                      ethnicities
${ROUNDS ACTIVITIES ADD}                /settings/add_rounds_activity
${ROUNDS ACTIVITIES TABLE}              rounds_activities
${ROUNDS LOCATIONS ADD}                 /settings/add_rounds_location
${ROUNDS LOCATIONS TABLE}               rounds_locations
${LEVELS OF CARE ADD}                   /settings/add_care_level
${LEVELS OF CARE TABLE}                 care_levels
${INSURANCE BENEFITS ADD}               /settings/add_insurance_benefit_setting
${INSURANCE BENEFITS TABLE}             insurance_benefit_settings
${INSURANCE VERIFICATION ADD}           /settings/add_insurance_verification
${INSURANCE VERIFICATION TABLE}         insurance_verifications
${INSURANCE TYPES ADD}                  /settings/add_insurance_type
${INSURANCE TYPES TABLE}                insurance_types
${INSURANCE PLAN TYPES ADD}             /settings/add_insurance_plan_type
${INSURANCE PLAN TYPES TABLE}           insurance_plan_types
${INSURANCE SUBS RELATIONSHIP ADD}      /settings/add_insurance_subscriber_relationship
${INSURANCE SUBS RELATIONSHIP TABLE}    insurance_subscriber_relationships
${UTILIZATION REVIEW FREQS ADD}         /settings/add_ur_frequency
${UTILIZATION REVIEW FREQS TABLE}       ur_frequencies
${PATIENT CONTACT RELATIONSHIP ADD}     /settings/add_patient_contact_relationship
${PATIENT CONTACT RELATIONSHIP TABLE}   patient_contact_relationships
${PATIENT CONTACT TYPES ADD}            /settings/add_patient_contact_type
${PATIENT CONTACT TYPES TABLE}          patient_contact_types
${PATIENT PROCESSES ADD}                /settings/add_patient_process
${PATIENT PROCESSES TABLE}              patient_processes
${MEDICATION ROUTES ADD}                /settings/add_medication_route
${MEDICATION ROUTES TABLE}              medication_routes
${CARE TEAM FUNCTIONS ADD}              /settings/add_primary_care_team_functions
${CARE TEAM FUNCTIONS TABLE}            primary_care_team_functions
${DIAGNOSES ADD}                        ...
${DIAGNOSES TABLE}                      diagnosis_codes


${PATIENT TILE}                         //div[@class='pbottom40']/div[@class='left']
${PATIENT TILE ASSESSMENTS}             find_element_by_css_selector('a>div>div.top>div>span').get_attribute('innerHTML')
                                        #requires extra parsing, use "Line parser    ${Name}    1"
${PATIENT TILE NAME}                    find_element_by_css_selector('a>div>div.bottom').get_attribute('innerHTML')
${PATIENT TILE MR NUMBER}               find_element_by_css_selector('a>div>div.bottom>div>div.left').get_attribute('innerHTML')
${PATIENT TILE BED}                     find_element_by_css_selector('a>div>div.bottom>div>div.right').get_attribute('innerHTML')
${PATIENT LIST}                         //div[@class='pbottom40']//tr[position()>1]
${PATIENT LIST NAME}                    find_element_by_css_selector('td:nth-child(1)>a').get_attribute('innerHTML')
${PATIENT LIST MR NUMBER}               find_element_by_css_selector('td:nth-child(2)>a').get_attribute('innerHTML')
${PATIENT LIST BED}                     find_element_by_css_selector('td:nth-child(4)').get_attribute('innerHTML')

${PATIENT FACESHEET PROGRAM}            patient_patient_color_id
${PATIENT FACESHEET PROGRAM DATE}       patient_patient_color_date
${PATIENT FACESHEET TAGS}               token-input-patient_patient_tags_attributes__name
${PATIENT FACESHEET CASE MANAGER}       patient_case_manager_user_id

${PATIENT FACESHEET}                    //div[@id='patient_information']
${PATIENT FACESHEET COMMITMENT}         patient_patient_statuses_attributes_0_name
${PATIENT FACESHEET COMMIT START DATE}  patient_patient_statuses_attributes_0_start_date
${PATIENT FACESHEET APPROACH}           patient_patient_statuses_attributes_1_name
${PATIENT FACESHEET CAR}                patient_patient_statuses_attributes_2_name
${PATIENT FACESHEET CAR START DATE}     patient_patient_statuses_attributes_2_start_date
${PATIENT FACESHEET CAR END DATE}       patient_patient_statuses_attributes_2_end_date
${PATIENT FACESHEET CURFEW}             patient_patient_statuses_attributes_3_name
${PATIENT FACESHEET CURFEW START DATE}  patient_patient_statuses_attributes_3_start_date
${PATIENT FACESHEET LANGUAGE}           patient_patient_statuses_attributes_4_name
${PATIENT FACESHEET PASS}               patient_patient_statuses_attributes_5_name
${PATIENT FACESHEET PASS START DATE}    patient_patient_statuses_attributes_5_start_date
${PATIENT FACESHEET PASS END DATE}      patient_patient_statuses_attributes_5_start_end

${PATIENT FACESHEET REFERRER}           patient_referrer_name
${PATIENT FACESHEET REFERRER CONTACT}   patient_referrer_contact_required
${PATIENT FACESHEET DISCHARGE}          patient_discharge_to_name
${PATIENT FACESHEET ADMISSION DATE}     patient_admission_date
${PATIENT FACESHEET DISCHARGE DATE}     patient_discharge_date
${PATIENT FACESHEET ANTI DISCHARGE}     patient_anticipated_discharge_date
${PATIENT FACESHEET LOCATION}           patient_location_id
${PATIENT FACESHEET BED}                patient_bed_name

${PATIENT FACESHEET ENABLE RECURRING}   patient_recurring_status

${PATIENT FACESHEET FIRST NAME}         patient_first_name
${PATIENT FACESHEET MIDDLE NAME}        patient_middle_name
${PATIENT FACESHEET LAST NAME}          patient_last_name
${PATIENT FACESHEET PREFERRED NAME}     patient_preferred_name
${PATIENT FACESHEET OTO}                patient_one_time_only_patient
${PATIENT FACESHEET MR}                 patient_mr
${PATIENT FACESHEET BIRTH SEX}          patient[gender_short]
${PATIENT FACESHEET GENDER IDENTITY}    patient_gender_identity_short
${PATIENT FACESHEET MARITIAL STATUS}    patient_marital_status
${PATIENT FACESHEET DIAGNOSIS}          diagnosis_code
${PATIENT FACESHEET RACE}               patient_race
${PATIENT FACESHEET ETHNICITY}          patient_ethnicity
${PATIENT FACESHEET SSN}                patient_ssn
${PATIENT FACESHEET DOB}                patient_dob
${PATIENT FACESHEET SOBRIETY DATE}      patient_sobriety_date
${PATIENT FACESHEET PHONE}              patient_phone
${PATIENT FACESHEET ALT PHONE}          patient_alternate_phone
${PATIENT FACESHEET EMAIL}              patient_email
${PATIENT FACESHEET STREET ADDRESS 1}   patient_address_street
${PATIENT FACESHEET STREET ADDRESS 2}   patient_address_street2
${PATIENT FACESHEET CITY}               patient_address_city
${PATIENT FACESHEET STATE}              patient_address_state
${PATIENT FACESHEET ZIP}                patient_address_zip
${PATIENT FACESHEET COUNTRY}            patient_address_country
${PATIENT FACESHEET PHOTO}              patient_image
${PATIENT FACESHEET ID}                 patient_patient_id_image

${PATIENT FACESHEET OCCUPATION}         patient_occupation
${PATIENT FACESHEET EMPLOYER NAME}      patient_employer_name
${PATIENT FACESHEET EMPLOYER PHONE}     patient_employer_phone

${PATIENT FACESHEET PAYMENT METHOD}     patient[payment_method]

${PATIENT FACESHEET INSURANCE COMPANY}  patient_insurances_attributes_$CID_insurance_company
${PATIENT FACESHEET POLICY NO}          patient_insurances_attributes_$CID_policy_no
${PATIENT FACESHEET GROUP ID}           patient_insurances_attributes_$CID_group_ID
${PATIENT FACESHEET INSURANCE STATUS}   patient_insurances_attributes_$CID_status
${PATIENT FACESHEET INSURANCE PHONE}    patient_insurances_attributes_$CID_insurance_phone
${PATIENT FACESHEET INSURANCE TYPE}     patient_insurances_attributes_$CID_insurance_type
${PATIENT FACESHEET INSURANCE PLAN}     patient_insurances_attributes_$CID_insurance_plan_type
${PATIENT FACESHEET RX}                 patient_insurances_attributes_$CID_rx_name
${PATIENT FACESHEET RX PHONE}           patient_insurances_attributes_$CID_rx_phone
${PATIENT FACESHEET RX GROUP}           patient_insurances_attributes_$CID_rx_group
${PATIENT FACESHEET RX BIN}             patient_insurances_attributes_$CID_rx_bin
${PATIENT FACESHEET RX PCN}             patient_insurances_attributes_$CID_rx_pcn
${PATIENT FACESHEET SUBSCRIBER RSHIP}   patient_insurances_attributes_$CID_subscriber_relationship
${PATIENT FACESHEET SUBSCRIBER FIRST}   patient_insurances_attributes_$CID_subscriber_first_name
${PATIENT FACESHEET SUBSCRIBER MIDDLE}  patient_insurances_attributes_$CID_subscriber_middle_name
${PATIENT FACESHEET SUBSCRIBER LAST}    patient_insurances_attributes_$CID_subscriber_last_name
${PATIENT FACESHEET SUBSCRIBER SSN}     patient_insurances_attributes_$CID_subscriber_SSN
${PATIENT FACESHEET SUBSCRIBER DOB}     patient_insurances_attributes_$CID_subscriber_DOB
${PATIENT FACESHEET SUBSCRIBER EMP}     patient_insurances_attributes_$CID_subscriber_employer
${PATIENT FACESHEET INSURANCE FRONT}    patient_insurances_attributes_$CID_image
${PATIENT FACESHEET INSURANCE BACK}     patient_insurances_attributes_$CID_insurance_card_image
${PATIENT FACESHEET INSURANCE NOTES}    patient_insurances_attributes_$CID_notes

${PATIENT FACESHEET CONTACT FULL NAME}  patient_patient_contacts_attributes_$CID_full_name
${PATIENT FACESHEET CONTACT TYPE}       patient_patient_contacts_attributes_$CID_contact_type
${PATIENT FACESHEET CONTACT RSHIP}      patient_patient_contacts_attributes_$CID_relationship
${PATIENT FACESHEET CONTACT PHONE}      patient_patient_contacts_attributes_$CID_phone
${PATIENT FACESHEET CONTACT ALT PHONE}  patient_patient_contacts_attributes_$CID_alternative_phone
${PATIENT FACESHEET CONTACT EMAIL}      patient_patient_contacts_attributes_$CID_email
${PATIENT FACESHEET CONTACT ADDRESS}    patient_patient_contacts_attributes_$CID_address
${PATIENT FACESHEET CONTACT NOTES}      patient_patient_contacts_attributes_$CID_notes

${PATIENT FACESHEET NO ALLERGY}         patient_has_no_allergy
${PATIENT FACESHEET ALLERGEN}           patient_allergies_attributes_$CID_allergen
${PATIENT FACESHEET ALLERGY TYPE}       patient_allergies_attributes_$CID_allergy_type
${PATIENT FACESHEET REACTION}           patient_allergies_attributes_$CID_reaction
${PATIENT FACESHEET REACTION TYPE}      patient_allergies_attributes_$CID_reaction_type
${PATIENT FACESHEET ONSET}              patient_allergies_attributes_$CID_onset
${PATIENT FACESHEET TREATMENT}          patient_allergies_attributes_$CID_treatment
${PATIENT FACESHEET ALLERGY STATUS}     patient_allergies_attributes_$CID_status_type
${PATIENT FACESHEET ALLERGY SOURCE}     patient_allergies_attributes_$CID_source
${PATIENT FACESHEET DIETS}              patient_patient_diets_attributes_$CID_diet
${PATIENT FACESHEET OTHER RESTRICT}     patient_food_restrictions

${PATIENT FACESHEET EXTERNAL APP}       patient[external_apps_attributes][$CID][external_app_name]


${DASHBOARD ORDERS}                     ${DASHBOARD}/orders?p_view=orders
${DASHBOARD MED PASS}                   ${DASHBOARD}/med_pass?p_view=med_pass
${DASHBOARD ACTIONS}                    ${DASHBOARD}/actions?p_view=actions
${DASHBOARD PHYSICIAN REVIEW}           ${DASHBOARD}/physician_review?p_subview=doctor_orders&p_view=physician_review
${DASHBOARD CASE MANAGER LOAD}          ${DASHBOARD}/care_team_load?function_id=4&p_view=Case+Manager
${DASHBOARD THERAPIST CASE LOAD}        ${DASHBOARD}/care_team_load?function_id=1&p_view=Therapist
${DASHBOARD CURRENT CENSUS}             ${DASHBOARD}?p_view=current
${DASHBOARD DISCHARGED PATIENTS}        ${DASHBOARD}?p_view=discharged


${CONTACT FORM}                         //div[@id='contact_form']
${CONTACT FORM CONTACT TYPE}            contact_contact_type_id
${CONTACT FORM COMPANY NAME}            contact_company_name
${CONTACT FORM STREET ADDRESS 1}        contact_address_street1
${CONTACT FORM PHONE}                   contact_company_phone
${CONTACT FORM FAX}                     contact_company_fax
${CONTACT FORM WEBSITE}                 contact_company_website
${CONTACT FORM NOTES}                   contact_notes


${TEMPLATES CONSENT FORMS}              //div[@id='sub_nav']//a[@href='/consent_forms']
${CONSENT FORMS FORM}                   //form[start-with(@id,'edit_consent_form_')]
${CONSENT FORMS FORM NAME}              consent_form_name
${CONSENT FORMS FORM PATIENT PROCESS}   consent_form_patient_process_id
${CONSENT FORMS FORM ENABLED}           consent_form_enabled
${CONSENT FORMS FORM PATIENT SIG REQ}   consent_form_signature_required
${CONSENT FORMS FORM GUART SIG REQ}     consent_form_guarantor_signature_required
${CONSENT FORMS FORM GUARD SIG REQ}     consent_form_guardian_signature_required
${CONSENT FORMS FORM STAFF SIG REQ}     consent_form_staff_signature
${CONSENT FORMS FORM ALLOW REVOCATION}  consent_form_allow_revocation
${CONSENT FORMS FORM RULES}             consent_form_rules
${CONSENT FORMS FORM ALL LOCATIONS}     consent_form_all_locations


${TEMPLATES EVALUATIONS}                /evaluations
${EVALUATIONS FORM}                     //form[start-with(@id,'edit_evaluation_')]
${EVALUATIONS FORM NAME}                evaluation_name
${EVALUATIONS FORM ENABLED}             evaluation_enabled
${EVALUATIONS FORM VERSION SELECT}      version_select
${EVALUATIONS FORM VERSION USE}         //label[@for='Make_in_use']/following-sibling::input[1]
${EVALUATIONS FORM VERSION UNLINK}      //label[@for='Unlink_version']/following-sibling::input[1]
${EVALUATIONS FORM PATIENT PROCESS}     evaluation_patient_process_id
${EVALUATIONS FORM ALLOW TECH ACCESS}   evaluation_allow_tech_access
${EVALUATIONS FORM SHOW P PHOTO H}      evaluation_show_patient_header
${EVALUATIONS FORM LOAD MANUALLY}       evaluation_load_manually
${EVALUATIONS FORM EVAL TYPE}           evaluation_evaluation_type
${EVALUATIONS FORM EVAL CONTENT}        evaluation_evaluation_content
${EVALUATIONS FORM ONLY ONE PER P}      evaluation_only_one_per_patient
${EVALUATIONS FORM BILLABLE}            evaluation_billable
${EVALUATIONS FORM ANCILLARY}           evaluation_ancillary
${EVALUATIONS FORM CLAIM FORMAT}        evaluation_billable_claim_format
${EVALUATIONS FORM RENDERING PROVIDER}  evaluation_rendering_provider
${EVALUATIONS FORM CODING SYSTEM}       coding_system

${EVALUATIONS FORM RECURRING}           evaluation_recurring
${EVALUATIONS FORM DAILY START T HR}    evaluation_recurring_start_time_4i
${EVALUATIONS FORM DAILY START T MIN}   evaluation_recurring_start_time_5i
${EVALUATIONS FORM INTERVAL IN MIN}     evaluation_interval
${EVALUATIONS FORM DAILY OVERVIEW}      evaluation_show_completed_compressed_vertical
${EVALUATIONS FORM PATIENT SIG}         evaluation_require_patient_signature
${EVALUATIONS FORM STAFF SIG}           evaluation_force_all_staff_users_titles
${EVALUATIONS FORM REVIEW SIG}          evaluation_force_all_review_users_titles
${EVALUATIONS FORM STAFF SINGLE SIG_}   staff
${EVALUATIONS FORM STAFF FORCE SIG}     evaluation_force_all_staff_users_titles
${EVALUATIONS FORM REVIEW SIG_}         review
${EVALUATIONS FORM REVIEW FORCE SIG}    evaluation_force_all_review_users_titles
${EVALUATIONS FORM ALL LOCATIONS}       evaluation_all_locations

${EVALUATIONS FORM ITEM ENABLED}        evaluation_evaluation_items_attributes_$CID_enabled
${EVALUATIONS FORM ITEM NAME}           evaluation_evaluation_items_attributes_$CID_name
${EVALUATIONS FORM ITEM LABEL}          evaluation_evaluation_items_attributes_$CID_label
${EVALUATIONS FORM ITEM LABEL WIDTH}    evaluation_evaluation_items_attributes_$CID_label_width
${EVALUATIONS FORM ITEM FIELD TYPE}     evaluation_evaluation_items_attributes_$CID_field_type
${EVALUATIONS FORM ITEM OPTIONAL}       //label[@for='evaluation_evaluation_items_attributes_$CID_optional']/following-sibling::input[last()]
${EVALUATIONS FORM ITEM POINTS GROUP}   evaluation_evaluation_items_attributes_$CID_item_group
${EVALUATIONS FORM ITEM CSS STYLE}      evaluation_evaluation_items_attributes_$CID_css_style
${EVALUATIONS FORM ITEM RECORD NAMES}   evaluation_evaluation_items_attributes_$CID_record_names
${EVALUATIONS FORM ITEM SHOW STRING}    evaluation_evaluation_items_attributes_$CID_show_string
${EVALUATIONS FORM ITEM PLACEHOLDER}    evaluation_evaluation_items_attributes_$CID_placeholder
${EVALUATIONS FORM ITEM SHOW CSS}       evaluation_evaluation_items_attributes_$CID_show_string_css
${EVALUATIONS FORM ITEM MATRIX NAMES}   evaluation_evaluation_items_attributes_$CID_column_names
${EVALUATIONS FORM ITEM MATRIX EMPTY}   evaluation_evaluation_items_attributes_$CID_matrix_default_records
${EVALUATIONS FORM ITEM RULE}           evaluation_evaluation_items_attributes_$CID_rule
${EVALUATIONS FORM ITEM DEFAULT VALUE}  evaluation_evaluation_items_attributes_$CID_default_value
${EVALUATIONS FORM ITEM PRE POP}        evaluation_evaluation_items_attributes_$CID_pre_populate_with_id
${EVALUATIONS FORM ITEM DIVIDER BELOW}  evaluation_evaluation_items_attributes_$CID_divider_below


${TEMPLATES ORDERS}                     /orders
${ORDERS FORM}                          //div[@id='order_form']
${ORDERS FORM NAME}                     order_name
${ORDERS FORM ALL LOCATIONS}            order_all_locations
${ORDERS FORM ENABLED}                  order_enabled
${ORDERS FORM PRN}                      order_prn
${ORDERS FORM JUSTIFICATION}            order_justification
${ORDERS FORM DOSAGE TYPE}              order[dosage_type]
${ORDERS FORM DURATION}                 order_duration_in_days
${ORDERS FORM NOTE}                     order_note
${ORDERS FORM ORDER ENABLED}            order_order_items_attributes_$CID_enabled
${ORDERS FORM DAY}                      order_order_items_attributes_$CID_day
${ORDERS FORM MEDICATION}               order_order_items_attributes_$CID_medication
${ORDERS FORM ROUTE}                    order_order_items_attributes_$CID_route
${ORDERS FORM DOSAGE FORM}              order_order_items_attributes_$CID_dosage_form
${ORDERS FORM DOSE}                     order_order_items_attributes_$CID_dose
${ORDERS FORM FREQUENCY}                order_order_items_attributes_$CID_medication_order_frequency_id


${TEMPLATES GROUP SESSIONS}             /group_sessions
${GROUP SESSIONS FORM}                  //div[@id='group_session_form]
${GROUP SESSIONS FORM TITLE}            group_session_title
${GROUP SESSIONS FORM NAME}             ${GROUP SESSIONS FORM TITLE}
${GROUP SESSIONS FORM SESSION TYPE}     group_session_session_type
${GROUP SESSIONS FORM ENABLED}          group_session_enabled
${GROUP SESSIONS FORM BILLABLE}         group_session_billable
${GROUP SESSIONS FORM WEEK DAY}         group_session_week_day
${GROUP SESSIONS FORM START TIME HR}    group_session_start_time_4i
${GROUP SESSIONS FORM START TIME MIN}   group_session_start_time_5i
${GROUP SESSIONS FORM END TIME HR}      group_session_end_time_4i
${GROUP SESSIONS FORM END TIME MIN}     group_session_end_time_5i

${TEMPLATES GROUP SESSIONS 2}           /gs${TEMPLATES GROUP SESSIONS}
${GROUP SESSIONS 2 FORM TITLE}          gs_${GROUP SESSIONS FORM TITLE}
${GROUP SESSIONS 2 FORM NAME}           ${GROUP SESSIONS 2 FORM TITLE}
${GROUP SESSIONS 2 FORM SESSION TYPE}   gs_${GROUP SESSIONS FORM SESSION TYPE}
# ${GROUP SESSIONS FORM SESSION TYPE 2}   group_session_session_type
${GROUP SESSIONS 2 FORM ENABLED}        gs_${GROUP SESSIONS FORM ENABLED}
${GROUP SESSIONS 2 FORM BILLABLE}       gs_${GROUP SESSIONS FORM BILLABLE}
${GROUP SESSIONS 2 FORM WEEK DAY}       gs_group_session_group_session_occurrences_attributes_$CID_week_day
${GROUP SESSIONS 2 FORM START HR}       gs_group_session_group_session_occurrences_attributes_$CID_start_time_4i
${GROUP SESSIONS 2 FORM START MIN}      gs_group_session_group_session_occurrences_attributes_$CID_start_time_5i
${GROUP SESSIONS 2 FORM END HR}         gs_group_session_group_session_occurrences_attributes_$CID_end_time_4i
${GROUP SESSIONS 2 FORM END MIN}        gs_group_session_group_session_occurrences_attributes_$CID_end_time_5i


${TEMPLATES SCHEDULES}                  /schedules
${SCHEDULES FORM}                       //div[@id='schedules_form']
${SCHEDULES FORM NAME}                  schedule_name
${SCHEDULES FORM ENABLED}               schedule_enabled
${SCHEDULES FORM PATIENT PROCESS}       schedule_patient_process_id


${TEMPLATES ROUNDS}                     /rounds
${ROUNDS FORM TITLE}                    round_title
${ROUNDS FORM NAME}                     ${ROUNDS FORM TITLE}
${ROUNDS FORM ROUND TYPE}               round_round_type
${ROUNDS FORM ENABLED}                  round_enabled
${ROUNDS FORM INTERVAL HRS}             round_q_interval_hours
${ROUNDS FORM INTERVAL MINS}            round_q_interval_minutes
${ROUNDS FORM VITALS}                   round_allow_vitals
${ROUNDS FORM WEIGHT}                   round_allow_weight
${ROUNDS FORM GLUCOSE}                  round_allow_glucose
# ${ROUNDS FORM ALERT MISSED START}       round_alert_missed_round_start
# ${ROUNDS FORM MISSED START MINS}        round_missed_round_start_minutes
${ROUNDS FORM MISSED START MINS}        round_round_start_threshold_minutes
# ${ROUNDS FORM ALERT MISSED INTERVAL}    round_alert_missed_q
# ${ROUNDS FORM MISSED INTERVAL COUNT}    round_missed_q_count
# ${ROUNDS FORM ALERT ROUND LEADERS}      round_alert_round_leaders
${ROUNDS FORM ALERT ADMIN}              round_alert_roles_admin
${ROUNDS FORM ALERT SUPER ADMIN}        round_alert_roles_super_admin
${ROUNDS FORM ALERT RECORDS ADMIN}      round_alert_roles_records_admin
${ROUNDS FORM ALERT MANAGE ROUNDS}      round_alert_roles_manage_rounds
# ${ROUNDS FORM SEND EMAIL ALERTS}        round_alert_methods_email
# ${ROUNDS FORM SEND SMS ALERTS}          round_alert_methods_sms

${ROUNDS FORM SUNDAY}                   round_week_days_sunday
${ROUNDS FORM MONDAY}                   round_week_days_monday
${ROUNDS FORM TUESDAY}                  round_week_days_tuesday
${ROUNDS FORM WEDNESDAY}                round_week_days_wednesday
${ROUNDS FORM THURSDAY}                 round_week_days_thursday
${ROUNDS FORM FRIDAY}                   round_week_days_friday
${ROUNDS FORM SATURDAY}                 round_week_days_saturday
${ROUNDS FORM START TIME HR}            round_start_time_4i
${ROUNDS FORM START TIME MIN}           round_start_time_5i
${ROUNDS FORM END TIME HR}              round_end_time_4i
${ROUNDS FORM END TIME MIN}             round_end_time_5i
${ROUNDS FORM MINS BEFORE START TIME}   round_round_start_threshold_minutes
${ROUNDS FORM LOCATIONS}                round_location_id

${ROUNDS FORM LEADER}                   round_round_leaders_attributes_$CID_user_id
${ROUNDS FORM ROLE}                     round_rounds_roles_attributes_$CID_role_id
${ROUNDS FORM USER FUNCTION}            round_rounds_user_titles_attributes_$CID_user_title_id


${ACCOUNT PDF PACKAGES}                 /pdf_packages
${NEW PDF PACKAGE}                      //form[@id='new_pdf_package']
${NEW PDF PACKAGE NAME}                 pdf_package_name
${NEW PDF PACKAGE ENABLED}              pdf_package_enabled


${NEW USER}                             //form[@id='new_user']
${NEW USER USERNAME}                    user_username
${NEW USER FIRST NAME}                  user_first_name
${NEW USER MIDDLE NAME}                 user_middle_name
${NEW USER LAST NAME}                   user_last_name
${NEW USER TITLE}                       user_title
${NEW USER EMAIL}                       user_email
${NEW USER MOBILE}                      user_mobile
${NEW USER NPI NUMBER}                  user_npi_number
${NEW USER DEA NUMBER}                  user_dea_number
${NEW USER NOTIFICATION PREF}           user_notification_preference
${NEW USER SIGN PIN}                    sign_with_pin
${NEW USER PIN}                         user_pin
${NEW USER ACCESS ALL LOCATIONS}        user_access_all_locations
${NEW USER DEFAULT LOCATION}            user_default_location_id
${NEW USER FUNCTION}                    user_user_title_id
${NEW USER DISABLE}                     user_disabled
${NEW USER LOCKED}                      unlock
${NEW USER NOTES}                       user_note
${NEW USER PASSWORD}                    user_password
${NEW USER PASSWORD CONFIRMATION}       user_password_confirmation
${NEW USER CURRENT PASSWORD}            user_current_password


${NEW APPOINTMENT}                      //form[@id='new_appointment']
${NEW APPOINTMENT PROVIDERS}            token-input-schedulers
${NEW APPOINTMENT PATIENTS}             token-input-scheduleables
${NEW APPOINTMENT START DATE TIME}      appointment_start_time
${NEW APPOINTMENT END DATE TIME}        appointment_end_time
${NEW APPOINTMENT TYPE}                 appointment_appointment_type_id
${NEW APPOINTMENT STATUS}               appointment_status_id
${NEW APPOINTMENT BILLABLE}             //span[@id='appointment_billable' and @class='switchery']
${NEW APPOINTMENT ALL DAY}              //span[@id='appointment_all_day' and @class='switchery']
${NEW APPOINTMENT NOTES}                appointment_reason
${NEW APPOINTMENT RECURRING RULE}       appointment_recurring_rule
${NEW APPOINTMENT SEARCH S DATE TIME}   appt-start-date
${NEW APPOINTMENT SEARCH E DATE TIME}   appt-end-date


${PAST GROUP SESSIONS}                  ${SCHEDULES}/past_group_sessions
${GS LEADER FORM}                       //div[@id='group_session_leader_form']
${GS LEADER FORM SESSION START HR}      //*[@id='group_session_leader_session_start_time_4i']
${GS LEADER FORM SESSION START MIN}     //*[@id='group_session_leader_session_start_time_5i']
${GS LEADER FORM SESSION END HR}        //*[@id='group_session_leader_session_end_time_4i']
${GS LEADER FORM SESSION END MIN}       //*[@id='group_session_leader_session_end_time_5i']
${GS LEADER FORM TOPIC}                 //*[@id='group_session_leader_group_session_topic']
${GS LEADER FORM FIRST PATIENT}         //*[@id='group_session_leader_group_session_attendances_attributes_0_present']
${GS LEADER FORM PATIENT}               //*[@id='group_session_leader_group_session_attendances_attributes_$CID_present']
${GS LEADER FORM ASSESSMENT}            //*[@id='group_session_leader_group_session_attendances_attributes_$CID_personal_group_session_note']
${GS LEADER FORM GROUP DESCRIPTION}     //*[@id='group_session_leader_group_session_notes']


# ${ADD ORDER}                 //div[@id='AddOrderMedication']
${ADD ORDER ORDERED BY}                 add_orders_instructed_by
${ADD ORDER VIA}                        add_orders_instructed_via
${ADD ORDERS ORDERED BY}                orders_ordered_by
${ADD ORDERS VIA}                       orders_ordered_via

${ADD ORDER MEDICATION}                 //div[@id='AddOrderMedication']
${ADD ORDER MEDICATION MEDICATION}      patient_order_item_medication
${ADD ORDER MEDICATION ROUTE}           patient_order_item_route
${ADD ORDER MEDICATION DOSAGE FORM}     patient_order_item_dosage_form
${ADD ORDER MEDICATION DOSE}            patient_order_item_dose
${ADD ORDER MEDICATION JUST}            //div[@id='AddOrderMedication']//*[@id='patient_order_justification']
${ADD ORDER MEDICATION WARNINGS}        //div[@id='AddOrderMedication']//*[@id='patient_order_warnings']
${ADD ORDER MEDICATION QUANTITY}        patient_order_item_administer_amount
${ADD ORDER MEDICATION FREQUENCY}       patient_order_item_frequency
${ADD ORDER MEDICATION START DATE}      medication_order_start_time
${ADD ORDER MEDICATION DURATION DAYS}   //div[@id='AddOrderMedication']//*[@id='patient_order_duration_in_days']
${ADD ORDER MEDICATION PRN}             //div[@id='AddOrderMedication']//*[@id='patient_order_prn']
${ADD ORDER MEDICATION CONT DISCHARGE}  //div[@id='AddOrderMedication']//*[@id='patient_order_continue_on_discharge']
${ADD ORDER MEDICATION NOTES}           //div[@id='AddOrderMedication']//*[@id='patient_order_note']
${ADD ORDER MEDICATION DISPENSE}        patient_order_pharmacy_dispense_amount
${ADD ORDER MEDICATION REFILLS}         patient_order_refills
${ADD ORDER MEDICATION ORDERED BY}      add_manual_order_instructed_by
${ADD ORDER MEDICATION VIA}             add_manual_order_instructed_via

${ADD ORDER MEDICATION2 MEDICATION}     medication_
${ADD ORDER MEDICATION2 ROUTE}          route_
${ADD ORDER MEDICATION2 DOSAGE FORM}    dosage_form_
${ADD ORDER MEDICATION2 JUST}           justification_
${ADD ORDER MEDICATION2 WARNINGS}       orders_med_orders_|_warnings
${ADD ORDER MEDICATION2 QUANTITY}       orders_med_orders_|_order_items_|_|_administer_amount
${ADD ORDER MEDICATION2 FREQUENCY}      frequency_|_
${ADD ORDER MEDICATION2 START DATE}     start_date_
${ADD ORDER MEDICATION2 DURATION DAYS}  duration_in_days_
${ADD ORDER MEDICATION2 PRN}            prn_
${ADD ORDER MEDICATION2 NOTES}          orders_med_orders_|_note
${ADD ORDER MEDICATION2 REFILLS}        orders_med_orders_|_refills
${ADD ORDER MEDICATION2 STRENGTH}       orders_med_orders_|_order_items_|_|_strength
${ADD ORDER MEDICATION2 UNITS}          orders_med_orders_|_order_items_|_|_administer_unit
${ADD ORDER MEDICATION2 DISPENSE}       orders_med_orders_|_dispense_amounts_

${ADD ORDER ACTION}                     //div[@id='AddOrderAction']
${ADD ORDER ACTION ACTION}              patient_order_name
${ADD ORDER ACTION SHOW MED LOG}        generate_mar_select
${ADD ORDER ACTION FREQUENCY}           action_order_frequency
${ADD ORDER ACTION DURATION DAYS}       //div[@id='AddOrderAction']//*[@id='patient_order_duration_in_days']
${ADD ORDER ACTION START DATE}          action_order_start_time
${ADD ORDER ACTION CONT DISCHARGE}      //div[@id='AddOrderAction']//*[@id='patient_order_continue_on_discharge']
${ADD ORDER ACTION PRN}                 //div[@id='AddOrderAction']//*[@id='patient_order_prn']
${ADD ORDER ACTION JUST}                //div[@id='AddOrderAction']//*[@id='patient_order_justification']
${ADD ORDER ACTION NOTES}               //div[@id='AddOrderAction']//*[@id='patient_order_note']
${ADD ORDER ACTION ORDERED BY}          add_manual_action_instructed_by
${ADD ORDER ACTION VIA}                 add_manual_action_instructed_via

${ADD ORDER ACTION2 ACTION}             action_order_
${ADD ORDER ACTION2 SHOW MED LOG}       orders_action_orders_|_generate_mar_select
${ADD ORDER ACTION2 FREQUENCY}          action_frequency_|_
${ADD ORDER ACTION2 DURATION DAYS}      orders_action_orders_|_duration_in_days
${ADD ORDER ACTION2 START DATE}         action_order_start_time_
${ADD ORDER ACTION2 CONT DISCHARGE}     orders_action_orders_|_continue_on_discharge
${ADD ORDER ACTION2 PRN}                orders_action_orders_|_prn
${ADD ORDER ACTION2 JUST}               orders_action_orders_|_justification
${ADD ORDER ACTION2 NOTES}              orders_action_orders_|_note

${ADD ORDER TAPERS MEDICATION}          medication_
${ADD ORDER TAPERS ROUTE}               route_
${ADD ORDER TAPERS DOSAGE FORM}         dosage_form_
${ADD ORDER TAPERS START DATE}          start_date_
${ADD ORDER TAPERS CONT DISCHARGE}      orders_med_orders_|_continue_on_discharge
${ADD ORDER TAPERS JUST}                justification_
${ADD ORDER TAPERS WARNINGS}            orders_med_orders_
${ADD ORDER TAPERS DURATION DAYS}       duration_in_days_
${ADD ORDER TAPERS NOTES}               orders_med_orders_|_note
${ADD ORDER TAPERS FREQUENCY}           frequency_|_
${ADD ORDER TAPERS STRENGTH}            orders_med_orders_|_order_items_|_|_strength
${ADD ORDER TAPERS UNITS}               orders_med_orders_|_order_items_|_|_administer_unit
${ADD ORDER TAPERS QUANTITY}            orders_med_orders_|_order_items_|_|_administer_amount
${ADD ORDER TAPERS PRN}                 orders_med_orders_|_order_items_|_|_prn
# ${ADD ORDER TAPERS DISPENSE}            orders_med_orders_

${ADD ORDER DC ORDERED BY}              discontinue_instructed_by
${ADD ORDER DC VIA}                     discontinue_instructed_via

${ADD ORDER CHANGE DURATION DAYS}       //div[starts-with(@id,'patient_order_item_')]//*[@id='patient_order_duration_in_days']
${ADD ORDER CHANGE ORDERED BY}          change_order_instructed_by
${ADD ORDER CHANGE VIA}                 change_order_instructed_via
${ADD ORDER CHANGE FREQUENCY}           patient_order_patient_order_item_frequency


${VITAL SIGNS}                          vital_signs_refresh
${VITAL SIGNS DATE TIME}                vital_sign_interval_timestamp
${VITAL SIGNS BP SYSTOLIC}              vital_sign_blood_pressure_systolic
${VITAL SIGNS BP DIASTOLIC}             vital_sign_blood_pressure_diastolic
${VITAL SIGNS TEMPERATURE}              vital_sign_temperature
${VITAL SIGNS PULSE}                    vital_sign_pulse
${VITAL SIGNS RESPIRATIONS}             vital_sign_respirations
${VITAL SIGNS O2 SATURATION}            vital_sign_o2_saturation
${GLUCOSE LOG DATE TIME}                glucose_log_evaluation_timestamp
${GLUCOSE LOG READING}                  glucose_log_reading
${GLUCOSE LOG TYPE OF CHECK}            glucose_log_type_of_check
${GLUCOSE LOG INTERVENTION}             intervention_
${GLUCOSE LOG NOTE}                     glucose_log_note
${WEIGHT DATE TIME}                     patient_attribute_history_evaluation_timestamp
${WEIGHT WEIGHT}                        patient_attribute_history_value
# ${HEIGHT DATE TIME}
${HEIGHT HEIGHT}                        patient_attribute_history_height


${EDIT COMPANY}                         //form[@id='edit_company_setting_1']
${EDIT COMPANY COMPANY}                 //*[@id='company_setting_name']
${EDIT COMPANY LOGO}                    //*[@id='company_setting_logo']
${NEW LOCATION}                         //form[@id='new_location']
${NEW LOCATION NAME}                    //*[@id='location_name']
${NEW LOCATION SHORT NAME}              //*[@id='location_short_name']
${NEW LOCATION STREET ADDRESS}          //*[@id='location_address_street']
${NEW LOCATION CITY}                    //*[@id='location_address_city']
${NEW LOCATION STATE}                   //*[@id='location_address_state']
${NEW LOCATION ZIP}                     //*[@id='location_address_zip']
${NEW LOCATION COUNTRY}                 //*[@id='location_address_county']
${NEW LOCATION TIMEZONE}                //*[@id='location_time_zone']
${NEW LOCATION PHONE}                   //*[@id='location_phone']
${NEW LOCATION FAX}                     //*[@id='location_fax']


${NEW PHI}                              //form[@id='new_patient_phi']
${NEW PHI DATE DISCLOSURE}              patient_phi_date_disclosure
${NEW PHI DATE REQUESTED}               patient_phi_date_requested
${NEW PHI REQUEST TYPE}                 patient_phi_request_type
${NEW PHI NAME}                         patient_phi_disclosure_name
${NEW PHI ADDRESS}                      patient_phi_disclosure_address
${NEW PHI DISCRIPTION}                  patient_phi_disclosure_description
${NEW PHI PURPOSE}                      patient_phi_disclosure_purpose
${NEW PHI DISCLOSED BY}                 patient_phi_disclosed_by


${GOLDEN THREAD DATE OF SERVICES}       patient_evaluation_evaluation_date
${GOLDEN THREAD MODALITY}               patient_evaluation_eval_treatment_plans_attributes_0_category
${GOLDEN THREAD PROBLEM}                patient_evaluation_eval_treatment_plans_attributes_0_problem
${GOLDEN THREAD TREATMENT MODAL}        master_treatment_plan_category
${GOLDEN THREAD TREATMENT PLAN STAT}    treatment_plan_statuses
${GOLDEN THREAD TREATMENT PLAN COL}     treatment_plan_columns
${GOLDEN THREAD PROGRESS NOTE COMP}     progress_note_components
${GOLDEN THREAD LEFT SIDE FILTER}       filterInput1
# 2->goals
# 3->obj
# 3->behav
# 3->interv
# 3->diag
${GOLDEN THREAD RIGHT SIDE FILTER}      filterInput3


${CT ASSIGN PRIMARY NURSE}              patient_evaluation_patient_primary_care_team_Primary_Nurse_primary_care_team_user_id
${CT ASSIGN PRIMARY PHYSICIAN}          patient_evaluation_patient_primary_care_team_Primary_Physician_primary_care_team_user_id
${CT ASSIGN PRIMARY THERAPIST}          patient_evaluation_patient_primary_care_team_Primary_Therapist_primary_care_team_user_id
${CT ASSIGN SECONDARY THERAPIST}        patient_evaluation_patient_primary_care_team_Secondary_Therapist_primary_care_team_user_id
${CT ASSIGN DESIGNATED TECH}            patient_evaluation_patient_primary_care_team_Designated_Tech_primary_care_team_user_id
${CT ASSIGN CASE MANAGER}               patient_evaluation_patient_primary_care_team_Case_Manager_primary_care_team_user_id
${CT ASSIGN ALUMNI COORDINATOR}         patient_evaluation_patient_primary_care_team_Alumni_Coordinator_primary_care_team_user_id


${VENDOR NAME}                          vendor_company_name
${VENDOR TYPE}                          vendor_vendor_type
${VENDOR STATUS}                        vendor_vendor_status
${VENDOR LOCATIONS}                     vendor_location_ids__
${VENDOR CONTACT NAME}                  vendor_contact_name
${VENDOR CONTACT PHONE}                 vendor_contact_phone
${VENDOR NOTES}                         vendor_notes
${VENDOR ADDRESS}                       vendor_address_street
${VENDOR CITY}                          vendor_address_city
${VENDOR STATE}                         vendor_address_state
${VENDOR ZIP}                           vendor_address_zip
${VENDOR COMPANY PHONE}                 vendor_company_phone
${VENDOR COMPANY FAX}                   vendor_company_fax

${VENDOR FACILITY NAME}                 vendor_vob_getter_interface_attributes_facility_id
${VENDOR PROVIDER NPI}                  vendor_vob_getter_interface_attributes_provider_npi
${VENDOR PROVIDER TAX ID}               vendor_vob_getter_interface_attributes_provider_tax_id
${VENDOR CONTACT EMAIL}                 vendor_vob_getter_interface_attributes_contact_email
${VENDOR BILLING EMAIL}                 vendor_vob_getter_interface_attributes_billing_email
${VENDOR COUPON CODE}                   vendor_vob_getter_interface_attributes_coupon_code
${VENDOR BILLING ADDRESS}               vendor_vob_getter_interface_attributes_billing_address_
${VENDOR BILLING CITY}                  vendor_vob_getter_interface_attributes_billing_address_city
${VENDOR BILLING STATE}                 vendor_vob_getter_interface_attributes_billing_address_state
${VENDOR BILLING ZIP}                   vendor_vob_getter_interface_attributes_billing_address_zip
${VENDOR RENDERING ADDRESS}             vendor_vob_getter_interface_attributes_rendering_address_
${VENDOR RENDERING CITY}                vendor_vob_getter_interface_attributes_rendering_address_city
${VENDOR RENDERING STATE}               vendor_vob_getter_interface_attributes_rendering_address_state
${VENDOR RENDERING ZIP}                 vendor_vob_getter_interface_attributes_rendering_address_zip
${VENDOR VOB MONITORING}                vendor[vob_getter_interface_attributes][recurrence_frequency]
${VENDOR VOB PHONE}                     vendor[vob_getter_interface_attributes][phone_option]

${VENDOR LAB RESULTS}                   vendor_results_enabled
${VENDOR LAB ORDERS}                    vendor_orders_enabled
${VENDOR LAB ORDER PROD MODE}           vendor_production_mode
${VENDOR LAB REQ PATIENT DIAG CODE}     vendor_require_patient_diagnosis_code
${VENDOR LAB ONLY ICD CODES}            vendor_require_icd10_diagnosis_coding_system
${VENDOR LAB PROCESS AOE QUESTIONS}     vendor_process_aoe_questions
${VENDOR LAB STANDARD AOE QUESTIONS}    vendor_use_standard_aoe_questions
${VENDOR LAB PROCESS INSURANCE INFO}    vendor_process_insurance_information
${VENDOR LAB SEND INSURANCE ID}         vendor_send_insurance_id
${VENDOR LAB REQ INSURANCE INFO}        vendor_require_insurance_information
${VENDOR LAB REQ INSURANCE CARD}        vendor_require_insurance_card
${VENDOR LAB PROCESS MEDICATION}        vendor_process_medication
${VENDOR LAB SEND MEDICAL NECESSITY}    vendor_require_medical_necessity_note
${VENDOR LAB UPPERCASE HL7}             vendor_hl7_upcase
${VENDOR LAB DEFAULT POC RESULTS ONLY}  vendor_default_poc_results_only
${VENDOR LAB FACILTY ID}                vendor_facility_id
${VENDOR LAB CODE}                      vendor_lab_code
${VENDOR LAB REQUISITION VALIDATION}    vendor_requisition_number_format
${VENDOR LAB REQUISITION LENGTH}        vendor_requisition_number_length
${VENDOR LAB REQUISITION PDF}           vendor_save_requisitions_as_pdf
${VENDOR LAB PATIENT CONSENT}           vendor_patient_consent_for_testing

${VENDOR COLLAB FACILITY NAME}          vendor_collaborate_md_interface_attributes_facility_name
${VENDOR COLLAB FACILITY ID}            vendor_collaborate_md_interface_attributes_facility_id
${VENDOR COLLAB CUSTOMER NAME}          vendor_collaborate_md_interface_attributes_customer_name
${VENDOR COLLAB CUSTOMER ID}            vendor_collaborate_md_interface_attributes_customer_id
${VENDOR COLLAB PROVIDER NUMBER}        vendor_collaborate_md_interface_attributes_provider_number
${VENDOR COLLAB PROVIDER LAST NAME}     vendor_collaborate_md_interface_attributes_provider_last_name
${VENDOR COLLAB PROVIDER FIRST NAME}    vendor_collaborate_md_interface_attributes_provider_first_name
${VENDOR COLLAB USER NAME}              vendor_collaborate_md_interface_attributes_exchanger_attributes_user_name
${VENDOR COLLAB PASSWORD}               vendor_collaborate_md_interface_attributes_exchanger_attributes_password
${VENDOR COLLAB EXTERNAL APP}           vendor_collaborate_md_interface_attributes_ext_app_id_for_alt_pid
${VENDOR COLLAB API VERSION}            vendor[collaborate_md_interface_attributes][api_version]

${VENDOR EXTERNAL APP NAME}             vendor_external_app_name
${VENDOR EXTERNAL APP ALT}              vendor_ext_app_id_for_alt_pid

${VENDOR PHARMACY FAX NUMBER}           vendor_order_fax_number

${VENDOR REPORT}                        report_
${VENDOR SFTP SERVER}                   vendor_sftp_server
${VENDOR SFTP PORT}                     vendor_sftp_port
${VENDOR SFTP USER NAME}                vendor_sftp_username
${VENDOR SFTP PASSWORD}                 vendor_sftp_password
${VENDOR SFTP RESULTS}                  vendor_sftp_result_path
${VENDOR SFTP ORDERS}                   vendor_sftp_order_path
${VENDOR RECURRING ROLE}                vendor_scheduled_report_interface_attributes_recurring_rule
${VENDOR DATE RUN AT}                   date_run_at

${VENDOR PDF ADAPTER}                   vendor_pdf_dropoff_interface_attributes_dropoff_adapter
${VENDOR PDF ENDPOINT}                  vendor_pdf_dropoff_interface_attributes_dropoff_endpoint
${VENDOR PDF PORT}                      vendor_pdf_dropoff_interface_attributes_dropoff_port
${VENDOR PDF PATH}                      vendor_pdf_dropoff_interface_attributes_dropoff_path
${VENDOR PDF USER}                      vendor_pdf_dropoff_interface_attributes_dropoff_user
${VENDOR PDF PASSWORD}                  vendor_pdf_dropoff_interface_attributes_dropoff_passwordvendor_pdf_dropoff_interface_attributes_dropoff_password
${VENDOR PDF PACKAGE TYPE}              vendor[pdf_dropoff_interface_attributes][pdf_packages_attributes][$CID][package_type]
${VENDOR PDF NAME TEMPLATE}             vendor_pdf_dropoff_interface_attributes_pdf_packages_attributes_$CID_file_name_template

${VENDOR PINGMD ID}                     vendor_ping_md_interface_attributes_ping_md_id

${VENDOR PRACTICE FACILITY NAME}        vendor_practice_suite_interface_attributes_facility_name
${VENDOR PRACTICE FACILITY ID}          vendor_practice_suite_interface_attributes_facility_id
# ${VENDOR PRACTICE CUSTOMER NAME}        vendor_practice_suite_interface_attributes_customer_name
# ${VENDOR PRACTICE CUSTOMER ID}          vendor_practice_suite_interface_attributes_customer_id
${VENDOR PRACTICE ACCOUNT}              vendor_practice_suite_interface_attributes_account
${VENDOR PRACTICE PROVIDER NUMBER}      vendor_practice_suite_interface_attributes_provider_number
${VENDOR PRACTICE PROVIDER LAST NAME}   vendor_practice_suite_interface_attributes_provider_last_name
${VENDOR PRACTICE PROVIDER FIRST NAME}  vendor_practice_suite_interface_attributes_provider_first_name
${VENDOR PRACTICE USER NAME}            vendor_practice_suite_interface_attributes_exchanger_attributes_user_name
${VENDOR PRACTICE PASSWORD}             vendor_practice_suite_interface_attributes_exchanger_attributes_password
${VENDOR PRACTICE EXTERNAL APP}         vendor_practice_suite_interface_attributes_ext_app_id_for_alt_pid

${VENDOR CONSENT RESTRICT TRANSFER}     vendor_kipu_facesheet_transfer_interface_attributes_consent_form_id

${VENDOR MEDICS AUTHSTRING}             vendor_medics_premier_interface_attributes_authstring
${VENDOR MEDICS AREA}                   vendor_medics_premier_interface_attributes_area
${VENDOR MEDICS ENTITY}                 vendor_medics_premier_interface_attributes_entity
${VENDOR MEDICS ENDPOINT}               vendor_medics_premier_interface_attributes_endpoint
${VENDOR MEDICS GATEWAY KEY}            vendor_medics_premier_interface_attributes_gateway_key
${VENDOR MEDICS SECRET KEY}             vendor_medics_premier_interface_attributes_secret_key
${VENDOR MEDICS API URL}                vendor_medics_premier_interface_attributes_api_url
${VENDOR MEDICS API URI}                vendor_medics_premier_interface_attributes_api_uri
${VENDOR MEDICS PROFILE}                vendor_medics_premier_interface_attributes_profile


${REPORTS NAME}                         report_name
${REPORTS TEMPLATE}                     report_template
${REPORTS SORT DIRECTION}               report_sort_direction
${REPORTS DATE RANGE}                   report_date_range
${REPORTS START DATE}                   report_custom_start_date
${REPORTS END DATE}                     report_custom_end_date
${REPORTS CRITERIA}                     report_main_filter
${REPORTS PATIENT SELECTION}            report_selection
${REPORTS EDITABLE}                     report[editable_by]
${REPORTS VIEWABLE}                     report[viewable_by]


# ${KIS LABS STAGING EMAIL}               user_email
# ${KIS LABS STAGING PASSWORD}            user_password
# ${KIS LABS STAGING URL}                 app_url
${LAB CLIENT CODE}                      kipu_labs_lab_client_settings_lab_client_code
${LAB CLIENT SEND LAB TEST REQ}         kipu_labs_lab_client_settings[send_lab_test_requisition]
${LAB CLIENT NOTIFY REVIEWED REPORTS}   kipu_labs_lab_client_settings[notify_reviewed_lab_reports]
${LAB CLIENT LABEL PRINTER}             kipu_labs_lab_client_settings[use_label_printer]
${LAB CLIENT WORKING MODE}              kipu_labs_lab_client_settings[working_mode]
${LAB CLIENT IMPORT LAB REPORTS}        kipu_labs_lab_client_settings[import_lab_reports]
${LAB CLIENT PROCESSING PERIOD}         kipu_labs_lab_client_settings_processing_period
${LAB CLIENT SYNC LAB CLIENT INFO}      kipu_labs_lab_client_settings[synchronize_lab_client_info]
${LAB CLIENT NOTIFY ASSIGNED REPORT}    kipu_labs_lab_client_settings[notify_assigned_lab_report]
${LAB CLIENT NOTIFY MEDICAL REVIEW}     kipu_labs_lab_client_settings[notify_medical_test_orders_review]
${LAB CLIENT SYNC LABS PLATFORM INFO}   kipu_labs_lab_client_settings[synchronize_labs_platform_info]
${LAB CLIENT NOTIFY UNASSIGNED REPORT}  kipu_labs_lab_client_settings[notify_unassigned_lab_report]


${BILLING SETTINGS CODES CODING}        coding_system
${BILLING SETTINGS CODES SYSTEM}        code_coding_system
${BILLING SETTINGS CODES CODE}          code_code
${BILLING SETTINGS CODES DESCRIPTION}   code_description
${BILLING SETTINGS CODES START D}       code_effective_date
${BILLING SETTINGS CODES END D}         code_end_date
${BILLING SETTINGS SERVICES NAME}       service_name
${BILLING SETTINGS SERVICES START D}    service_start_date
${BILLING SETTINGS SERVICES END D}      service_end_date
${BILLING SETTINGS SERVICES TYPE}       service_service_type
${BILLING SETTINGS SERVICES HCODE}      token-input-HCode
${BILLING SETTINGS SERVICES CCODE}      token-input-CCode
${BILLING SETTINGS SERVICES RCODE}      token-input-RCode
${BILLING SETTINGS SERVICES CUSTOM}     token-input-Custom

${BILLING REPORTS START DATE}           appt-start-date
${BILLING REPORTS END DATE}             appt-end-date


${REVIEW AUTHORIZATION DATE}            insurance_authorization_authorization_date
${REVIEW AUTHORIZATION DAYS}            insurance_authorization_number_of_days
${REVIEW AUTHORIZATION FREQUENCY}       insurance_authorization_frequency_id
${REVIEW AUTHORIZATION LEVEL OF CARE}   insurance_authorization_care_level
${REVIEW AUTHORIZATION START DATE}      insurance_authorization_start_date
${REVIEW AUTHORIZATION END DATE}        insurance_authorization_end_date
${REVIEW AUTHORIZATION LAST COVERAGE}   insurance_authorization_last_coverage_date
${REVIEW AUTHORIZATION NUMBER}          insurance_authorization_authorization_number
${REVIEW AUTHORIZATION NEXT DATE}       insurance_authorization_next_review_date
${REVIEW AUTHORIZATION COMPANY}         insurance_authorization_insurance_company
${REVIEW AUTHORIZATION HOURS PER DAY}   insurance_authorization_hours_per_day
${REVIEW AUTHORIZATION DAYS PER WEEK}   insurance_authorization_num_days_per_week
${REVIEW AUTHORIZATION SUNDAY}          insurance_authorization_sun
${REVIEW AUTHORIZATION MONDAY}          insurance_authorization_mon
${REVIEW AUTHORIZATION TUESDAY}         insurance_authorization_tue
${REVIEW AUTHORIZATION WEDNESDAY}       insurance_authorization_wed
${REVIEW AUTHORIZATION THURSDAY}        insurance_authorization_thu
${REVIEW AUTHORIZATION FRIDAY}          insurance_authorization_fri
${REVIEW AUTHORIZATION SATURDAY}        insurance_authorization_sat
${REVIEW AUTHORIZATION NEXT CARE}       insurance_authorization_next_care_level
${REVIEW AUTHORIZATION NEXT CARE DATE}  insurance_authorization_next_care_level_date
${REVIEW AUTHORIZATION STATUS}          insurance_authorization_status
${REVIEW AUTHORIZATION MANAGED}         insurance_authorization_managed
${REVIEW AUTHORIZATION COMMENT}         insurance_authorization_comment


${MEDS BROUGHT IN DATE}                 patient_evaluation_evaluation_date
${MEDS BROUGHT IN MEDICATIONS BROUGHT}  patient_evaluation[eval_strings_attributes][0][description]
${MEDS BROUGHT IN MEDICATION}           patient_evaluation_patient_orders_attributes_$CID_patient_order_items_attributes_0_medication
${MEDS BROUGHT IN AMOUNT}               patient_evaluation_patient_orders_attributes_$CID_patient_order_items_attributes_0_quantity
${MEDS BROUGHT IN ROUTE}                patient_evaluation_patient_orders_attributes_$CID_patient_order_items_attributes_0_route
${MEDS BROUGHT IN DOSAGE FORM}          patient_evaluation_patient_orders_attributes_$CID_patient_order_items_attributes_0_dosage_form
${MEDS BROUGHT IN DOSE}                 patient_evaluation_patient_orders_attributes_$CID_patient_order_items_attributes_0_dose
${MEDS BROUGHT IN FREQ}                 patient_evaluation_patient_orders_attributes_$CID_patient_order_items_attributes_0_patient_order_item_frequency
${MEDS BROUGHT IN QUANTITY}             patient_evaluation_patient_orders_attributes_$CID_patient_order_items_attributes_0_administer_amount
${MEDS BROUGHT IN PRN}                  patient_evaluation_patient_orders_attributes_$CID_prn
${MEDS BROUGHT IN LAST DOSE}            patient_evaluation_patient_orders_attributes_$CID_last_dose_before_admission
${MEDS BROUGHT IN JUSTIFICATION}        patient_evaluation_patient_orders_attributes_$CID_justification
${MEDS BROUGHT IN DESTROYED}            patient_evaluation_patient_orders_attributes_$CID_was_destroyed
${MEDS BROUGHT IN NOTE}                 patient_evaluation_patient_orders_attributes_$CID_note


${EPRESCRIBE LOCATION}                  e_prescribe_setting_location_id
${EPRESCRIBE CLINIC ID}                 setting_$CID_clinic_id
${EPRESCRIBE CLINIC KEY}                setting_$CID_clinic_key
${EPRESCRIBE MASTER CLINICIAN ID}       setting_$CID_master_clinician_id
${EPRESCRIBE USER}                      add_e_prescribe_clinician_user_id
${EPRESCRIBE CLINICIAN ID}              add_e_prescribe_clinician_clinician_id
${EPRESCRIBE PROXY USER}                add_e_prescribe_clinician_proxy_user
${EPRESCRIBE PROXY AGENT}               add_e_prescribe_clinician_provider_agent


${MEDS INV MEDICATION}                  medication_
${MEDS INV ROUTE}                       route_
${MEDS INV DOSAGE FORM}                 dosage_form_
${MEDS INV STRENGTH}                    strength_
${MEDS INV LOT NO}                      medication_inventory_lot_no
${MEDS INV SERIAL NO}                   medication_inventory_serial_no
${MEDS INV MULTIPLE}                    multiple_inventory
${MEDS INV TOTAL QUANTITY}              total_quantity
${MEDS INV REPLENISH ALERT QUANTITY}    medication_inventory_replenish_threshold
${MEDS INV LOCATION}                    medication_inventory_location_id
${MEDS INV MANUFACTURER}                medication_inventory_manufacturer
${MEDS INV ORDER REFERENCE NO}          medication_inventory_order_no
${MEDS INV NOTES}                       medication_inventory_notes
${MEDS INV QUANTITY}                    rcv_quantity
${MEDS INV UNITS}                       rcv_units
${MEDS INV RECEIVED DATE TIME}          rcv_performed_at
${MEDS INV RECEIVED BY}                 rcv_performed_by
${MEDS INV EXPIRATION DATE}             transaction_expiration_date
${MEDS INV WITNESS}                     witness_name

*** Keywords ***
I am on the "${page}" page
  Verify for no bad page
  Location Should Contain    ${BASE URL}${${page}}

I am on the "${page}" patient page
  Verify for no bad page
  Run Keyword If    '${page}'=='appointments'      Run Keyword And Return    Location Should Be
  ...                                              ${BASE URL}${Patient ${page}.replace('$ID','${Current Id}')}
  ...    ELSE IF    '${page}'=='med log'           Run Keyword And Return    Location Should Contain
  ...                                              ${Patient ${page}.split('&')[1]}
  ...    ELSE IF    '${page}'=='record med log'    Run Keyword And Return    Location Should Contain
  ...                                              ${Patient ${page}.split('?')[1]}
  ${passes} =    Run Keyword And Return Status    Location Should Be
                 ...                              ${BASE URL}${PATIENTS}/${Current Id}${PATIENT ${page}}
  Run Keyword Unless    ${passes}    Location Should Contain    ${BASE URL}${PATIENTS}/${Current Id}${PATIENT ${page}}

I hit the "${tab}" tab
  Run Keyword If    '${${tab}}'=='${DASHBOARD}' or '${${tab}}'=='${PATIENTS}'    Click Element
  ...                                                                            //*[contains(@href,'${${tab}}')]
  ...    ELSE IF    '${${tab}}'=='${SHIFTS}'                                     I hit the "Shifts" view
  ...               ELSE                                                         Click Element
  ...                                                                            //*[@id='${${tab}}' or @href='${${tab}}' or @data-opener-url='${${tab}}']
  Ajax wait
  Run Keyword Unless    '${${tab}}' in ${Exclude here}    I am on the "${tab}" page

I attempt to hit the "${tab}" tab
  ${passes} =    Run Keyword And Return Status    I hit the "${${tab}}" tab
  Run Keyword Unless    ${passes}    Run Keywords    Go To    ${BASE URL}${${tab}}
  ...                                AND             Run Keyword Unless    '${${tab}}' in ${Exclude here}
  ...                                                I am on the "${tab}" page

I hit the "${tab}" patient tab
  ${link} =    Run Keyword If    '${tab}'!='chart summary' and '${tab}'!='information' and '${tab}'!='appointments'
               ...                       Get Element Attribute
               ...                       //*[contains(@href,'process=${Patient ${tab}.split('process=')[-1]}')]    href
               ...               ELSE    Set Variable    ${EMPTY}
  Run Keyword If    '${tab}'=='appointments'    I hit the "${Patient ${tab}.replace('$ID','${Current Id}')}" view
  ...    ELSE IF    '${tab}'=='med log'         I hit the "${link.split('${BASE URL}')[-1]}" view
  ...    ELSE IF    '${tab}'=='information'     I hit the "Information" text
  ...               ELSE                        Run Keywords    Run Keyword If    '${tab}'=='chart summary'
  ...                                                           Refresh chart summary tab
  ...                                           AND             I hit the "${PATIENTS}/${Current Id}${Patient ${tab}}" view

I hit the "${view}" view
  ${passes} =    Run Keyword And Return Status    Click Link    default=${view}
  Run Keyword Unless    ${passes}    Click Element    //span[contains(text(),'${view}')]
  Ajax wait

I hit the "${text}" text
  Ajax wait
  Click Element    //*[.='${text}' or contains(text(),'${text}')]
  Ajax wait

Custom screenshot
  ${index} =    Increment Running Screenshot
  ${passes}    ${screenshot} =    Run Keyword If    ${RF HUG}    Run Keyword And Ignore Error    Capture Page Screenshot
                                  ...                            screenshots/selenium-screenshot-${UUID}-${index.__str__()}.png
                                  ...               ELSE         Run Keyword And Ignore Error    Capture Page Screenshot
                                  ...                            selenium-screenshot-${index.__str__()}.png
  Run Keyword If    '${passes}'=='PASS' and ${index}%20==0    Log To Console    ${screenshot}

Verify for no bad page
  ${passes 1} =    Run Keyword And Return Status    Page Should Not Contain    Routing Error
  ${passes 2} =    Run Keyword And Return Status    Page Should Not Contain    Toggle session dump
  ${passes 3} =    Run Keyword And Return Status    Page Should Not Contain    Kipu Records:
  ${passes 4} =    Run Keyword And Return Status    Page Should Not Contain
                   ...                              The page you were looking for doesn't exist
  ${passes 5} =    Run Keyword And Return Status    Page Should Not Contain
                   ...                              We're sorry, but something went wrong (500)
  Run Keyword Unless    ${passes 1} and ${passes 2} and ${passes 3} and ${passes 4} and ${passes 5}    Fail    Bad page!
