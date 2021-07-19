*** Settings ***
Documentation		This page object contains low level keywords in 2 different categories:
...						- Page URL verification
...						- Verifying Element Texts
...                 The keywords here are used in Verifiers/LoginFailurePageVerifier.resource
Resource			../Texts/IndexPageTexts.resource

*** Variable ***
${EXPECTED_INDEX_PAGE_URL}       ${BASE_URL}

*** Keywords ***
Verify Url
	[Documentation]		Verifies that URL of the page matches to EXPECTED_INDEX_PAGE_URL
	Get Url		==		${EXPECTED_INDEX_PAGE_URL}

Verify Main Title Text
	Get Text	${INDEX_PAGE_LOCATOR}[title]    ==	${INDEX_PAGE_TEXT}[title]



