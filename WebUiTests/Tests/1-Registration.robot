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
    [tags]      BAT     username    empty
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a short username
    Manipulate      ${registration_form_data}       username    an empty username
    Register        ${registration_form_data}

Short Username Containing Numbers Is Not Accepted
    [Documentation]   username must be at least 8 chars. It can contain any character except space characters
    [tags]      BAT     username    minimum-8-characters
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a short username
    Manipulate      ${registration_form_data}       username    7 numeric characters forms username
    Register        ${registration_form_data}

Short Username Containing Alpha Characters Is Not Accepted
    [Documentation]   username must be at least 8 chars. It can contain any character except space characters
    [tags]      BAT     username    minimum-8-characters
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a short username
    Manipulate      ${registration_form_data}       username    7 alpha characters forms username
    Register        ${registration_form_data}

Short Username Containing Non-Alpha-Numeric Characters Is Not Accepted
    [Documentation]   username must be at least 8 chars. It can contain any character except space characters
    [tags]      BAT     username    minimum-8-characters
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a short username
    Manipulate      ${registration_form_data}       username    7 non-alphanumeric characters forms username
    Register        ${registration_form_data}

Short Username Containing Alpha-Numeric Characters Is Not Accepted
    [Documentation]   username must be at least 8 chars. It can contain any character except space characters
    [tags]      BAT     username    minimum-8-characters
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a short username
    Manipulate      ${registration_form_data}       username    7 alphanumeric characters forms username
    Register        ${registration_form_data}

Short Username Containing Alpha-Numeric And Non-Alpha Numeric Characters Is Not Accepted
    [Documentation]   username must be at least 8 chars. It can contain any character except space characters
    [tags]      BAT     username    minimum-8-characters
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a short username
    Manipulate      ${registration_form_data}       username    7 (non-)alphanumeric characters forms username
    Register        ${registration_form_data}

Short Username Containing Non-Alpha Numeric And Alpha Characters Is Not Accepted
    [Documentation]   username must be at least 8 chars. It can contain any character except space characters
    [tags]      BAT     username    minimum-8-characters
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a short username
    Manipulate      ${registration_form_data}       username    7 non-alphanumeric and alpha characters forms username
    Register        ${registration_form_data}

Short Username Containing Non-Alpha Numeric And Numeric Characters Is Not Accepted
    [Documentation]   username must be at least 8 chars. It can contain any character except space characters
    [tags]      BAT     username    minimum-8-characters
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a short username
    Manipulate      ${registration_form_data}       username    7 non-alphanumeric and numeric characters forms username
    Register        ${registration_form_data}

Minimum Length Username Containing Numeric Characters Is Accepted
    [Documentation]   Minimum lenght username is accepted when it contains anything but the space characters
    [tags]  BAT     username    minimum-8-characters
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a min.length valid username
    Manipulate      ${registration_form_data}       username    8 numeric characters forms username
    Register        ${registration_form_data}

Minimum Length Username Containing Alpha Characters Is Accepted
    [Documentation]   Minimum lenght username is accepted when it contains anything but the space characters
    [tags]  BAT     username    minimum-8-characters
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a min.length valid username
    Manipulate      ${registration_form_data}       username    8 alpha characters forms username
    Register        ${registration_form_data}

Minimum Length Username Containing Non-Alphanumeric Characters Is Accepted
    [Documentation]   Minimum lenght username is accepted when it contains anything but the space characters
    [tags]  BAT     username    minimum-8-characters
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a min.length valid username
    Manipulate      ${registration_form_data}       username    8 non-alphanumeric characters forms username
    Register        ${registration_form_data}

Minimum Length Username Containing Alphanumeric Characters Is Accepted
    [Documentation]   Minimum lenght username is accepted when it contains anything but the space characters
    [tags]  BAT     username    minimum-8-characters
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a min.length valid username
    Manipulate      ${registration_form_data}       username    8 alphanumeric characters forms username
    Register        ${registration_form_data}

