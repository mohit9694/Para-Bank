*** Settings ***
Documentation    This is parabank open new register account page test case file

Library          Browser
Library          String
Library          ${EXECDIR}/python/update_yaml.py
Resource         ${EXECDIR}/Resources/Locators/login.resource
Resource         ${EXECDIR}/Resources/Locators/home_page.resource
Resource         ${EXECDIR}/Resources/Keywords/loginpage.resource
Resource         ${EXECDIR}/Resources/Locators/register_new_user.resource
Variables        ${EXECDIR}/${CRED}
Suite Setup       Open Website    ${browser}    ${url}
Suite Teardown    Close Browser


*** Variables ***
${CRED}                credential.yaml
${firstname}           ${input_fields.ui.firstname}
${lastname}            ${input_fields.ui.lastname}
${address}             ${input_fields.ui.address}
${city}                ${input_fields.ui.city}
${state}               ${input_fields.ui.state}
${zipcode}             ${input_fields.ui.zipcode}
${phonenumber}         ${input_fields.ui.phonenumber}
${ssn}                 ${input_fields.ui.ssn}
${confirmpassword}     ${input_fields..ui.confirmpassword}


*** Test Cases ***
Verify Click On Register A New User Button
    [Documentation]    This test case will click on register link to open new user details
    [Tags]    sanity
    Random String
    Click    ${new_user_register_link}
    Get Element States    ${title_of_register_new_user_page}    contains    visible    enabled
    Get Element States    ${first_name_input_field_register_new_user}    contains    visible    enabled
    Get Element States    ${last_name_input_field_register_new_user}    contains    visible    enabled
    Get Element States    ${address_input_field_register_new_user}    contains    visible    enabled
    Get Element States    ${city_input_field_address_register_new_user}    contains    visible    enabled
    Get Element States    ${state_input_field_address_register_new_user}    contains    visible    enabled
    Get Element States    ${phone_input_field_number_register_new_user}    contains    visible    enabled
    Get Element States    ${ssn_input_field_register_new_user}    contains    visible    enabled
    Get Element States    ${username_input_field_register_new_user}    contains    visible    enabled
    Get Element States    ${password_input_field_register_new_user}    contains    visible    enabled
    Get Element States    ${password_input_field_confirm_register_new_user}    contains    visible    enabled
    Get Element States    ${register_button_register_new_user}    contains    visible    enabled

Verify First Name Input Field
    [Documentation]    This test case will verify first name input field
    [Tags]    sanity
    Fill Text    ${first_name_input_field_register_new_user}    ${firstname}${random_string}
    ${filled_name}    Get Text    ${first_name_input_field_register_new_user}
    Should Not Be Equal As Strings    ${filled_name}    ${EMPTY}

Verify Last Name Input Field
    [Documentation]    This test case will verify last name input field
    [Tags]    sanity
    Fill Text    ${last_name_input_field_register_new_user}    ${lastname}${random_string}
    ${filled_last_name}    Get Text    ${last_name_input_field_register_new_user}
    Should Not Be Equal As Strings    ${filled_last_name}    ${EMPTY}

Verify Address Input Field
    [Documentation]    This test case will verify address input field
    [Tags]    sanity
    Fill Text    ${address_input_field_register_new_user}    ${input_fields.ui.address}${random_string}
    ${filled_address}    Get Text    ${address_input_field_register_new_user}
    Should Not Be Equal As Strings    ${filled_address}    ${EMPTY}

Verify City Input Field
    [Documentation]    This test case will verify city input field
    [Tags]    sanity
    Fill Text    ${city_input_field_address_register_new_user}    ${input_fields.ui.city}${random_string}
    ${filled_city}    Get Text    ${city_input_field_address_register_new_user}
    Should Not Be Equal As Strings    ${filled_city}    ${EMPTY}

Verify State Input Field
    [Documentation]    This test case will verify state input field
    [Tags]    sanity
    Fill Text    ${state_input_field_address_register_new_user}    ${input_fields.ui.state}${random_string}
    ${filled_state}    Get Text    ${state_input_field_address_register_new_user}
    Should Not Be Equal As Strings    ${filled_state}    ${EMPTY}

