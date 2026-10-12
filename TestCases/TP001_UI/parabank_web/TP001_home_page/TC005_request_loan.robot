*** Settings ***
Documentation    This is parabank loan request page test case file

Library           Browser
Resource          ${EXECDIR}/Resources/Locators/login.resource
Resource          ${EXECDIR}/Resources/Locators/home_page.resource
Resource          ${EXECDIR}/Resources/Keywords/loginpage.resource
Resource          ${EXECDIR}/Resources/Locators/account_sevices/open_new_ac.resource
Resource          ${EXECDIR}/Resources/Locators/account_sevices/apply_loan.resource
Resource          ${EXECDIR}/Resources/Locators/account_sevices/find_transactions.resource  
Variables         ${EXECDIR}/${CRED}
Suite Setup       Login With Valid Credencial    ${browser}    ${url}
Suite Teardown    Close Browser


*** Variables ***
${CRED}                credential.yaml


*** Test Cases ***
Verify Request Loan navigation button link
    [Documentation]    This test case will navigate to request loan page
    [Tags]    sanity
    Click    ${home_page_request_load}
    Get Element States    ${apply_loan_page_amount_input_field}    contains    visible    enabled
    Get Element States    ${apply_loan_page_down_payment_input_field}    contains    visible    enabled
    Get Element States    ${apply_loan_page_apply_loan_button}    contains    visible    enabled

Verify Amount Input Field On Request Loan Page
    [Documentation]    This test case fill amount input field
    [Tags]    sanity
    Fill Text    ${apply_loan_page_amount_input_field}    ${input_fields.ui.apply_loan.amount}
    ${value}    Get Text    ${apply_loan_page_amount_input_field}
    Should Be Equal As Strings    ${value}    ${input_fields.ui.apply_loan.amount}

Verify Down Payment Input Field On Request Loan Page
    [Documentation]    This test case fill down payment input field
    [Tags]    sanity
    Fill Text    ${apply_loan_page_down_payment_input_field}    ${input_fields.ui.apply_loan.down_pay}
    ${value}    Get Text    ${apply_loan_page_down_payment_input_field}
    Should Be Equal As Strings    ${value}    ${input_fields.ui.apply_loan.down_pay}

Verify Apply Now Button On Request Loan Page
    [Documentation]    This test case verify Apply Now Button On Request Loan Page
    [Tags]    sanity
    Click    ${apply_loan_page_apply_loan_button}
    Get Element States    ${apply_loan_successfull_process_mssg}    contains    visible    attached
    Get Element States    ${apply_loand_new_ac_number}    contains    visible    attached
    ${new_loan_ac_number}    Get Text    ${apply_loand_new_ac_number}
