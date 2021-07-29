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

With Valid Token, Attempt to Set Username To All System Users
    [Arguments]         ${token}     ${username_value}
    ${headers} =        Create Dictionary       Token=${token}
    ${payload} =        Create Dictionary       username=${username_value}
    FOR     ${system_user}      IN      @{SYSTEM_USERS}
            ${response} =       PUT     /users/${system_user}[username]        headers=${headers}   body=${payload}
            Verify Response     ${response}     message=Field update not allowed    status=FAILURE
    END

*** Test Cases ***
With Any Valid Token, Updating Username Of Each System User With '' Results In "Field update not allowed"
    [Documentation]     Imagine we have three system users X, Y, Z. We make PUT requests to /api/users/<username>
    ...                 where <username> is any registered user's username. In the requests' body, we set an empty
    ...                 username as such:
    ...                 {
    ...                     "username": ''
    ...                 }
    ...                 Then, Each time, the request should fail each time with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=${EMPTY}
    END

