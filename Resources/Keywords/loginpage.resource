*** Settings ***
Library          Browser
Resource         ${EXECDIR}/Resources/Locators/login.resource
Resource         ${EXECDIR}/Resources/Locators/home_page.resource
Variables        ${EXECDIR}/${PARAMS}


*** Variables ***
${PARAMS}              parameters.yaml
${url}                 ${fields.ui.url}
${browser}             ${fields.ui.browser}
${username}            ${fields.ui.username}
${password}            ${fields.ui.password}


*** Keywords ***
Open Website
    [Documentation]    This keyword open the website
    [Arguments]    ${browser}    ${url}
    New Browser    browser=${browser}    headless=True
    New Page    ${url}

Login With Valid Credencial
    [Documentation]    This keyword will login to the web
    [Arguments]    ${browser}    ${url}
    Open Website    ${browser}    ${url}
    Fill Text    ${username_field}    ${username}
    Fill Text    ${password_field}    ${password}
    Click    ${login_button}
