*** Settings ***
Documentation		Exposes its keywords to other Verifiers/*Verifier.resource files
... 				Top Nav area has a state:
...						- If user is not logged in, it shows:
...							- Demo App
...							- Register
...							- Login
...						- If user is indeed logged in, it shows:
...							- Demo App
...							- <username>
...							- Logout
...					The keywords implemented here are taking into account the state of the Top Nav Area;
...					If a username is given as an argument, then Top Nav area must be in logged in state.
...					Otherwise, Top Nav Area must be not logged in state.


*** Keywords ***
Verify Top Nav Texts
	[Arguments]			${username}
	Verify Main Title Text
	IF	$username
		Verify User X Text		${username}
		Verify Logout Text
	ELSE
		Verify Register Text
		Verify Login Text
	END

Verify Top Nav Links
	[Arguments]			${username}
	Verify Main Title Link
	IF	$username
		Verify Logout Link
	ELSE
		Verify Register Link
		Verify Login Link
	END




