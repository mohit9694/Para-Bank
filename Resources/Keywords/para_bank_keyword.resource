*** Settings ***
Library          RequestsLibrary
Library          String
Library          JSONLibrary
Library          Collections
Variables        ${EXECDIR}/${CRED}


*** Variables ***
${CRED}                              parameters.yaml
${url}                               ${fields.api.url}
${browser}                           ${fields.api.browser}
${username}                          ${fields.api.username}
${password}                          ${fields.api.password}



*** Keywords ***
Get Login Details
    [Documentation]    This keyword creating a session
    [Arguments]    ${cookie}   
    Create Session    mysession    ${url}    cookies=${cookie}

Create Account Parameters
    [Documentation]    This keyword create post request session
    [Arguments]    ${customer_id_data}    ${new_account_type}    ${form_account_id}
    ${ranodm_name}    Generate Random String    3    [NUMBERS]
    ${my_params}    Create Dictionary    customerId=${customer_id_data}
    ...    newAccountType=${new_account_type}
    ...    fromAccountId=${form_account_id}
    Set To Dictionary    ${my_params}
    Create Session    mysession    ${url}
    RETURN    ${my_params}

Update Customers Details Endpoint
    [Documentation]    This keyword create a disctionary that contains customer details
    [Arguments]    ${customerid}
    ${my_params}    Create Dictionary    customerId=${customerid}
    ...    firstName=${username}
    ...     lastName=${username}
    ...       street=${input_fields.ui.address}
    ...        city=${input_fields.ui.city}
    ...        state=${input_fields.ui.state}
    ...        zipCode=${input_fields.ui.Zipcode}
    ...       phoneNumber=${input_fields.ui.phonenumber}
    ...     ssn=124543
    ...    username=${username}
    ...    password=${password}
    Set To Dictionary    ${my_params}
    Create Session    mysession    ${url}
    RETURN    ${my_params}

Stock Buying Process Details
    [Documentation]    This keyword create a disctionary that contains customer details
    [Arguments]    ${customerid}    ${account_id}
    ${my_params}    Create Dictionary    customerId=${customerid}
    ...    accountId=${account_id}
    ...     name=banjo
    ...       symbol=${input_fields.ui.share_details.symbol}
    ...        shares=${input_fields.ui.share_details.shares}
    ...        pricePerShare=${input_fields.ui.share_details.pricePerShare}
    Set To Dictionary    ${my_params}
    Create Session    mysession    ${url}
    RETURN    ${my_params}

Stock Sell Process Details
    [Documentation]    This keyword create a disctionary that contains customer details
    [Arguments]    ${customerid}    ${account_id}    ${position_id}
    ${my_params}    Create Dictionary    customerId=${customerid}
    ...    accountId=${account_id}
    ...       positionId=${position_id}
    ...        shares=${input_fields.ui.share_details.shares}
    ...        pricePerShare=${input_fields.ui.share_details.pricePerShare}
    Set To Dictionary    ${my_params}
    Create Session    mysession    ${url}
    RETURN    ${my_params}

Customer Position
    [Documentation]    This keyword create post request session
    [Arguments]    ${position_id}    ${start_date}    ${end_date}
    ${my_params}    Create Dictionary    positionId=${position_id}
    ...    startDate=${start_date}
    ...    endDate=${end_date}
    Set To Dictionary    ${my_params}
    Create Session    mysession    ${url}
    RETURN    ${my_params}
