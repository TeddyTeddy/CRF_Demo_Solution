*** Settings ***
Documentation		Note that Top Nav area has its own Verifiers/TopNavVerifier.resource,
...					whose keywords are utilized here.
...					This file mainly exports keywords which is utilized by
...						- Resources/CrfDemoApp.robot


*** Keywords ***
Verify Login Failure Page Texts
	Verify Top Nav Texts		${EMPTY}
	LoginFailurePage.Verify Main Title Text
	LoginFailurePage.Verify Description Text

Verify Login Failure Page Links
	Verify Top Nav Links	${EMPTY}

Verify Login Failure Page
	LoginFailurePage.Verify Url
	Verify Login Failure Page Texts
	Verify Login Failure Page Links




