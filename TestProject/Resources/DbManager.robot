*** Settings ***
Documentation		Database connection & CRUD keywords defined here for the test suites
Library             DatabaseLibrary
Library				String
Library				OperatingSystem
Library				Collections

*** Variables ***
${QUERY_ALL_USERS}		select username, firstname, lastname, phone, token from user;

*** Keywords ***
Get Path To App Database
	${path_to_database} =		Set Variable		${EXECDIR}
	${path_to_database} = 		Fetch From Left		${path_to_database}		TestProject
	${path_to_database} =		Set Variable		${path_to_database}Flasky${/}instance${/}demo_app.sqlite
	[Return]	${path_to_database}

Initialize Database Connection
	${path_to_database} = 		Get Path To App Database
	# https://groups.google.com/g/robotframework-users/c/wEyHBlQxr1o/m/eGNrttuI8EgJ
	Connect To Database Using Custom Params		sqlite3		database='${path_to_database}'

Verify Tables
	Table Must Exist	user

Fetch All System Users From Db
	${users} = 			Query	${QUERY_ALL_USERS}		# a list of tuples, where each tuple is a user entry
	${SYSTEM_USERS} =	Create List
	FOR     ${user}  	  IN 	@{users}
		&{new_user} = 		Create Dictionary
		Set To Dictionary	${new_user}		username=${user}[0]		firstname=${user}[1]	lastname=${user}[2]		phone=${user}[3]		token=${user}[4]
		Append to List		${SYSTEM_USERS}		${new_user}
	END
	Set Suite Variable		@{SYSTEM_USERS}

Replace Database With New Database Having Users
	${source} = 		Set Variable		${EXECDIR}${/}TestData${/}demo_app_with_users.sqlite
	${target} =			Get Path To App Database
	Run		cp ${source} ${target}