Minimum Length Username Containing Non-Alphanumeric And Alphanumeric Characters Is Accepted
    [Documentation]   Minimum lenght username is accepted when it contains anything but the space characters
    [tags]  BAT     username    minimum-8-characters
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a min.length valid username
    Manipulate      ${registration_form_data}       username    8 (non-)alphanumeric characters forms username
    Register        ${registration_form_data}

Minimum Length Username Containing Non-Alphanumeric And Alpha Characters Is Accepted
    [Documentation]   Minimum lenght username is accepted when it contains anything but the space characters
    [tags]  BAT     username    minimum-8-characters
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a min.length valid username
    Manipulate      ${registration_form_data}       username    8 non-alphanumeric and alpha characters forms username
    Register        ${registration_form_data}

Minimum Length Username Containing Non-Alphanumeric And Numeric Characters Is Accepted
    [Documentation]   Minimum lenght username is accepted when it contains anything but the space characters
    [tags]  BAT     username    minimum-8-characters
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a min.length valid username
    Manipulate      ${registration_form_data}       username    8 non-alphanumeric and numeric characters forms username
    Register        ${registration_form_data}

Long Username With Numeric Characters Is Accepted
    [tags]  BAT     username    minimum-8-characters
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long username
    Manipulate      ${registration_form_data}       username    14 numeric characters forms username
    Register        ${registration_form_data}

Long Username With Alpha Characters Is Accepted
    [tags]  BAT     username    minimum-8-characters
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long username
    Manipulate      ${registration_form_data}       username    20 alpha characters forms username
    Register        ${registration_form_data}

Long Username With Non-Alphanumeric Characters Is Accepted
    [tags]  BAT     username    minimum-8-characters
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long username
    Manipulate      ${registration_form_data}       username    13 non-alphanumeric characters forms username
    Register        ${registration_form_data}

Long Username With Alphanumeric Characters Is Accepted
    [tags]  BAT     username    minimum-8-characters
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long username
    Manipulate      ${registration_form_data}       username    23 alphanumeric characters forms username
    Register        ${registration_form_data}

Long Username With Alphanumeric And Non-Alphanumeric Characters Is Accepted
    [tags]  BAT     username    minimum-8-characters
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long username
    Manipulate      ${registration_form_data}       username    19 (non-)alphanumeric characters forms username
    Register        ${registration_form_data}

Long Username With Non-Alphanumeric And Alpha Characters Is Accepted
    [tags]  BAT     username    minimum-8-characters
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long username
    Manipulate      ${registration_form_data}       username    26 non-alphanumeric and alpha characters forms username
    Register        ${registration_form_data}

Long Username With Non-Alphanumeric And Numeric Characters Is Accepted
    [tags]  BAT     username    minimum-8-characters
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long username
    Manipulate      ${registration_form_data}       username    28 non-alphanumeric and numeric characters forms username
    Register        ${registration_form_data}

Usernames Containing Space(s) Are Not Accepted
    [tags]  BAT     username    space-character
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
    [tags]  BAT     password    empty
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    an empty password
    Register        ${registration_form_data}

Short Password Containing Only Small Letters [a-z] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    short   a-z
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    only 7 characters from set [a-z], missing [A-Z], [0-9], [!?.] characters
    Register        ${registration_form_data}

Minimum Length Password Containing Only [a-z] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    min-length   a-z
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    8 characters from set [a-z], missing [A-Z], [0-9], [!?.]
    Register        ${registration_form_data}

Long Password Containing Only Small Letters [a-z] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    long   a-z
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    24 characters from set [a-z], missing [A-Z], [0-9], [!?.] characters
    Register        ${registration_form_data}

Short Password Containing Only Capital Letters [A-Z] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    short   A-Z
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    only 7 characters from set [A-Z], missing [a-z], [0-9], [!?.] characters
    Register        ${registration_form_data}

Minimum Length Password Containing Only Capital Letters [A-Z] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    min-length   A-Z
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    8 characters from set [A-Z], missing [a-z], [0-9], [!?.] characters
    Register        ${registration_form_data}

