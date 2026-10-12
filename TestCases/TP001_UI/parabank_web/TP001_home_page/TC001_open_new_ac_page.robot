*** Settings ***
Documentation    This is parabank open new account page test case file

Library          Browser
Library          ${EXECDIR}/python/update_yaml.py
Resource         ${EXECDIR}/Resources/Locators/login.resource
Resource         ${EXECDIR}/Resources/Locators/home_page.resource
Resource         ${EXECDIR}/Resources/Keywords/loginpage.resource
Resource         ${EXECDIR}/Resources/Locators/account_sevices/open_new_ac.resource
Suite Setup       Login With Valid Credencial    ${browser}    ${url}
Suite Teardown    Close Browser


*** Test Cases ***
Verify To Click On Open New Account button
    [Documentation]    This test case will open new account page
    [Tags]    sanity
    Click    ${home_page_open_new_account_button}
    Get Element States    ${open_new_account_page_title}    contains    visible    enabled
    Get Element States    ${open_new_account_page_ac_type}    contains    visible    enabled
    Get Element States    ${open_new_ac_page_selet_ac_mssg}    contains    visible    enabled
    Get Element States    ${open_new_account_page_select_ac_dropdown}    contains    visible    enabled
    Get Element States    ${open_new_ac_page_submit_button}    contains    visible    enabled
    
Verify To Click Account Type Dropdown
    [Documentation]    This test case will open account type dropdown
    [Tags]    sanity
    Click    ${open_new_account_page_ac_type_dropdown}
    Get Element States    ${open_new_ac_page_ac_type_dropdown_checking}    contains    visible    enabled
    Get Element States    ${open_new_ac_page_ac_type_dropdown_savings}    contains    visible    enabled

Verify To Click Select Checking From Account Type Dropdown
    [Documentation]    This test case select CHECKING from ac dropdown
    [Tags]    sanity
    Click    ${open_new_ac_page_ac_type_dropdown_checking}
    ${checking}    Get Text    ${open_new_account_page_ac_type_dropdown}
    Should Be Equal As Strings    ${checking}    CHECKING

Verify To Click Select Savings From Account Type Dropdown
    [Documentation]    This test case select SAVINGS from ac dropdown
    [Tags]    sanity
    Click    ${open_new_account_page_ac_type_dropdown}
    Click    ${open_new_ac_page_ac_type_dropdown_savings}
    ${savings}    Get Text    ${open_new_account_page_ac_type_dropdown}
    Should Be Equal As Strings    ${savings}    SAVINGS

Verify To Click Existing Account dropdown
    [Documentation]    This test case will click on available account dropdown
    [Tags]    sanity
    Click    ${open_new_account_page_select_ac_dropdown}
    ${ac_id}    Get Text    ${open_new_account_page_select_ac_dropdown}

Verify To Click Open New Account Button
    [Documentation]    This test case create new account
    [Tags]    sanity
    Click    ${open_new_ac_page_submit_button}
    Get Element States    ${new_ac_open_success_msg}    contains    visible    enabled
    Get Element States    ${new_account_number_id}    contains    visible    enabled
    ${new_ac_id}    Get Text    ${new_account_number_id}
    Set Global Variable    ${new_ac_id}
    Update Yaml Value    ${EXECDIR}/credential.yaml    input_fields.ui.new_ac_id    ${new_ac_id}

Verify Click On The Account Overview
    [Documentation]    This test case open account overview
    [Tags]    sanity
    Click    ${home_page_account_overview_button}
    ${new_value}    Evaluate    $home_page_created_ac_number.replace('value',str($new_ac_id))
    Get Element States    ${new_value}    contains    visible    enabled 
