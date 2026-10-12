*** Settings ***
Documentation    This is parabank find transaction page test case file

Library           Browser
Resource          ${EXECDIR}/Resources/Locators/login.resource
Resource          ${EXECDIR}/Resources/Locators/home_page.resource
Resource          ${EXECDIR}/Resources/Keywords/loginpage.resource
Resource          ${EXECDIR}/Resources/Locators/account_sevices/open_new_ac.resource
Resource          ${EXECDIR}/Resources/Locators/account_sevices/find_transactions.resource  
Variables         ${EXECDIR}/${CRED}
Suite Setup       Login With Valid Credencial    ${browser}    ${url}
Suite Teardown    Close Browser


*** Variables ***
${CRED}                credential.yaml


*** Test Cases ***
Verify Find Transactions button navigation Link
    [Documentation]    This test case will navigate on find transaction page
    [Tags]    sanity
    Click    ${home_page_find_transactions_button}
    Get Element States    ${find_transactions_page_find_by_id}    contains    visible    enabled
    Get Element States    ${find_transactions_page_find_by_id_button}    contains    visible    enabled
    Get Element States    ${find_transactions_page_find_by_date_button}    contains    visible    enabled
    Get Element States    ${find_transactions_page_find_by_date}    contains    visible    enabled
    Get Element States    ${find_transactions_page_find_by_start_date}    contains    visible    enabled
    Get Element States    ${find_transactions_page_find_by_end_date}    contains    visible    enabled
    Get Element States    ${find_transactions_page_find_by_date_range_button}    contains    visible    enabled
    Get Element States    ${find_transactions_page_find_by_amount}    contains    visible    enabled
    Get Element States    ${find_transactions_page_find_by_amount_button}    contains    visible    enabled

Verify Find Transactions By Id Input Field
    [Documentation]    This test case find transaction by id
    [Tags]    sanity
    Fill Text    ${find_transactions_page_find_by_id}    ${input_fields.ui.new_ac_id}
    ${value}    Get Text    ${find_transactions_page_find_by_id}
    Should Be Equal As Strings    ${value}    ${input_fields.ui.new_ac_id}

Verify Find TransactionsById Button
    [Documentation]    This test case click transaction by id button
    [Tags]    sanity
    Click    ${find_transactions_page_find_by_id_button}
    Get Element States    ${find_transaction_result_page_title}    contains    visible

Verify Find Transaction By Date input Field
    [Documentation]    This test case find transaction by date
    [Tags]    sanity
    Click    ${home_page_find_transactions_button}
    Fill Text    ${find_transactions_page_find_by_date}    ${input_fields.ui.find_transaction.find_by_date}
    ${value}    Get Text    ${find_transactions_page_find_by_date}
    Should Be Equal As Strings    ${value}    ${input_fields.ui.find_transaction.find_by_date}

Verify Find TransactionByDate Button
    [Documentation]    This test case click transaction by date button
    [Tags]    sanity
    Click    ${find_transactions_page_find_by_date_button}
    Get Element States    ${find_transaction_result_page_title}    contains    visible

Verify Find Transaction By Date Range Start Input Field
    [Documentation]    This test case find transaction by date range
    [Tags]    sanity
    Click    ${home_page_find_transactions_button}
    Fill Text    ${find_transactions_page_find_by_start_date}    ${input_fields.ui.find_transaction.find_by_date_range_start}
    ${value}    Get Text    ${find_transactions_page_find_by_start_date}
    Should Be Equal As Strings    ${value}    ${input_fields.ui.find_transaction.find_by_date_range_start}

Verify Find Transaction By Date Range End Input Field
    [Documentation]    This test case find transaction by date range
    [Tags]    sanity
    Fill Text    ${find_transactions_page_find_by_end_date}    ${input_fields.ui.find_transaction.find_by_date_range_end}
    ${value}    Get Text    ${find_transactions_page_find_by_end_date}
    Should Be Equal As Strings    ${value}    ${input_fields.ui.find_transaction.find_by_date_range_end}

Verify Find TransactionByDate Range Button
    [Documentation]    This test case click transactionbydate range button
    [Tags]    sanity
    Click    ${find_transactions_page_find_by_date_range_button}
    Get Element States    ${find_transaction_result_page_title}    contains    visible

Verify Find Transaction By Amount Input Field
    [Documentation]    This test case find transaction by amount range
    [Tags]    sanity
    Click    ${home_page_find_transactions_button}
    Fill Text    ${find_transactions_page_find_by_amount}    ${input_fields.ui.find_transaction.find_by_amount}
    ${value}    Get Text    ${find_transactions_page_find_by_amount}
    Should Be Equal As Strings    ${value}    ${input_fields.ui.find_transaction.find_by_amount}

Verify Find Transaction By Amount Button
    [Documentation]    This test case click transactionbydate range button button
    [Tags]    sanity
    Click    ${find_transactions_page_find_by_amount_button}
    Get Element States    ${find_transaction_result_page_title}    contains    visible
