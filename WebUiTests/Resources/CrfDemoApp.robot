*** Settings ***
Documentation		Contains higher level keywords having business logic for the system under test
Resource			./PO/TopNav.resource
Resource			./PO/RegistrationPage.resource
Resource			./PO/LoginPage.resource
Resource			./Verifiers/TopNavVerifier.resource
Resource			./Verifiers/RegistrationPageVerifier.resource
Resource			./Verifiers/LoginPageVerifier.resource

*** Variable ***
${BROWSER}						chromium


*** Keywords ***
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
    RegistrationPage.Fill In Username        ${registration_form_data}[username][value]
    RegistrationPage.Fill In Password        ${registration_form_data}[password][value]
    RegistrationPage.Fill In First Name      ${registration_form_data}[first_name][value]
    RegistrationPage.Fill In Last Name       ${registration_form_data}[last_name][value]
    RegistrationPage.Fill In Phone Number    ${registration_form_data}[phone_number][value]
    RegistrationPage.Press Register Button
    ${expected_page} =      Calculate Next Page    ${registration_form_data}
    IF          $expected_page=='RegistrationPage'
        Verify Registration Page
        Check Registration Form Error Messages    ${registration_form_data}
    ELSE IF     $expected_page=='LoginPage'
        Verify Login Page    ${registration_form_data}[username][value]
    ELSE
        Fail    'Could not calculate next page from registration form data'
    END

Calculate Next Page
    [Documentation]     In order registration_form_data to be valid, all the fields' in registration_form_data must be valid.
    ...                 If registration_form_data is valid we expect the system under test to redirect to login page.
    ...                 If registration_form_data is invalid, we expect the system under test to stay in registration page.
    [Arguments]     ${registration_form_data}
    ${is_registration_form_data_valid} =    Evaluate    $registration_form_data['username']['isValid'] and $registration_form_data['password']['isValid'] and $registration_form_data['first_name']['isValid'] and $registration_form_data['last_name']['isValid'] and $registration_form_data['phone_number']['isValid']
    ${next_page} =      Set Variable       RegistrationPage
    IF      ${is_registration_form_data_valid}
        ${next_page} =      Set Variable       LoginPage
    END
    [Return]    ${next_page}




