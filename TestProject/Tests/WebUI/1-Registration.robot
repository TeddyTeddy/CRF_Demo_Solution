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
Empty Username Is Not Accepted
    [Documentation]   username must be at least 8 chars. It can contain any character except space characters
    [tags]      BAT     username    REQ-REG-FORM-USERNAME-2
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a short username
    Manipulate      ${registration_form_data}       username    an empty username
    Register        ${registration_form_data}

Short Username Containing Numbers Is Not Accepted
    [Documentation]   username must be at least 8 chars. It can contain any character except space characters
    [tags]      BAT     username    REQ-REG-FORM-USERNAME-2
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a short username
    Manipulate      ${registration_form_data}       username    7 numeric characters forms username
    Register        ${registration_form_data}

Short Username Containing Alpha Characters Is Not Accepted
    [Documentation]   username must be at least 8 chars. It can contain any character except space characters
    [tags]      BAT     username    REQ-REG-FORM-USERNAME-2
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a short username
    Manipulate      ${registration_form_data}       username    7 alpha characters forms username
    Register        ${registration_form_data}

Short Username Containing Non-Alpha-Numeric Characters Is Not Accepted
    [Documentation]   username must be at least 8 chars. It can contain any character except space characters
    [tags]      BAT     username    REQ-REG-FORM-USERNAME-2
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a short username
    Manipulate      ${registration_form_data}       username    7 non-alphanumeric characters forms username
    Register        ${registration_form_data}

Short Username Containing Alpha-Numeric Characters Is Not Accepted
    [Documentation]   username must be at least 8 chars. It can contain any character except space characters
    [tags]      BAT     username    REQ-REG-FORM-USERNAME-2
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a short username
    Manipulate      ${registration_form_data}       username    7 alphanumeric characters forms username
    Register        ${registration_form_data}

Short Username Containing Alpha-Numeric And Non-Alpha Numeric Characters Is Not Accepted
    [Documentation]   username must be at least 8 chars. It can contain any character except space characters
    [tags]      BAT     username    REQ-REG-FORM-USERNAME-2
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a short username
    Manipulate      ${registration_form_data}       username    7 (non-)alphanumeric characters forms username
    Register        ${registration_form_data}

Short Username Containing Non-Alpha Numeric And Alpha Characters Is Not Accepted
    [Documentation]   username must be at least 8 chars. It can contain any character except space characters
    [tags]      BAT     username    REQ-REG-FORM-USERNAME-2
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a short username
    Manipulate      ${registration_form_data}       username    7 non-alphanumeric and alpha characters forms username
    Register        ${registration_form_data}

Short Username Containing Non-Alpha Numeric And Numeric Characters Is Not Accepted
    [Documentation]   username must be at least 8 chars. It can contain any character except space characters
    [tags]      BAT     username    REQ-REG-FORM-USERNAME-2
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a short username
    Manipulate      ${registration_form_data}       username    7 non-alphanumeric and numeric characters forms username
    Register        ${registration_form_data}

Minimum Length Username Containing Numeric Characters Is Accepted
    [Documentation]   Minimum lenght username is accepted when it contains anything but the space characters
    [tags]  BAT     username    REQ-REG-FORM-USERNAME-2     REQ-REG-FORM-USERNAME-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a min.length valid username
    Manipulate      ${registration_form_data}       username    8 numeric characters forms username
    Register        ${registration_form_data}

Minimum Length Username Containing Alpha Characters Is Accepted
    [Documentation]   Minimum lenght username is accepted when it contains anything but the space characters
    [tags]  BAT     username    REQ-REG-FORM-USERNAME-2     REQ-REG-FORM-USERNAME-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a min.length valid username
    Manipulate      ${registration_form_data}       username    8 alpha characters forms username
    Register        ${registration_form_data}

Minimum Length Username Containing Non-Alphanumeric Characters Is Accepted
    [Documentation]   Minimum lenght username is accepted when it contains anything but the space characters
    [tags]  BAT     username    REQ-REG-FORM-USERNAME-2     REQ-REG-FORM-USERNAME-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a min.length valid username
    Manipulate      ${registration_form_data}       username    8 non-alphanumeric characters forms username
    Register        ${registration_form_data}

