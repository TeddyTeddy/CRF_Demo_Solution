*** Settings ***
Documentation		This page object contains low level keywords in 4 different categories:
...						- Page URL verification
...						- Verifying Element Texts
...						- Actions that can be taken on the page (i.e. fill in a field, click an element etc)
...                     - Checking error messages on the form if any is expected to be found
...                 The keywords here are used in Verifiers/RegistrationPageVerifier.resource
Resource			../Texts/RegistrationPageTexts.resource

*** Variable ***
${EXPECTED_REGISTRATION_PAGE_URL}       ${BASE_URL}register

*** Keywords ***
Verify Url
	Get Url		==		${EXPECTED_REGISTRATION_PAGE_URL}

Verify Form Main Title Text
	Get Text	${REGISTRATION_PAGE_LOCATOR}[form_title]    ==	    ${REGISTRATION_PAGE_TEXT}[form_title]

Verify Username Text
	Get Text	${REGISTRATION_PAGE_LOCATOR}[username_label]  ==	${REGISTRATION_PAGE_TEXT}[username_label]

Verify Password Text
	Get Text	${REGISTRATION_PAGE_LOCATOR}[password_label]	==	${REGISTRATION_PAGE_TEXT}[password_label]

Verify First Name Text
	Get Text	${REGISTRATION_PAGE_LOCATOR}[firstname_label]	==	${REGISTRATION_PAGE_TEXT}[firstname_label]

Verify Last Name Text
	Get Text	${REGISTRATION_PAGE_LOCATOR}[lastname_label]	==	${REGISTRATION_PAGE_TEXT}[lastname_label]

Verify Phone Number Text
	Get Text	${REGISTRATION_PAGE_LOCATOR}[phone_number_label]     ==	${REGISTRATION_PAGE_TEXT}[phone_number_label]

Verify Register Button Text
	Get Attribute		${REGISTRATION_PAGE_LOCATOR}[register_button]	value
	...					== 	${REGISTRATION_PAGE_TEXT}[register_button_text]

Fill In Username
    [Arguments]     ${username}
	Type Text	${REGISTRATION_PAGE_LOCATOR}[username_field]		txt=${username}

Fill In Password
    [Arguments]     ${password}
	Type Text	${REGISTRATION_PAGE_LOCATOR}[password_field]		txt=${password}

Fill In First Name
    [Arguments]     ${firstname}
	Type Text	${REGISTRATION_PAGE_LOCATOR}[firstname_field]		txt=${firstname}

Fill In Last Name
    [Arguments]     ${lastname}
	Type Text	${REGISTRATION_PAGE_LOCATOR}[lastname_field]		txt=${lastname}

Fill In Phone Number
    [Arguments]     ${phone_number}
	Type Text	${REGISTRATION_PAGE_LOCATOR}[phone_number_field]		txt=${phone_number}

Press Register Button
    Click       ${REGISTRATION_PAGE_LOCATOR}[register_button]

Check Username Field Error
        [Arguments]     ${username_field}
        ${is_username_field_error_message_shown} =         Set Variable    ${False}
        # entered username is not valid, we expect an error message given in username_field data
        IF  not $username_field['value']
            # https://medium.com/@nalinikanth/selenium-and-html5-required-7da8e8b22121
            # if the username field is left blank and pressed Register Button
            # then we expect an attribute named "required" in username_field.
            Get Attribute Names   ${REGISTRATION_PAGE_LOCATOR}[username_field]   contains  required
            # If execution comes to here passing the above assertion "contains" , then
            # We expect that the tooltip box is shown by the browser (e.g. "Please fill out this field." in Chromium)
            ${is_username_field_error_message_shown} =         Set Variable    ${True}
        ELSE
            # there is a non-empty & invalid username in the username field
            # we expect its error message given
            ${count} = 		Get Element Count   text=${username_field}[expected_error]
		    Should Be Equal As Integers		${count}		${1}	Missing username field error message: ${username_field}[expected_error]	    values=False
            # if the execution comes here, that means the correct error message is shown
            ${is_username_field_error_message_shown} =         Set Variable    ${True}
        END
        [Return]    ${is_username_field_error_message_shown}

Check Password Field Error
        [Arguments]     ${password_field}
        ${is_password_field_error_message_shown} =         Set Variable    ${False}
        # entered username is not valid, we expect an error message given in password_field data
        IF  not $password_field['value']
            # https://medium.com/@nalinikanth/selenium-and-html5-required-7da8e8b22121
            # if the password field is left blank and pressed Register Button
            # then we expect an attribute named "required" in password_field.
            Get Attribute Names   ${REGISTRATION_PAGE_LOCATOR}[password_field]   contains  required
            # If execution comes to here passing the above assertion "contains" , then
            # We expect that the tooltip box is shown by the browser (e.g. "Please fill out this field." in Chromium)
            ${is_password_field_error_message_shown} =         Set Variable    ${True}
        ELSE
            # there is a non-empty & invalid password in the password field
            # we expect its error message given
            ${count} = 		Get Element Count   text=${password_field}[expected_error]
		    Should Be Equal As Integers		${count}		${1}	Missing password field error message: ${password_field}[expected_error]	    values=False
            # if the execution comes here, that means the correct error message is shown
            ${is_password_field_error_message_shown} =         Set Variable    ${True}
        END
        [Return]    ${is_password_field_error_message_shown}