Verify Zip Code Input Field
    [Documentation]    This test case will verify zip code input field
    [Tags]    sanity
    Fill Text    ${zip_code_input_field_register_new_user}    ${input_fields.ui.Zipcode}${random_string}
    ${filled_zip}    Get Text    ${zip_code_input_field_register_new_user}
    Should Not Be Equal As Strings    ${filled_zip}    ${EMPTY}

Verify Phone Number Input Field
    [Documentation]    This test case will verify phone number input field
    [Tags]    sanity
    Fill Text    ${phone_input_field_number_register_new_user}    ${input_fields.ui.phonenumber}${random_string}
    ${filled_phone}    Get Text    ${phone_input_field_number_register_new_user}
    Should Not Be Equal As Strings    ${filled_phone}    ${EMPTY}

Verify SSN Input Field
    [Documentation]    This test case will verify ssn input field
    [Tags]    sanity
    Fill Text    ${ssn_input_field_register_new_user}    ${input_fields.ui.ssn}${random_string}
    ${filled_ssn}    Get Text    ${ssn_input_field_register_new_user}
    Should Not Be Equal As Strings    ${filled_ssn}    ${EMPTY}

Verify Username Input Field
    [Documentation]    This test case will verify username input field
    [Tags]    sanity
    Fill Text    ${username_input_field_register_new_user}    ${input_fields.ui.username}${random_string}
    ${filled_username}    Get Text    ${username_input_field_register_new_user}
    Should Not Be Equal As Strings    ${filled_username}    ${EMPTY}
    Set Global Variable    ${filled_username}
    Update Yaml Value    ${EXECDIR}/parameters.yaml    fields.ui.username    ${filled_username}

Verify Password Input Field
    [Documentation]    This test case will verify password input field
    [Tags]    sanity
    Fill Text    ${password_input_field_register_new_user}    ${input_fields.ui.password}${random_string}
    ${filled_password}    Get Text    ${password_input_field_register_new_user}
    Should Not Be Equal As Strings    ${filled_password}    ${EMPTY}
    Set Global Variable    ${filled_password}
    Update Yaml Value    ${EXECDIR}/parameters.yaml    fields.ui.password    ${filled_password}

Verify Confirm Password Input Field
    [Documentation]    This test case will verify confirm input field
    [Tags]    sanity
    Fill Text    ${password_input_field_confirm_register_new_user}    ${input_fields.ui.confirmpassword}${random_string}
    ${filled_confirm}    Get Text    ${password_input_field_confirm_register_new_user}
    Should Not Be Equal As Strings    ${filled_confirm}    ${EMPTY}

Verify Register Button To Submit New User Data
    [Documentation]    This test case will verify submit all details
    [Tags]    sanity
    Click    ${register_button_register_new_user}
    Get Element States    ${successfull_mssg}    contains    visible
    Get Element States    ${new_user_welcome_msg}    contains    visible
    Get Element States    ${home_page_open_new_account_button}    contains    visible    enabled
    Get Element States    ${home_page_account_overview_button}    contains    visible    enabled
    Get Element States    ${home_page_transfer_funds_button}    contains    visible    enabled
    Get Element States    ${home_page_bill_pay_button}    contains    visible    enabled
    Get Element States    ${home_page_find_transactions_button}    contains    visible    enabled
    Get Element States    ${home_page_update_contact_info}    contains    visible    enabled
    Get Element States    ${home_page_request_load}    contains    visible    enabled
    Get Element States    ${home_page_log_out}    contains    visible    enabled

Verify Loguot Button On Home Page
    [Documentation]    This test case will logout the user
    [Tags]    sanity
    Click    ${home_page_log_out}
    Get Element States    ${login_page_title}    contains    visible    enabled
    Get Element States    ${username_field}    contains    visible    enabled
    Get Element States    ${password_field}    contains    visible    enabled

Login User With Valid Credentials
    [Documentation]    This test case will login the web with valid username and password
    [Tags]    sanity
    Fill Text    ${username_field}    ${filled_username}
    Fill Text    ${password_field}    ${filled_password}
    Click    ${login_button}
    Get Element States    ${account_overview_home_page}    contains    visible    enabled


*** Keywords ***
Random String
    [Documentation]    This keyword generate random string
    ${random_string}    Generate Random String    3    [LETTERS]
    Set Global Variable    ${random_string}
