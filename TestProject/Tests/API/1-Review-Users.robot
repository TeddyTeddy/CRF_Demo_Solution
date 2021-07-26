*** Settings ***
Documentation       This test suite contains test cases for CRF Demo API.
...                 Documentation for the API can be found:
...                 https://github.com/Interview-demoapp/Flasky
...                 The acceptance criteria we verify here is
...                 "1: Review users registered in the system"

Resource                ../../Resources/CrfDemoApp.robot
Resource                ../../Resources/Common.robot
Resource                ../../Resources/DbManager.robot
Library                 ../../CustomLibs/CRUD_Library.py        base_url=http://0.0.0.0:8080/api


Suite Setup             Run keywords   Kill Web Application  AND   Replace Database With New Database Having Users  AND
...                     Start Web Application With No Init Procedure  AND
...                     Initialize Database Connection    AND    Verify Tables   AND    Fetch All System Users From Db  AND
...                     Filter System Users By  key=username

Suite Teardown          Kill Web Application


*** Keywords ***
Filter System Users By
    [Arguments]         ${key}
    ${SYSTEM_USERS_USERNAMES} =	    Create List
    FOR     ${system_user}      IN    @{SYSTEM_USERS}
        Append To List      ${SYSTEM_USERS_USERNAMES}       ${system_user}[${key}]
    END
	Set Suite Variable		@{SYSTEM_USERS_USERNAMES}

With Valid Token, Reading Users From API Should Return All System Users
    [Arguments]         ${system_user}
    ${headers} =        Create Dictionary       Token=${system_user}[token]
    ${response} =       GET     /users        headers=${headers}
    # verify the content of the successful response
    Should Be Equal As Strings      ${response}[status]     SUCCESS
    Lists Should Be Equal       ${SYSTEM_USERS_USERNAMES}   ${response}[payload]


*** Test Cases ***
With No Token, Reading Users From API Should Return Error
    ${response} =       GET     /users
    # verify the content of the failed response
    Should Be Equal As Strings      ${response}[status]     FAILURE

With Invalid Token, Reading Users From API Should Return Error
    ${headers} =        Create Dictionary       Token=Invalid Token
    ${response} =       GET     /users        headers=${headers}
    # verify the content of the failed response
    Should Be Equal As Strings      ${response}[status]     FAILURE

With Valid Token, Reading Users From API Matches With Users From DB
    [Template]          With Valid Token, Reading Users From API Should Return All System Users
    FOR     ${system_user}      IN      @{SYSTEM_USERS}
            ${system_user}
    END
