*** Settings ***
Documentation       This test suite contains test cases for CRF Demo API.
...                 Documentation for the API can be found:
...                 https://github.com/Interview-demoapp/Flasky
...                 The acceptance criteria we verify here is
...                 "3: As an API Consumer, if authenticated, I can update personal information of users"
...                 Definitions
...                 (1) System User: The user, who is registered to the system under test with a valid token
...                 (2) API User: The user, who calls the API to update personal information of the system user

Resource                ../../Resources/Common.robot
Resource                ../../Resources/DbManager.robot
Library                 ../../CustomLibs/CRUD_Library.py        base_url=http://0.0.0.0:8080/api

Suite Setup             Import DataManager
Test Setup              Run keywords   Kill Web Application  AND   Replace Database With New Database Having Users  AND
...                     Start Web Application With No Init Procedure  AND
...                     Initialize Database Connection    AND    Verify Tables   AND    Fetch All System Users From Db

Test Teardown           Kill Web Application


*** Keywords ***
Verify Response
    [Arguments]            ${response}     ${message}    ${status}
    Should Be Equal As Strings      ${response}[status]     ${status}
    Should Be Equal As Strings      ${response}[message]    ${message}

Verify System Users In Database Are Intact
    ${old_system_users} =       Copy List     ${SYSTEM_USERS}     deepcopy=True
    Fetch All System Users From Db
    Lists Should Be Equal    ${old_system_users}     ${SYSTEM_USERS}

With Valid Token, Attempt to Set Username To All System Users
    [Arguments]         ${token}     ${username}
    ${headers} =        Create Dictionary       Token=${token}
    ${payload} =        Create Dictionary       username=${username}
    FOR     ${system_user}      IN      @{SYSTEM_USERS}
            ${response} =       PUT     /users/${system_user}[username]        headers=${headers}   body=${payload}
            Verify Response     ${response}     message=Field update not allowed    status=FAILURE
            Verify System Users In Database Are Intact
    END

With Valid Token, Attempt to Set Password To All System Users
    [Arguments]         ${token}     ${password}
    ${headers} =        Create Dictionary       Token=${token}
    ${payload} =        Create Dictionary       password=${password}
    FOR     ${system_user}      IN      @{SYSTEM_USERS}
            ${response} =       PUT     /users/${system_user}[username]        headers=${headers}   body=${payload}
            Verify Response     ${response}     message=Field update not allowed    status=FAILURE
            Verify System Users In Database Are Intact
    END

Verify Response Based On Field Data
    [Arguments]         ${response}     ${field_data}
        IF  ${field_data}[isValid]   # if valid, firstname must be updated for system user
            Verify Response     ${response}     message=Updated    status=SUCCESS
        ELSE
            Verify Response     ${response}     message=${field_data}[expected_error]    status=FAILURE
        END

Verify System User's Data Updated In Database
    [Arguments]         ${target_user}      ${field_name}    ${value}
    Fetch All System Users From Db      # updates SYSTEM_USERS
    ${is_updated} =     Set Variable    ${False}
    ${is_found} =       Set Variable    ${False}
    FOR     ${system_user}  IN      @{SYSTEM_USERS}
        IF  $system_user['username']==$target_user['username']      # this is the system user we are looking for
            ${is_found} =       Set Variable    ${True}
            ${is_updated} =     Evaluate    $system_user[$field_name]==$value
        END
    END
    Should Be True  ${is_found}
    Should Be True  ${is_updated}

Verify System User's Data In Database
    [Arguments]     ${system_user}   ${field_name}    ${field_data}
    IF  ${field_data}[isValid]   # if valid, field_data must be updated for system user
        Verify System User's Data Updated In Database    ${system_user}      ${field_name}    ${field_data}[value]
    ELSE
        Verify System Users In Database Are Intact
    END

With Valid Token, Attempt to Set A Field For All System Users
    [Documentation]  A field_data is a dictionary. An example:
    ...     {
    ...         "value": "Helena!.?",
    ...         "isValid": false,
    ...         "description": "First name does contain non alphanumeric characters, which makes it invalid",
    ...         "expected_error": "Each first name must contain only characters from the set [a-zA-Z]. First names must be seperated by a a single space. First names must have at least 2 characters"
    ...     }
    ...     With the above field_data, say we want to change a system_user's firstname field.
    ...     To indicate that we are to change the firstname field, we set field_name argument to firstname
    [Arguments]         ${token}     ${field_name}    ${field_data}
    ${headers} =        Create Dictionary       Token=${token}
    ${payload} =        Create Dictionary       ${field_name}=${field_data}[value]
    FOR     ${system_user}      IN      @{SYSTEM_USERS}
            ${response} =       PUT     /users/${system_user}[username]        headers=${headers}   body=${payload}
            Verify Response Based On Field Data    ${response}     ${field_data}
            Verify System User's Data In Database  ${system_user}   ${field_name}    ${field_data}
    END


With Valid Token, Attempt to Set Given Fields For All System Users
    [Arguments]     ${token}        ${payload}      ${first_unknown_field}
    ${headers} =        Create Dictionary       Token=${token}
    Log     ${payload}
    FOR     ${system_user}      IN      @{SYSTEM_USERS}
            ${response} =       PUT     /users/${system_user}[username]        headers=${headers}   body=${payload}
            Verify Response     ${response}     message=Unknown field ${first_unknown_field}   status=FAILURE
            Verify System Users In Database Are Intact
    END

Compare System User With Payload     
    [Arguments]     ${system_user}     ${payload}
    IF  'firstname' in $payload.keys()
        Should Be Equal As Strings      ${system_user}[firstname]   ${payload}[firstname]
    END
    IF  'lastname' in $payload.keys()
        Should Be Equal As Strings      ${system_user}[lastname]   ${payload}[lastname]
    END
    IF  'phone' in $payload.keys()
        Should Be Equal As Strings      ${system_user}[phone]   ${payload}[phone]
    END

Verify System User's Data Updated In Database With Payload       
    [Arguments]     ${target_user}      ${payload}
    Fetch All System Users From Db      # updates SYSTEM_USERS
    ${is_updated} =     Set Variable    ${False}
    ${is_found} =       Set Variable    ${False}
    FOR     ${system_user}  IN      @{SYSTEM_USERS}
        IF  $system_user['username']==$target_user['username']      # this is the system user we are looking for
            ${is_found} =       Set Variable    ${True}
            Compare System User With Payload     ${system_user}     ${payload}   
        END
    END
    Should Be True  ${is_found}