Long Password Containing Only Capital Letters [A-Z] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    long   A-Z
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    24 characters from set [A-Z], missing [a-z], [0-9], [!?.] characters
    Register        ${registration_form_data}

Short Password Containing Only [0-9] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    short   0-9
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    7 characters from set [0-9], missing [a-z], [A-Z], [!?.] characters
    Register        ${registration_form_data}

Minimum Length Password Containing Only [0-9] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    min-length   0-9
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    8 characters from set [0-9], missing [a-z], [A-Z], [!?.] characters
    Register        ${registration_form_data}

Long Password Containing Only [0-9] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    long   0-9
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    20 characters from set [0-9], missing [a-z], [A-Z], [!?.] characters
    Register        ${registration_form_data}

Short Password Containing Only [!?.] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    short   !?.
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    7 characters from set [!?.], missing [a-z], [A-Z], [0-9] characters
    Register        ${registration_form_data}

Minimum Length Password Containing Only [!?.] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    min-length   !?.
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    8 characters from set [!?.], missing [a-z], [A-Z], [0-9] characters
    Register        ${registration_form_data}

Long Password Containing Only [!?.] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    long   !?.
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    20 characters from set [!?.], missing [a-z], [A-Z], [0-9] characters
    Register        ${registration_form_data}

Short Password Containing Characters From Sets [A-Z] and [a-z] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    short   A-Z     a-z
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    7 characters from sets [A-Z] and [a-z], missing [!?.], [0-9] characters
    Register        ${registration_form_data}

Minimum Length Password Containing Characters From Sets [A-Z] and [a-z] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    min-length   A-Z     a-z
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    8 characters from sets [A-Z] and [a-z], missing [!?.], [0-9] characters
    Register        ${registration_form_data}

Long Password Containing Characters From Sets [A-Z] and [a-z] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    long   A-Z     a-z
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    22 characters from sets [A-Z] and [a-z], missing [!?.], [0-9] characters
    Register        ${registration_form_data}

Short Password Containing Characters From Sets [0-9] and [a-z] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    short   a-z     0-9
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    7 characters from sets [a-z] and [0-9], missing [!?.], [A-Z] characters
    Register        ${registration_form_data}

Minimum Length Password Containing Characters From Sets [0-9] and [a-z] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    min-length   a-z     0-9
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    8 characters from sets [a-z] and [0-9], missing [!?.], [A-Z] characters
    Register        ${registration_form_data}

Long Password Containing Characters From Sets [0-9] and [a-z] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    long   a-z     0-9
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    22 characters from sets [a-z] and [0-9], missing [!?.], [A-Z] characters
    Register        ${registration_form_data}

Short Password Containing Characters From Sets [!?.] and [a-z] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    short   a-z     !?.
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    7 characters from sets [a-z] and [!?.], missing [0-9], [A-Z] characters
    Register        ${registration_form_data}

Minimum Length Password Containing Characters From Sets [!?.] and [a-z] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    min-length   a-z     !?.
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    8 characters from sets [a-z] and [!?.], missing [0-9], [A-Z] characters
    Register        ${registration_form_data}

Long Password Containing Characters From Sets [!?.] and [a-z] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    long   a-z     !?.
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    22 characters from sets [a-z] and [!?.], missing [0-9], [A-Z] characters
    Register        ${registration_form_data}

Short Password Containing Characters From Sets [A-Z] and [0-9] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    short   A-Z     0-9
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    7 characters from sets [A-Z] and [0-9], missing [a-z], [!?.] characters
    Register        ${registration_form_data}

Minimum Length Password Containing Characters From Sets [A-Z] and [0-9] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    min-length   A-Z     0-9
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    8 characters from sets [A-Z] and [0-9], missing [a-z], [!?.] characters
    Register        ${registration_form_data}

Long Password Containing Characters From Sets [A-Z] and [0-9] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    long   A-Z     0-9
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    22 characters from sets [A-Z] and [0-9], missing [a-z], [!?.] characters
    Register        ${registration_form_data}

