*** Settings ***
Documentation		Contains higher level keywords having business logic for the demo app
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
    [Arguments]     ${registration_form_data}
    ${is_registration_form_data_valid} =    Evaluate    $registration_form_data['username']['isValid'] and $registration_form_data['password']['isValid'] and $registration_form_data['first_name']['isValid'] and $registration_form_data['last_name']['isValid'] and $registration_form_data['phone_number']['isValid']
    ${next_page} =      Set Variable       RegistrationPage
    IF      ${is_registration_form_data_valid}
        ${next_page} =      Set Variable       LoginPage
    END
    [Return]    ${next_page}




