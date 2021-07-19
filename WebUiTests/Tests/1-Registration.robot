*** Settings ***
Documentation       This test suite contains registration test cases for CRF Demo Web Application.
...                 Documentation for the application can be found:
...                 https://github.com/Interview-demoapp/Flasky
...                 The acceptance criteria we verify here is
...                 "1: As a UI user I can register through web portal"

Resource                ../Resources/CrfDemoApp.robot
Resource                ../Resources/Common.robot


Suite Setup             Begin Web Test
Suite Teardown          End Web Test
Test Setup              Re-Start Web Application With No Users
Test Teardown           Stop Web Application


*** Test Cases ***
Registering With Valid Registration Form Data
    [Documentation]     When username/password/first name/last name and phone number are according to the requirements,
    ...                 then this keyword checks that registration is successful
    [Tags]              BAT
    ${valid_user_registration_form_data} =     Get Valid User's Registration Form Data
    Go To Registration Page
    Register            ${valid_user_registration_form_data}

Registering With Variety Of Registration Form Data
    [Documentation]     When username/password/first name/last name and phone number are randomly chosen
    ...                 then this keyword checks that registration is successful iff all of the fields are valid acc.to requirements.
    ...                 Otherwise, an appropriate error message is displayed based on the first erroneus field from top to bottom
    ...                 (refer to UML/RegistrationFormFlowChart.jpg)
    [Tags]              CI
    ${test_case_passed} =     Set Variable      ${True}
    FOR     ${index}        IN RANGE    999999
        ${registration_form_data} =     Get Registration Form Data
        Exit For Loop If   $registration_form_data is None
        Re-Start Web Application With No Users
        Go To Registration Page
        Verify Registration Page
        ${status}   ${response} =    Run Keyword And Ignore Error   Register     ${registration_form_data}
        Log Result  ${index}    ${status}   ${response}     ${registration_form_data}
        ${test_case_passed} =      Evaluate     $test_case_passed and $status=='PASS'
    END
    Should Be True      ${test_case_passed}

Attempting to Register With An Existing User Name Fails
    [Documentation]     Tests that if a user name is already registered, then
    ...                 the registration fails with an appropriate error message.
    [Tags]      BAT
    ${valid_user_registration_form_data} =     Get Valid User's Registration Form Data
    Go To Registration Page
    Register            ${valid_user_registration_form_data}
    Go To Registration Page
    Re-Register         ${valid_user_registration_form_data}