Minimum Length Username Containing Alphanumeric Characters Is Accepted
    [Documentation]   Minimum lenght username is accepted when it contains anything but the space characters
    [tags]  BAT     username    REQ-REG-FORM-USERNAME-2     REQ-REG-FORM-USERNAME-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a min.length valid username
    Manipulate      ${registration_form_data}       username    8 alphanumeric characters forms username
    Register        ${registration_form_data}

Minimum Length Username Containing Non-Alphanumeric And Alphanumeric Characters Is Accepted
    [Documentation]   Minimum lenght username is accepted when it contains anything but the space characters
    [tags]  BAT     username    REQ-REG-FORM-USERNAME-2     REQ-REG-FORM-USERNAME-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a min.length valid username
    Manipulate      ${registration_form_data}       username    8 (non-)alphanumeric characters forms username
    Register        ${registration_form_data}

Minimum Length Username Containing Non-Alphanumeric And Alpha Characters Is Accepted
    [Documentation]   Minimum lenght username is accepted when it contains anything but the space characters
    [tags]  BAT     username    REQ-REG-FORM-USERNAME-2     REQ-REG-FORM-USERNAME-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a min.length valid username
    Manipulate      ${registration_form_data}       username    8 non-alphanumeric and alpha characters forms username
    Register        ${registration_form_data}

Minimum Length Username Containing Non-Alphanumeric And Numeric Characters Is Accepted
    [Documentation]   Minimum lenght username is accepted when it contains anything but the space characters
    [tags]  BAT     username    REQ-REG-FORM-USERNAME-2     REQ-REG-FORM-USERNAME-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a min.length valid username
    Manipulate      ${registration_form_data}       username    8 non-alphanumeric and numeric characters forms username
    Register        ${registration_form_data}

Long Username With Numeric Characters Is Accepted
    [tags]  BAT     username    REQ-REG-FORM-USERNAME-2     REQ-REG-FORM-USERNAME-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long username
    Manipulate      ${registration_form_data}       username    14 numeric characters forms username
    Register        ${registration_form_data}

Long Username With Alpha Characters Is Accepted
    [tags]  BAT     username    REQ-REG-FORM-USERNAME-2     REQ-REG-FORM-USERNAME-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long username
    Manipulate      ${registration_form_data}       username    20 alpha characters forms username
    Register        ${registration_form_data}

Long Username With Non-Alphanumeric Characters Is Accepted
    [tags]  BAT     username    REQ-REG-FORM-USERNAME-2     REQ-REG-FORM-USERNAME-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long username
    Manipulate      ${registration_form_data}       username    13 non-alphanumeric characters forms username
    Register        ${registration_form_data}

Long Username With Alphanumeric Characters Is Accepted
    [tags]  BAT     username    REQ-REG-FORM-USERNAME-2     REQ-REG-FORM-USERNAME-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long username
    Manipulate      ${registration_form_data}       username    23 alphanumeric characters forms username
    Register        ${registration_form_data}

Long Username With Alphanumeric And Non-Alphanumeric Characters Is Accepted
    [tags]  BAT     username    REQ-REG-FORM-USERNAME-2     REQ-REG-FORM-USERNAME-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long username
    Manipulate      ${registration_form_data}       username    19 (non-)alphanumeric characters forms username
    Register        ${registration_form_data}

Long Username With Non-Alphanumeric And Alpha Characters Is Accepted
    [tags]  BAT     username    REQ-REG-FORM-USERNAME-2     REQ-REG-FORM-USERNAME-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long username
    Manipulate      ${registration_form_data}       username    26 non-alphanumeric and alpha characters forms username
    Register        ${registration_form_data}

Long Username With Non-Alphanumeric And Numeric Characters Is Accepted
    [tags]  BAT     username    REQ-REG-FORM-USERNAME-2     REQ-REG-FORM-USERNAME-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long username
    Manipulate      ${registration_form_data}       username    28 non-alphanumeric and numeric characters forms username
    Register        ${registration_form_data}

