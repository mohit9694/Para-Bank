*** Settings ***
Documentation    This file contains api testcases of parabank website

Library            RequestsLibrary
Library            JSONLibrary
Library            String
Library            XML
Library            OperatingSystem
Library            Collections
Resource           ${EXECDIR}/Resources/Keywords/para_bank_keyword.resource
Variables          ${EXECDIR}/${PARAMS}
Variables          ${EXECDIR}/${CRED}


*** Variables ***
${PARAMS}                       parameters.yaml
${CRED}                         credential.yaml
${url}                          ${fields.api.url}
${browser}                      ${fields.api.browser}
${username}                     ${fields.ui.username}
${password}                     ${fields.ui.password}
${bill_details}                 ${EXECDIR}/Testdata/API/Post_request.json


*** Test Cases ***
Verify Get Request To Login The Page
    [Documentation]    This test case login the parabank user
    [Tags]    sanity
    ${end_point}    Get Login Details    ${EMPTY}
    ${response}    GET On Session    mysession    /login/${username}/${password}
    Status Should Be    200    msg=ok
    ${xml_doc}      Parse Xml    ${response.text}
    ${customer_id}    Get Element Text    ${xml_doc}    id
    Set Global Variable    ${customer_id}

Verify Get Request To Get Customers Details
    [Documentation]    This test case get all customers details by customer id
    [Tags]    sanity
    ${response}    GET On Session    mysession    /customers/${customer_id}
    Status Should Be    200    msg=ok
    ${xml_doc}      Parse Xml    ${response.text}

Verify Get Request To Get Customers Accounts
    [Documentation]    This test case get accounts of available customers
    [Tags]    sanity
    ${response}    GET On Session    mysession    /customers/${customer_id}/accounts
    Status Should Be    200    msg=ok
    ${xml_doc}      Parse Xml    ${response.text}
    ${account_id}    Get Element Text    ${xml_doc}    account[1]/id
    Set Global Variable    ${account_id}

Verify Post Request To Create A Account
    [Documentation]    This test case create a new accoount using existing account details
    [Tags]    sanity
    ${end_point}    Create Account Parameters    ${customer_id}    1    ${account_id}
    ${response}    POST On Session    mysession    /createAccount    params=${end_point}
    Status Should Be    200    msg=ok
    ${xml_doc}      Set Variable    ${response.text}
    ${ac_type}    Get Element Text    ${xml_doc}    type
    ${new_account_id}    Get Element Text    ${xml_doc}    id
    Should Be Equal As Strings    ${ac_type}    SAVINGS
    Set Global Variable    ${new_account_id}

Verify Get Request To Get New Account By Id 
    [Documentation]    This test case get new account by id
    [Tags]    sanity
    ${response}    GET On Session    mysession    /accounts/${new_account_id}
    Status Should Be    200    msg=ok
    ${xml_doc}      Parse Xml    ${response.text}
    ${customer_id}    Get Element Text    ${xml_doc}    customerId

Verify Post Request To Deposit Funds
    [Documentation]    This test case deposit funds
    [Tags]    sanity
    ${my_params}    Create Dictionary    accountId=${account_id}
    ...    amount=${input_fields.ui.fund_transfer.amount1}
    Set To Dictionary    ${my_params}
    ${response}    POST On Session    mysession    /deposit    params=${my_params}
    Status Should Be    200    msg=ok
    ${xml_doc}      Set Variable    ${response.text}
    Should Contain    ${xml_doc}    Successfully deposited

Verify Post Request To Withdraw Funds
    [Documentation]    This test case withdraw funds
    [Tags]    sanity
    ${my_params}    Create Dictionary    accountId=${account_id}
    ...    amount=${input_fields.ui.fund_transfer.amount2}
    Set To Dictionary    ${my_params}
    ${response}    POST On Session    mysession    /withdraw    params=${my_params}
    Status Should Be    200    msg=ok
    ${xml_doc}      Set Variable    ${response.text}
    Should Contain    ${xml_doc}    Successfully withdrew

