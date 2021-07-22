*** Settings ***
Documentation		Note that Top Nav area has its own Verifiers/TopNavVerifier.resource,
...					whose keywords are utilized here.
...					This file mainly exports keywords which is utilized by
...						- Resources/CrfDemoApp.robot
...						- Tests/Registration.robot
...                     - Tests/Login.robot


*** Keywords ***
Verify Main Page Texts
	[Arguments]		${registration_form_data}
	Verify Top Nav Texts		${registration_form_data}[username][value]
    MainPage.Verify Form Main Title Text
    MainPage.Verify Key Column Title Text
    MainPage.Verify Value Column Title Text
    MainPage.Verify Username Key Text
    MainPage.Verify First Name Key Text
    MainPage.Verify Last Name Key Text
    MainPage.Verify Phone Number Key Text
    MainPage.Verify Username         ${registration_form_data}[username][value]
    MainPage.Verify First Name       ${registration_form_data}[first_name][value]
    MainPage.Verify Last Name        ${registration_form_data}[last_name][value]
    MainPage.Verify Phone Number     ${registration_form_data}[phone_number][value]

Verify Main Page Links
	[Arguments]		${username}
	Verify Top Nav Links	${username}

Verify Main Page
    [Arguments]     ${registration_form_data}
	MainPage.Verify Url
	Verify Main Page Texts	 ${registration_form_data}
	Verify Main Page Links	 ${registration_form_data}[username][value]