Usernames Containing Space(s) Are Not Accepted
    [tags]  BAT     username    REQ-REG-FORM-USERNAME-4
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a username with space(s)
    Manipulate      ${registration_form_data}       username    12 non-alphanumeric characters and a space form username
    Register        ${registration_form_data}
    # make it have a username with space(s)
    Manipulate      ${registration_form_data}       username    13 numeric characters and a space form username
    Register        ${registration_form_data}
    # make it have a username with space(s)
    Manipulate      ${registration_form_data}       username    19 alpha characters and a space form username
    Register        ${registration_form_data}
    # make it have a username with space(s)
    Manipulate      ${registration_form_data}       username    22 alphanumeric characters and a space form username
    Register        ${registration_form_data}
    # make it have a username with space(s)
    Manipulate      ${registration_form_data}       username    27 non-alphanumeric and numeric characters and a space form username
    Register        ${registration_form_data}
    # make it have a username with space(s)
    Manipulate      ${registration_form_data}       username    17 (non-)alphanumeric characters and 2 spaces form username
    Register        ${registration_form_data}
    # make it have a username with space(s)
    Manipulate      ${registration_form_data}       username    25 non-alphanumeric and alpha characters and a space form username
    Register        ${registration_form_data}

Empty Password Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    an empty password
    Register        ${registration_form_data}

Short Password Containing Only Small Letters [a-z] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    only 7 characters from set [a-z], missing [A-Z], [0-9], [!?.] characters
    Register        ${registration_form_data}

Minimum Length Password Containing Only [a-z] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    8 characters from set [a-z], missing [A-Z], [0-9], [!?.]
    Register        ${registration_form_data}

Long Password Containing Only Small Letters [a-z] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    24 characters from set [a-z], missing [A-Z], [0-9], [!?.] characters
    Register        ${registration_form_data}

Short Password Containing Only Capital Letters [A-Z] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    only 7 characters from set [A-Z], missing [a-z], [0-9], [!?.] characters
    Register        ${registration_form_data}

Minimum Length Password Containing Only Capital Letters [A-Z] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    8 characters from set [A-Z], missing [a-z], [0-9], [!?.] characters
    Register        ${registration_form_data}

Long Password Containing Only Capital Letters [A-Z] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    24 characters from set [A-Z], missing [a-z], [0-9], [!?.] characters
    Register        ${registration_form_data}

Short Password Containing Only [0-9] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    7 characters from set [0-9], missing [a-z], [A-Z], [!?.] characters
    Register        ${registration_form_data}

Minimum Length Password Containing Only [0-9] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    8 characters from set [0-9], missing [a-z], [A-Z], [!?.] characters
    Register        ${registration_form_data}

Long Password Containing Only [0-9] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    20 characters from set [0-9], missing [a-z], [A-Z], [!?.] characters
    Register        ${registration_form_data}

Short Password Containing Only [!?.] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    7 characters from set [!?.], missing [a-z], [A-Z], [0-9] characters
    Register        ${registration_form_data}

Minimum Length Password Containing Only [!?.] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    8 characters from set [!?.], missing [a-z], [A-Z], [0-9] characters
    Register        ${registration_form_data}

Long Password Containing Only [!?.] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    20 characters from set [!?.], missing [a-z], [A-Z], [0-9] characters
    Register        ${registration_form_data}

Short Password Containing Characters From Sets [A-Z] and [a-z] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    7 characters from sets [A-Z] and [a-z], missing [!?.], [0-9] characters
    Register        ${registration_form_data}

Minimum Length Password Containing Characters From Sets [A-Z] and [a-z] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    8 characters from sets [A-Z] and [a-z], missing [!?.], [0-9] characters
    Register        ${registration_form_data}

Long Password Containing Characters From Sets [A-Z] and [a-z] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    22 characters from sets [A-Z] and [a-z], missing [!?.], [0-9] characters
    Register        ${registration_form_data}

Short Password Containing Characters From Sets [0-9] and [a-z] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    7 characters from sets [a-z] and [0-9], missing [!?.], [A-Z] characters
    Register        ${registration_form_data}

Minimum Length Password Containing Characters From Sets [0-9] and [a-z] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    8 characters from sets [a-z] and [0-9], missing [!?.], [A-Z] characters
    Register        ${registration_form_data}

Long Password Containing Characters From Sets [0-9] and [a-z] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    22 characters from sets [a-z] and [0-9], missing [!?.], [A-Z] characters
    Register        ${registration_form_data}

Short Password Containing Characters From Sets [!?.] and [a-z] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    7 characters from sets [a-z] and [!?.], missing [0-9], [A-Z] characters
    Register        ${registration_form_data}

