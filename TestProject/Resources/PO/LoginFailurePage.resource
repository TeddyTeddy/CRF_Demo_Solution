*** Settings ***
Documentation		This page object contains low level keywords in 2 different categories:
...						- Page URL verification
...						- Verifying Element Texts
...                 The keywords here are used in Verifiers/LoginFailurePageVerifier.resource
Resource			../Texts/LoginFailurePageTexts.resource

*** Variable ***
${EXPECTED_LOGIN_FAILURE_PAGE_URL}       ${BASE_URL}error

*** Keywords ***
Verify Url
	[Documentation]		Verifies that URL of the page matches to EXPECTED_LOGIN_FAILURE_PAGE_URL
	Get Url		==		${EXPECTED_LOGIN_FAILURE_PAGE_URL}

Verify Main Title Text
	Get Text	${LOGIN_FAILURE_PAGE_LOCATOR}[title]    ==	${LOGIN_FAILURE_PAGE_TEXT}[title]

Verify Description Text
	Get Text	${LOGIN_FAILURE_PAGE_LOCATOR}[description]  ==	${LOGIN_FAILURE_PAGE_TEXT}[description]


