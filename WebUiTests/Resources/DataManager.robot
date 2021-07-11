*** Settings ***
Documentation   Use this layer to get data from external files
Library         ../CustomLibs/RegistrationFormDataReader.py   ${DATA_SET_LENGTH}    ${USE_EXISTING_FORM_DATA_SET}


*** Keywords ***
Get Registration Form Data
    ${registration_form_data} =  read registration form data
    [Return]  ${registration_form_data}