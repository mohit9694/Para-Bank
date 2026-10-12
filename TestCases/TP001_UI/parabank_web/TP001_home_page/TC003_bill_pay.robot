*** Settings ***
Documentation    This is parabank bill payment page test case file

Library           Browser
Resource          ${EXECDIR}/Resources/Locators/login.resource
Resource          ${EXECDIR}/Resources/Locators/home_page.resource
Resource          ${EXECDIR}/Resources/Keywords/loginpage.resource
Resource          ${EXECDIR}/Resources/Locators/account_sevices/open_new_ac.resource
Resource          ${EXECDIR}/Resources/Locators/account_sevices/funds_transfer.resource
Resource          ${EXECDIR}/Resources/Locators/account_sevices/bill_pay.resource
Variables         ${EXECDIR}/${CRED}
Suite Setup       Login With Valid Credencial    ${browser}    ${url}
Suite Teardown    Close Browser


*** Variables ***
${CRED}                credential.yaml


*** Test Cases ***
Verify That The Bill Pay Button Is Clickable In The Account Services Section
    [Documentation]    This test case navigate to the bill payment service page
    Click    ${home_page_bill_pay_button}
    Get Element States    ${bill_pay_payee_name_field}    contains    visible    enabled
    Get Element States    ${bill_pay_page_address_field}    contains    visible    enabled
    Get Element States    ${bill_pay_page_city_field}    contains    visible    enabled
    Get Element States    ${bill_pay_page_state_field}    contains    visible    enabled
    Get Element States    ${bill_pay_page_zip_code_field}    contains    visible    enabled
    Get Element States    ${bill_pay_page_phone_field}    contains    visible    enabled
    Get Element States    ${bill_pay_page_account_number_field}    contains    visible    enabled
    Get Element States    ${bill_pay_page_verify_account_number_field}    contains    visible    enabled
    Get Element States    ${bill_pay_page_amount_field}    contains    visible    enabled
    Get Element States    ${bill_pay_page_send_payment_button}    contains    visible    enabled

Verify Payee Name Field On Bill Payment Service Page
    [Documentation]    This test case will fill payee name field
    [Tags]    sanity
    Fill Text    ${bill_pay_payee_name_field}    ${input_fields.ui.bill_pay.payee_name}
    ${value}    Get Text    ${bill_pay_payee_name_field}
    Should Be Equal As Strings    ${value}    ${input_fields.ui.bill_pay.payee_name}

Verify Address Field On Bill Payment Service Page
    [Documentation]    This test case will fill address field
    [Tags]    sanity
    Fill Text    ${bill_pay_page_address_field}    ${input_fields.ui.bill_pay.address}
    ${value}    Get Text    ${bill_pay_page_address_field}
    Should Be Equal As Strings    ${value}    ${input_fields.ui.bill_pay.address}

Verify City Field On Bill Payment Service Page
    [Documentation]    This test case will fill CITY field
    [Tags]    sanity
    Fill Text    ${bill_pay_page_city_field}    ${input_fields.ui.bill_pay.city}
    ${value}    Get Text    ${bill_pay_page_city_field}
    Should Be Equal As Strings    ${value}    ${input_fields.ui.bill_pay.city}

Verify State Field On Bill Payment Service Page
    [Documentation]    This test case will fill state field
    [Tags]    sanity
    Fill Text    ${bill_pay_page_state_field}    ${input_fields.ui.bill_pay.state}
    ${value}    Get Text    ${bill_pay_page_state_field}
    Should Be Equal As Strings    ${value}    ${input_fields.ui.bill_pay.state}

Verify Zip Code Field On Bill Payment Service Page
    [Documentation]    This test case will fill zip code field
    [Tags]    sanity
    Fill Text    ${bill_pay_page_zip_code_field}    ${input_fields.ui.bill_pay.zip_code}
    ${value}    Get Text    ${bill_pay_page_zip_code_field}
    Should Be Equal As Strings    ${value}    ${input_fields.ui.bill_pay.zip_code}

Verify Phone Field On Bill Payment Service Page
    [Documentation]    This test case will fill phone field
    [Tags]    sanity
    Fill Text    ${bill_pay_page_phone_field}    ${input_fields.ui.bill_pay.phone}
    ${value}    Get Text    ${bill_pay_page_phone_field}
    Should Be Equal As Strings    ${value}    ${input_fields.ui.bill_pay.phone}

Verify Account Number Field On Bill Payment Service Page
    [Documentation]    This test case will fill ac number field
    [Tags]    sanity
    Fill Text    ${bill_pay_page_account_number_field}    ${input_fields.ui.bill_pay.account}
    ${value}    Get Text    ${bill_pay_page_account_number_field}
    Should Be Equal As Strings    ${value}    ${input_fields.ui.bill_pay.account}

Verify Verify Account Field On Bill Payment Service Page
    [Documentation]    This test case will fill verify ac number field
    [Tags]    sanity
    Fill Text    ${bill_pay_page_verify_account_number_field}    ${input_fields.ui.bill_pay.verify_account}
    ${value}    Get Text    ${bill_pay_page_verify_account_number_field}
    Should Be Equal As Strings    ${value}    ${input_fields.ui.bill_pay.verify_account}

Verify Amount Field On Bill Payment Service Page
    [Documentation]    This test case will fill amount field
    [Tags]    sanity
    Fill Text    ${bill_pay_page_amount_field}    ${input_fields.ui.bill_pay.amount}
    ${value}    Get Text    ${bill_pay_page_amount_field}
    Should Be Equal As Strings    ${value}    ${input_fields.ui.bill_pay.amount}

Verify Send Payment Button On Bill Payment Service Page
    [Documentation]    This test case will click on send button
    [Tags]    sanity
    Click    ${bill_pay_page_send_payment_button}
    Get Element States    ${bill_pay_page_payment_successfull_msg}    contains    visible    attached
