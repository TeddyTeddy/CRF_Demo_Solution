*** Settings ***
Documentation		Note that Top Nav area has its own Verifiers/TopNavVerifier.resource,
...					whose keywords are utilized here.
...					This file mainly exports keywords which is utilized by
...						- Resources/CrfDemoApp.robot
...						- Tests/Login.robot


*** Keywords ***
Verify Login Page Texts
	Verify Top Nav Texts		${EMPTY}
	LoginPage.Verify Form Main Title Text
	LoginPage.Verify Username Text
	LoginPage.Verify Password Text
	LoginPage.Verify Login Button Text

Verify Login Page Links
	Verify Top Nav Links	${EMPTY}

Verify Login Page
	LoginPage.Verify Url
	Verify Login Page Texts
	Verify Login Page Links