Verify Post Request To Transfer Funds
    [Documentation]    This test case transfer funds
    [Tags]    sanity
    ${my_params}    Create Dictionary    fromAccountId=${account_id}
    ...    toAccountId=${account_id}
    ...    amount=${input_fields.ui.fund_transfer.amount1}
    Set To Dictionary    ${my_params}
    ${response}    POST On Session    mysession    /transfer    params=${my_params}
    Status Should Be    200    msg=ok
    ${xml_doc}      Set Variable    ${response.text}
    Should Contain    ${xml_doc}    Successfully transfer

Verify Get Request To Get The List Of Transaction Account
    [Documentation]    This test case get new account by id
    [Tags]    sanity
    ${response}    GET On Session    mysession    /accounts/${account_id}/transactions
    Status Should Be    200    msg=ok
    ${xml_doc}      Parse Xml    ${response.text}
    ${transaction_id}    Get Element Text    ${xml_doc}    transaction[1]/id
    ${transaction_amount}    Get Element Text    ${xml_doc}    transaction[1]/amount
    Set Global Variable    ${transaction_amount}
    Set Global Variable    ${transaction_id}
    ${transaction_description}    Get Element Text    ${xml_doc}    transaction[1]/description
    ${transaction_date}    Get Element Text    ${xml_doc}    transaction[1]/date
    Set Global Variable    ${transaction_date}
    ${transaction_type}    Get Element Text    ${xml_doc}    transaction[1]/type
    Set Global Variable    ${transaction_type}

Verify Get Request To Get Transaction By Id
    [Documentation]    This test case get new account by id
    [Tags]    sanity
    ${response}    GET On Session    mysession    transactions/${transaction_id}
    Status Should Be    200    msg=ok
    ${xml_doc}      Parse Xml    ${response.text}
    ${transaction_id}    Get Element Text    ${xml_doc}    id
    ${transaction_description}    Get Element Text    ${xml_doc}    description

Verify Get Request To Get Transaction By Amount
    [Documentation]    This test case get new account by amount
    [Tags]    sanity
    ${response}    GET On Session    mysession    accounts/${account_id}/transactions/amount/${transaction_amount}
    Status Should Be    200    msg=ok
    ${xml_doc}      Parse Xml    ${response.text}
    ${transaction_id}    Get Element Text    ${xml_doc}    transaction[1]/id
    ${transaction_description}    Get Element Text    ${xml_doc}    transaction[1]/description

Verify Get Request To Get Transaction By Month And Type Of Account
    [Documentation]    This test case get new account by amount
    [Tags]    sanity
    ${response}    GET On Session    mysession    accounts/${account_id}/transactions/month/${transaction_date}/type/${transaction_type}
    Status Should Be    200    msg=ok
    ${xml_doc}      Parse Xml    ${response.text}
    ${transaction_id}    Get Element Text    ${xml_doc}    transaction[1]/id
    ${transaction_description}    Get Element Text    ${xml_doc}    transaction[1]/description

Verify Get Request To Get Transaction By Date Range For Account
    [Documentation]    This test case get transaction By Date Range For Account
    [Tags]    sanity
    ${response}    GET On Session    mysession    accounts/${account_id}/transactions/fromDate/${input_fields.ui.find_transaction.find_by_date_range_start}/toDate/${input_fields.ui.find_transaction.find_by_date_range_end}
    Status Should Be    200    msg=ok
    ${xml_doc}      Parse Xml    ${response.text}
    ${transaction_id}    Get Element Text    ${xml_doc}    transaction[1]/id
    ${transaction_description}    Get Element Text    ${xml_doc}    transaction[1]/description

Verify Get Request To Get Transaction By Specific Date
    [Documentation]    This test case get transaction By specific date
    [Tags]    sanity
    ${response}    GET On Session    mysession    accounts/${account_id}/transactions/onDate/${input_fields.ui.find_transaction.find_by_date_range_start}
    Status Should Be    200    msg=ok
    ${xml_doc}      Parse Xml    ${response.text}
    ${transaction_id}    Get Element Text    ${xml_doc}    transaction[1]/id
    ${transaction_description}    Get Element Text    ${xml_doc}    transaction[1]/description

Verify Post Request To Billpay
    [Documentation]    This test case pay bills
    [Tags]    sanity
    ${bill_detalis}    Load Json From File    ${bill_details}
    ${my_params}    Create Dictionary    accountId=${account_id}
    ...    amount=${input_fields.ui.fund_transfer.amount1}
    Set To Dictionary    ${my_params}
    ${response}    POST On Session    mysession    /billpay    params=${my_params}    json=${bill_detalis}
    Status Should Be    200    msg=ok
    ${xml_doc}      Set Variable    ${response.text}

