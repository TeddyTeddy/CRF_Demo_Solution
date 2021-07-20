*** Settings ***
Documentation		Contains higher level keywords having business logic for the system under test
Resource			./PO/TopNav.resource
Resource			./PO/RegistrationPage.resource
Resource			./PO/LoginPage.resource
Resource	        ./PO/MainPage.resource
Resource			./PO/LoginFailurePage.resource
Resource			./PO/IndexPage.resource
Resource			./Verifiers/TopNavVerifier.resource
Resource			./Verifiers/RegistrationPageVerifier.resource
Resource			./Verifiers/LoginPageVerifier.resource
Resource			./Verifiers/MainPageVerifier.resource
Resource            ./Verifiers/LoginFailurePageVerifier.resource
Resource            ./Verifiers/IndexPageVerifier.resource
Library				Collections


*** Variable ***
${BROWSER}						chromium


*** Keywords ***
Fill Registration Form And Press Register
    [Arguments]     ${registration_form_data}
    RegistrationPage.Fill In Username        ${registration_form_data}[username][value]
    RegistrationPage.Fill In Password        ${registration_form_data}[password][value]
    RegistrationPage.Fill In First Name      ${registration_form_data}[first_name][value]
    RegistrationPage.Fill In Last Name       ${registration_form_data}[last_name][value]
    RegistrationPage.Fill In Phone Number    ${registration_form_data}[phone_number][value]
    RegistrationPage.Press Register Button

Register
    [Documentation]     For a list of registration_form_data examples, have a look at TestData/RegistrationFormDataSet.json
    ...                 Note that registration_form_data is a dictionary.
    ...                 This keyword fills in the form with the given data in the registration_form_data dictionary.
    ...                 The presses "Register" button in the registration page.
    ...                 The system under test is supposed to check if the data entered into the form is valid:
    ...                     - If not valid, registration page is still shown
    ...                     - If the form data is valid, then login page is to be shown
    ...                 If the form data is not valid, then the registration page is supposed to show only the first
    ...                 error for the field from top to bottom. Refer to "Check Registration Form Error Messages" for more information
    [Arguments]     ${registration_form_data}
    Go To Registration Page
    Verify Registration Page
    Fill Registration Form And Press Register       ${registration_form_data}
    ${expected_page} =      Calculate Next Page    ${registration_form_data}
    IF          $expected_page=='RegistrationPage'
        Verify Registration Page
        Check Registration Form Error Messages    ${registration_form_data}
    ELSE IF     $expected_page=='LoginPage'
        Verify Login Page
    ELSE
        Fail    Could not calculate next page from registration form data
    END

Check Registration Form Data Validity
    [Arguments]     ${registration_form_data}
    ${is_registration_form_data_valid} =    Evaluate    $registration_form_data['username']['isValid'] and $registration_form_data['password']['isValid'] and $registration_form_data['first_name']['isValid'] and $registration_form_data['last_name']['isValid'] and $registration_form_data['phone_number']['isValid']
    [Return]    ${is_registration_form_data_valid}

Calculate Next Page
    [Documentation]     In order registration_form_data to be valid, all the fields' in registration_form_data must be valid.
    ...                 If registration_form_data is valid we expect the system under test to redirect to login page.
    ...                 If registration_form_data is invalid, we expect the system under test to stay in registration page.
    [Arguments]     ${registration_form_data}
    ${is_registration_form_data_valid} =    Check Registration Form Data Validity   ${registration_form_data}
    ${next_page} =      Set Variable       RegistrationPage
    IF      ${is_registration_form_data_valid}
        ${next_page} =      Set Variable       LoginPage
    END
    [Return]    ${next_page}

Re-Register
    [Documentation]     If the user has already registered with the given valid_user_registration_form_data,
    ...                 then this keyword expects "User X is already registered.", where X is the username
    [Arguments]     ${registration_form_data}
    Go To Registration Page
    Verify Registration Page
    Fill Registration Form And Press Register       ${registration_form_data}
    Verify Registration Page
    Verify User Name Already Exists Error        ${registration_form_data}[username][value]

Re-Start Web Application With Many Registered Users
    [Documentation]     After re-starting the web app, it calls Register keyword multiple times with a valid user's data each time
    Re-Start Web Application With No Users
    FOR     ${index}        IN RANGE    999999
        ${registration_form_data} =     Get Valid User's Registration Form Data
        Exit For Loop If   $registration_form_data is None
        # we didn't exit the loop: we have valid registration_form_data
        Go To Registration Page
        Register        ${registration_form_data}
    END

Fill In Login Form And Press Login Button
    [Arguments]     ${login_form_data}
    LoginPage.Fill In Username      ${login_form_data}[username][value]
    LoginPage.Fill In Password      ${login_form_data}[password][value]
    LoginPage.Press Login Button

Can User Login
    [Documentation]     In order login_form_data to be valid, both fields must be correct as they are registered.
    ...                 So, username and password fields must be correct as they are registered.
    [Arguments]         ${login_form_data}
    ${can_user_login} =     Evaluate  $login_form_data['username']['isRegistered'] and $login_form_data['password']['isRegistered']
    [Return]    ${can_user_login}

Login
    [Documentation]     Attempts to Login with the given login_form_data.
    ...                 If the data is valid, expect the main profile page to show
    ...                 If the data is invalid, expects the corresponding error message to be shown in the login page
    [Arguments]         ${registration_form_data}
    Fill In Login Form And Press Login Button       ${registration_form_data}
    ${can_user_login} =     Can User Login      ${registration_form_data}
    IF      ${can_user_login}
        Verify Main Page    ${registration_form_data}
    ELSE
        Verify Login Failure Page
    END

Mark Username As Registered
    [Arguments]     ${valid_user_registration_form_data}
    Set To Dictionary    ${valid_user_registration_form_data}[username]   isRegistered=${True}

Mark Password As Registered
    [Arguments]     ${valid_user_registration_form_data}
    Set To Dictionary    ${valid_user_registration_form_data}[password]    isRegistered=${True}

Set Username To Unregistered Value
    [Arguments]     ${registration_form_data}
    ${username} =   Set Variable        unregistered_username
    Set To Dictionary    ${registration_form_data}[username]    value=${username}
    # mark username as unregistered
    Set To Dictionary    ${registration_form_data}[username]   isRegistered=${False}

Set Password To Unregistered Value
    [Arguments]     ${registration_form_data}
    # important: the password below is valid but not registered. You can verify it in ManyValidUsers.json
    ${password} =   Set Variable        012!.Aab012!.Aab012!.A
    Set To Dictionary    ${registration_form_data}[password]    value=${password}
    # mark password as unregistered
    Set To Dictionary    ${registration_form_data}[password]   isRegistered=${False}