*** Settings ***
Documentation		Note that Top Nav area has its own Verifiers/TopNavVerifier.resource,
...					whose keywords are utilized here.
...					This file mainly exports keywords which is utilized by
...						- Tests/3-Review-Own-Info.robot


*** Keywords ***
Verify Index Page Texts
	Verify Top Nav Texts		${EMPTY}
	IndexPage.Verify Main Title Text

Verify Index Page Links
	Verify Top Nav Links	${EMPTY}

Verify Index Page
	IndexPage.Verify Url
	Verify Index Page Texts
	Verify Index Page Links




