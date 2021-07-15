*** Settings ***
Documentation		Note that Top Nav area has its own Verifiers/TopNavVerifier.resource,
...					whose keywords are utilized here.
...					This file mainly exports keywords which is utilized by
...						- Resources/CrfDemoApp.robot
...						- Tests/Registration.robot


*** Keywords ***
Verify Registration Page Texts
	[Arguments]		${username}
	Verify Top Nav Texts		${username}
	RegistrationPage.Verify Form Main Title Text
	RegistrationPage.Verify Username Text
	RegistrationPage.Verify Password Text
	RegistrationPage.Verify First Name Text
	RegistrationPage.Verify Last Name Text
	RegistrationPage.Verify Phone Number Text
	RegistrationPage.Verify Register Button Text

Verify Registration Page Links
	[Arguments]		${username}
	Verify Top Nav Links	${username}

Verify Registration Page
	RegistrationPage.Verify Url
	Verify Registration Page Texts	 ${EMPTY}
	Verify Registration Page Links	 ${EMPTY}