Minimum Length Password Containing Characters From Sets [!?.] and [a-z] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    8 characters from sets [a-z] and [!?.], missing [0-9], [A-Z] characters
    Register        ${registration_form_data}

Long Password Containing Characters From Sets [!?.] and [a-z] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    22 characters from sets [a-z] and [!?.], missing [0-9], [A-Z] characters
    Register        ${registration_form_data}

Short Password Containing Characters From Sets [A-Z] and [0-9] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    7 characters from sets [A-Z] and [0-9], missing [a-z], [!?.] characters
    Register        ${registration_form_data}

Minimum Length Password Containing Characters From Sets [A-Z] and [0-9] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    8 characters from sets [A-Z] and [0-9], missing [a-z], [!?.] characters
    Register        ${registration_form_data}

Long Password Containing Characters From Sets [A-Z] and [0-9] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    22 characters from sets [A-Z] and [0-9], missing [a-z], [!?.] characters
    Register        ${registration_form_data}

Short Password Containing Characters From Sets [A-Z] and [!?.] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    7 characters from sets [A-Z] and [!?.], missing [a-z], [0-9] characters
    Register        ${registration_form_data}

Minimum Length Password Containing Characters From Sets [A-Z] and [!?.] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    8 characters from sets [A-Z] and [!?.], missing [a-z], [0-9] characters
    Register        ${registration_form_data}

Long Password Containing Characters From Sets [A-Z] and [!?.] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    22 characters from sets [A-Z] and [!?.], missing [a-z], [0-9] characters
    Register        ${registration_form_data}

Short Password Containing Characters From Sets [0-9] and [!?.] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    7 characters from sets [0-9] and [!?.], missing [a-z], [A-Z]
    Register        ${registration_form_data}

Minimum Length Password Containing Characters From Sets [0-9] and [!?.] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    8 characters from sets [0-9] and [!?.], missing [a-z], [A-Z] characters
    Register        ${registration_form_data}

Long Password Containing Characters From Sets [0-9] and [!?.] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    22 characters from sets [0-9] and [!?.], missing [a-z], [A-Z] characters
    Register        ${registration_form_data}

Short Password Containing Characters From Sets [a-z], [A-Z] and [0-9] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    7 characters from sets [A-Z], [a-z] and [0-9]. Missing characters from set [!?.]
    Register        ${registration_form_data}

Minimum Length Password Containing Characters Sets [a-z], [A-Z] and [0-9] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    8 characters from sets [A-Z], [a-z] and [0-9]. Missing characters from set [!?.]
    Register        ${registration_form_data}

Long Password Containing Characters From Sets [a-z], [A-Z] and [0-9] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    22 characters from sets [A-Z], [a-z] and [0-9]. Missing characters from set [!?.]
    Register        ${registration_form_data}

Short Password Containing Characters From Sets [a-z], [A-Z] and [!?.] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    7 characters from sets [A-Z], [a-z] and [!?.]. Missing characters from set [0-9]
    Register        ${registration_form_data}

Minimum Length Password Containing Characters Sets [a-z], [A-Z] and [!?.] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    8 characters from sets [A-Z], [a-z] and [!?.]. Missing characters from set [0-9]
    Register        ${registration_form_data}

Long Password Containing Characters From Sets [a-z], [A-Z] and [!?.] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    22 characters from sets [A-Z], [a-z] and [!?.]. Missing characters from set [0-9]
    Register        ${registration_form_data}

Short Password Containing Characters From Sets [!?.], [0-9] and [a-z] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    7 characters from sets [a-z], [0-9] and [!?.]. Missing characters from set [A-Z]
    Register        ${registration_form_data}

Minimum Length Password Containing Characters Sets [a-z], [0-9] and [!?.] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    8 characters from sets [a-z], [0-9] and [!?.]. Missing characters from set [A-Z]
    Register        ${registration_form_data}

Long Password Containing Characters From Sets [a-z], [!?.] and [0-9] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    22 characters from sets [a-z], [0-9] and [!?.]. Missing characters from set [A-Z]
    Register        ${registration_form_data}

Short Password Containing Characters From Sets [a-z], [!?.] and [A-Z] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    7 characters from sets [a-z], [!?.] and [A-Z]. Missing characters from set [0-9]
    Register        ${registration_form_data}

