*** Settings ***
Documentation		This page object contains low level keywords in 3 different categories:
...						- Page URL verification
...						- Verifying Element Texts
...						- Actions that can be taken on the page (i.e. fill in a field, click an element etc)
...                 The keywords here are used in Verifiers/LoginPageVerifier.resource
Resource			../Texts/LoginPageTexts.resource

*** Variable ***
${EXPECTED_LOGIN_PAGE_URL}       ${BASE_URL}login

*** Keywords ***
Verify Url
	[Documentation]		Verifies that URL of the page matches to EXPECTED_LOGIN_PAGE_URL
	Get Url		==		${EXPECTED_LOGIN_PAGE_URL}

Verify Form Main Title Text
	Get Text	${LOGIN_PAGE_LOCATOR}[form_title]    ==	${LOGIN_PAGE_TEXT}[form_title]

Verify Username Text
	Get Text	${LOGIN_PAGE_LOCATOR}[username_label]  ==	${LOGIN_PAGE_TEXT}[username_label]

Verify Password Text
	Get Text	${LOGIN_PAGE_LOCATOR}[password_label]	==	${LOGIN_PAGE_TEXT}[password_label]

Verify Login Button Text
	Get Attribute		${LOGIN_PAGE_LOCATOR}[login_button]		value
	...					== 	${LOGIN_PAGE_TEXT}[login_button_text]

Fill In Username
    [Arguments]     ${username}
	Type Text	${LOGIN_PAGE_LOCATOR}[username_field]		txt=${username}

Fill In Password
    [Arguments]     ${password}
	Type Text	${LOGIN_PAGE_LOCATOR}[password_field]		txt=${password}

Press Login Button
    Click       ${LOGIN_PAGE_LOCATOR}[login_button]

