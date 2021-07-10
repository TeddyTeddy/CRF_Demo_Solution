*** Settings ***
Documentation       This test suite contains test cases for CRF Demo Web Application.
...                 Documentation for the application can be found:
...                 https://github.com/Interview-demoapp/Flasky

Resource                ../Resources/Common.robot
Resource                ../Resources/CrfDemoApp.robot

Suite Setup             Begin Web Test
Suite Teardown          End Web Test

*** Test Cases ***


