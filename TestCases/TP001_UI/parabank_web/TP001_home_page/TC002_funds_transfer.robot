*** Settings ***
Documentation    This is parabank fund transfer page test case file

Library          Browser
Resource         ${EXECDIR}/Resources/Locators/login.resource
Resource         ${EXECDIR}/Resources/Locators/home_page.resource
Resource         ${EXECDIR}/Resources/Keywords/loginpage.resource
Resource         ${EXECDIR}/Resources/Locators/account_sevices/open_new_ac.resource
Resource         ${EXECDIR}/Resources/Locators/account_sevices/funds_transfer.resource
Variables        ${EXECDIR}/${CRED}
Suite Setup       Login With Valid Credencial    ${browser}    ${url}
Suite Teardown    Close Browser


*** Variables ***
${CRED}                credential.yaml


*** Test Cases ***
Verify Click On Transfer Funds Page
    [Documentation]    This Test Case Will Open Funds Transfer Page
    [Tags]    sanity
    Click    ${home_page_transfer_funds_button}
    Get Element States    ${fund_transfer_page_amount_input_field}    contains    visible    enabled
    Get Element States    ${fund_transfer_page_transfer_button}    contains    visible    enabled

Verify Amount Field On Transfer Funds Page Using $150 transfering
    [Documentation]    This test case will fill amount for fund transfer
    [Tags]    sanity
    Fill Text    ${fund_transfer_page_amount_input_field}    ${input_fields.ui.fund_transfer.amount1}
    ${amount}    Get Text    ${fund_transfer_page_amount_input_field}
    Should Be Equal As Strings    ${amount}    ${input_fields.ui.fund_transfer.amount1}

Verify Click On Transfer Button
    [Documentation]    This test case will click on transfer button
    [Tags]    sanity
    Click    ${fund_transfer_page_transfer_button}
    Get Element States    ${transefer_complete_successfully_mssg}    contains    visible

Verify Amount Field On Transfer Funds Page Using $25.5 transfering
    [Documentation]    This test case will fill amount for fund transfer
    [Tags]    sanity
    Click    ${home_page_transfer_funds_button}
    Fill Text    ${fund_transfer_page_amount_input_field}    ${input_fields.ui.fund_transfer.amount2}
    Click    ${fund_transfer_page_transfer_button}
    ${amount}    Get Text    ${fund_transfer_page_amount_input_field}
    Should Be Equal As Strings    ${amount}    ${input_fields.ui.fund_transfer.amount2}

Verify Amount Field On Transfer Funds Page Using $8.99 transfering
    [Documentation]    This test case will fill amount for fund transfer
    [Tags]    sanity
    Click    ${home_page_transfer_funds_button}
    Fill Text    ${fund_transfer_page_amount_input_field}    ${input_fields.ui.fund_transfer.amount3}
    Click    ${fund_transfer_page_transfer_button}
    ${amount}    Get Text    ${fund_transfer_page_amount_input_field}
    Should Be Equal As Strings    ${amount}    ${input_fields.ui.fund_transfer.amount3}
