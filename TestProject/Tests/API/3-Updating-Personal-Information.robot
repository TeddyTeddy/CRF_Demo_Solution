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
    [Documentation]     Imagine we have three system & api users X, Y, Z. We make PUT requests to /api/users/<username>
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

With Any Valid Token, Updating Username Of Each System User With !#%&/¤% Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z. We make PUT requests to /api/users/<username>
    ...                 where <username> is any registered user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '!#%&/¤%'
    ...                 }
    ...                 Then, Each time, the request should fail each time with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=!#%&/¤%
    END

With Any Valid Token, Updating Username Of Each System User With !#%&/¤%= Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z. We make PUT requests to /api/users/<username>
    ...                 where <username> is any registered user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '!#%&/¤%='
    ...                 }
    ...                 Then, Each time, the request should fail each time with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=!#%&/¤%=
    END

With Any Valid Token, Updating Username Of Each System User With !#%&/¤%=!()=? Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z. We make PUT requests to /api/users/<username>
    ...                 where <username> is any registered user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '!#%&/¤%=!()=?'
    ...                 }
    ...                 Then, Each time, the request should fail each time with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=!#%&/¤%=!()=?
    END

With Any Valid Token, Updating Username Of Each System User With 1234567 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z. We make PUT requests to /api/users/<username>
    ...                 where <username> is any registered user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '1234567'
    ...                 }
    ...                 Then, Each time, the request should fail each time with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=1234567
    END

With Any Valid Token, Updating Username Of Each System User With 12345678 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z. We make PUT requests to /api/users/<username>
    ...                 where <username> is any registered user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '12345678'
    ...                 }
    ...                 Then, Each time, the request should fail each time with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=12345678
    END

With Any Valid Token, Updating Username Of Each System User With 12345678912345 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z. We make PUT requests to /api/users/<username>
    ...                 where <username> is any registered user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '12345678912345'
    ...                 }
    ...                 Then, Each time, the request should fail each time with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=12345678912345
    END

With Any Valid Token, Updating Username Of Each System User With abcdefg Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z. We make PUT requests to /api/users/<username>
    ...                 where <username> is any registered user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": 'abcdefg'
    ...                 }
    ...                 Then, Each time, the request should fail each time with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=abcdefg
    END

With Any Valid Token, Updating Username Of Each System User With abcdefgh Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z. We make PUT requests to /api/users/<username>
    ...                 where <username> is any registered user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": 'abcdefgh'
    ...                 }
    ...                 Then, Each time, the request should fail each time with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=abcdefgh
    END

With Any Valid Token, Updating Username Of Each System User With abcdefghijklmnprstop Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z. We make PUT requests to /api/users/<username>
    ...                 where <username> is any registered user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": 'abcdefghijklmnprstop'
    ...                 }
    ...                 Then, Each time, the request should fail each time with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=abcdefghijklmnprstop
    END

With Any Valid Token, Updating Username Of Each System User With hakan12 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z. We make PUT requests to /api/users/<username>
    ...                 where <username> is any registered user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": 'hakan12'
    ...                 }
    ...                 Then, Each time, the request should fail each time with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=hakan12
    END

With Any Valid Token, Updating Username Of Each System User With hakan123 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z. We make PUT requests to /api/users/<username>
    ...                 where <username> is any registered user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": 'hakan123'
    ...                 }
    ...                 Then, Each time, the request should fail each time with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=hakan123
    END

With Any Valid Token, Updating Username Of Each System User With hakan123456789123456789 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z. We make PUT requests to /api/users/<username>
    ...                 where <username> is any registered user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": 'hakan123456789123456789'
    ...                 }
    ...                 Then, Each time, the request should fail each time with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=hakan123456789123456789
    END

With Any Valid Token, Updating Username Of Each System User With #¤%123! Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z. We make PUT requests to /api/users/<username>
    ...                 where <username> is any registered user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '#¤%123!'
    ...                 }
    ...                 Then, Each time, the request should fail each time with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=#¤%123!
    END

With Any Valid Token, Updating Username Of Each System User With #¤%123!& Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z. We make PUT requests to /api/users/<username>
    ...                 where <username> is any registered user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '#¤%123!&'
    ...                 }
    ...                 Then, Each time, the request should fail each time with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=#¤%123!&
    END

