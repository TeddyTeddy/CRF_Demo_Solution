*** Settings ***
Documentation       This test suite contains login test cases for CRF Demo Web Application.
...                 Documentation for the application can be found:
...                 https://github.com/Interview-demoapp/Flasky
...                 The acceptance criteria we verify here is
...                 "2: As a UI user I can login"

Resource                ../Resources/CrfDemoApp.robot
Resource                ../Resources/Common.robot


Suite Setup             Run keywords    Begin Web Test      Re-Start Web Application With Many Registered Users
Suite Teardown          Run Keywords    End Web Test        Stop Web Application


*** Test Cases ***
Attempting to Login With Wrong Username And Wrong Password Fails
    [Documentation]     Tests that if username & the password are incorrect
    ...                 Then system redirects to login failure page
    # note that this user is already registered into the system
    # Refer to "Re-Start Web Application With Many Registered Users" keyword
    ${registration_form_data} =     Get Valid User's Registration Form Data
    Set Username To Unregistered Value  ${registration_form_data}
    Set Password To Unregistered Value  ${registration_form_data}
    Go To Login Page
    Login            ${registration_form_data}


Attempting to Login With Wrong Username And Correct Password Fails
    [Documentation]     Tests that if username is wrong & the password is correct
    ...                 Then system redirects to login failure page
    # note that this user is already registered into the system
    # Refer to "Re-Start Web Application With Many Registered Users" keyword
    ${registration_form_data} =     Get Valid User's Registration Form Data
    Set Username To Unregistered Value      ${registration_form_data}
    Mark Password As Registered             ${registration_form_data}
    Go To Login Page
    Login            ${registration_form_data}

Attempting to Login With Correct Username And Wrong Password Fails
    [Documentation]     Tests that if username is correct & the password is incorrect
    ...                 Then system redirects to login failure page
    # note that this user is already registered into the system
    # Refer to "Re-Start Web Application With Many Registered Users" keyword
    ${registration_form_data} =     Get Valid User's Registration Form Data
    Mark Username As Registered         ${registration_form_data}
    Set Password To Unregistered Value  ${registration_form_data}
    Go To Login Page
    Login            ${registration_form_data}

Logging In With Correct Username and Correct Password Succeeds
    [Documentation]     Tests that if both username and password are correct, then login is successful.
    ${valid_user_registration_form_data} =     Get Valid User's Registration Form Data
    Mark Username As Registered    ${valid_user_registration_form_data}
    Mark Password As Registered    ${valid_user_registration_form_data}
    Go To Login Page
    Login            ${valid_user_registration_form_data}