Short Password Containing Characters From Sets [A-Z] and [!?.] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    short   A-Z     !?.
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    7 characters from sets [A-Z] and [!?.], missing [a-z], [0-9] characters
    Register        ${registration_form_data}

Minimum Length Password Containing Characters From Sets [A-Z] and [!?.] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    min-length   A-Z     !?.
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    8 characters from sets [A-Z] and [!?.], missing [a-z], [0-9] characters
    Register        ${registration_form_data}

Long Password Containing Characters From Sets [A-Z] and [!?.] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    long   A-Z     !?.
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    22 characters from sets [A-Z] and [!?.], missing [a-z], [0-9] characters
    Register        ${registration_form_data}

Short Password Containing Characters From Sets [0-9] and [!?.] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    short   0-9     !?.
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    7 characters from sets [0-9] and [!?.], missing [a-z], [A-Z]
    Register        ${registration_form_data}

Minimum Length Password Containing Characters From Sets [0-9] and [!?.] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    min-length   0-9     !?.
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    8 characters from sets [0-9] and [!?.], missing [a-z], [A-Z] characters
    Register        ${registration_form_data}

Long Password Containing Characters From Sets [0-9] and [!?.] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    long   0-9     !?.
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    22 characters from sets [0-9] and [!?.], missing [a-z], [A-Z] characters
    Register        ${registration_form_data}

Short Password Containing Characters From Sets [a-z], [A-Z] and [0-9] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    short   a-z     A-Z     0-9
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    7 characters from sets [A-Z], [a-z] and [0-9]. Missing characters from set [!?.]
    Register        ${registration_form_data}

Minimum Length Password Containing Characters Sets [a-z], [A-Z] and [0-9] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    min-length   a-z     A-Z     0-9
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    8 characters from sets [A-Z], [a-z] and [0-9]. Missing characters from set [!?.]
    Register        ${registration_form_data}

Long Password Containing Characters From Sets [a-z], [A-Z] and [0-9] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    long   a-z     A-Z     0-9
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    22 characters from sets [A-Z], [a-z] and [0-9]. Missing characters from set [!?.]
    Register        ${registration_form_data}

Short Password Containing Characters From Sets [a-z], [A-Z] and [!?.] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    short   a-z     A-Z     !?.
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    7 characters from sets [A-Z], [a-z] and [!?.]. Missing characters from set [0-9]
    Register        ${registration_form_data}

Minimum Length Password Containing Characters Sets [a-z], [A-Z] and [!?.] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    min-length   a-z     A-Z     !?.
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    8 characters from sets [A-Z], [a-z] and [!?.]. Missing characters from set [0-9]
    Register        ${registration_form_data}

Long Password Containing Characters From Sets [a-z], [A-Z] and [!?.] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    long   a-z     A-Z     !?.
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    22 characters from sets [A-Z], [a-z] and [!?.]. Missing characters from set [0-9]
    Register        ${registration_form_data}

Short Password Containing Characters From Sets [!?.], [0-9] and [a-z] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    short   a-z     0-9     !?.
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    7 characters from sets [a-z], [0-9] and [!?.]. Missing characters from set [A-Z]
    Register        ${registration_form_data}

Minimum Length Password Containing Characters Sets [a-z], [0-9] and [!?.] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    min-length   a-z     0-9     !?.
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    8 characters from sets [a-z], [0-9] and [!?.]. Missing characters from set [A-Z]
    Register        ${registration_form_data}

Long Password Containing Characters From Sets [a-z], [!?.] and [0-9] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    long   a-z     0-9     !?.
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    22 characters from sets [a-z], [0-9] and [!?.]. Missing characters from set [A-Z]
    Register        ${registration_form_data}

Short Password Containing Characters From Sets [a-z], [!?.] and [A-Z] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    short   a-z     !?.     A-Z
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    7 characters from sets [a-z], [!?.] and [A-Z]. Missing characters from set [0-9]
    Register        ${registration_form_data}

