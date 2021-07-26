*** Settings ***
Documentation       This test suite contains login test cases for CRF Demo API.
...                 Documentation for the API can be found:
...                 https://github.com/Interview-demoapp/Flasky
...                 The acceptance criteria we verify here is
...                 "1: Review users registered in the system"

Resource                ../../Resources/CrfDemoApp.robot
Resource                ../../Resources/Common.robot
Resource                ../../Resources/DbManager.robot
Library                 ../../CustomLibs/CRUD_Library.py        base_url=http://0.0.0.0:8080/api


Suite Setup             Run keywords   Kill Web Application     Replace Database With New Database Having Users
...                     Start Web Application With No Init Procedure
...                     Initialize Database Connection      Verify Tables       Fetch All System Users From Db

Suite Teardown          Kill Web Application

Test Template           With Valid Token, Reading Users From API Should Return All System Users

*** Keywords ***
With Valid Token, Reading Users From API Should Return All System Users
    [Arguments]         ${system_user}
    Log     ${system_user}
    ${headers} =        Set Variable     {'Content-Type': 'application/json', 'Token': 'MTczNzAyNjc5NDg4Mzc1MzcwNDIwODAyOTM1NTExMjU4NzkzNDM2' }
    ${response} =       GET     /users        headers=${headers}
    Log                 ${response}

*** Test Cases ***
Reading Users From DB
    [Template]          With Valid Token, Reading Users From API Should Return All System Users
    FOR     ${system_user}      IN      @{SYSTEM_USERS}
            ${system_user}
    END