Minimum Length Password Containing Characters Sets [a-z], [!?.] and [A-Z] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    8 characters from sets [a-z], [!?.] and [A-Z]. Missing characters from set [0-9]
    Register        ${registration_form_data}

Long Password Containing Characters From Sets [a-z], [!?.] and [A-Z] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    22 characters from sets [a-z], [!?.] and [A-Z]. Missing characters from set [0-9]
    Register        ${registration_form_data}

Short Password Containing Characters From Sets [0-9], [a-z] and [!?.] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    7 characters from sets [a-z], [!?.] and [0-9]. Missing characters from set [A-Z]
    Register        ${registration_form_data}

Minimum Length Password Containing Characters From Sets [0-9], [!?.] and [a-z] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    8 characters from sets [a-z], [!?.] and [0-9]. Missing characters from set [A-Z]
    Register        ${registration_form_data}

Long Password Containing Characters From Sets [!?.], [a-z] and [0-9] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    22 characters from sets [a-z], [!?.] and [0-9]. Missing characters from set [A-Z]
    Register        ${registration_form_data}

Short Password Containing Characters From Sets [A-Z], [0-9] and [!?.] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    7 characters from sets [A-Z], [0-9] and [!?.]. Missing characters from set [a-z]
    Register        ${registration_form_data}

Minimum Length Password Containing Characters From Sets [A-Z], [0-9] and [!?.] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    8 characters from sets [A-Z], [0-9] and [!?.]. Missing characters from set [a-z]
    Register        ${registration_form_data}

Long Password Containing Characters From Sets [A-Z], [0-9] and [!?.] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    22 characters from sets [A-Z], [0-9] and [!?.]. Missing characters from set [a-z]
    Register        ${registration_form_data}

Short Password Containing Characters From Sets [A-Z], [!?.] and [0-9] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    7 characters from sets [A-Z], [!?.] and [0-9]. Missing characters from set [a-z]
    Register        ${registration_form_data}

Minimum Length Password Containing Characters From Sets [A-Z], [!?.] and [0-9] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    8 characters from sets [A-Z], [!?.] and [0-9]. Missing characters from set [a-z]
    Register        ${registration_form_data}

Long Password Containing Characters From Sets [0-9], [A-Z] and [!?.] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    22 characters from sets [A-Z], [!?.] and [0-9]. Missing characters from set [a-z]
    Register        ${registration_form_data}

Short Password Containing Characters From Sets [A-Z], [!?.], [0-9] and [a-z] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    only 7 characters from sets [0-9], [!?.], [A-Z] and [a-z].
    Register        ${registration_form_data}

Minimum Length Password Containing Characters From Sets [A-Z], [!?.], [0-9] and [a-z] Is Indeed Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    8 characters from sets [0-9], [!?.], [A-Z] and [a-z]
    Register        ${registration_form_data}

Long Password Containing Characters From Sets [A-Z], [!?.], [0-9] and [a-z] Is Indeed Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    REQ-REG-FORM-PASSWORD-2     REQ-REG-FORM-PASSWORD-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    22 characters from sets [0-9], [!?.], [A-Z] and [a-z]
    Register        ${registration_form_data}

Empty First Name Is Not Accepted
    [Tags]              BAT     first_name      REQ-REG-FORM-FIRST-NAME-2
    ${registration_form_data} =     Get Valid User's Registration Form Data
    Manipulate      ${registration_form_data}       first_name    An empty first name
    Register        ${registration_form_data}

First Name Containing More Than 2 Characters Is Accepted
    [Tags]              BAT     first_name      REQ-REG-FORM-FIRST-NAME-2       REQ-REG-FORM-FIRST-NAME-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    Manipulate      ${registration_form_data}       first_name    A first name containing more than 2 characters
    Register        ${registration_form_data}

First Name Containing Numbers And Non-Aphanumeric Characters Is Not Accepted
    [Tags]              BAT     first_name      REQ-REG-FORM-FIRST-NAME-5       REQ-REG-FORM-FIRST-NAME-6
    ${registration_form_data} =     Get Valid User's Registration Form Data
    Manipulate      ${registration_form_data}       first_name    A name containing numbers and non-alphanumeric characters
    Register        ${registration_form_data}

