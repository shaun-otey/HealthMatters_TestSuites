*** Settings ***
Documentation   Null variables for empty posts.
...

*** Variables ***
${_LOCATIONS ACTIVE}                    ${false}
${_LOCATION 1}                          null
${_LOCATION 2}                          null
${_LOCATION 3}                          null
${_LOCATION 4}                          null
${_LOCATION 5}                          null
${_LOCATION ALT 1}                      null
${_LOCATION ALT 2}                      null
${_LOCATION ALT 3}                      null
${_LOCATION ALT 4}                      null
${_LOCATION ALT 5}                      null
${_LOCATION ID 1}                       null

${_BUILDING 1}                          null
${_BUILDING 2}                          null
${_BUILDING 3}                          null
${_BUILDING 4}                          null
${_BUILDING 5}                          null

${_PATIENT 1}                           Arnold
${_PATIENT 2}                           Ana G.
${_PATIENT 2 NAME SEG 1}                Ana
${_PATIENT 2 NAME SEG 2}                Maria
${_PATIENT 3}                           Ann "Annie" R.
${_PATIENT 3 NAME SEG 1}                Ann
${_PATIENT 3 NAME SEG 2}                Annie
${_PATIENT 3 NAME SEG 3}                Marie
${_PATIENT 3 NAME SEG 4}                Rucku
${_PATIENT 4}                           Adina A.
${_PATIENT 4 NAME SEG 1}                null
${_PATIENT 4 NAME SEG 2}                null
${_PATIENT 4 NAME SEG 3}                null
${_PATIENT 5}                           Albert "Al" K.
${_PATIENT 5 NAME SEG 1}                Albert
${_PATIENT 5 NAME SEG 2}                Robert
${_PATIENT 5 NAME SEG 3}                Klein
${_PATIENT 6}                           Adelyn "Addie" T.
${_PATIENT 6 NAME SEG 1}                Adelyn
${_PATIENT 6 NAME SEG 2}                Jessica
${_PATIENT 6 NAME SEG 3}                Torrer
${_PATIENT 6 NAME SEG 4}                Ade
${_PATIENT 7}                           Bernard "Bernie" J.
${_PATIENT 7 NAME SEG 1}                Bernard
${_PATIENT 7 NAME SEG 2}                Jackson
${_PATIENT 8}                           Courtney Marie Arnold
${_PATIENT 8 NAME SEG 1}                Courtney
${_PATIENT 8 NAME SEG 2}                Marie
${_PATIENT 8 NAME SEG 3}                Arnold
${_PATIENT 9}                           Albert E Smith
${_PATIENT 9 NAME SEG 1}                Albert
${_PATIENT 9 NAME SEG 2}                Smith
${_PATIENT 10}                          Marvin B Smith
${_PATIENT 11}                          Arnold Michael Murtz
${_PATIENT 11 NAME SEG 1}               Mur
${_PATIENT 12}                          Alfred Jones

${_ITEM 1}                              DAP Individual Progress Note 10/25/2016
${_ITEM 1 SEG 1}                        DAP
${_ITEM 1 SEG 2}                        Individual
${_ITEM 1 SEG 3}                        Progress
${_ITEM 1 SEG 4}                        Note
${_ITEM 1 SEG 5}                        10/25/2016
${_ITEM 2}                              Wiley HW: Anger As A Drug
${_ITEM 2 SEG 1}                        ANGER AS A DRUG
${_ITEM 3}                              Lab Order: Admit Panel (Female) - (Fast Bloodwork Lab) - (Blood)
${_ITEM 3 SEG 1}                        Lab Order: Admit Panel (Female)
${_ITEM 3 SEG 2}                        (Fast Bloodwork Lab)
${_ITEM 3 SEG 3}                        (Blood)
${_ITEM 4}                              Alcohol/Benzo Detox - Ativan 5 day taper
${_ITEM 5}                              Ativan 2mg PO, every 6 hours PRN, for 3 days
${_ITEM 6}                              Folic Acid 1mg PO, once daily, for 7 days

${_THERAPIST 1}                         JC Carrillo

${_CASE MANAGER 1}                      Allen Penn, C.A.C.

${_GROUP LEADERS 1}                     Shara Ottoman
${_GROUP LEADERS 2}                     John Sandbox, sandbox
${_GROUP LEADERS 3}                     Test Shane

${_PROVIDER 1}                          Art Teacher
${_PROVIDER 1 NAME SEG 1}               art
${_PROVIDER 2}                          Clifford Levy
${_PROVIDER 2 NAME SEG 1}               cli
${_PROVIDER 3}                          Diego Salza
${_PROVIDER 3 NAME SEG 1}               die
${_PROVIDER 4}                          Jason Saint Elli
${_PROVIDER 4 NAME SEG 1}               jas

${_DOCTOR 1}                            John Merrick, MD