Verify Get Request To Get Customers By Position
    [Documentation]    This test case get transaction By specific date
    [Tags]    sanity
    ${response}    GET On Session    mysession    customers/${customer_id}/positions
    Status Should Be    200    msg=ok
    ${xml_doc}      Parse Xml    ${response.text}

Verify Post Request To Update Customer Details
    [Documentation]    This test case Update Customer Details
    [Tags]    sanity
    ${my_params}    Update Customers Details Endpoint    ${customer_id}
    Set To Dictionary    ${my_params}
    ${response}    POST On Session    mysession    /customers/update/${customer_id}    params=${my_params}
    Status Should Be    200    msg=ok
    ${xml_doc}      Set Variable    ${response.text}

Verify Post Request To Buy A Share
    [Documentation]    This test case will buy a share
    [Tags]    sanity
    ${my_params}    Stock Buying Process Details    ${customerid}    ${account_id}
    Set To Dictionary    ${my_params}
    ${response}    POST On Session    mysession    /customers/${customerid}/buyPosition    params=${my_params}
    Status Should Be    200    msg=ok
    ${xml_doc}      Set Variable    ${response.text}
    ${position_id}    Get Element Text    ${xml_doc}    position[1]/positionId
    Set Global Variable    ${position_id}

Verify Get Request To Get Customer Position By Position Id
    [Documentation]    This test case get Position By Position Id
    [Tags]    sanity
    ${response}    GET On Session    mysession    positions/${position_id}
    Status Should Be    200    msg=ok
    ${xml_doc}      Parse Xml    ${response.text}

# Verify Get Request To Get Customer Position By date range
#     [Documentation]    This test case Customer Position By date range
#     [Tags]    sanity
#     ${response}    GET On Session    mysession    positions/${position_id}/${input_fields.ui.find_transaction.find_by_date_range_start}/${input_fields.ui.find_transaction.find_by_date_range_end}
#     Status Should Be    200    msg=ok
#     ${xml_doc}      Parse Xml    ${response.text}

Verify Get Request To Get Customer Positions By Costumer Id
    [Documentation]    This test case Customer Positions By Costumer Id
    [Tags]    sanity
    ${response}    GET On Session    mysession    customers/${customerid}/positions
    Status Should Be    200    msg=ok
    ${xml_doc}      Parse Xml    ${response.text}

Verify Post Request To Sell A Share
    [Documentation]    This test case will Sell A Share
    [Tags]    sanity
    ${my_params}    Stock Sell Process Details    ${customerid}    ${account_id}    ${position_id}
    Set To Dictionary    ${my_params}
    ${response}    POST On Session    mysession    customers/${customerid}/sellPosition    params=${my_params}
    Status Should Be    200    msg=ok
    ${xml_doc}      Set Variable    ${response.text}

Verify Post Request To Clean DB
    [Documentation]    This test case will Clean DB
    [Tags]    sanity
    ${response}    POST On Session    mysession    /cleanDB
    Status Should Be    204    msg=ok
    ${xml_doc}      Set Variable    ${response.text}

Verify Post Request To InitializeDB
    [Documentation]    This test case will InitializeDB
    [Tags]    sanity
    ${response}    POST On Session    mysession    /initializeDB
    Status Should Be    204    msg=ok
    ${xml_doc}      Set Variable    ${response.text}

Verify Post Request To Stop JMS Listener
    [Documentation]    This test case will Stop JMS Listener
    [Tags]    sanity
    ${response}    POST On Session    mysession    /shutdownJmsListener
    Status Should Be    204    msg=ok
    ${xml_doc}      Set Variable    ${response.text}

Verify Post Request To Start JMS Listener
    [Documentation]    This test case will start JMS Listener
    [Tags]    sanity
    ${response}    POST On Session    mysession    /startupJmsListener
    Status Should Be    204    msg=ok
    ${xml_doc}      Set Variable    ${response.text}


*** Keywords ***
Session Creation
    [Documentation]    This keyword creating a session
    [Arguments]    ${cookie}
    Create Session    mysession    ${url}    cookies=${cookie}