With Any Valid Token, Updating Username Of Each System User With #¤%123!&7683##()=?@#¤%&34567 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z. We make PUT requests to /api/users/<username>
    ...                 where <username> is any registered user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '#¤%123!&7683##()=?@#¤%&34567'
    ...                 }
    ...                 Then, Each time, the request should fail each time with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=#¤%123!&7683##()=?@#¤%&34567
    END

With Any Valid Token, Updating Username Of Each System User With #¤123ab Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z. We make PUT requests to /api/users/<username>
    ...                 where <username> is any registered user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '#¤123ab'
    ...                 }
    ...                 Then, Each time, the request should fail each time with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=#¤123ab
    END

With Any Valid Token, Updating Username Of Each System User With #¤123abc Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z. We make PUT requests to /api/users/<username>
    ...                 where <username> is any registered user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '#¤123abc'
    ...                 }
    ...                 Then, Each time, the request should fail each time with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=#¤123abc
    END

With Any Valid Token, Updating Username Of Each System User With #¤/&¤!!123abc456hjk Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z. We make PUT requests to /api/users/<username>
    ...                 where <username> is any registered user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '#¤/&¤!!123abc456hjk'
    ...                 }
    ...                 Then, Each time, the request should fail each time with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=#¤/&¤!!123abc456hjk
    END

With Any Valid Token, Updating Username Of Each System User With #¤/abc! Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z. We make PUT requests to /api/users/<username>
    ...                 where <username> is any registered user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '#¤/abc!'
    ...                 }
    ...                 Then, Each time, the request should fail each time with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=#¤/abc!
    END

With Any Valid Token, Updating Username Of Each System User With #¤/abc!g Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z. We make PUT requests to /api/users/<username>
    ...                 where <username> is any registered user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '#¤/abc!g'
    ...                 }
    ...                 Then, Each time, the request should fail each time with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=#¤/abc!g
    END

With Any Valid Token, Updating Username Of Each System User With #¤/abc!g()=&%¤fghjklQWERTY Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z. We make PUT requests to /api/users/<username>
    ...                 where <username> is any registered user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '#¤/abc!g()=&%¤fghjklQWERTY'
    ...                 }
    ...                 Then, Each time, the request should fail each time with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=#¤/abc!g()=&%¤fghjklQWERTY
    END

With Any Valid Token, Updating Username Of Each System User With !# &/¤% Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z. We make PUT requests to /api/users/<username>
    ...                 where <username> is any registered user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '!# &/¤%'
    ...                 }
    ...                 Then, Each time, the request should fail each time with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=!# &/¤%
    END

With Any Valid Token, Updating Username Of Each System User With !#%&/¤ = Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z. We make PUT requests to /api/users/<username>
    ...                 where <username> is any registered user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '!#%&/¤ ='
    ...                 }
    ...                 Then, Each time, the request should fail each time with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=!#%&/¤ =
    END

With Any Valid Token, Updating Username Of Each System User With !#%&/¤%= ()=? Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z. We make PUT requests to /api/users/<username>
    ...                 where <username> is any registered user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '!#%&/¤%= ()=?'
    ...                 }
    ...                 Then, Each time, the request should fail each time with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=!#%&/¤%= ()=?
    END

With Any Valid Token, Updating Username Of Each System User With 1234 67 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z. We make PUT requests to /api/users/<username>
    ...                 where <username> is any registered user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '1234 67'
    ...                 }
    ...                 Then, Each time, the request should fail each time with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=1234 67
    END

With Any Valid Token, Updating Username Of Each System User With 123456 8 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z. We make PUT requests to /api/users/<username>
    ...                 where <username> is any registered user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '123456 8'
    ...                 }
    ...                 Then, Each time, the request should fail each time with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=123456 8
    END

With Any Valid Token, Updating Username Of Each System User With 12345678 12345 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z. We make PUT requests to /api/users/<username>
    ...                 where <username> is any registered user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '12345678 12345'
    ...                 }
    ...                 Then, Each time, the request should fail each time with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=12345678 12345
    END

With Any Valid Token, Updating Username Of Each System User With abcd fg Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z. We make PUT requests to /api/users/<username>
    ...                 where <username> is any registered user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": 'abcd fg'
    ...                 }
    ...                 Then, Each time, the request should fail each time with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=abcd fg
    END

With Any Valid Token, Updating Username Of Each System User With ab defgh Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z. We make PUT requests to /api/users/<username>
    ...                 where <username> is any registered user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": 'ab defgh'
    ...                 }
    ...                 Then, Each time, the request should fail each time with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=ab defgh
    END

