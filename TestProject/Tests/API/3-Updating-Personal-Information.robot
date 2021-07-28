*** Settings ***
Documentation       This test suite contains test cases for CRF Demo API.
...                 Documentation for the API can be found:
...                 https://github.com/Interview-demoapp/Flasky
...                 The acceptance criteria we verify here is
...                 "3: As an API Consumer, if authenticated, I can update personal information of users"
...                 Definitions
...                 (1) System User: The user, who is registered to the system under test
...                 (2) API User: The user, who calls the API to update personal information of the system user

Resource                ../../Resources/Common.robot
Resource                ../../Resources/DbManager.robot
Library                 ../../CustomLibs/CRUD_Library.py        base_url=http://0.0.0.0:8080/api


Test Setup              Run keywords   Kill Web Application  AND   Replace Database With New Database Having Users  AND
...                     Start Web Application With No Init Procedure  AND
...                     Initialize Database Connection    AND    Verify Tables   AND    Fetch All System Users From Db

Test Teardown           Kill Web Application


*** Keywords ***
Verify Response
    [Arguments]            ${response}     ${message}    ${status}
    Should Be Equal As Strings      ${response}[status]     ${status}
    Should Be Equal As Strings      ${response}[message]    ${message}

Even With Valid Token, Cannot Set Empty Username To Any System User
    [Arguments]         ${api_user}
    ${headers} =        Create Dictionary       Token=${api_user}[token]
    ${payload} =        Create Dictionary       username=${EMPTY}
    FOR     ${system_user}      IN      @{SYSTEM_USERS}
            ${response} =       PUT     /users/${system_user}[username]        headers=${headers}   body=${payload}
            Verify Response     ${response}     message=Field update not allowed    status=FAILURE
    END

*** Test Cases ***
With Any Valid Token, Attempting To Update Username Of Each System User With Empty String Should Fail
    [Documentation]     Imagine we have three system users X, Y, Z. We make PUT requests to /api/users/<username>
    ...                 where <username> is any registered user's username. In the requests' body, we set an empty
    ...                 username. Each time, the request should fail each time with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          Even With Valid Token, Cannot Set Empty Username To Any System User
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            ${api_user}
    END

