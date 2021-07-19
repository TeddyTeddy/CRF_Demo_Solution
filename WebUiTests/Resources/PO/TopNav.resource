*** Settings ***
Documentation		This page object contains low level keywords in 4 different categories:
...						- Verifying Element Texts
...						- Verifying Element Links
...						- Actions that can be taken on the TopNav area (i.e. click Register etc)
...					Note that TopNav area is shared accross Login Page and Registration Page
...					meaning that the keywords presented here are utilized by
... 				Verifiers/TopNavVerifier.resource

Resource			../Texts/TopNavTexts.resource


*** Variable ***
&{TOP_NAV_LINK}
...			main_title=/			# on the upper left corner
...			register=/register	# on the upper right corner
...			login=/login		    # on the upper rightmost corner
...         logout=/logout        # on the upper rightmost corner


*** Keywords ***
Verify Main Title Text
	Get Text	${TOP_NAV_LOCATOR}[main_title]	==	${TOP_NAV_TEXT}[main_title]

Verify User X Text
	[Documentation]		Given the username, this keyword verifies that a string appears mentioning the username in Top Nav Pane
	[Arguments]		${username}
	${expected_dynamic_user_text}=		Evaluate		$TOP_NAV_TEXT['dynamic_username'] % $username
	# user navigation bar on the upper right of the page
	Get Text	${TOP_NAV_LOCATOR}[dynamic_username]		==	${expected_dynamic_user_text}

Verify Register Text
	Get Text	${TOP_NAV_LOCATOR}[register]	==	${TOP_NAV_TEXT}[register]

Verify Login Text
	Get Text	${TOP_NAV_LOCATOR}[login]		==	${TOP_NAV_TEXT}[login]

Verify Logout Text
	Get Text	${TOP_NAV_LOCATOR}[logout]	==	${TOP_NAV_TEXT}[logout]

Verify Main Title Link
	Get Attribute		${TOP_NAV_LOCATOR}[main_title]		href	==	${TOP_NAV_LINK}[main_title]

Verify Register Link
	Get Attribute		${TOP_NAV_LOCATOR}[register]		href	==	${TOP_NAV_LINK}[register]

Verify Login Link
	Get Attribute		${TOP_NAV_LOCATOR}[login]		href	==	${TOP_NAV_LINK}[login]

Verify Logout Link
	Get Attribute		${TOP_NAV_LOCATOR}[logout]		href	==	${TOP_NAV_LINK}[logout]

Logout
	Click		${TOP_NAV_LOCATOR}[logout]

Go To Index Page
	Click		${TOP_NAV_LOCATOR}[main_title]

Go To Registration Page
	Click		${TOP_NAV_LOCATOR}[register]

Go To Login Page
	Click		${TOP_NAV_LOCATOR}[login]

Click On Username
	Click		${TOP_NAV_LOCATOR}[dynamic_username]
