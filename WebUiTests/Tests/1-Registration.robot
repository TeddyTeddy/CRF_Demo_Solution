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
Short Usernames Containing Only Valid Characters Are Not Accepted
    [tags]  BAT     username    minimum-8-characters
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a short username
    Manipulate      ${registration_form_data}       username    7 numeric characters forms username
    Register        ${registration_form_data}
    # make it have a short username
    Manipulate      ${registration_form_data}       username    7 alpha characters forms username
    Register        ${registration_form_data}
    # make it have a short username
    Manipulate      ${registration_form_data}       username    7 non-alphanumeric characters forms username
    Register        ${registration_form_data}
    # make it have a short username
    Manipulate      ${registration_form_data}       username    7 alphanumeric characters forms username
    Register        ${registration_form_data}
    # make it have a short username
    Manipulate      ${registration_form_data}       username    7 (non-)alphanumeric characters forms username
    Register        ${registration_form_data}
    # make it have a short username
    Manipulate      ${registration_form_data}       username    7 non-alphanumeric and alpha characters forms username
    Register        ${registration_form_data}
    # make it have a short username
    Manipulate      ${registration_form_data}       username    7 non-alphanumeric and numeric characters forms username
    Register        ${registration_form_data}

Minimum Length Valid Usernames Are Accepted
    [tags]  BAT     username    minimum-8-characters
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a min.length valid username
    Manipulate      ${registration_form_data}       username    8 numeric characters forms username
    Register        ${registration_form_data}
    # make it have a min.length valid username
    Manipulate      ${registration_form_data}       username    8 alpha characters forms username
    Register        ${registration_form_data}
    # make it have a min.length valid username
    Manipulate      ${registration_form_data}       username    8 non-alphanumeric characters forms username
    Register        ${registration_form_data}
    # make it have a min.length valid username
    Manipulate      ${registration_form_data}       username    8 alphanumeric characters forms username
    Register        ${registration_form_data}
    # make it have a min.length valid username
    Manipulate      ${registration_form_data}       username    8 (non-)alphanumeric characters forms username
    Register        ${registration_form_data}
    # make it have a min.length valid username
    Manipulate      ${registration_form_data}       username    8 non-alphanumeric and alpha characters forms username
    Register        ${registration_form_data}
    # make it have a min.length valid username
    Manipulate      ${registration_form_data}       username    8 non-alphanumeric and numeric characters forms username
    Register        ${registration_form_data}


Long Valid Usernames Are Accepted
    [tags]  BAT     username    minimum-8-characters
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long username
    Manipulate      ${registration_form_data}       username    14 numeric characters forms username
    Register        ${registration_form_data}
    # make it have a valid long username
    Manipulate      ${registration_form_data}       username    20 alpha characters forms username
    Register        ${registration_form_data}
    # make it have a valid long username
    Manipulate      ${registration_form_data}       username    13 non-alphanumeric characters forms username
    Register        ${registration_form_data}
    # make it have a valid long username
    Manipulate      ${registration_form_data}       username    23 alphanumeric characters forms username
    Register        ${registration_form_data}
    # make it have a valid long username
    Manipulate      ${registration_form_data}       username    19 (non-)alphanumeric characters forms username
    Register        ${registration_form_data}
    # make it have a valid long username
    Manipulate      ${registration_form_data}       username    26 non-alphanumeric and alpha characters forms username
    Register        ${registration_form_data}
    # make it have a valid long username
    Manipulate      ${registration_form_data}       username    28 non-alphanumeric and numeric characters forms username
    Register        ${registration_form_data}

Usernames Containing Space(s) Are Not Accepted
    [tags]  BAT     username    space-character
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long username
    Manipulate      ${registration_form_data}       username    12 non-alphanumeric characters and a space form username
    Register        ${registration_form_data}
    # make it have a valid long username
    Manipulate      ${registration_form_data}       username    13 numeric characters and a space form username
    Register        ${registration_form_data}
    # make it have a valid long username
    Manipulate      ${registration_form_data}       username    19 alpha characters and a space form username
    Register        ${registration_form_data}
    # make it have a valid long username
    Manipulate      ${registration_form_data}       username    22 alphanumeric characters and a space form username
    Register        ${registration_form_data}
    # make it have a valid long username
    Manipulate      ${registration_form_data}       username    27 non-alphanumeric and numeric characters and a space form username
    Register        ${registration_form_data}
    # make it have a valid long username
    Manipulate      ${registration_form_data}       username    17 (non-)alphanumeric characters and 2 spaces form username
    Register        ${registration_form_data}
    # make it have a valid long username
    Manipulate      ${registration_form_data}       username    25 non-alphanumeric and alpha characters and a space form username
    Register        ${registration_form_data}

Registering With Valid Registration Form Data
    [Documentation]     When username/password/first name/last name and phone number are according to the requirements,
    ...                 then this keyword checks that registration is successful
    [Tags]              BAT
    ${valid_user_registration_form_data} =     Get Valid User's Registration Form Data
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
    Register            ${valid_user_registration_form_data}
    Re-Register         ${valid_user_registration_form_data}