First Name Containing 2 Characters Is Accepted
    [Tags]              BAT     first_name      REQ-REG-FORM-FIRST-NAME-2
    ${registration_form_data} =     Get Valid User's Registration Form Data
    Manipulate      ${registration_form_data}       first_name    A minimum 2 characters first name
    Register        ${registration_form_data}

First Name Having Two Words Each Containing 2 Characters Is Accepted
    [Tags]              BAT     first_name      REQ-REG-FORM-FIRST-NAME-7       REQ-REG-FORM-FIRST-NAME-2
    ${registration_form_data} =     Get Valid User's Registration Form Data
    Manipulate      ${registration_form_data}       first_name    A minimum 2 characters first names for each first name
    Register        ${registration_form_data}

'H Xu' As First Name Is Not Accepted
    [Documentation]     The first first name is invalid with only 1 letter, the second first name is valid
    [Tags]              BAT     first_name      REQ-REG-FORM-FIRST-NAME-2
    ${registration_form_data} =     Get Valid User's Registration Form Data
    Manipulate      ${registration_form_data}       first_name    The first first name is invalid with only 1 letter, the second first name is valid
    Register        ${registration_form_data}

'Ha X' As First Name Is Not Accepted
    [Documentation]     The second first name is invalid with only 1 letter, the first first name is valid
    [Tags]              BAT     first_name      REQ-REG-FORM-FIRST-NAME-2
    ${registration_form_data} =     Get Valid User's Registration Form Data
    Manipulate      ${registration_form_data}       first_name    The second first name is invalid with only 1 letter, the first first name is valid
    Register        ${registration_form_data}

'H X' As First Name Is Not Accepted
    [Documentation]     The both first names are invalid with only 1 letter
    [Tags]              BAT     first_name      REQ-REG-FORM-FIRST-NAME-2
    ${registration_form_data} =     Get Valid User's Registration Form Data
    Manipulate      ${registration_form_data}       first_name    The both first names are invalid with only 1 letter
    Register        ${registration_form_data}

First Name Containing Numbers Is Not Accepted
    [Tags]              BAT     first_name      REQ-REG-FORM-FIRST-NAME-5
    ${registration_form_data} =     Get Valid User's Registration Form Data
    Manipulate      ${registration_form_data}       first_name    First name does contain numbers, which makes it invalid
    Register        ${registration_form_data}

First Name Containing Non-Alphanumeric Characters Is Not Accepted
    [Tags]              BAT     first_name      REQ-REG-FORM-FIRST-NAME-6
    ${registration_form_data} =     Get Valid User's Registration Form Data
    Manipulate      ${registration_form_data}       first_name    First name does contain non alphanumeric characters, which makes it invalid
    Register        ${registration_form_data}

First Name Having Two Words Seperated By A Single Space Is Indeed Accepted
    [Tags]              BAT     first_name      REQ-REG-FORM-FIRST-NAME-7
    ${registration_form_data} =     Get Valid User's Registration Form Data
    Manipulate      ${registration_form_data}       first_name    Two valid first names seperated by a single space character
    Register        ${registration_form_data}

First Name Having Two Words Seperated By Multiple Spaces Is Not Accepted
    [Tags]              BAT     first_name      REQ-REG-FORM-FIRST-NAME-7
    ${registration_form_data} =     Get Valid User's Registration Form Data
    Manipulate      ${registration_form_data}       first_name    Two valid first names seperated by multiple space characters making it invalid
    Register        ${registration_form_data}

Empty Last Name Is Not Accepted
    [Tags]              BAT     last_name       REQ-REG-FORM-LAST-NAME-2
    ${registration_form_data} =     Get Valid User's Registration Form Data
    Manipulate      ${registration_form_data}       last_name    empty last name
    Register        ${registration_form_data}

A Valid Last Name Containing More Than 2 Characters Is Accepted
    [Tags]              BAT     last_name       REQ-REG-FORM-LAST-NAME-2        REQ-REG-FORM-LAST-NAME-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    Manipulate      ${registration_form_data}       last_name    last name containing more than 2 characters
    Register        ${registration_form_data}