With Any Valid Token, Updating Username Of Each System User With abcdefghijklmnp stop Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z. We make PUT requests to /api/users/<username>
    ...                 where <username> is any registered user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": 'abcdefghijklmnp stop'
    ...                 }
    ...                 Then, Each time, the request should fail each time with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=abcdefghijklmnp stop
    END

With Any Valid Token, Updating Username Of Each System User With haka 12 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z. We make PUT requests to /api/users/<username>
    ...                 where <username> is any registered user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": 'haka 12'
    ...                 }
    ...                 Then, Each time, the request should fail each time with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=haka 12
    END

With Any Valid Token, Updating Username Of Each System User With haka 123 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z. We make PUT requests to /api/users/<username>
    ...                 where <username> is any registered user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": 'haka 123'
    ...                 }
    ...                 Then, Each time, the request should fail each time with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=haka 123
    END

With Any Valid Token, Updating Username Of Each System User With haka 123456789123456789 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z. We make PUT requests to /api/users/<username>
    ...                 where <username> is any registered user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": 'haka 123456789123456789'
    ...                 }
    ...                 Then, Each time, the request should fail each time with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=haka 123456789123456789
    END

With Any Valid Token, Updating Username Of Each System User With #¤% 23! Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z. We make PUT requests to /api/users/<username>
    ...                 where <username> is any registered user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '#¤% 23!'
    ...                 }
    ...                 Then, Each time, the request should fail each time with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=#¤% 23!
    END

With Any Valid Token, Updating Username Of Each System User With # %123!& Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z. We make PUT requests to /api/users/<username>
    ...                 where <username> is any registered user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '# %123!&'
    ...                 }
    ...                 Then, Each time, the request should fail each time with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=# %123!&
    END

With Any Valid Token, Updating Username Of Each System User With #¤%123!&7683##() ?@#¤%&34567 Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z. We make PUT requests to /api/users/<username>
    ...                 where <username> is any registered user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '#¤%123!&7683##() ?@#¤%&34567'
    ...                 }
    ...                 Then, Each time, the request should fail each time with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=#¤%123!&7683##() ?@#¤%&34567
    END

With Any Valid Token, Updating Username Of Each System User With #¤12 ab Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z. We make PUT requests to /api/users/<username>
    ...                 where <username> is any registered user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '#¤12 ab'
    ...                 }
    ...                 Then, Each time, the request should fail each time with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=#¤12 ab
    END

With Any Valid Token, Updating Username Of Each System User With # 123abc Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z. We make PUT requests to /api/users/<username>
    ...                 where <username> is any registered user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '# 123abc'
    ...                 }
    ...                 Then, Each time, the request should fail each time with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=# 123abc
    END

With Any Valid Token, Updating Username Of Each System User With #¤/&\ \ !123abc456hjk Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z. We make PUT requests to /api/users/<username>
    ...                 where <username> is any registered user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '#¤/&  !123abc456hjk'
    ...                 }
    ...                 Then, Each time, the request should fail each time with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=#¤/&\ \ !123abc456hjk
    END

With Any Valid Token, Updating Username Of Each System User With #¤ abc! Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z. We make PUT requests to /api/users/<username>
    ...                 where <username> is any registered user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '#¤ abc!'
    ...                 }
    ...                 Then, Each time, the request should fail each time with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=#¤ abc!
    END

With Any Valid Token, Updating Username Of Each System User With #¤ abc!g Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z. We make PUT requests to /api/users/<username>
    ...                 where <username> is any registered user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '#¤ abc!g'
    ...                 }
    ...                 Then, Each time, the request should fail each time with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=#¤ abc!g
    END

With Any Valid Token, Updating Username Of Each System User With #¤/abc!g() &%¤fghjklQWERTY Results In "Field update not allowed"
    [Documentation]     Imagine we have three system & api users X, Y, Z. We make PUT requests to /api/users/<username>
    ...                 where <username> is any registered user's username. In the requests' body, we set a
    ...                 username as such:
    ...                 {
    ...                     "username": '#¤/abc!g() &%¤fghjklQWERTY'
    ...                 }
    ...                 Then, Each time, the request should fail each time with the following response body:
    ...                 {
    ...                     "message": "Field update not allowed",
    ...                     "status": "FAILURE"
    ...                 }
    [Template]          With Valid Token, Attempt to Set Username To All System Users
    FOR     ${api_user}      IN      @{SYSTEM_USERS}
            token=${api_user}[token]      username_value=#¤/abc!g() &%¤fghjklQWERTY
    END
