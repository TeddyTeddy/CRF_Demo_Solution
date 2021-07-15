*** Settings ***
Documentation		Common keywords and variables defined here for the test suites
Library				OperatingSystem
Library				Process
Library				Browser		timeout=5s		auto_closing_level=SUITE	enable_presenter_mode=${False}


*** Variables ***
${LOCATORS_PATH}				${EXECDIR}${/}Resources${/}Locators${/}
${BROWSER}						chromium
${BASE_URL}						http://localhost:8080/


*** Keywords ***
Begin Web Test
	[Documentation]		Operations that are repeated at test suite level setup
	Convert Suite Variables To Correct Types
	Import Resource 			${EXECDIR}${/}Resources${/}DataManager.robot
	Load Locator Resources
	New Browser 	browser=${BROWSER}	 headless=False
	New Context
	New Page
	Re-Start Web Application With No Users

End Web Test
	[Documentation]		Operations that are repeated at test suite level tear down
	Close Browser
	Stop Web Application

Convert Suite Variables To Correct Types
	[Documentation]		This keyword is needed because parameters passed by command line
	...					to robot (i.e. -v variable_name:value) are of string types
	...					We need to convert:
	...						- DATA_SET_LENGTH to int (i.e. integer)
	...						- USE_EXISTING_FORM_DATA_SET to bool (i.e. boolean)
	...					Later these values will be used upon loading RegistrationFormDataReader.py as a custom Library.
	${DATA_SET_LENGTH} =  					Evaluate        int($DATA_SET_LENGTH)
	${USE_EXISTING_FORM_DATA_SET} =		  	Evaluate        $USE_EXISTING_FORM_DATA_SET=='True'
	Set Suite Variable		${DATA_SET_LENGTH}
	Set Suite Variable		${USE_EXISTING_FORM_DATA_SET}

Load Locator Resources
	[Documentation]   Depending on the BROWSER selected, it loads the corresponding locator resource files
	...				  This keyword enables us to choose the right folder (e.g. Locators/Chromium),
	...				  inside which we expect to have the correct *Locators.resource files.
	...				  Each *Locators.resource file (e.g. Locators/Chromium/LoginPageLocators.resource)
	...				  contains the correct locators for the page in question (e.g. Login Page)
	...				  and for the browser (e.g. Chromium ) in question
	IF		'${BROWSER}'=='firefox' or '${BROWSER}'=='ff'
	    Import Locators		${LOCATORS_PATH}Firefox
	END
	IF		'${BROWSER}'=='chrome' or '${BROWSER}'=='gc'
	    Import Locators		${LOCATORS_PATH}Chrome
	END
	IF		'${BROWSER}'=='chromium'
		Import Locators		${LOCATORS_PATH}Chromium
	END

Import Locators
	[Arguments]				${locators_path}
	${locator_files} 		List Files In Directory			${locators_path}		*Locators.resource		absolute
	FOR		${locator_file}	IN		@{locator_files}
		Log To Console		Loading the resource file: ${locator_file}
		Import Resource		${locator_file}
	END

Stop Web Application
	Terminate All Processes

Re-Start Web Application With No Users
	${rc}	${pids} =		Run And Return Rc And Output	pgrep -f 'flask run --host=0.0.0.0 --port=8080'
	${is_not_empty} =		Evaluate	$pids!=''
	IF	${is_not_empty}
		${pids} = 	Evaluate	$pids.split('\\n')
		FOR  ${pid}		IN		@{pids}
			Run		kill ${pid}
		END
	END
	Start Process		export FLASK_APP\=demo_app;flask init-db;flask run --host\=0.0.0.0 --port\=8080
	...					shell=True
	...					alias=flasky
	...					cwd=${EXECDIR}${/}..${/}Flasky
	# let the demo app to re-start in its own time
	Sleep	1s
	Go To	${BASE_URL}

Log Result
	[Arguments]		${index}	${status}   ${response}     ${registration_form_data}
	IF		$status=='PASS'
		Log		Registration (with index: ${index}) succeeded with the following form data		level=INFO
		Log		${registration_form_data}		level=INFO
		Log		-------------------------		level=INFO
	ELSE
		Log		Registration (with index: ${index}) has failed with the following form data			level=ERROR
		Log		${registration_form_data}		level=ERROR
		Log		Error message:					level=ERROR
		Log		${response}						level=ERROR
		Log		-------------------------		level=ERROR
	END