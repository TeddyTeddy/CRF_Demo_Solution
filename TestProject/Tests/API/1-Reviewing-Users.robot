*** Settings ***
Documentation       This test suite contains test cases for CRF Demo API.
...                 Documentation for the API can be found:
...                 https://github.com/Interview-demoapp/Flasky
...                 The acceptance criteria we verify here is
...                 "1: As an API Consumer, I can review users registered in the system"

Resource                ../../Resources/CrfDemoApp.robot
Resource                ../../Resources/Common.robot
Resource                ../../Resources/DbManager.robot
Library                 ../../CustomLibs/CRUD_Library.py        base_url=http://0.0.0.0:8080/api


Suite Setup             Run keywords   Kill Web Application  AND   Replace Database With New Database Having Users  AND
...                     Start Web Application With No Init Procedure  AND
...                     Initialize Database Connection    AND    Verify Tables   AND    Fetch All System Users From Db  AND
...                     Filter System Users By  username    \${SYSTEM_USERS_USERNAMES}

Suite Teardown          Kill Web Application


*** Keywords ***
Filter System Users By
    [Documentation]     This keyword expects SYSTEM_USERS suite variable being present in the suite.
    ...                 SYSTEM_USERS is a list of system users, each of which is a dictionary
    ...                 An example of a system user:
    ...                 {'username': 'SuperDuperUser1', 'firstname': 'David', 'lastname': 'Holm', 'phone': '0506627124', 'token': 'MTczNzAyNjc5NDg4Mzc1MzcwNDIwODAyOTM1NTExMjU4NzkzNDM2'}
    ...                 As you see, there are several keys such as username, firstname, lastname, phone and token.
    ...                 This keyword filters by SYSTEM_USERS with a given key (e.g. username).
    ...                 That is, all the usernames in SYSTEM_USERS are placed into a new list.
    ...                 Then this keyword sets a suite variable with that new list. The name of the suite variable
    ...                 is provided in DYNAMIC_VARIABLE_NAME variable.
    ...                 Some example usages:
    ...                 (1) gives all the usernames in SYSTEM_USERS_USERNAMES suite variable:
    ...                 Filter System Users By  username \${SYSTEM_USERS_USERNAMES}
    ...                 (2) gives all lastnames in SYSTEM_USERS_LASTNAMES suite variable:
    ...                 Filter System Users By  lastname \${SYSTEM_USERS_LASTNAMES}
    [Arguments]         ${key}      ${DYNAMIC_VARIABLE_NAME}
    ${list} =	    Create List
    FOR     ${system_user}      IN    @{SYSTEM_USERS}
        Append To List      ${list}        ${system_user}[${key}]
    END
	Set Suite Variable		${DYNAMIC_VARIABLE_NAME}    ${list}

With Valid Token, Reading Users From API Should Return All System Users' Usernames
    [Documentation]     The system_user parameter is a dictionary. An example:
    ...                 {'username': 'SuperDuperUser1', 'firstname': 'David', 'lastname': 'Holm', 'phone': '0506627124', 'token': 'MTczNzAyNjc5NDg4Mzc1MzcwNDIwODAyOTM1NTExMjU4NzkzNDM2'}
    ...                 This keyword uses the token of system_user to make a GET request.
    ...                 It then expects that response status is SUCCESS and the response payload
    ...                 contains usernames  (i.e. SYSTEM_USERS_USERNAMES) read from the database.
    [Arguments]         ${system_user}
    ${headers} =        Create Dictionary       Token=${system_user}[token]
    ${response} =       GET     /users        headers=${headers}
    # verify the content of the successful response
    Should Be Equal As Strings      ${response}[status]     SUCCESS
    Lists Should Be Equal       ${SYSTEM_USERS_USERNAMES}   ${response}[payload]


*** Test Cases ***
With No Token, Reading Users From API Should Return Error
    [Documentation]     Given no token, when reading usernames from API, the api
    ...                 must return FAILURE in its response status
    ${response} =       GET     /users
    # verify the content of the failed response
    Should Be Equal As Strings      ${response}[status]     FAILURE

With Invalid Token, Reading Users From API Should Return Error
    [Documentation]     Given an invalid token, when reading usernames from API, the api
    ...                 must return FAILURE in its response status
    ${headers} =        Create Dictionary       Token=Invalid Token
    ${response} =       GET     /users        headers=${headers}
    # verify the content of the failed response
    Should Be Equal As Strings      ${response}[status]     FAILURE

With Valid Token, Reading Users From API Matches With Users From DB
    [Documentation]     Valid token results in reading all users from the database regardless of the system_user
    ...                 That is, as long as system_user has a valid token, it can retrive usernames from the API.
    [Template]          With Valid Token, Reading Users From API Should Return All System Users' Usernames
    FOR     ${system_user}      IN      @{SYSTEM_USERS}
            ${system_user}
    END
