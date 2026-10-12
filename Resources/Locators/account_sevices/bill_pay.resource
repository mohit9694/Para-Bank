*** Variables ***
${bill_pay_payee_name_field}        //input[@name="payee.name"]

${bill_pay_page_address_field}    //input[@name="payee.address.street"]

${bill_pay_page_city_field}    //input[@name="payee.address.city"]

${bill_pay_page_state_field}    //input[@name="payee.address.state"]

${bill_pay_page_zip_code_field}    //input[@name="payee.address.zipCode"]

${bill_pay_page_phone_field}        //input[@name="payee.phoneNumber"]

${bill_pay_page_account_number_field}        //input[@name="payee.accountNumber"]

${bill_pay_page_verify_account_number_field}    //input[@name="verifyAccount"]

${bill_pay_page_amount_field}    //input[@name="amount"]

${bill_pay_page_send_payment_button}    //input[@value="Send Payment"]

${bill_pay_page_payment_successfull_msg}    //h1[normalize-space(text())='Bill Payment Complete']