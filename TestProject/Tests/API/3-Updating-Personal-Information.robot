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
    [Arguments]         ${token}     ${username_value}
    ${headers} =        Create Dictionary       Token=${token}
    ${payload} =        Create Dictionary       username=${username_value}
    FOR     ${system_user}      IN      @{SYSTEM_USERS}
            ${response} =       PUT     /users/${system_user}[username]        headers=${headers}   body=${payload}
            Verify Response     ${response}     message=Field update not allowed    status=FAILURE
            Verify System Users In Database Are Intact
    END

With Valid Token, Attempt to Set Password To All System Users
    [Arguments]         ${token}     ${password_value}
    ${headers} =        Create Dictionary       Token=${token}
    ${payload} =        Create Dictionary       password=${password_value}
    FOR     ${system_user}      IN      @{SYSTEM_USERS}
            ${response} =       PUT     /users/${system_user}[username]        headers=${headers}   body=${payload}
            Verify Response     ${response}     message=Field update not allowed    status=FAILURE
            Verify System Users In Database Are Intact
    END

*** Test Cases ***
With Any Valid Token, Updating Username Of Each System User With '' Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 username as such:
    ...                 {
    ...                     "username": ''
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=${EMPTY}
    END

With Any Valid Token, Updating Username Of Each System User With !#%&/¤% Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '!#%&/¤%'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=!#%&/¤%
    END

With Any Valid Token, Updating Username Of Each System User With !#%&/¤%= Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '!#%&/¤%='
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=!#%&/¤%=
    END

With Any Valid Token, Updating Username Of Each System User With !#%&/¤%=!()=? Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '!#%&/¤%=!()=?'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=!#%&/¤%=!()=?
    END

With Any Valid Token, Updating Username Of Each System User With 1234567 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '1234567'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=1234567
    END

With Any Valid Token, Updating Username Of Each System User With 12345678 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '12345678'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=12345678
    END

With Any Valid Token, Updating Username Of Each System User With 12345678912345 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '12345678912345'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=12345678912345
    END

With Any Valid Token, Updating Username Of Each System User With abcdefg Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": 'abcdefg'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=abcdefg
    END

With Any Valid Token, Updating Username Of Each System User With abcdefgh Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": 'abcdefgh'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=abcdefgh
    END

With Any Valid Token, Updating Username Of Each System User With abcdefghijklmnprstop Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": 'abcdefghijklmnprstop'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=abcdefghijklmnprstop
    END

With Any Valid Token, Updating Username Of Each System User With hakan12 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": 'hakan12'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=hakan12
    END

With Any Valid Token, Updating Username Of Each System User With hakan123 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": 'hakan123'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=hakan123
    END

With Any Valid Token, Updating Username Of Each System User With hakan123456789123456789 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": 'hakan123456789123456789'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=hakan123456789123456789
    END

With Any Valid Token, Updating Username Of Each System User With #¤%123! Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '#¤%123!'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=#¤%123!
    END

With Any Valid Token, Updating Username Of Each System User With #¤%123!& Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '#¤%123!&'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=#¤%123!&
    END

With Any Valid Token, Updating Username Of Each System User With #¤%123!&7683##()=?@#¤%&34567 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '#¤%123!&7683##()=?@#¤%&34567'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=#¤%123!&7683##()=?@#¤%&34567
    END

With Any Valid Token, Updating Username Of Each System User With #¤123ab Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '#¤123ab'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=#¤123ab
    END

With Any Valid Token, Updating Username Of Each System User With #¤123abc Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '#¤123abc'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=#¤123abc
    END

With Any Valid Token, Updating Username Of Each System User With #¤/&¤!!123abc456hjk Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '#¤/&¤!!123abc456hjk'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=#¤/&¤!!123abc456hjk
    END

With Any Valid Token, Updating Username Of Each System User With #¤/abc! Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '#¤/abc!'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=#¤/abc!
    END

With Any Valid Token, Updating Username Of Each System User With #¤/abc!g Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '#¤/abc!g'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=#¤/abc!g
    END

With Any Valid Token, Updating Username Of Each System User With #¤/abc!g()=&%¤fghjklQWERTY Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '#¤/abc!g()=&%¤fghjklQWERTY'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=#¤/abc!g()=&%¤fghjklQWERTY
    END

With Any Valid Token, Updating Username Of Each System User With !# &/¤% Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '!# &/¤%'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=!# &/¤%
    END

With Any Valid Token, Updating Username Of Each System User With !#%&/¤ = Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '!#%&/¤ ='
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=!#%&/¤ =
    END

With Any Valid Token, Updating Username Of Each System User With !#%&/¤%= ()=? Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '!#%&/¤%= ()=?'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=!#%&/¤%= ()=?
    END

With Any Valid Token, Updating Username Of Each System User With 1234 67 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '1234 67'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=1234 67
    END

With Any Valid Token, Updating Username Of Each System User With 123456 8 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '123456 8'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=123456 8
    END

With Any Valid Token, Updating Username Of Each System User With 12345678 12345 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '12345678 12345'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=12345678 12345
    END

With Any Valid Token, Updating Username Of Each System User With abcd fg Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": 'abcd fg'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=abcd fg
    END

With Any Valid Token, Updating Username Of Each System User With ab defgh Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": 'ab defgh'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=ab defgh
    END

With Any Valid Token, Updating Username Of Each System User With abcdefghijklmnp stop Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": 'abcdefghijklmnp stop'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=abcdefghijklmnp stop
    END

With Any Valid Token, Updating Username Of Each System User With haka 12 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": 'haka 12'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=haka 12
    END

With Any Valid Token, Updating Username Of Each System User With haka 123 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": 'haka 123'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=haka 123
    END

With Any Valid Token, Updating Username Of Each System User With haka 123456789123456789 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": 'haka 123456789123456789'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=haka 123456789123456789
    END

With Any Valid Token, Updating Username Of Each System User With #¤% 23! Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '#¤% 23!'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=#¤% 23!
    END

With Any Valid Token, Updating Username Of Each System User With # %123!& Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '# %123!&'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=# %123!&
    END

With Any Valid Token, Updating Username Of Each System User With #¤%123!&7683##() ?@#¤%&34567 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '#¤%123!&7683##() ?@#¤%&34567'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=#¤%123!&7683##() ?@#¤%&34567
    END

With Any Valid Token, Updating Username Of Each System User With #¤12 ab Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '#¤12 ab'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=#¤12 ab
    END

With Any Valid Token, Updating Username Of Each System User With # 123abc Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '# 123abc'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=# 123abc
    END

With Any Valid Token, Updating Username Of Each System User With #¤/&\ \ !123abc456hjk Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '#¤/&  !123abc456hjk'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=#¤/&\ \ !123abc456hjk
    END

With Any Valid Token, Updating Username Of Each System User With #¤ abc! Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '#¤ abc!'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=#¤ abc!
    END

With Any Valid Token, Updating Username Of Each System User With #¤ abc!g Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '#¤ abc!g'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=#¤ abc!g
    END

With Any Valid Token, Updating Username Of Each System User With #¤/abc!g() &%¤fghjklQWERTY Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '#¤/abc!g() &%¤fghjklQWERTY'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=#¤/abc!g() &%¤fghjklQWERTY
    END

With Any Valid Token, Updating Password Of Each System User With '' Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": ''
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=${EMPTY}
    END

With Any Valid Token, Updating Password Of Each System User With abcdefg Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'abcdefg'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=abcdefg
    END

With Any Valid Token, Updating Password Of Each System User With abcdefgh Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'abcdefgh'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=abcdefgh
    END

With Any Valid Token, Updating Password Of Each System User With abcdefghjklmnprstoöuüvyz Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'abcdefghjklmnprstoöuüvyz'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=abcdefghjklmnprstoöuüvyz
    END

With Any Valid Token, Updating Password Of Each System User With ABCDEFG Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'ABCDEFG'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=ABCDEFG
    END

With Any Valid Token, Updating Password Of Each System User With ABCDEFGH Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'ABCDEFGH'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=ABCDEFGH
    END

With Any Valid Token, Updating Password Of Each System User With ABCDEFGHJKLMNPRSTOÖUÜVYZ Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'ABCDEFGHJKLMNPRSTOÖUÜVYZ'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=ABCDEFGHJKLMNPRSTOÖUÜVYZ
    END

With Any Valid Token, Updating Password Of Each System User With 0123456 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": '0123456'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=0123456
    END

With Any Valid Token, Updating Password Of Each System User With 01234567 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": '01234567'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=01234567
    END

With Any Valid Token, Updating Password Of Each System User With 01234567890123456789 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": '01234567890123456789'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=01234567890123456789
    END

With Any Valid Token, Updating Password Of Each System User With !?.?!.! Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": '!?.?!.!'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=!?.?!.!
    END

With Any Valid Token, Updating Password Of Each System User With !?.?!.!? Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": '!?.?!.!?'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=!?.?!.!?
    END

With Any Valid Token, Updating Password Of Each System User With !?.?!.!?!?.?!.!?!.!. Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": '!?.?!.!?!?.?!.!?!.!.'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=!?.?!.!?!?.?!.!?!.!.
    END

With Any Valid Token, Updating Password Of Each System User With abcdABC Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'abcdABC'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=abcdABC
    END

With Any Valid Token, Updating Password Of Each System User With abcdABCD Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'abcdABCD'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=abcdABCD
    END

With Any Valid Token, Updating Password Of Each System User With abcdABCDefgjklmnprstoö Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'abcdABCDefgjklmnprstoö'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=abcdABCDefgjklmnprstoö
    END

With Any Valid Token, Updating Password Of Each System User With abcd012 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'abcd012'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=abcd012
    END

With Any Valid Token, Updating Password Of Each System User With abcd0123 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'abcd0123'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=abcd0123
    END

With Any Valid Token, Updating Password Of Each System User With abcd0123456789defghjk4 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'abcd0123456789defghjk4'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=abcd0123456789defghjk4
    END

With Any Valid Token, Updating Password Of Each System User With abcd!?. Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'abcd!?.'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=abcd!?.
    END

With Any Valid Token, Updating Password Of Each System User With abcd!?.! Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'abcd!?.!'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=abcd!?.!
    END

With Any Valid Token, Updating Password Of Each System User With abcd!?.!abcd!?.!abcd?? Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'abcd!?.!abcd!?.!abcd??'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=abcd!?.!abcd!?.!abcd??
    END

With Any Valid Token, Updating Password Of Each System User With ABCD012 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'ABCD012'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=ABCD012
    END

With Any Valid Token, Updating Password Of Each System User With ABCD0123 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'ABCD0123'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=ABCD0123
    END

With Any Valid Token, Updating Password Of Each System User With ABCD0123ABCD0123ABCD01 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'ABCD0123ABCD0123ABCD01'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=ABCD0123ABCD0123ABCD01
    END

With Any Valid Token, Updating Password Of Each System User With ABCD!?. Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'ABCD!?.'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=ABCD!?.
    END

With Any Valid Token, Updating Password Of Each System User With ABCD!?.. Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'ABCD!?..'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=ABCD!?..
    END

With Any Valid Token, Updating Password Of Each System User With ABCD!?..ABCD!?..ABCD!? Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'ABCD!?..ABCD!?..ABCD!?'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=ABCD!?..ABCD!?..ABCD!?
    END

With Any Valid Token, Updating Password Of Each System User With 0123!?. Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": '0123!?.'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=0123!?.
    END

With Any Valid Token, Updating Password Of Each System User With 0123!?.0 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": '0123!?.0'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=0123!?.0
    END

With Any Valid Token, Updating Password Of Each System User With 0123!?.00123!?.00123!? Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": '0123!?.00123!?.00123!?'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=0123!?.00123!?.00123!?
    END

With Any Valid Token, Updating Password Of Each System User With abcdAB9 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'abcdAB9'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=abcdAB9
    END

With Any Valid Token, Updating Password Of Each System User With abcdAB90 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'abcdAB90'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=abcdAB90
    END

With Any Valid Token, Updating Password Of Each System User With abcdAB90abcdAB90abcdAB Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'abcdAB90abcdAB90abcdAB'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=abcdAB90abcdAB90abcdAB
    END

With Any Valid Token, Updating Password Of Each System User With ABCabc! Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'ABCabc!'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=ABCabc!
    END

With Any Valid Token, Updating Password Of Each System User With ABCabc!? Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'ABCabc!?'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=ABCabc!?
    END

With Any Valid Token, Updating Password Of Each System User With ABCabc!?ABCabc!?ABCab. Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'ABCabc!?ABCabc!?ABCab.'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=ABCabc!?ABCabc!?ABCab.
    END

With Any Valid Token, Updating Password Of Each System User With abc012. Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'abc012.'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=abc012.
    END

With Any Valid Token, Updating Password Of Each System User With abc012!? Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'abc012!?'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=abc012!?
    END

With Any Valid Token, Updating Password Of Each System User With abc012!?abc012!?abc012 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'abc012!?abc012!?abc012'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=abc012!?abc012!?abc012
    END

With Any Valid Token, Updating Password Of Each System User With abc!?.Z Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'abc!?.Z'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=abc!?.Z
    END

With Any Valid Token, Updating Password Of Each System User With abc!?.ZA Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'abc!?.ZA'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=abc!?.ZA
    END

With Any Valid Token, Updating Password Of Each System User With abc!?.ZAabc!?.ZAabc!?. Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'abc!?.ZAabc!?.ZAabc!?.'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=abc!?.ZAabc!?.ZAabc!?.
    END

With Any Valid Token, Updating Password Of Each System User With abc!?.6 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'abc!?.6'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=abc!?.6
    END

With Any Valid Token, Updating Password Of Each System User With abc!?.67 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'abc!?.67'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=abc!?.67
    END

With Any Valid Token, Updating Password Of Each System User With abc!?.67abc!?.67abc!?. Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'abc!?.67abc!?.67abc!?.'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=abc!?.67abc!?.67abc!?.
    END

With Any Valid Token, Updating Password Of Each System User With ABC456. Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'ABC456.'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=ABC456.
    END

With Any Valid Token, Updating Password Of Each System User With ABC456.? Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'ABC456.?'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=ABC456.?
    END

With Any Valid Token, Updating Password Of Each System User With ABC456.?ABC456.?ABC456 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'ABC456.?ABC456.?ABC456'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=ABC456.?ABC456.?ABC456
    END

With Any Valid Token, Updating Password Of Each System User With ABC!?.0 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'ABC!?.0'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=ABC!?.0
    END

With Any Valid Token, Updating Password Of Each System User With ABC!?.01 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'ABC!?.01'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=ABC!?.01
    END

With Any Valid Token, Updating Password Of Each System User With ABC!?.01ABC!?.01ABC!?. Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": 'ABC!?.01ABC!?.01ABC!?.'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=ABC!?.01ABC!?.01ABC!?.
    END

With Any Valid Token, Updating Password Of Each System User With 012!.Aa Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": '012!.Aa'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=012!.Aa
    END

With Any Valid Token, Updating Password Of Each System User With 012!.Aab Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": '012!.Aab'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=012!.Aab
    END

With Any Valid Token, Updating Password Of Each System User With 012!.Aab012!.Aab012!.A Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z, each of whom makes PUT requests to /api/users/<username>
    ...                 where <username> is any system user's username. In the requests' body, we set an empty
    ...                 password as such:
    ...                 {
    ...                     "password": '012!.Aab012!.Aab012!.A'
    ...                 }
    ...                 Then, each request should fail with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Password To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      password_value=012!.Aab012!.Aab012!.A
    END
