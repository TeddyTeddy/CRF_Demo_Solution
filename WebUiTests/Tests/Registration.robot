*** Settings ***
Documentation       This test suite contains test cases for CRF Demo Web Application.
...                 Documentation for the application can be found:
...                 https://github.com/Interview-demoapp/Flasky

Resource                ../Resources/Common.robot
#Resource                ../Resources/CrfDemoApp.robot

Suite Setup             Begin Web Test
Suite Teardown          End Web Test

*** Test Cases ***
Read Registration Form Data

    ${type} =       Evaluate        type($DATA_SET_LENGTH)
    Log to console  type(DATA_SET_LENGTH): ${type}
    Log to console  ${DATA_SET_LENGTH}

    ${type} =       Evaluate        type($USE_EXISTING_FORM_DATA_SET)
    Log to console  type(USE_EXISTING_FORM_DATA_SET): ${type}
    Log to console  ${USE_EXISTING_FORM_DATA_SET}

    FOR     ${index}        IN RANGE    999999
        ${registration_form_data} =     Get Registration Form Data
        Exit For Loop If   $registration_form_data is None
        Log To Console     ${index} ${registration_form_data}
    END
