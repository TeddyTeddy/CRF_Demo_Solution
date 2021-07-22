*** Settings ***
Documentation		Note that Top Nav area has its own Verifiers/TopNavVerifier.resource,
...					whose keywords are utilized here.
...					This file mainly exports keywords which is utilized by
...						- Tests/3-Review-Own-Info.robot


*** Keywords ***
Verify Index Page Texts
	[Arguments]		${username}
	Verify Top Nav Texts		${username}
	IndexPage.Verify Main Title Text

Verify Index Page Links
	[Arguments]		${username}
	Verify Top Nav Links	${username}

Verify Index Page
	[Arguments]		${username}
	IndexPage.Verify Url
	Verify Index Page Texts		${username}
	Verify Index Page Links		${username}




