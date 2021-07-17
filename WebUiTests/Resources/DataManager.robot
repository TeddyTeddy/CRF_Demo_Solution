*** Settings ***
Documentation   Test file provides a layer to hide how registration_form_data is produced.
...             The file contains a list of registration form data(s)

Library         ../CustomLibs/RegistrationFormDataReader.py   ${DATA_SET_LENGTH}    ${USE_EXISTING_FORM_DATA_SET}


*** Keywords ***
Get Registration Form Data
    [Documentation]     Test suites (e.g. Tests/Registration.robot) use this keyword
    ...                 registration_form_data is a dictionary or None.
    ...                 If it is a dictionary, then it contains data, for example:
    ...     {
    ...         "username": {
    ...             "value": "# 123abc",
    ...             "isValid": false,
    ...             "expected_error": "Minimum 8 characters required. Space character is not allowed"
    ...          },
    ...         "password": {
    ...             "value": "ABC!?.abABC!?.abABC!?.",
    ...             "isValid": false,
    ...             "expected_error": "Min 8 characters. Must contain at least one character from [a-z], [A-Z], [0-9] and [!?.]"
    ...            },
    ...         "first_name": {
    ...              "value": "Helena!.?",
    ...              "isValid": false,
    ...              "expected_error": "Each first name must contain only characters from the set [a-zA-Z]. First names must be seperated by a a single space. First names must have at least 2 characters"
    ...         },
    ...         "last_name": {
    ...             "value": "W Xi",
    ...             "isValid": false,
    ...             "expected_error": "Each last name must contain only characters from the set [a-zA-Z]. Last names must be seperated by a a single space. Last names must have at least 2 characters"
    ...         },
    ...         "phone_number": {
    ...             "value": "",
    ...             "isValid": false,
    ...             "expected_error": "Please fill out this field."
    ...         }
    ...     }
    ${registration_form_data} =  read registration form data
    [Return]  ${registration_form_data}

Get Valid User's Registration Form Data
    ${valid_user_registration_form_data} =  read valid users registration form data
    [Return]  ${valid_user_registration_form_data}