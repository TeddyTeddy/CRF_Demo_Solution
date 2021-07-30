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
Import DataManager
	# Important, (1) must run before (2)
	Convert Suite Variables To Correct Types	# (1)
	Import Resource 			${EXECDIR}${/}Resources${/}DataManager.robot	# (2)

Begin Web Test
	[Documentation]		Operations that are meant for the suite setup
	Import DataManager
	Load Locator Resources
	New Browser 	browser=${BROWSER}	 headless=False
	New Context
	New Page

End Web Test
	[Documentation]		Operations that are meant for the suite tear down
	Close Browser

Convert Suite Variables To Correct Types
	[Documentation]		This keyword is needed because parameters passed by command line
	...					to robot (i.e. -v variable_name:value) are of string types.
	...					In run command we pass 2 parameters to robot:
	...					robot -d Results/ -v DATA_SET_LENGTH:100 -v USE_EXISTING_FORM_DATA_SET:True  -v BROWSER:chromium -P CustomLibs Tests/
	...					So, we have the following variables passed as strings:
	...						- DATA_SET_LENGTH:100
	...						- USE_EXISTING_FORM_DATA_SET:True
	...					We need to convert:
	...						- DATA_SET_LENGTH to int (i.e. integer)
	...						- USE_EXISTING_FORM_DATA_SET to bool (i.e. boolean)
	...					Later these values will be used while loading DataManager.robot resource.
	${DATA_SET_LENGTH} =  					Evaluate        int($DATA_SET_LENGTH)
	${USE_EXISTING_FORM_DATA_SET} =		  	Evaluate        $USE_EXISTING_FORM_DATA_SET=='True'
	Set Suite Variable		${DATA_SET_LENGTH}
	Set Suite Variable		${USE_EXISTING_FORM_DATA_SET}

Load Locator Resources
	[Documentation]   Depending on the BROWSER variable's value, it loads the corresponding locator resource files
	...				  This keyword enables us to choose the right folder (e.g. Locators/Chromium),
	...				  inside which we expect to have the correct *Locators.resource files.
	...				  Each *Locators.resource file (e.g. Locators/Chromium/LoginPageLocators.resource)
	...				  contains the correct locators for the page in question (e.g. Login Page)
	...				  and for the browser (e.g. Chromium ) in question
	IF		'${BROWSER}'=='firefox'
	    Import Locators		${LOCATORS_PATH}Firefox
	END
	IF		'${BROWSER}'=='webkit'
	    Import Locators		${LOCATORS_PATH}Webkit
	END
	IF		'${BROWSER}'=='chromium'
		Import Locators		${LOCATORS_PATH}Chromium
	END

Import Locators
	[Documentation]			Given the locators_path, which points at Resources/Locators/<Browser> directory
	...						(e.g. Resources/Locators/Chromium),
	...						this keyword loads all *Locators.resource files inside the directory.
	...						This is due to fact that the system under test's DOM can be different for different browsers.
	...						Imagine that Registration Page has differengt DOM structure for Firefox and Chrome.
	...						Then we have to have 2 different REGISTRATION_PAGE_LOCATORs defined for each browser
	...						Have a look at
	...							- Resources/Locators/Chromium/RegistrationPageLocators.resource
	...							- Resources/Locators/Firefox/RegistrationPageLocators.resource
	...						So we would have to import different locators for different browsers via this keyword
	[Arguments]				${locators_path}
	${locator_files} 		List Files In Directory			${locators_path}		*Locators.resource		absolute
	FOR		${locator_file}	IN		@{locator_files}
		Log To Console		Loading the resource file: ${locator_file}
		Import Resource		${locator_file}
	END

Stop Web Application
	[Documentation]			This terminates all the flask processes created by "Re-Start Web Application With No Users"
	...						keyword.
	Terminate All Processes

Kill Web Application
	# First check if the user has started any flask process externally in a command line
	# before running the "run" command, which runs robot command running the test suite
	# if there are any, kill those processes because only one process can use port 8080
	# at a time.
	${rc}	${pids} =		Run And Return Rc And Output	pgrep -f 'flask run --host=0.0.0.0 --port=8080'
	${is_not_empty} =		Evaluate	$pids!=''
	IF	${is_not_empty}
		${pids} = 	Evaluate	$pids.split('\\n')
		FOR  ${pid}		IN		@{pids}
			Run		kill ${pid}
		END
	END

Start Web Application With No Init Procedure
	# At this point, there is no system under test instance is running
	# we can start a process running the system under test.
	Start Process		export FLASK_APP\=demo_app;flask run --host\=0.0.0.0 --port\=8080
	...					shell=True
	...					alias=flasky
	...					cwd=${EXECDIR}${/}..${/}Flasky
	# let the system under test app to re-start in its own time
	Sleep	1.5s

Re-Start Web Application With No Users
	Kill Web Application
	# At this point, there is no system under test instance is running
	# we can start a process running the system under test.
	Start Process		export FLASK_APP\=demo_app;flask init-db;flask run --host\=0.0.0.0 --port\=8080
	...					shell=True
	...					alias=flasky
	...					cwd=${EXECDIR}${/}..${/}Flasky
	# let the system under test app to re-start in its own time
	Sleep	1.5s
	Go To	${BASE_URL}

Log Result
	[Arguments]		${index}	${register_keyword_status}   ${error_message}     ${registration_form_data}
    ${is_registration_form_data_valid} =    Check Registration Form Data Validity   ${registration_form_data}
	IF			$is_registration_form_data_valid==True and $register_keyword_status=='PASS'
		Log		Registration (with index: ${index}) succeeded as it should with the following form data:		level=INFO		console=True
		Log		${registration_form_data}		level=INFO		console=True
		Log		-------------------------		level=INFO		console=True
	ELSE IF		$is_registration_form_data_valid==False and $register_keyword_status=='PASS'
		Log		Registration (with index: ${index}) failed as it should with the following form data:		level=INFO		console=True
		Log		${registration_form_data}		level=INFO		console=True
		Log		-------------------------		level=INFO		console=True
	ELSE IF		$is_registration_form_data_valid==True and $register_keyword_status=='FAIL'
		Log		Programming error in Register keyword. (Index: ${index}). Register keyword should not have failed with the following form data:			level=ERROR
		Log		${registration_form_data}		level=ERROR
		Log		Error message:					level=ERROR
		Log		${error_message}				level=ERROR
		Log		-------------------------		level=ERROR
	ELSE IF		$is_registration_form_data_valid==False and $register_keyword_status=='FAIL'
		Log		Registration attempt with index: ${index}. Register keyword has catched an error with the following form data:			level=ERROR
		Log		${registration_form_data}		level=ERROR
		Log		Error message:					level=ERROR
		Log		${error_message}				level=ERROR
		Log		-------------------------		level=ERROR
	END

