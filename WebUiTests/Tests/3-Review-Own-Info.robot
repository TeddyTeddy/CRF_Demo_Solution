*** Settings ***
Documentation       This test suite contains test cases for CRF Demo Web Application.
...                 Documentation for the application can be found:
...                 https://github.com/Interview-demoapp/Flasky
...                 The acceptance criteria we verify here is
...                 "3: As a UI user I can review my own user information from the main view"

Resource                ../Resources/CrfDemoApp.robot
Resource                ../Resources/Common.robot

# (1) note that in suite setup, we have registered many users from TestData/ManyValidUsers.json
Suite Setup             Run keywords    Begin Web Test      Re-Start Web Application With Many Registered Users
Suite Teardown          Run Keywords    End Web Test        Stop Web Application


*** Test Cases ***
Can Review Own User Information From The Main View
    [Documentation]     Tests that if both username and password are correct, then login is successful.
    ...                 User is redirected to the main view and he can check his own user information.
    # Referring to (1), note that valid_user_registration_form_data is one of the registered user's data
    ${valid_user_registration_form_data} =     Get Valid User's Registration Form Data
    Mark Username As Registered    ${valid_user_registration_form_data}
    Mark Password As Registered    ${valid_user_registration_form_data}
    Go To Login Page
    Fill In Login Form And Press Login Button            ${valid_user_registration_form_data}
    Verify Main Page    ${valid_user_registration_form_data}