Check First Name Field Error
        [Arguments]     ${first_name_field}
        ${is_first_name_field_error_message_shown} =         Set Variable    ${False}
        # entered username is not valid, we expect an error message given in first_name_field data
        IF  not $first_name_field['value']
            # https://medium.com/@nalinikanth/selenium-and-html5-required-7da8e8b22121
            # if the first name field is left blank and pressed Register Button
            # then we expect an attribute named "required" in firstname_field.
            Get Attribute Names   ${REGISTRATION_PAGE_LOCATOR}[firstname_field]   contains  required
            # If execution comes to here passing the above assertion "contains" , then
            # We expect that the tooltip box is shown by the browser (e.g. "Please fill out this field." in Chromium)
            ${is_first_name_field_error_message_shown} =         Set Variable    ${True}
        ELSE
            # there is a non-empty & invalid first name in the first name field
            # we expect its error message given
            ${count} = 		Get Element Count   text=${first_name_field}[expected_error]
		    Should Be Equal As Integers		${count}		${1}	Missing password field error message: ${first_name_field}[expected_error]	    values=False
            # if the execution comes here, that means the correct error message is shown
            ${is_first_name_field_error_message_shown} =         Set Variable    ${True}
        END
        [Return]    ${is_first_name_field_error_message_shown}


Check Last Name Field Error
        [Arguments]     ${last_name_field}
        ${is_last_name_field_error_message_shown} =         Set Variable    ${False}
        # entered username is not valid, we expect an error message given in last_name_field data
        IF  not $last_name_field['value']
            # https://medium.com/@nalinikanth/selenium-and-html5-required-7da8e8b22121
            # if the last name field is left blank and pressed Register Button
            # then we expect an attribute named "required" in lastname_field.
            Get Attribute Names   ${REGISTRATION_PAGE_LOCATOR}[lastname_field]   contains  required
            # If execution comes to here passing the above assertion "contains" , then
            # We expect that the tooltip box is shown by the browser (e.g. "Please fill out this field." in Chromium)
            ${is_last_name_field_error_message_shown} =         Set Variable    ${True}
        ELSE
            # there is a non-empty & invalid last name in the last name field
            # we expect its error message given
            ${count} = 		Get Element Count   text=${last_name_field}[expected_error]
		    Should Be Equal As Integers		${count}		${1}	Missing password field error message: ${last_name_field}[expected_error]	    values=False
            # if the execution comes here, that means the correct error message is shown
            ${is_last_name_field_error_message_shown} =         Set Variable    ${True}
        END
        [Return]    ${is_last_name_field_error_message_shown}


Check Phone Number Field Error
        [Arguments]     ${phone_number_field}
        # entered phone number is not valid, we expect an error message given in phone_number_field data
        IF  not $phone_number_field['value']
            # https://medium.com/@nalinikanth/selenium-and-html5-required-7da8e8b22121
            # if the phone number field is left blank and pressed Register Button
            # then we expect an attribute named "required" in phone_number_field.
            Get Attribute Names   ${REGISTRATION_PAGE_LOCATOR}[phone_number_field]   contains  required
        ELSE
            # there is a non-empty & invalid phone number in the phone number field
            # we expect its error message given
            ${count} = 		Get Element Count   text=${phone_number_field}[expected_error]
		    Should Be Equal As Integers		${count}		${1}	Missing password field error message: ${phone_number_field}[expected_error]	    values=False
        END


Check Registration Form Error Messages
    [Documentation]     Before this keyword is called, the form is filled with registration_form_data
    ...                 and Register button is clicked. registration_form_data is a dictionary containing 5 (UI) elements:
    ...                     - username
    ...                     - password
    ...                     - first_name
    ...                     - last_name
    ...                     - phone_number
    ...                 Refer to TestData/RegisterFormDataSet.json for a list of registration_form_data examples.
    ...                 We check in the above given priority order the following:
    ...                     - If the element (e.g. username) is invalid, then we expect to see its custom error message
    ...                         - If the custom error message is shown, then we move on to the next element.
    ...                         - Otherwise, we fail with telling which custom error message is missing.

    [Arguments]         ${registration_form_data}
    IF  $registration_form_data['username']['isValid']==False
        ${is_username_field_error_message_shown} =         Check Username Field Error      ${registration_form_data}[username]
    END

    # Note that form only shows one error at a time from top to bottom, so must not check for other fields' errors at the bottom
    Return From Keyword If      ${is_username_field_error_message_shown}

    IF  $registration_form_data['password']['isValid']==False
        ${is_password_field_error_message_shown} =         Check Password Field Error      ${registration_form_data}[password]
    END

    # Note that form only shows one error at a time from top to bottom, so must not check for other fields' errors at the bottom
    Return From Keyword If      ${is_password_field_error_message_shown}

    IF  $registration_form_data['first_name']['isValid']==False
        ${is_firstname_field_error_message_shown} =         Check First Name Field Error      ${registration_form_data}[first_name]
    END

    # Note that form only shows one error at a time from top to bottom, so must not check for other fields' errors at the bottom
    Return From Keyword If      ${is_firstname_field_error_message_shown}

    IF  $registration_form_data['last_name']['isValid']==False
        ${is_lastname_field_error_message_shown} =         Check Last Name Field Error      ${registration_form_data}[last_name]
    END

    # Note that form only shows one error at a time from top to bottom, so must not check for other fields' errors at the bottom
    Return From Keyword If      ${is_lastname_field_error_message_shown}

    IF  $registration_form_data['phone_number']['isValid']==False
        Check Phone Number Field Error      ${registration_form_data}[phone_number]
    END
