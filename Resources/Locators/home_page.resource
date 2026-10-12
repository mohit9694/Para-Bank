*** Variables ***
${new_user_welcome_msg}                       //h1[@class='title' and contains(text(),'Welcome')]

${successfull_mssg}        //p[text()='Your account was created successfully. You are now logged in.']

${account_overview_home_page}    //h1[@class="title" and normalize-space(text())='Accounts Overview']

${home_page_open_new_account_button}        //a[@href="openaccount.htm" and text()='Open New Account']

${home_page_account_overview_button}        //a[@href="overview.htm"  and text()='Accounts Overview']

${home_page_transfer_funds_button}        //a[@href="transfer.htm"  and text()='Transfer Funds']

${home_page_bill_pay_button}            //a[@href="billpay.htm"  and text()='Bill Pay']

${home_page_find_transactions_button}        //a[@href="findtrans.htm"  and text()='Find Transactions']

${home_page_update_contact_info}        //a[@href="updateprofile.htm"  and text()='Update Contact Info']

${home_page_request_load}        //a[@href="requestloan.htm"  and text()='Request Loan']

${home_page_log_out}    //a[@href="logout.htm"  and text()='Log Out']

${home_page_created_ac_number}    //a[normalize-space(text())='value']