With Valid Token, Update Given Fields For All System Users
    [Arguments]     ${token}        ${payload}
    ${headers} =        Create Dictionary       Token=${token}    
    Log     ${payload}
    FOR     ${system_user}      IN      @{SYSTEM_USERS}
            ${response} =       PUT     /users/${system_user}[username]        headers=${headers}   body=${payload}
            Verify Response     ${response}     message=Updated   status=SUCCESS
            Verify System User's Data Updated In Database With Payload       ${system_user}      ${payload}
    END

*** Test Cases ***
With Each Valid Token, Updating Username Of Each System User With '' Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 username as such:
    ...                 {
    ...                     "username": ''
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username=${EMPTY}
    END

With Each Valid Token, Updating Username Of Each System User With !#%&/¤% Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '!#%&/¤%'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username=!#%&/¤%
    END

With Each Valid Token, Updating Username Of Each System User With !#%&/¤%= Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '!#%&/¤%='
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username=!#%&/¤%=
    END

With Each Valid Token, Updating Username Of Each System User With !#%&/¤%=!()=? Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '!#%&/¤%=!()=?'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username=!#%&/¤%=!()=?
    END

With Each Valid Token, Updating Username Of Each System User With 1234567 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '1234567'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username=1234567
    END

With Each Valid Token, Updating Username Of Each System User With 12345678 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '12345678'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username=12345678
    END

With Each Valid Token, Updating Username Of Each System User With 12345678912345 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '12345678912345'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username=12345678912345
    END

With Each Valid Token, Updating Username Of Each System User With abcdefg Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": 'abcdefg'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username=abcdefg
    END

With Each Valid Token, Updating Username Of Each System User With abcdefgh Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": 'abcdefgh'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username=abcdefgh
    END

With Each Valid Token, Updating Username Of Each System User With abcdefghijklmnprstop Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": 'abcdefghijklmnprstop'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username=abcdefghijklmnprstop
    END

With Each Valid Token, Updating Username Of Each System User With hakan12 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": 'hakan12'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username=hakan12
    END

With Each Valid Token, Updating Username Of Each System User With hakan123 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": 'hakan123'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username=hakan123
    END

With Each Valid Token, Updating Username Of Each System User With hakan123456789123456789 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": 'hakan123456789123456789'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username=hakan123456789123456789
    END

With Each Valid Token, Updating Username Of Each System User With #¤%123! Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '#¤%123!'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username=#¤%123!
    END

With Each Valid Token, Updating Username Of Each System User With #¤%123!& Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '#¤%123!&'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username=#¤%123!&
    END

With Each Valid Token, Updating Username Of Each System User With #¤%123!&7683##()=?@#¤%&34567 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '#¤%123!&7683##()=?@#¤%&34567'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username=#¤%123!&7683##()=?@#¤%&34567
    END

With Each Valid Token, Updating Username Of Each System User With #¤123ab Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '#¤123ab'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username=#¤123ab
    END

With Each Valid Token, Updating Username Of Each System User With #¤123abc Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '#¤123abc'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username=#¤123abc
    END

With Each Valid Token, Updating Username Of Each System User With #¤/&¤!!123abc456hjk Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '#¤/&¤!!123abc456hjk'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username=#¤/&¤!!123abc456hjk
    END

With Each Valid Token, Updating Username Of Each System User With #¤/abc! Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '#¤/abc!'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username=#¤/abc!
    END

With Each Valid Token, Updating Username Of Each System User With #¤/abc!g Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '#¤/abc!g'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username=#¤/abc!g
    END

With Each Valid Token, Updating Username Of Each System User With #¤/abc!g()=&%¤fghjklQWERTY Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '#¤/abc!g()=&%¤fghjklQWERTY'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username=#¤/abc!g()=&%¤fghjklQWERTY
    END

With Each Valid Token, Updating Username Of Each System User With !# &/¤% Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '!# &/¤%'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username=!# &/¤%
    END

With Each Valid Token, Updating Username Of Each System User With !#%&/¤ = Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '!#%&/¤ ='
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username=!#%&/¤ =
    END

With Each Valid Token, Updating Username Of Each System User With !#%&/¤%= ()=? Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '!#%&/¤%= ()=?'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username=!#%&/¤%= ()=?
    END

With Each Valid Token, Updating Username Of Each System User With 1234 67 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '1234 67'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username=1234 67
    END

With Each Valid Token, Updating Username Of Each System User With 123456 8 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '123456 8'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username=123456 8
    END

With Each Valid Token, Updating Username Of Each System User With 12345678 12345 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '12345678 12345'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username=12345678 12345
    END

With Each Valid Token, Updating Username Of Each System User With abcd fg Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": 'abcd fg'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username=abcd fg
    END

With Each Valid Token, Updating Username Of Each System User With ab defgh Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": 'ab defgh'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username=ab defgh
    END

With Each Valid Token, Updating Username Of Each System User With abcdefghijklmnp stop Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": 'abcdefghijklmnp stop'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username=abcdefghijklmnp stop
    END

With Each Valid Token, Updating Username Of Each System User With haka 12 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": 'haka 12'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username=haka 12
    END

With Each Valid Token, Updating Username Of Each System User With haka 123 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": 'haka 123'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username=haka 123
    END

With Each Valid Token, Updating Username Of Each System User With haka 123456789123456789 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": 'haka 123456789123456789'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username=haka 123456789123456789
    END

With Each Valid Token, Updating Username Of Each System User With #¤% 23! Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '#¤% 23!'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username=#¤% 23!
    END

With Each Valid Token, Updating Username Of Each System User With # %123!& Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '# %123!&'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username=# %123!&
    END

With Each Valid Token, Updating Username Of Each System User With #¤%123!&7683##() ?@#¤%&34567 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '#¤%123!&7683##() ?@#¤%&34567'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username=#¤%123!&7683##() ?@#¤%&34567
    END

With Each Valid Token, Updating Username Of Each System User With #¤12 ab Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '#¤12 ab'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username=#¤12 ab
    END

With Each Valid Token, Updating Username Of Each System User With # 123abc Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '# 123abc'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username=# 123abc
    END

With Each Valid Token, Updating Username Of Each System User With #¤/&\ \ !123abc456hjk Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '#¤/&  !123abc456hjk'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username=#¤/&\ \ !123abc456hjk
    END

With Each Valid Token, Updating Username Of Each System User With #¤ abc! Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '#¤ abc!'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username=#¤ abc!
    END

With Each Valid Token, Updating Username Of Each System User With #¤ abc!g Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '#¤ abc!g'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username=#¤ abc!g
    END

With Each Valid Token, Updating Username Of Each System User With #¤/abc!g() &%¤fghjklQWERTY Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '#¤/abc!g() &%¤fghjklQWERTY'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username=#¤/abc!g() &%¤fghjklQWERTY
    END

With Each Valid Token, Updating Password Of Each System User With '' Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": ''
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=${EMPTY}
    END

With Each Valid Token, Updating Password Of Each System User With abcdefg Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'abcdefg'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=abcdefg
    END

With Each Valid Token, Updating Password Of Each System User With abcdefgh Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'abcdefgh'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=abcdefgh
    END

With Each Valid Token, Updating Password Of Each System User With abcdefghjklmnprstoöuüvyz Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'abcdefghjklmnprstoöuüvyz'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=abcdefghjklmnprstoöuüvyz
    END

With Each Valid Token, Updating Password Of Each System User With ABCDEFG Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'ABCDEFG'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=ABCDEFG
    END

With Each Valid Token, Updating Password Of Each System User With ABCDEFGH Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'ABCDEFGH'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=ABCDEFGH
    END

With Each Valid Token, Updating Password Of Each System User With ABCDEFGHJKLMNPRSTOÖUÜVYZ Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'ABCDEFGHJKLMNPRSTOÖUÜVYZ'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=ABCDEFGHJKLMNPRSTOÖUÜVYZ
    END

With Each Valid Token, Updating Password Of Each System User With 0123456 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": '0123456'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=0123456
    END

With Each Valid Token, Updating Password Of Each System User With 01234567 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": '01234567'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=01234567
    END

With Each Valid Token, Updating Password Of Each System User With 01234567890123456789 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": '01234567890123456789'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=01234567890123456789
    END

With Each Valid Token, Updating Password Of Each System User With !?.?!.! Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": '!?.?!.!'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=!?.?!.!
    END

With Each Valid Token, Updating Password Of Each System User With !?.?!.!? Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": '!?.?!.!?'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=!?.?!.!?
    END

With Each Valid Token, Updating Password Of Each System User With !?.?!.!?!?.?!.!?!.!. Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": '!?.?!.!?!?.?!.!?!.!.'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=!?.?!.!?!?.?!.!?!.!.
    END

With Each Valid Token, Updating Password Of Each System User With abcdABC Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'abcdABC'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=abcdABC
    END

With Each Valid Token, Updating Password Of Each System User With abcdABCD Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'abcdABCD'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=abcdABCD
    END

With Each Valid Token, Updating Password Of Each System User With abcdABCDefgjklmnprstoö Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'abcdABCDefgjklmnprstoö'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=abcdABCDefgjklmnprstoö
    END

With Each Valid Token, Updating Password Of Each System User With abcd012 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'abcd012'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=abcd012
    END

With Each Valid Token, Updating Password Of Each System User With abcd0123 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'abcd0123'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=abcd0123
    END

With Each Valid Token, Updating Password Of Each System User With abcd0123456789defghjk4 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'abcd0123456789defghjk4'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=abcd0123456789defghjk4
    END

With Each Valid Token, Updating Password Of Each System User With abcd!?. Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'abcd!?.'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=abcd!?.
    END

With Each Valid Token, Updating Password Of Each System User With abcd!?.! Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'abcd!?.!'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=abcd!?.!
    END

With Each Valid Token, Updating Password Of Each System User With abcd!?.!abcd!?.!abcd?? Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'abcd!?.!abcd!?.!abcd??'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=abcd!?.!abcd!?.!abcd??
    END

With Each Valid Token, Updating Password Of Each System User With ABCD012 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'ABCD012'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=ABCD012
    END

With Each Valid Token, Updating Password Of Each System User With ABCD0123 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'ABCD0123'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=ABCD0123
    END

With Each Valid Token, Updating Password Of Each System User With ABCD0123ABCD0123ABCD01 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'ABCD0123ABCD0123ABCD01'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=ABCD0123ABCD0123ABCD01
    END

With Each Valid Token, Updating Password Of Each System User With ABCD!?. Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'ABCD!?.'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=ABCD!?.
    END

With Each Valid Token, Updating Password Of Each System User With ABCD!?.. Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'ABCD!?..'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=ABCD!?..
    END

With Each Valid Token, Updating Password Of Each System User With ABCD!?..ABCD!?..ABCD!? Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'ABCD!?..ABCD!?..ABCD!?'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=ABCD!?..ABCD!?..ABCD!?
    END

With Each Valid Token, Updating Password Of Each System User With 0123!?. Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": '0123!?.'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=0123!?.
    END

With Each Valid Token, Updating Password Of Each System User With 0123!?.0 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": '0123!?.0'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=0123!?.0
    END

With Each Valid Token, Updating Password Of Each System User With 0123!?.00123!?.00123!? Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": '0123!?.00123!?.00123!?'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=0123!?.00123!?.00123!?
    END

With Each Valid Token, Updating Password Of Each System User With abcdAB9 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'abcdAB9'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=abcdAB9
    END

With Each Valid Token, Updating Password Of Each System User With abcdAB90 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'abcdAB90'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=abcdAB90
    END

With Each Valid Token, Updating Password Of Each System User With abcdAB90abcdAB90abcdAB Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'abcdAB90abcdAB90abcdAB'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=abcdAB90abcdAB90abcdAB
    END

With Each Valid Token, Updating Password Of Each System User With ABCabc! Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'ABCabc!'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=ABCabc!
    END

With Each Valid Token, Updating Password Of Each System User With ABCabc!? Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'ABCabc!?'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=ABCabc!?
    END

With Each Valid Token, Updating Password Of Each System User With ABCabc!?ABCabc!?ABCab. Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'ABCabc!?ABCabc!?ABCab.'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=ABCabc!?ABCabc!?ABCab.
    END

With Each Valid Token, Updating Password Of Each System User With abc012. Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'abc012.'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=abc012.
    END

With Each Valid Token, Updating Password Of Each System User With abc012!? Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'abc012!?'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=abc012!?
    END

With Each Valid Token, Updating Password Of Each System User With abc012!?abc012!?abc012 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'abc012!?abc012!?abc012'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=abc012!?abc012!?abc012
    END

With Each Valid Token, Updating Password Of Each System User With abc!?.Z Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'abc!?.Z'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=abc!?.Z
    END

With Each Valid Token, Updating Password Of Each System User With abc!?.ZA Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'abc!?.ZA'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=abc!?.ZA
    END

With Each Valid Token, Updating Password Of Each System User With abc!?.ZAabc!?.ZAabc!?. Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'abc!?.ZAabc!?.ZAabc!?.'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=abc!?.ZAabc!?.ZAabc!?.
    END

With Each Valid Token, Updating Password Of Each System User With abc!?.6 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'abc!?.6'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=abc!?.6
    END

With Each Valid Token, Updating Password Of Each System User With abc!?.67 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'abc!?.67'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=abc!?.67
    END

With Each Valid Token, Updating Password Of Each System User With abc!?.67abc!?.67abc!?. Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'abc!?.67abc!?.67abc!?.'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=abc!?.67abc!?.67abc!?.
    END

With Each Valid Token, Updating Password Of Each System User With ABC456. Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'ABC456.'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=ABC456.
    END

With Each Valid Token, Updating Password Of Each System User With ABC456.? Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'ABC456.?'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=ABC456.?
    END

With Each Valid Token, Updating Password Of Each System User With ABC456.?ABC456.?ABC456 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'ABC456.?ABC456.?ABC456'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=ABC456.?ABC456.?ABC456
    END

With Each Valid Token, Updating Password Of Each System User With ABC!?.0 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'ABC!?.0'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=ABC!?.0
    END

With Each Valid Token, Updating Password Of Each System User With ABC!?.01 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'ABC!?.01'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=ABC!?.01
    END

With Each Valid Token, Updating Password Of Each System User With ABC!?.01ABC!?.01ABC!?. Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'ABC!?.01ABC!?.01ABC!?.'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=ABC!?.01ABC!?.01ABC!?.
    END

With Each Valid Token, Updating Password Of Each System User With 012!.Aa Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": '012!.Aa'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=012!.Aa
    END

With Each Valid Token, Updating Password Of Each System User With 012!.Aab Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": '012!.Aab'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=012!.Aab
    END

With Each Valid Token, Updating Password Of Each System User With 012!.Aab012!.Aab012!.A Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": '012!.Aab012!.Aab012!.A'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password=012!.Aab012!.Aab012!.A
    END

With Each Valid Token, Updating First Name Of Each System User With '' Results In Failure Status With Right Error Message
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 firstname as such:
    ...                 {
    ...                     "firstname": ''
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Each first name must contain only characters from the set [a-zA-Z]. First names must be seperated by a a single space. First names must have at least 2 characters",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    ${user_data} =     Get Valid User's Registration Form Data
    # at this stage, user_data is valid
    # make it have the right firstname for testing purposes
    Manipulate      ${user_data}       first_name    An empty first name
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            With Valid Token, Attempt to Set A Field For All System Users
            ...     token=${api_user}[token]     field_name=firstname   field_data=${user_data}[first_name]
    END

With Each Valid Token, Updating First Name Of Each System User With Hakan Results In Success
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 firstname as such:
    ...                 {
    ...                     "firstname": 'Hakan'
    ...                 }
    ...                 Then, each request should succeed with the following response body:
    ...                 {
    ...                     "message": "Updated",
    ...                     "status": "SUCCESS"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that the <username>'s data in the database has changed.
    ${user_data} =     Get Valid User's Registration Form Data
    # at this stage, user_data is valid
    # make it have the right firstname for testing purposes
    Manipulate      ${user_data}       first_name    A first name containing more than 2 characters
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            With Valid Token, Attempt to Set A Field For All System Users
            ...     token=${api_user}[token]      field_name=firstname   field_data=${user_data}[first_name]
    END

With Each Valid Token, Updating First Name Of Each System User With Hakan123!?. Results In Failure Status With Right Error Message
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 firstname as such:
    ...                 {
    ...                     "firstname": 'Hakan123!?.'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Each first name must contain only characters from the set [a-zA-Z]. First names must be seperated by a a single space. First names must have at least 2 characters",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    ${user_data} =     Get Valid User's Registration Form Data
    # at this stage, user_data is valid
    # make it have the right firstname for testing purposes
    Manipulate      ${user_data}       first_name    A name containing numbers and non-alphanumeric characters
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            With Valid Token, Attempt to Set A Field For All System Users
            ...     token=${api_user}[token]      field_name=firstname   field_data=${user_data}[first_name]
    END

With Each Valid Token, Updating First Name Of Each System User With Ha Results In Success
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 firstname as such:
    ...                 {
    ...                     "firstname": 'Ha'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Updated",
    ...                     "status": "SUCCESS"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that the <username>'s data in the database has changed.
    ${user_data} =     Get Valid User's Registration Form Data
    # at this stage, user_data is valid
    # make it have the right firstname for testing purposes
    Manipulate      ${user_data}       first_name    A minimum 2 characters first name
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            With Valid Token, Attempt to Set A Field For All System Users
            ...     token=${api_user}[token]      field_name=firstname   field_data=${user_data}[first_name]
    END

With Each Valid Token, Updating First Name Of Each System User With Ha Xu Results In Success
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 firstname as such:
    ...                 {
    ...                     "firstname": 'Ha Xu'
    ...                 }
    ...                 Then, each request should succeed with the following response body:
    ...                 {
    ...                     "message": "Updated",
    ...                     "status": "SUCCESS"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that the <username>'s data in the database has changed.
    ${user_data} =     Get Valid User's Registration Form Data
    # at this stage, user_data is valid
    # make it have the right firstname for testing purposes
    Manipulate      ${user_data}       first_name    minimum 2 characters first names for each first name
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            With Valid Token, Attempt to Set A Field For All System Users
            ...     token=${api_user}[token]      field_name=firstname   field_data=${user_data}[first_name]
    END

With Each Valid Token, Updating First Name Of Each System User With H Xu Results In Failure Status With Right Error Message
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 firstname as such:
    ...                 {
    ...                     "firstname": 'H Xu'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Each first name must contain only characters from the set [a-zA-Z]. First names must be seperated by a a single space. First names must have at least 2 characters",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    ${user_data} =     Get Valid User's Registration Form Data
    # at this stage, user_data is valid
    # make it have the right firstname for testing purposes
    Manipulate      ${user_data}       first_name    The first first name is invalid with only 1 letter, the second first name is valid
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            With Valid Token, Attempt to Set A Field For All System Users
            ...     token=${api_user}[token]      field_name=firstname   field_data=${user_data}[first_name]
    END

With Each Valid Token, Updating First Name Of Each System User With Ha X Results In Failure Status With Right Error Message
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 firstname as such:
    ...                 {
    ...                     "firstname": 'Ha X'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Each first name must contain only characters from the set [a-zA-Z]. First names must be seperated by a a single space. First names must have at least 2 characters",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    ${user_data} =     Get Valid User's Registration Form Data
    # at this stage, user_data is valid
    # make it have the right firstname for testing purposes
    Manipulate      ${user_data}       first_name    The second first name is invalid with only 1 letter, the first first name is valid
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            With Valid Token, Attempt to Set A Field For All System Users
            ...     token=${api_user}[token]      field_name=firstname   field_data=${user_data}[first_name]
    END

With Each Valid Token, Updating First Name Of Each System User With H X Results In Failure Status With Right Error Message
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 firstname as such:
    ...                 {
    ...                     "firstname": 'H X'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Each first name must contain only characters from the set [a-zA-Z]. First names must be seperated by a a single space. First names must have at least 2 characters",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    ${user_data} =     Get Valid User's Registration Form Data
    # at this stage, user_data is valid
    # make it have the right firstname for testing purposes
    Manipulate      ${user_data}       first_name    The both first names are invalid with only 1 letter
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            With Valid Token, Attempt to Set A Field For All System Users
            ...     token=${api_user}[token]      field_name=firstname   field_data=${user_data}[first_name]
    END

With Each Valid Token, Updating First Name Of Each System User With Helena123 Results In Failure Status With Right Error Message
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 firstname as such:
    ...                 {
    ...                     "firstname": 'Helena123'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Each first name must contain only characters from the set [a-zA-Z]. First names must be seperated by a a single space. First names must have at least 2 characters",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    ${user_data} =     Get Valid User's Registration Form Data
    # at this stage, user_data is valid
    # make it have the right firstname for testing purposes
    Manipulate      ${user_data}       first_name    First name does contain numbers, which makes it invalid
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            With Valid Token, Attempt to Set A Field For All System Users
            ...     token=${api_user}[token]      field_name=firstname   field_data=${user_data}[first_name]
    END

With Each Valid Token, Updating First Name Of Each System User With Helena!.? Results In Failure Status With Right Error Message
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 firstname as such:
    ...                 {
    ...                     "firstname": 'Helena!.?'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Each first name must contain only characters from the set [a-zA-Z]. First names must be seperated by a a single space. First names must have at least 2 characters",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    ${user_data} =     Get Valid User's Registration Form Data
    # at this stage, user_data is valid
    # make it have the right firstname for testing purposes
    Manipulate      ${user_data}       first_name    First name does contain non alphanumeric characters, which makes it invalid
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            With Valid Token, Attempt to Set A Field For All System Users
            ...     token=${api_user}[token]      field_name=firstname   field_data=${user_data}[first_name]
    END

With Each Valid Token, Updating First Name Of Each System User With Helena Margaretha Results In Success
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 firstname as such:
    ...                 {
    ...                     "firstname": 'Helena Margaretha'
    ...                 }
    ...                 Then, each request should succeed with the following response body:
    ...                 {
    ...                     "message": "Updated",
    ...                     "status": "SUCCESS"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that the <username>'s data in the database has changed.
    ${user_data} =     Get Valid User's Registration Form Data
    # at this stage, user_data is valid
    # make it have the right firstname for testing purposes
    Manipulate      ${user_data}       first_name    Two valid first names seperated by a single space character
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            With Valid Token, Attempt to Set A Field For All System Users
            ...     token=${api_user}[token]      field_name=firstname   field_data=${user_data}[first_name]
    END

With Each Valid Token, Updating First Name Of Each System User With Helena\ \ \ \ \ \ Margaretha Results In Failure Status With Right Error Message
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 firstname as such:
    ...                 {
    ...                     "firstname": 'Helena      Margaretha'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Each first name must contain only characters from the set [a-zA-Z]. First names must be seperated by a a single space. First names must have at least 2 characters",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    ${user_data} =     Get Valid User's Registration Form Data
    # at this stage, user_data is valid
    # make it have the right firstname for testing purposes
    Manipulate      ${user_data}       first_name    Two valid first names seperated by multiple space characters making it invalid
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            With Valid Token, Attempt to Set A Field For All System Users
            ...     token=${api_user}[token]      field_name=firstname   field_data=${user_data}[first_name]
    END

With Each Valid Token, Updating Last Name Of Each System User With '' Results In Failure Status With Right Error Message
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 lastname as such:
    ...                 {
    ...                     "lastname": ''
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Each last name must contain only characters from the set [a-zA-Z]. Last names must be seperated by a a single space. Last names must have at least 2 characters",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    ${user_data} =     Get Valid User's Registration Form Data
    # at this stage, user_data is valid
    # make it have the right lastname for testing purposes
    Manipulate      ${user_data}       last_name    An empty last name
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            With Valid Token, Attempt to Set A Field For All System Users
            ...     token=${api_user}[token]     field_name=lastname   field_data=${user_data}[last_name]
    END

With Each Valid Token, Updating Last Name Of Each System User With Cuzdan Results In Success
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 lastname as such:
    ...                 {
    ...                     "lastname": 'Cuzdan'
    ...                 }
    ...                 Then, each request should succeed with the following response body:
    ...                 {
    ...                     "message": "Updated",
    ...                     "status": "SUCCESS"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that the <username>'s data in the database has changed.
    ${user_data} =     Get Valid User's Registration Form Data
    # at this stage, user_data is valid
    # make it have the right lastname for testing purposes
    Manipulate      ${user_data}       last_name    A last name containing more than 2 characters
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            With Valid Token, Attempt to Set A Field For All System Users
            ...     token=${api_user}[token]      field_name=lastname   field_data=${user_data}[last_name]
    END

With Each Valid Token, Updating Last Name Of Each System User With Cuzdan123!?. Results In Failure Status With Right Error Message
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 lastname as such:
    ...                 {
    ...                     "lastname": 'Cuzdan123!?.'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Each last name must contain only characters from the set [a-zA-Z]. Last names must be seperated by a a single space. Last names must have at least 2 characters",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    ${user_data} =     Get Valid User's Registration Form Data
    # at this stage, user_data is valid
    # make it have the right lastname for testing purposes
    Manipulate      ${user_data}       last_name    A last name containing numbers and non-alphanumeric characters
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            With Valid Token, Attempt to Set A Field For All System Users
            ...     token=${api_user}[token]     field_name=lastname   field_data=${user_data}[last_name]
    END

With Each Valid Token, Updating Last Name Of Each System User With Wi Results In Success
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 lastname as such:
    ...                 {
    ...                     "lastname": 'Wi'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Updated",
    ...                     "status": "SUCCESS"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that the <username>'s data in the database has changed.
    ${user_data} =     Get Valid User's Registration Form Data
    # at this stage, user_data is valid
    # make it have the right lastname for testing purposes
    Manipulate      ${user_data}       last_name    2 character last name with only one word
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            With Valid Token, Attempt to Set A Field For All System Users
            ...     token=${api_user}[token]      field_name=lastname   field_data=${user_data}[last_name]
    END

With Each Valid Token, Updating Last Name Of Each System User With Wi Xi Results In Success
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 lastname as such:
    ...                 {
    ...                     "lastname": 'Wi Xi'
    ...                 }
    ...                 Then, each request should succeed with the following response body:
    ...                 {
    ...                     "message": "Updated",
    ...                     "status": "SUCCESS"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that the <username>'s data in the database has changed.
    ${user_data} =     Get Valid User's Registration Form Data
    # at this stage, user_data is valid
    # make it have the right lastname for testing purposes
    Manipulate      ${user_data}       last_name    2 characters last name with two words
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            With Valid Token, Attempt to Set A Field For All System Users
            ...     token=${api_user}[token]      field_name=lastname   field_data=${user_data}[last_name]
    END

With Each Valid Token, Updating Last Name Of Each System User With W Xi Results In Failure Status With Right Error Message
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 lastname as such:
    ...                 {
    ...                     "lastname": 'W Xi'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Each last name must contain only characters from the set [a-zA-Z]. Last names must be seperated by a a single space. Last names must have at least 2 characters",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    ${user_data} =     Get Valid User's Registration Form Data
    # at this stage, user_data is valid
    # make it have the right lastname for testing purposes
    Manipulate      ${user_data}       last_name    The first last name is invalid with only 1 letter, the second last name is valid
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            With Valid Token, Attempt to Set A Field For All System Users
            ...     token=${api_user}[token]     field_name=lastname   field_data=${user_data}[last_name]
    END

With Each Valid Token, Updating Last Name Of Each System User With Wi X Results In Failure Status With Right Error Message
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 lastname as such:
    ...                 {
    ...                     "lastname": 'Wi X'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Each last name must contain only characters from the set [a-zA-Z]. Last names must be seperated by a a single space. Last names must have at least 2 characters",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    ${user_data} =     Get Valid User's Registration Form Data
    # at this stage, user_data is valid
    # make it have the right lastname for testing purposes
    Manipulate      ${user_data}       last_name    The second last name is invalid with only 1 letter, the first last name is valid
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            With Valid Token, Attempt to Set A Field For All System Users
            ...     token=${api_user}[token]     field_name=lastname   field_data=${user_data}[last_name]
    END

With Each Valid Token, Updating Last Name Of Each System User With W X Results In Failure Status With Right Error Message
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 lastname as such:
    ...                 {
    ...                     "lastname": 'W X'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Each last name must contain only characters from the set [a-zA-Z]. Last names must be seperated by a a single space. Last names must have at least 2 characters",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    ${user_data} =     Get Valid User's Registration Form Data
    # at this stage, user_data is valid
    # make it have the right lastname for testing purposes
    Manipulate      ${user_data}       last_name    The both last names are invalid because they only have 1 letter
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            With Valid Token, Attempt to Set A Field For All System Users
            ...     token=${api_user}[token]     field_name=lastname   field_data=${user_data}[last_name]
    END

With Each Valid Token, Updating Last Name Of Each System User With Holm123 Results In Failure Status With Right Error Message
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 lastname as such:
    ...                 {
    ...                     "lastname": 'Holm123'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Each last name must contain only characters from the set [a-zA-Z]. Last names must be seperated by a a single space. Last names must have at least 2 characters",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    ${user_data} =     Get Valid User's Registration Form Data
    # at this stage, user_data is valid
    # make it have the right lastname for testing purposes
    Manipulate      ${user_data}       last_name    Last name does contain numbers, which makes it invalid
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            With Valid Token, Attempt to Set A Field For All System Users
            ...     token=${api_user}[token]     field_name=lastname   field_data=${user_data}[last_name]
    END

With Each Valid Token, Updating Last Name Of Each System User With Holm!.? Results In Failure Status With Right Error Message
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 lastname as such:
    ...                 {
    ...                     "lastname": 'Holm!.?'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Each last name must contain only characters from the set [a-zA-Z]. Last names must be seperated by a a single space. Last names must have at least 2 characters",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    ${user_data} =     Get Valid User's Registration Form Data
    # at this stage, user_data is valid
    # make it have the right lastname for testing purposes
    Manipulate      ${user_data}       last_name    Last name does contain non alphanumeric characters, which makes it invalid
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            With Valid Token, Attempt to Set A Field For All System Users
            ...     token=${api_user}[token]     field_name=lastname   field_data=${user_data}[last_name]
    END

With Each Valid Token, Updating Last Name Of Each System User With Holm Cuzdan Results In Success
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 lastname as such:
    ...                 {
    ...                     "lastname": 'Holm Cuzdan'
    ...                 }
    ...                 Then, each request should succeed with the following response body:
    ...                 {
    ...                     "message": "Updated",
    ...                     "status": "SUCCESS"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that the <username>'s data in the database has changed.
    ${user_data} =     Get Valid User's Registration Form Data
    # at this stage, user_data is valid
    # make it have the right lastname for testing purposes
    Manipulate      ${user_data}       last_name    Two valid last names seperated by a single space character
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            With Valid Token, Attempt to Set A Field For All System Users
            ...     token=${api_user}[token]      field_name=lastname   field_data=${user_data}[last_name]
    END

With Each Valid Token, Updating Last Name Of Each System User With Holm\ \ \ \ \ \ Cuzdan Results In Failure Status With Right Error Message
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 lastname as such:
    ...                 {
    ...                     "lastname": 'Holm      Cuzdan'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Each last name must contain only characters from the set [a-zA-Z]. Last names must be seperated by a a single space. Last names must have at least 2 characters",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    ${user_data} =     Get Valid User's Registration Form Data
    # at this stage, user_data is valid
    # make it have the right lastname for testing purposes
    Manipulate      ${user_data}       last_name    Two valid last names seperated by many space characters
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            With Valid Token, Attempt to Set A Field For All System Users
            ...     token=${api_user}[token]     field_name=lastname   field_data=${user_data}[last_name]
    END

With Each Valid Token, Updating Phone Number Of Each System User With Empty String Results In Failure Status With Right Error Message
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 phone number as such:
    ...                 {
    ...                     "phone": ''
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "mandatory phone number can only contain numbers [0-9] and optionally a single plus sign at the beginning indicating the country code",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    ${user_data} =     Get Valid User's Registration Form Data
    # at this stage, user_data is valid
    # make it have the right phone number for testing purposes
    Manipulate      ${user_data}       phone_number    An empty phone number
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            With Valid Token, Attempt to Set A Field For All System Users
            ...     token=${api_user}[token]     field_name=phone   field_data=${user_data}[phone_number]
    END

With Each Valid Token, Updating Phone Number Of Each System User With +358506662712 Results In Success
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 phone number as such:
    ...                 {
    ...                     "phone": '+358506662712'
    ...                 }
    ...                 Then, each request should succeed with the following response body:
    ...                 {
    ...                     "message": "Updated",
    ...                     "status": "SUCCESS"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that the <username>'s data in the database has changed.
    ${user_data} =     Get Valid User's Registration Form Data
    # at this stage, user_data is valid
    # make it have the right phone number for testing purposes
    Manipulate      ${user_data}       phone_number    A valid phone number with a country code +358
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            With Valid Token, Attempt to Set A Field For All System Users
            ...     token=${api_user}[token]      field_name=phone   field_data=${user_data}[phone_number]
    END

With Each Valid Token, Updating Phone Number Of Each System User With +358+50666+2712 Results In Failure Status With Right Error Message
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 phone number as such:
    ...                 {
    ...                     "phone": '+358+50666+2712'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "mandatory phone number can only contain numbers [0-9] and optionally a single plus sign at the beginning indicating the country code",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    ${user_data} =     Get Valid User's Registration Form Data
    # at this stage, user_data is valid
    # make it have the right phone number for testing purposes
    Manipulate      ${user_data}       phone_number    An invalid phone number with a country code with second and third + signs misplaced
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            With Valid Token, Attempt to Set A Field For All System Users
            ...     token=${api_user}[token]     field_name=phone   field_data=${user_data}[phone_number]
    END

With Each Valid Token, Updating Phone Number Of Each System User With 0+506662712+ Results In Failure Status With Right Error Message
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 phone number as such:
    ...                 {
    ...                     "phone": '0+506662712+'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "mandatory phone number can only contain numbers [0-9] and optionally a single plus sign at the beginning indicating the country code",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    ${user_data} =     Get Valid User's Registration Form Data
    # at this stage, user_data is valid
    # make it have the right phone number for testing purposes
    Manipulate      ${user_data}       phone_number    An invalid phone number with two + signs misplaced
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            With Valid Token, Attempt to Set A Field For All System Users
            ...     token=${api_user}[token]     field_name=phone   field_data=${user_data}[phone_number]
    END

With Each Valid Token, Updating Phone Number Of Each System User With 0506662712 Results In Success
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 phone number as such:
    ...                 {
    ...                     "phone": '0506662712'
    ...                 }
    ...                 Then, each request should succeed with the following response body:
    ...                 {
    ...                     "message": "Updated",
    ...                     "status": "SUCCESS"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that the <username>'s data in the database has changed.
    ${user_data} =     Get Valid User's Registration Form Data
    # at this stage, user_data is valid
    # make it have the right phone number for testing purposes
    Manipulate      ${user_data}       phone_number    A valid phone number without a country code. This assumes Finland
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            With Valid Token, Attempt to Set A Field For All System Users
            ...     token=${api_user}[token]      field_name=phone   field_data=${user_data}[phone_number]
    END

With Each Valid Token, Updating Phone Number Of Each System User With +358506abc!#662712 Results In Failure Status With Right Error Message
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 phone number as such:
    ...                 {
    ...                     "phone": '+358506abc!#662712'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "mandatory phone number can only contain numbers [0-9] and optionally a single plus sign at the beginning indicating the country code",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    ${user_data} =     Get Valid User's Registration Form Data
    # at this stage, user_data is valid
    # make it have the right phone number for testing purposes
    Manipulate      ${user_data}       phone_number    An invalid phone number containing letters, non-alphanumeric characters
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            With Valid Token, Attempt to Set A Field For All System Users
            ...     token=${api_user}[token]     field_name=phone   field_data=${user_data}[phone_number]
    END

With Each Valid Token, Updating Phone Number Of Each System User With 050!?.#662712 Results In Failure Status With Right Error Message
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 phone number as such:
    ...                 {
    ...                     "phone": '050!?.#662712'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "mandatory phone number can only contain numbers [0-9] and optionally a single plus sign at the beginning indicating the country code",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    ${user_data} =     Get Valid User's Registration Form Data
    # at this stage, user_data is valid
    # make it have the right phone number for testing purposes
    Manipulate      ${user_data}       phone_number    An invalid phone number containing non-alphanumeric characters
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            With Valid Token, Attempt to Set A Field For All System Users
            ...     token=${api_user}[token]     field_name=phone   field_data=${user_data}[phone_number]
    END

With Each Valid Token, Updating Phone Number Of Each System User With +358abc662712xyz Results In Failure Status With Right Error Message
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 phone number as such:
    ...                 {
    ...                     "phone": '+358abc662712xyz'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "mandatory phone number can only contain numbers [0-9] and optionally a single plus sign at the beginning indicating the country code",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    ${user_data} =     Get Valid User's Registration Form Data
    # at this stage, user_data is valid
    # make it have the right phone number for testing purposes
    Manipulate      ${user_data}       phone_number    An invalid phone number containing letters in between
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            With Valid Token, Attempt to Set A Field For All System Users
            ...     token=${api_user}[token]     field_name=phone   field_data=${user_data}[phone_number]
    END

With Each Valid Token, Updating Phone Number Of Each System User With +35840 687 54 53 Results In Failure Status With Right Error Message
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set an empty
    ...                 phone number as such:
    ...                 {
    ...                     "phone": '+35840 687 54 53'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "mandatory phone number can only contain numbers [0-9] and optionally a single plus sign at the beginning indicating the country code",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    ${user_data} =     Get Valid User's Registration Form Data
    # at this stage, user_data is valid
    # make it have the right phone number for testing purposes
    Manipulate      ${user_data}       phone_number    An invalid phone number containing spaces in between digits
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            With Valid Token, Attempt to Set A Field For All System Users
            ...     token=${api_user}[token]     field_name=phone   field_data=${user_data}[phone_number]
    END

With Each Valid Token, Updating Each System User With Unknown Field Results In Failure Status With Right Error Message
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set:
    ...                 {
    ...                     "firstname": "Hakan",
    ...                     "lastname": "Cuzdan",
    ...                     "phone": '+358406875453',
    ...                     "alien_field_one": "some value"
    ...                 }
    ...                 Note that firstname, lastname and phone are valid, and alien_field_one is not available in user table in SUT.
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "unknown field alien_field_one",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    ${payload} =     Create Dictionary
    # manipulate payload for testing purposes
    Set To Dictionary     ${payload}      firstname=Hakan
    Set To Dictionary     ${payload}      lastname=Cuzdan
    Set To Dictionary     ${payload}      phone=+358406875453
    Set To Dictionary     ${payload}      alien_field_one=some value
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            With Valid Token, Attempt to Set Given Fields For All System Users
            ...     ${api_user}[token]     ${payload}   alien_field_one
    END

With Each Valid Token, Updating Each System User With Multiple Unknown Fields Results In Failure Status With Right Error Message
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set:
    ...                 {
    ...                     "firstname": "Hakan",
    ...                     "lastname": "Cuzdan",
    ...                     "phone": '+358406875453',
    ...                     "alien_field_one": "some value",
    ...                     "alien_field_two": "some other value"
    ...                 }
    ...                 Note that firstname, lastname and phone are valid, and alien_field_one is not available in user table in SUT.
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "unknown field alien_field_one",
    ...                     "status": "FAILURE"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that no data in the database has changed.
    ${payload} =     Create Dictionary
    # manipulate payload for testing purposes
    Set To Dictionary     ${payload}      firstname=Hakan
    Set To Dictionary     ${payload}      lastname=Cuzdan
    Set To Dictionary     ${payload}      phone=+358406875453
    Set To Dictionary     ${payload}      alien_field_one=some value
    Set To Dictionary     ${payload}      alien_field_two=some other value
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            With Valid Token, Attempt to Set Given Fields For All System Users
            ...     ${api_user}[token]     ${payload}   alien_field_one
    END

All System Users With A Valid Token Can Update Firstname, Lastname And Phone Of All System Users With Valid Values
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set:
    ...                 {
    ...                     "firstname": "Hakan",
    ...                     "lastname": "Cuzdan",
    ...                     "phone": '+358406875453'
    ...                 }
    ...                 Note that firstname, lastname and phone are valid.
    ...                 Then, each request should pass with the following response body:
    ...                 {
    ...                     "message": "Updated",
    ...                     "status": "SUCCESS"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that <username>'s data in the database has changed.
    [Tags]      run-me
    ${payload} =     Create Dictionary
    # manipulate payload for testing purposes
    Set To Dictionary     ${payload}      firstname=Hakan       # firstname is a field in SUT's database
    Set To Dictionary     ${payload}      lastname=Cuzdan       # lastname is a field in SUT's database
    Set To Dictionary     ${payload}      phone=+358406875453   # phone is a field in SUT's database
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            With Valid Token, Update Given Fields For All System Users
            ...     ${api_user}[token]     ${payload}
    END

All System Users With A Valid Token Can Update Firstname And Lastname Of All System Users With Valid Values
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set:
    ...                 {
    ...                     "firstname": "Hakan",
    ...                     "lastname": "Cuzdan"
    ...                 }
    ...                 Note that firstname, lastname are valid.
    ...                 Then, each request should pass with the following response body:
    ...                 {
    ...                     "message": "Updated",
    ...                     "status": "SUCCESS"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that <username>'s data in the database has changed.
    [Tags]      run-me
    ${payload} =     Create Dictionary
    # manipulate payload for testing purposes
    Set To Dictionary     ${payload}      firstname=Hakan       # firstname is a field in SUT's database
    Set To Dictionary     ${payload}      lastname=Cuzdan       # lastname is a field in SUT's database
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            With Valid Token, Update Given Fields For All System Users
            ...     ${api_user}[token]     ${payload}
    END

All System Users With A Valid Token Can Update Firstname And Phone Of All System Users With Valid Values
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set:
    ...                 {
    ...                     "firstname": "Hakan",
    ...                     "phone": '+358406875453'
    ...                 }
    ...                 Note that firstname and phone are valid.
    ...                 Then, each request should pass with the following response body:
    ...                 {
    ...                     "message": "Updated",
    ...                     "status": "SUCCESS"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that <username>'s data in the database has changed.
    [Tags]      run-me
    ${payload} =     Create Dictionary
    # manipulate payload for testing purposes
    Set To Dictionary     ${payload}      firstname=Hakan       # firstname is a field in SUT's database
    Set To Dictionary     ${payload}      phone=+358406875453   # phone is a field in SUT's database
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            With Valid Token, Update Given Fields For All System Users
            ...     ${api_user}[token]     ${payload}
    END

All System Users With A Valid Token Can Update Lastname And Phone Of All System Users With Valid Values
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set:
    ...                 {
    ...                     "lastname": "Cuzdan",
    ...                     "phone": '+358406875453'
    ...                 }
    ...                 Note that lastname and phone are valid.
    ...                 Then, each request should pass with the following response body:
    ...                 {
    ...                     "message": "Updated",
    ...                     "status": "SUCCESS"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that <username>'s data in the database has changed.
    [Tags]      run-me
    ${payload} =     Create Dictionary
    # manipulate payload for testing purposes
    Set To Dictionary     ${payload}      lastname=Cuzdan       # lastname is a field in SUT's database
    Set To Dictionary     ${payload}      phone=+358406875453   # phone is a field in SUT's database
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            With Valid Token, Update Given Fields For All System Users
            ...     ${api_user}[token]     ${payload}
    END

All System Users With A Valid Token Can Update Firstname Of All System Users With Valid Values
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set:
    ...                 {
    ...                     "firstname": "Hakan"
    ...                 }
    ...                 Note that firstname is valid.
    ...                 Then, each request should pass with the following response body:
    ...                 {
    ...                     "message": "Updated",
    ...                     "status": "SUCCESS"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that <username>'s data in the database has changed.
    [Tags]      run-me
    ${payload} =     Create Dictionary
    # manipulate payload for testing purposes
    Set To Dictionary     ${payload}      firstname=Hakan       # firstname is a field in SUT's database
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            With Valid Token, Update Given Fields For All System Users
            ...     ${api_user}[token]     ${payload}
    END

All System Users With A Valid Token Can Update Lastname Of All System Users With Valid Values
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set:
    ...                 {
    ...                     "lastname": "Cuzdan"
    ...                 }
    ...                 Note that firstname, lastname and phone are valid.
    ...                 Then, each request should pass with the following response body:
    ...                 {
    ...                     "message": "Updated",
    ...                     "status": "SUCCESS"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that <username>'s data in the database has changed.
    [Tags]      run-me
    ${payload} =     Create Dictionary
    # manipulate payload for testing purposes
    Set To Dictionary     ${payload}      lastname=Cuzdan       # lastname is a field in SUT's database
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            With Valid Token, Update Given Fields For All System Users
            ...     ${api_user}[token]     ${payload}
    END

All System Users With A Valid Token Can Update Phone Of All System Users With Valid Values
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes multiple PUT requests to /api/users/<username>
    ...                 where <username> is replaced with each system user's username. In the requests' body, we set:
    ...                 {
    ...                     "phone": '+358406875453'
    ...                 }
    ...                 Note that phone is valid.
    ...                 Then, each request should pass with the following response body:
    ...                 {
    ...                     "message": "Updated",
    ...                     "status": "SUCCESS"
    ...                 }
    ...                 This test not only verifies message and status but also verifies that <username>'s data in the database has changed.
    [Tags]      run-me
    ${payload} =     Create Dictionary
    # manipulate payload for testing purposes
    Set To Dictionary     ${payload}      phone=+358406875453   # phone is a field in SUT's database
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            With Valid Token, Update Given Fields For All System Users
            ...     ${api_user}[token]     ${payload}
    END

