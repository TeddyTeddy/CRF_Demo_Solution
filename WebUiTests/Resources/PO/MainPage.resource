*** Settings ***
Documentation		This page object contains low level keywords in 2 different categories:
...						- Page URL verification
...						- Verifying Element Texts
...                 The keywords here are used in Verifiers/MainPageVerifier.resource
Resource			../Texts/MainPageTexts.resource


*** Variable ***
${EXPECTED_MAIN_PAGE_URL}       ${BASE_URL}user


*** Keywords ***
Verify Url
	[Documentation]		Verifies that URL of the page matches to EXPECTED_MAIN_PAGE_URL
	Get Url		==		${EXPECTED_MAIN_PAGE_URL}

Verify Form Main Title Text
	Get Text	${MAIN_PAGE_LOCATOR}[title]    ==	${MAIN_PAGE_TEXT}[title]

Verify Key Column Title Text
	Get Text	${MAIN_PAGE_LOCATOR}[key_column_title]    ==	${MAIN_PAGE_TEXT}[key_column_title]

Verify Value Column Title Text
	Get Text	${MAIN_PAGE_LOCATOR}[value_column_title]    ==	${MAIN_PAGE_TEXT}[value_column_title]

Verify Username Key Text
	Get Text	${MAIN_PAGE_LOCATOR}[username_key]    ==	${MAIN_PAGE_TEXT}[username_key]

Verify First Name Key Text
	Get Text	${MAIN_PAGE_LOCATOR}[first_name_key]    ==	${MAIN_PAGE_TEXT}[first_name_key]

Verify Last Name Key Text
	Get Text	${MAIN_PAGE_LOCATOR}[last_name_key]    ==	${MAIN_PAGE_TEXT}[last_name_key]

Verify Phone Number Key Text
	Get Text	${MAIN_PAGE_LOCATOR}[phone_number_key]    ==	${MAIN_PAGE_TEXT}[phone_number_key]

Verify Username
    [Arguments]     ${username}
    ${expected} =      Evaluate        $MAIN_PAGE_TEXT['username_value'] % $username
	Get Text	${MAIN_PAGE_LOCATOR}[username_value]    ==	    ${expected}

Verify First Name
    [Arguments]     ${first_name}
    ${expected} =      Evaluate        $MAIN_PAGE_TEXT['first_name_value'] % $first_name
	Get Text	${MAIN_PAGE_LOCATOR}[first_name_value]    ==	    ${expected}

Verify Last Name
    [Arguments]     ${last_name}
    ${expected} =      Evaluate        $MAIN_PAGE_TEXT['last_name_value'] % $last_name
	Get Text	${MAIN_PAGE_LOCATOR}[last_name_value]    ==	    ${expected}

Verify Phone Number
    [Arguments]     ${phone_number}
    ${expected} =      Evaluate        $MAIN_PAGE_TEXT['phone_number_value'] % $phone_number
	Get Text	${MAIN_PAGE_LOCATOR}[phone_number_value]    ==	    ${expected}