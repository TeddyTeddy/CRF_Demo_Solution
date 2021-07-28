*** Settings ***
Documentation       This test suite contains test cases for CRF Demo API.
...                 Documentation for the API can be found:
...                 https://github.com/Interview-demoapp/Flasky
...                 The acceptance criteria we verify here is
...                 "2: As an API Consumer, if authenticated, I can get personal information of users"
...                 Definitions
...                 (1) System User: The user, who is registered to the system under test
...                 (2) API User: The user, who calls the API to fetch personal information about the system user

Resource                ../../Resources/Common.robot
Resource                ../../Resources/DbManager.robot
Library                 ../../CustomLibs/CRUD_Library.py        base_url=http://0.0.0.0:8080/api


Suite Setup             Run keywords   Kill Web Application  AND   Replace Database With New Database Having Users  AND
...                     Start Web Application With No Init Procedure  AND
...                     Initialize Database Connection    AND    Verify Tables   AND    Fetch All System Users From Db

Suite Teardown          Kill Web Application


*** Keywords ***
When Fetching Personal Info Of A System User Without A Token, API User Gets Error
    [Documentation]     If API user does not provide any Token in headers when making a GET request to /api/users/{username}
    ...                 then user is supposed to get an error in the following form in the response body:
    ...                 {
    ...                     "message": "Token authentication required",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test case check that the message & the status returned are correct
    [Arguments]         ${username}
    # make sure that no header is passed with token
    ${response} =       GET     /users/${username}
    # verify the content of the failed response
    Should Be Equal As Strings      ${response}[status]     FAILURE
    Should Be Equal As Strings      ${response}[message]    Token authentication required

When Fetching Personal Info Of A System User With Invalid Token, API User Gets Error
    [Documentation]     Given an invalid token, when reading personal information of a system user
    ...                 via GET request to /api/users/{username}, the api
    ...                 must return the following in its response body:
    ...                 {
    ...                     "message": "Invalid Token",
    ...                     "status": "FAILURE"
    ...                 }
    [Arguments]         ${username}
    # make sere that headers contain Token with invalid value not recognized by the system
    ${headers} =        Create Dictionary       Token=Invalid Token
    ${response} =       GET     /users/${username}        headers=${headers}
    # verify the content of the failed response
    Should Be Equal As Strings      ${response}[status]     FAILURE
    Should Be Equal As Strings      ${response}[message]    Invalid Token

Verify Response Contains Personal Info
    [Arguments]         ${system_user}      ${response}
    Should Be Equal As Strings      ${response}[status]     SUCCESS
    Should Be Equal As Strings      ${response}[message]    retrieval succesful
    # make sure all the personal info except username & password are given
    Should Be Equal As Strings      ${response}[payload][firstname]     ${system_user}[firstname]
    Should Be Equal As Strings      ${response}[payload][lastname]      ${system_user}[lastname]
    Should Be Equal As Strings      ${response}[payload][phone]     ${system_user}[phone]
    Dictionary Should Not Contain Key   ${response}[payload]        username
    Dictionary Should Not Contain Key   ${response}[payload]        password

Any API User With A Valid Token Can Fetch Personal Info Of All System Users
    [Documentation]     Given an api_user example:
    ...                 {'username': 'SuperDuperUser1', 'firstname': 'David', 'lastname': 'Holm', 'phone': '0506627124', 'token': 'MTczNzAyNjc5NDg4Mzc1MzcwNDIwODAyOTM1NTExMjU4NzkzNDM2'}
    ...                 We use the token of api_user as a request header.
    ...                 We pick a system_user from SYSTEM_USERS in each FOR loop iteration.
    ...                 And we query the personal information of that particular system_user using the api_user's token
    ...                 Imagine we have three system users X, Y, Z. If api_user is X, then he can query the personal info of X, Y, Z
    ...                 with his token using this keyword.
    [Arguments]         ${api_user}
    ${headers} =        Create Dictionary       Token=${api_user}[token]
    FOR     ${system_user}      IN      @{SYSTEM_USERS}
            ${response} =       GET     /users/${system_user}[username]        headers=${headers}
            Verify Response Contains Personal Info     ${system_user}      ${response}
    END

When Fetching Personal Info Of Non-Existing User With Valid Token, API User Gets Error
    [Arguments]         ${api_user}
    ${headers} =        Create Dictionary       Token=${api_user}[token]
    ${response} =       GET     /users/non-existing-user       headers=${headers}
    Should Be Equal As Strings      ${response}[status]     FAILURE
    Should Be Equal As Strings      ${response}[message]    user does not exist

*** Test Cases ***
Fetching Personal Info Of System Users Without Token, API User Gets Error
    [Documentation]     If a 3.rd party unknown user, who is not a system user with a valid token,
    ...                 attempts to read personal information of system users without a token, then he will get an error.
    ...                 The unknown user will receive the error regardless of which system user he queries.
    [Template]          When Fetching Personal Info Of A System User Without A Token, API User Gets Error
    FOR     ${system_user}      IN      @{SYSTEM_USERS}
            ${system_user}[username]
    END

Fetching Personal Info Of System Users With Invalid Token, API User Gets Error
    [Documentation]     If a 3.rd party unknown user, who is not a system user with a valid token,
    ...                 attempts to read personal information of system users with an invalid token, then he will get an error.
    ...                 The unknown user will receive the error regardless of which system user he queries.
    [Template]          When Fetching Personal Info Of A System User With Invalid Token, API User Gets Error
    FOR     ${system_user}      IN      @{SYSTEM_USERS}
            ${system_user}[username]
    END

Fetching Personal Info Of System User With Valid Token, API User Indeed Gets The Personal Info Of That System User
    [Documentation]     Imagine we have three system users X, Y, Z. This test case checks that
    ...                 X, Y, Z can query the personal info of X, Y, Z with a their own respective keys.
    [Template]          Any API User With A Valid Token Can Fetch Personal Info Of All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            ${api_user}
    END

Fetching Personal Info Of Non-Existing User With Valid Token, API User Gets Error
    [Documentation]     Imagine we have three system users X, Y, Z. Each of them wants to query personal
    ...                 information of non-existing system user A. The system should return a response
    ...                 having a message "user does not exist" with status FAILURE
    [Template]          When Fetching Personal Info Of Non-Existing User With Valid Token, API User Gets Error
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            ${api_user}
    END