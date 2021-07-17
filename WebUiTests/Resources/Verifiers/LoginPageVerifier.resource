*** Settings ***
Documentation		Note that Top Nav area has its own Verifiers/TopNavVerifier.resource,
...					whose keywords are utilized here.
...					This file mainly exports keywords which is utilized by
...						- Resources/CrfDemoApp.robot
...						- Tests/Login.robot


*** Keywords ***
Verify Login Page Texts
	[Arguments]		${username}
	Verify Top Nav Texts		${username}
	LoginPage.Verify Form Main Title Text
	LoginPage.Verify Username Text
	LoginPage.Verify Password Text
	LoginPage.Verify Login Button Text

Verify Login Page Links
	[Arguments]		${username}
	Verify Top Nav Links	${username}

Verify Login Page
	[Arguments]		${username}
	LoginPage.Verify Url
	Verify Login Page Texts	 ${username}
	Verify Login Page Links	 ${username}