Minimum Length Password Containing Characters Sets [a-z], [!?.] and [A-Z] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    min-length   a-z     !?.     A-Z
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    8 characters from sets [a-z], [!?.] and [A-Z]. Missing characters from set [0-9]
    Register        ${registration_form_data}

Long Password Containing Characters From Sets [a-z], [!?.] and [A-Z] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    long   a-z     !?.     A-Z
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    22 characters from sets [a-z], [!?.] and [A-Z]. Missing characters from set [0-9]
    Register        ${registration_form_data}

Short Password Containing Characters From Sets [0-9], [a-z] and [!?.] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    short   a-z     !?.     0-9
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    7 characters from sets [a-z], [!?.] and [0-9]. Missing characters from set [A-Z]
    Register        ${registration_form_data}

Minimum Length Password Containing Characters From Sets [0-9], [!?.] and [a-z] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    min-length   a-z     !?.     0-9
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    8 characters from sets [a-z], [!?.] and [0-9]. Missing characters from set [A-Z]
    Register        ${registration_form_data}

Long Password Containing Characters From Sets [!?.], [a-z] and [0-9] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    long   a-z     !?.     0-9
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    22 characters from sets [a-z], [!?.] and [0-9]. Missing characters from set [A-Z]
    Register        ${registration_form_data}

Short Password Containing Characters From Sets [A-Z], [0-9] and [!?.] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    short   A-Z     0-9     !?.
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    7 characters from sets [A-Z], [0-9] and [!?.]. Missing characters from set [a-z]
    Register        ${registration_form_data}

Minimum Length Password Containing Characters From Sets [A-Z], [0-9] and [!?.] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    min-length   A-Z     0-9     !?.
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    8 characters from sets [A-Z], [0-9] and [!?.]. Missing characters from set [a-z]
    Register        ${registration_form_data}

Long Password Containing Characters From Sets [A-Z], [0-9] and [!?.] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    long   A-Z     0-9     !?.
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    22 characters from sets [A-Z], [0-9] and [!?.]. Missing characters from set [a-z]
    Register        ${registration_form_data}

Short Password Containing Characters From Sets [A-Z], [!?.] and [0-9] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    short   A-Z     !?.     0-9
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    7 characters from sets [A-Z], [!?.] and [0-9]. Missing characters from set [a-z]
    Register        ${registration_form_data}

Minimum Length Password Containing Characters From Sets [A-Z], [!?.] and [0-9] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    min-length   A-Z     !?.     0-9
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    8 characters from sets [A-Z], [!?.] and [0-9]. Missing characters from set [a-z]
    Register        ${registration_form_data}

Long Password Containing Characters From Sets [0-9], [A-Z] and [!?.] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    long   A-Z     !?.     0-9
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    22 characters from sets [A-Z], [!?.] and [0-9]. Missing characters from set [a-z]
    Register        ${registration_form_data}

Short Password Containing Characters From Sets [A-Z], [!?.], [0-9] and [a-z] Is Not Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    short   A-Z     !?.     0-9     a-z
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    only 7 characters from sets [0-9], [!?.], [A-Z] and [a-z].
    Register        ${registration_form_data}

Minimum Length Password Containing Characters From Sets [A-Z], [!?.], [0-9] and [a-z] Is Indeed Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    min-length   A-Z     !?.     0-9     a-z
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    8 characters from sets [0-9], [!?.], [A-Z] and [a-z]
    Register        ${registration_form_data}

Long Password Containing Characters From Sets [A-Z], [!?.], [0-9] and [a-z] Is Indeed Accepted
    [Documentation]     Password must be at least 8 characters. It must contain letters from [a-z], [A-Z], [0-9] and [!?.]
    [tags]  BAT     password    long   A-Z     !?.     0-9     a-z
    ${registration_form_data} =     Get Valid User's Registration Form Data
    # at this stage, registration_form_data is valid
    # make it have a valid long password
    Manipulate      ${registration_form_data}       password    22 characters from sets [0-9], [!?.], [A-Z] and [a-z]
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