Last Name Containing Numbers And Non-Aphanumeric Characters Is Not Accepted
    [Tags]              BAT     last_name       REQ-REG-FORM-LAST-NAME-5        REQ-REG-FORM-LAST-NAME-6
    ${registration_form_data} =     Get Valid User's Registration Form Data
    Manipulate      ${registration_form_data}       last_name    last name containing numbers and non-alphanumeric characters
    Register        ${registration_form_data}

'Wi' As Last Name Is Accepted
    [Documentation]       Short names in Asian culture are common with 2 alphabetical letters minimum
    [Tags]              BAT     last_name       REQ-REG-FORM-LAST-NAME-2        REQ-REG-FORM-LAST-NAME-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    Manipulate      ${registration_form_data}       last_name    2 character last name with only one word
    Register        ${registration_form_data}

'Wi Xi' As Last Name Is Accepted
    [Documentation]       Short names in Asian culture are common with 2 alphabetical letters minimum for each word
    [Tags]              BAT     last_name   REQ-REG-FORM-LAST-NAME-7    REQ-REG-FORM-LAST-NAME-2
    ${registration_form_data} =     Get Valid User's Registration Form Data
    Manipulate      ${registration_form_data}       last_name    2 characters last name with two words
    Register        ${registration_form_data}

'W Xi' As Last Name Is Not Accepted
    [Documentation]       Short names in Asian culture are common with at least 2 alphabetical letters minimum for each word
    [Tags]              BAT     last_name   REQ-REG-FORM-LAST-NAME-2
    ${registration_form_data} =     Get Valid User's Registration Form Data
    Manipulate      ${registration_form_data}       last_name    The first last name is invalid with only 1 letter, the second last name is valid
    Register        ${registration_form_data}

'Wi X' As Last Name Is Not Accepted
    [Documentation]       Short names in Asian culture are common with at least 2 alphabetical letters minimum for each word
    [Tags]              BAT     last_name   REQ-REG-FORM-LAST-NAME-2
    ${registration_form_data} =     Get Valid User's Registration Form Data
    Manipulate      ${registration_form_data}       last_name    second last name is invalid with only 1 letter, the first last name is valid
    Register        ${registration_form_data}

'W X' As Last Name Is Not Accepted
    [Documentation]       Short names in Asian culture are common with at least 2 alphabetical letters minimum for each word
    [Tags]              BAT     last_name   REQ-REG-FORM-LAST-NAME-2
    ${registration_form_data} =     Get Valid User's Registration Form Data
    Manipulate      ${registration_form_data}       last_name    both last names are invalid because they only have 1 letter
    Register        ${registration_form_data}

Last Name Containing Numbers Is Not Accepted
    [Tags]              BAT     last_name   REQ-REG-FORM-LAST-NAME-5
    ${registration_form_data} =     Get Valid User's Registration Form Data
    Manipulate      ${registration_form_data}       last_name    Last name does contain numbers, which makes it invalid
    Register        ${registration_form_data}

Last Name Containing Non-Alphanumeric Characters Is Not Accepted
    [Tags]              BAT     last_name   REQ-REG-FORM-LAST-NAME-6
    ${registration_form_data} =     Get Valid User's Registration Form Data
    Manipulate      ${registration_form_data}       last_name    Last name does contain non alphanumeric characters, which makes it invalid
    Register        ${registration_form_data}

Last Name Containing Two Words Seperated By A Space Is Accepted
    [Tags]              BAT     last_name   REQ-REG-FORM-LAST-NAME-7    REQ-REG-FORM-LAST-NAME-2
    ${registration_form_data} =     Get Valid User's Registration Form Data
    Manipulate      ${registration_form_data}       last_name    Two valid last names seperated by a single space character
    Register        ${registration_form_data}

Last Name Containing Two Words Seperated By Many Spaces Is Not Accepted
    [Tags]              BAT     last_name   REQ-REG-FORM-LAST-NAME-7
    ${registration_form_data} =     Get Valid User's Registration Form Data
    Manipulate      ${registration_form_data}       last_name    Two valid last names seperated by many space characters
    Register        ${registration_form_data}

Empty Phone Number Is Not Accepted
    [Tags]              BAT     phone_number    REQ-REG-FORM-PHONE-NUMBER-2
    ${registration_form_data} =     Get Valid User's Registration Form Data
    Manipulate      ${registration_form_data}       phone_number    empty phone number
    Register        ${registration_form_data}

