*** Variables ***
${open_new_account_page_title}        //h1[@class="title" and text()='Open New Account']

${open_new_account_page_ac_type}        //b[text()='What type of Account would you like to open?']

${open_new_account_page_ac_type_dropdown}    //select[@id="type"]

${open_new_ac_page_ac_type_dropdown_checking}    //option[text()='CHECKING']

${open_new_ac_page_ac_type_dropdown_savings}    //option[text()='SAVINGS']

${open_new_ac_page_selet_ac_mssg}        //b[text()='A minimum of $100.00 must be deposited into this account at time of opening. Please choose an existing account to transfer funds into the new account.']

${open_new_account_page_select_ac_dropdown}        //select[@id="fromAccountId"]

${open_new_ac_page_submit_button}            //input[@value="Open New Account"]

${new_ac_open_success_msg}    //h1[text()='Account Opened!']

${new_account_number_id}            //a[@id="newAccountId"]