Valid Phone Number With Country Code Is Indeed Accepted
    [Tags]              BAT     phone_number    REQ-REG-FORM-PHONE-NUMBER-1
    ${registration_form_data} =     Get Valid User's Registration Form Data
    Manipulate      ${registration_form_data}       phone_number    valid phone number with a country code +358
    Register        ${registration_form_data}

"+358+50666+2712" As Phone Number Is Not Accepted
    [Tags]              BAT     phone_number    REQ-REG-FORM-PHONE-NUMBER-1
    ${registration_form_data} =     Get Valid User's Registration Form Data
    Manipulate      ${registration_form_data}       phone_number    invalid phone number with a country code with second and third + signs misplaced
    Register        ${registration_form_data}

"0+506662712+" As Phone Number Is Not Accepted
    [Tags]              BAT     phone_number    REQ-REG-FORM-PHONE-NUMBER-1
    ${registration_form_data} =     Get Valid User's Registration Form Data
    Manipulate      ${registration_form_data}       phone_number    invalid phone number with two + signs misplaced
    Register        ${registration_form_data}

Valid Phone Number Without Country Code Is Indeed Accepted
    [Tags]              BAT     phone_number    REQ-REG-FORM-PHONE-NUMBER-2
    ${registration_form_data} =     Get Valid User's Registration Form Data
    Manipulate      ${registration_form_data}       phone_number    valid phone number without a country code. This assumes Finland
    Register        ${registration_form_data}

"+358506abc!#662712" As Phone Number Is Not Accepted
    [Tags]              BAT     phone_number    REQ-REG-FORM-PHONE-NUMBER-3     REQ-REG-FORM-PHONE-NUMBER-4
    ${registration_form_data} =     Get Valid User's Registration Form Data
    Manipulate      ${registration_form_data}       phone_number    invalid phone number containing letters, non-alphanumeric characters
    Register        ${registration_form_data}

"050!?.#662712" As Phone Number Is Not Accepted
    [Tags]              BAT     phone_number     REQ-REG-FORM-PHONE-NUMBER-4
    ${registration_form_data} =     Get Valid User's Registration Form Data
    Manipulate      ${registration_form_data}       phone_number    invalid phone number containing non-alphanumeric characters
    Register        ${registration_form_data}

"+358abc662712xyz" As Phone Number Is Not Accepted
    [Tags]              BAT     phone_number    REQ-REG-FORM-PHONE-NUMBER-3
    ${registration_form_data} =     Get Valid User's Registration Form Data
    Manipulate      ${registration_form_data}       phone_number    invalid phone number containing letters in between
    Register        ${registration_form_data}

"+35840 687 54 53" As Phone Number Is Not Accepted
    [Tags]              BAT     phone_number    REQ-REG-FORM-PHONE-NUMBER-5
    ${registration_form_data} =     Get Valid User's Registration Form Data
    Manipulate      ${registration_form_data}       phone_number    invalid phone number containing spaces in between digits
    Register        ${registration_form_data}

Registering With Variety Of Registration Form Data
    [Documentation]     When username/password/first name/last name and phone number are randomly chosen
    ...                 then this keyword checks that registration is successful iff all of the fields are valid acc.to requirements.
    ...                 Otherwise, an appropriate error message is displayed based on the first erroneus field from top to bottom
    ...                 (refer to UML/RegistrationFormFlowChart.jpg)
    [Tags]              CI  REQ-REG-FORM-USERNAME-1     REQ-REG-FORM-PASSWORD-1     REQ-REG-FORM-FIRST-NAME-1       
    ...                 REQ-REG-FORM-LAST-NAME-1    REQ-REG-FORM-PHONE-NUMBER-6     REQ-REG-FORM-USERNAME-5
    ...                 REQ-REG-FORM-PASSWORD-4    REQ-REG-FORM-FIRST-NAME-8        REQ-REG-FORM-LAST-NAME-8
    ...                 REQ-REG-FORM-PHONE-NUMBER-7
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

Registering With Valid Registration Form Data
    [Documentation]     When username/password/first name/last name and phone number are according to the requirements,
    ...                 then this keyword checks that registration is successful
    [Tags]              BAT
    ${valid_user_registration_form_data} =     Get Valid User's Registration Form Data
    Register            ${valid_user_registration_form_data}