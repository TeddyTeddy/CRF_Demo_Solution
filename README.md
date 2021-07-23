# 1. INSTALLATION INSTRUCTIONS FOR UBUNTU 18.04 LTS

### 1.1 Installing SQLite on Ubuntu [1]
1. sudo apt-get update
2. sudo apt-get install sqlite3
3. sqlite3 --version

### 1.2 Installing Python 3.7.4 or Higher
Acc. to the instructions in [2]:

1. sudo apt update
2. sudo apt install software-properties-common
3. sudo add-apt-repository ppa:deadsnakes/ppa
4. sudo apt update
5. sudo apt install python3.8

Verify that you have python 3.7.4 or higher:
6. python --version

### 1.3 Installing Node.js v16.4.1
According to the instructions in [3]:
1. curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
2. sudo apt-get install -y nodejs
3. node --version

### 1.4 Installing The CRF_Demo_Solution Containing The TestProject
On bash terminal, in the given order:
1. git clone https://github.com/TeddyTeddy/CRF_Demo_Solution.git
2. cd CRF_Demo_Solution/
3. git clone https://github.com/Interview-demoapp/Flasky.git

Continuing on the same bash terminal in CRF_Demo_Solution/ folder:

4. Install a virtual environment:       python -m venv .venv/
5. Activate the virtual environment:    source .venv/bin/activate
6. python -m pip install -r requirements.txt
7. rfbrowser init

# 2. Running The UI Test Cases
1. cd CRF_Demo_Solution/TestProject/
2. ./run

The outcome of test results can be found under CRF_Demo_Solution/TestProject/Results/ folder

# 2.1 Some Terminology Regarding TestProject

### 2.1.1 registration_form_data

An example:

```json
    {
        "username": {
            "value": "",
            "isValid": false,
            "expected_error": "Please fill out this field."
        },
        "password": {
            "value": "0123!?.00123!?.00123!?",
            "isValid": false,
            "expected_error": "Min 8 characters. Must contain at least one character from [a-z], [A-Z], [0-9] and [!?.]"
        },
        "first_name": {
            "value": "Hakan",
            "isValid": true
        },
        "last_name": {
            "value": "W Xi",
            "isValid": false,
            "expected_error": "Each last name must contain only characters from the set [a-zA-Z]. Last names must be seperated by a a single space. Last names must have at least 2 characters"
        },
        "phone_number": {
            "value": "+358506abc!#662712",
            "isValid": false,
            "expected_error": "phone number can only contain numbers [0-9] and optionally a single plus sign at the beginning indicating the country code"
        }
    }
```
Above you see a registration_form_data (instance) containing username, password, first_name, last_name and phone_number data.
Note that if a specific field (e.g. username) is not valid (e.g. "isValid": false), then there is "expected_error" included
in that field. Otherwise there is no "expected_error" field (e.g. first_name)

You can find many examples of registration_form_data in TestProject/TestData/RegistrationFormDataSet.json.

registration_form_data as JSON & as a Python dictionary is heavily used in the test code.

### 2.1.2 registration_form_data set

Referring to TestProject/TestData/RegistrationFormDataSet.json, it is a list of randomly chosen registration_form_data instances.
Referring to TestProject/TestData/ folder, we currenly have the following:
    - Usernames.json : Contains 43 usernames
    - Passwords.json : Contains 55 usernames
    - Firstnames.json : Contains 12 first_names
    - Lastnames.json  : Contains 12 last_names
    - PhoneNumbers.json : Contains 8 phone_numbers

It is the combinations of these usernames/passwords/first_names/last_names and phone_numbers that form the registration_form_data set.
Althogether they form 2724480 (43x55x12x12x8) registration_form_data instances. Running 2724480 registration_form_data instances is a big challenge unless paralel testing is used. Note that paralel testing is not in the scope of this demo. Instead, I chose to pick a subset of them.

If you are curious how RegistrationFormDataSet.json is created and/or used, have a look at:
TestProject/Resources/DataManager.robot
TestProject/CustomLibs/RegistrationFormDataReader.py
TestProject/CustomLibs/RegistrationFormDataUtils.py

Note that DataManager loads RegistrationFormDataReader passing DATA_SET_LENGTH and USE_EXISTING_FORM_DATA_SET robot variables,
which are explained in the next section.
### 2.2 About the run command

The run command calls robot as such:

robot -d Results/ -v DATA_SET_LENGTH:100 -v USE_EXISTING_FORM_DATA_SET:True  -v BROWSER:firefox -P CustomLibs Tests/

### 2.2.1 USE_EXISTING_FORM_DATA_SET AND DATA_SET_LENGTH parameters

USE_EXISTING_FORM_DATA_SET, if set to False, tells the test project to create a brand new registration form data set.
Also, DATA_SET_LENGTH is used to determine the length of registration_form_data set. In other words, out of
2724480 registration_form_data instances, we pick 100 of them randomly.

USE_EXISTING_FORM_DATA_SET, if set to True, tells the test project to use the existing
TestProject/TestData/RegistrationFormDataSet.json file. Then, DATA_SET_LENGTH is ignored.

We receive registration_form_data (instance) from DataManager's keywords:
+ **Get Registration Form Data**: We can call this keyword many times. In between first to DATA_SET_LENGTH.th call, it returns a random registration_form_data instance (out of 2724480 instances). It returns None on DATA_SET_LENGTH + 1.th call onwards.

The source of registration_form_data is different depending on USE_EXISTING_FORM_DATA_SET value:
+ If USE_EXISTING_FORM_DATA_SET is True, it uses RegistrationFormDataSet.json: one registration_form_data at a time
+ If USE_EXISTING_FORM_DATA_SET is False, it randomly creates registration_form_data instance (out of 2724480 instances)
  The instances it creates overwrites the contents of RegistrationFormDataSet.json file.

The longest running test case **Registering With Variety Of Registration Form Data** utilizes **Get Registration Form Data** keyword.
Note that the test case is tagged with CI for long running nightly builds. We call that test case as CI test case shortly.
Unless the keyword returns None, the test case attempts to register with the obtained registration_form_data from the keyword.

Imagine all the issues found by the test cases including the long running CI test case are fixed so that are all passing.
Then, we can set do the following (Procedure A):
```
USE_EXISTING_FORM_DATA_SET:False
DATA_SET_LENGTH:10000
```

This way, we pick another random 10000 registration_form_data instances out of 2724480 instances pool for that night.
If all the tests pass in that nightly build, then we repeat the process (Procedure A) in the next nightly build and so on.
If the CI test case fails, then we do (Procedure B):
    - Commit RegistrationFormDataSet.json file
    - Fix the issue(s) found
    - Set USE_EXISTING_FORM_DATA_SET to True.
    - Re-run to see if the issues are fixed
        - if the issues are not fixed, repeat Procedure B
        - If the issues are fixed, repeat procedure A

NOTE: Using a combination of procedures A & B depending on the outcome of the test results is the best one can do given
the time & my skillset restrictions. A better solution, considering the CI test case, would be to use multiple slave containers, where each slave runs a specific set from 2724480 registration_form_data instances. And then a master container would combine the CI tests' outcomes from those slaves and combines them using rebot. But as said before, it is out of scope for this demo.

### 2.2.2 BROWSER variable

Since we are using RF's Browser Library to do Web UI test automation, we have 3 options for BROWSER:

+ firefox
+ webkit
+ chromium

All these keywords are case sensitive.

Referring to TestProject/Resources/Common.robot; the test code utilizes the variable to load locators for different browsers.
Say, you wanted to test things in firefox, then passing -v BROWSER:firefox to robot would cause the Common.robot to load
locators for firefox. If the system under test's front-end has a different DOM structure for different browsers, then
this approach comes handy. Say if the DOM is different between firefox, webkit and chromium, then by loading different locators
for those browsers, our test cases would test the targeted DOM structure for the right browser.
For more information, refer to TestProject/Resources/Locators.

# 2.3. Short description of components, including external libraries

So far, you have been introduced to
+ registration_form_data (instance)
+ registration_form_data set
+ The contents of TestData folder
+ run command and its variables passed to robot

Lets give a brief introduction to components used & implemented in this section.

### 2.3.1 DataManager

Found in Resources/DataManager.robot. Used by test suites. If registration_form_data is needed/manipulated,
then DataManager's keywords are used:

+ **Get Registration Form Data**
  To provide registration_form_data to the CI test case.
  hiding the implementation details of how it is generated; Read sections 2.1.2 and 2.2.1 for details.

+ **Get Valid User's Registration Form Data**
  To provide a valid registration form data; here valid means all the 5 fields are valid.

+ **Manipulate**
  To manipulate a given registration_form_data's field (e.g. username or phone_number) to a desired value

It loads RegistrationFormDataReader as a custom robot library, which is explained next
### 2.3.2  RegistrationFormDataReader
Found in TestProject/CustomLibs/RegistrationFormDataReader.py.
TestProject/Resources/Common.robot imports DataManager, which then imports the library RegistrationFormDataReader.
RegistrationFormDataReader provides the functionality for reading/manipulating registration_form_data.
The keywords are implemented in Python, which are listed shortly:

+ **read_random_registration_form_data()**
  Returns a registration_form_data instance whose fields may contain (in)valid data.
  It uses a generator/iterator, so you can call many times to get new registration_form_data instances.
  When the generator is exhausted, then it returns None to signal the end of registration_form_data instances
  (and thus the end of test run).

+ **read_one_valid_users_registration_form_data()**
  Returns a registration_form_data instance, whose fields are all valid. The data source file for the instances
  is located in TestProject/TestData/ManyValidUsers.json. It reads the file in a cyclic fashion one
  registration_form_data instance at a time. When end of file is reached, it returns to the begining of the file
  and repeats the process.

+ **do_manipulate(self, registration_form_data, key, description)**
  Given a valid registration_form_data instance, if we are to change one of its fields (e.g. username)
  then we provide the key to be the string "username". We also provide a description as a string,
  which must match with one of the description fields in TestData/Usernames.json file. The username (in the file),
  whose description is matching description parameter we provide, is used to replace the username
  of the instance. This way, we can quickly create a new instance matching the requirements of the test case
  (e.g. An Empty Username Is Not Accepted)

RegistrationFormDataReader heavily utilizes the generators. Each generator reads one of the following files:

+ TestProject/TestData/RegistrationFormDataSet.json
+ TestProject/TestData/ManyValidUsers.json

And the files contain registration_form_data instances. The generators read one instance at a time and return it
to RegistrationFormDataReader, which then returns it to the DataManager.

## 2.3.3 Common.robot

Found in TestProject/Resources/Common.robot. Provides keywords that do not contain business logic for the system under test.

## 2.3.4 CrfDemoApp.robot

Found in TestProject/Resources/CrfDemoApp.robot. Provides keywords containing business logic for the system under test.
The business logic can be about registration, logging in or landing. It relies on implementation provided by
+ Page Objects (PO in short), which are provided under TestProject/Resources/PO
+ Verifiers, which are provided under TestProject/Resources/Verifiers

### 2.3.5 Page Objects
We have currenly the following pages in the system under test:

- Index Page (i.e. landing page)
- Registration Page
- Login Page
- Main Page
- Login Failure Page

Each of which share Top Navigation Area (i.e. Top Nav for short). The Top Nav has a state:

If user is not logged in, it shows:
+ Demo App
+ Register
+ Login

If user is indeed logged in, it shows:
+ Demo App
+ <username>
+ Logout

Referring to TestProject/Resources/PO, the pages have their own page objects. Note that Top Nav has its own page object.
Each page object (e.g. TestProject/Resources/PO/RegistrationPage.resource) utilizes the Browser Library implementing
if applicable:

- Page URL verification
- Verifying Element Texts
- Verifying Element Links
- Actions that can be taken on the page (i.e. fill in a field, click an element etc)
- Checking error messages on the page if any is expected to be found

### 2.3.6 Verifiers

Each page in the system under test and Top Nave have their own verifiers, which can found under TestProject/Resources/Verifiers.
Note that the verifiers uses heavily the page objects' keywords to do a complete check up of the page in question:

+ checking the URL of the page
+ checking the texts of the page
+ checking the links of the page

### 2.3.7 External Components Used In TestProject

Referring to requirements.txt at the root of this repository, we can list the PyPi project pages of each dependency as follows:

+ backports.cached-property == 1.0.1            => https://pypi.org/project/backports.cached-property/
+ blessings == 1.7                              => https://pypi.org/project/blessings/
+ bpython == 0.21                               => https://pypi.org/project/bpython/
+ certifi == 2020.12.5                          => https://pypi.org/project/certifi/2020.12.5/
+ chardet == 4.0.0                              => https://pypi.org/project/chardet/
+ click == 8.0.1                                => https://pypi.org/project/click/
+ coverage == 5.5                               => https://pypi.org/project/coverage/
+ curtsies == 0.3.5                             => https://pypi.org/project/curtsies/
+ cwcwidth == 0.1.4                             => https://pypi.org/project/cwcwidth/
+ demjson == 2.2.4                              => https://pypi.org/project/demjson/
+ Flask == 1.0.2                                => https://pypi.org/project/Flask/1.0.2/
+ greenlet == 1.0.0                             => https://pypi.org/project/greenlet/1.0.0/
+ grpcio == 1.38.1                              => https://pypi.org/project/grpcio/1.38.1/
+ grpcio-tools == 1.38.1                        => https://pypi.org/project/grpcio-tools/1.38.1/
+ idna == 2.10                                  => https://pypi.org/project/idna/2.10/
+ importlib-metadata == 4.0.1                   => https://pypi.org/project/importlib-metadata/4.0.1/
+ itsdangerous == 2.0.1                         => https://pypi.org/project/itsdangerous/2.0.1/
+ Jinja2 == 3.0.1                               => https://pypi.org/project/Jinja2/3.0.1/
+ MarkupSafe == 2.0.1                           => https://pypi.org/project/MarkupSafe/2.0.1/
+ mockito == 1.2.2                              => https://pypi.org/project/mockito/1.2.2/
+ overrides == 6.1.0                            => https://pypi.org/project/overrides/6.1.0/
+ protobuf == 3.17.3                            => https://pypi.org/project/protobuf/3.17.3/
+ Pygments == 2.8.1                             => https://pypi.org/project/Pygments/2.8.1/
+ pyxdg == 0.27                                 => https://pypi.org/project/pyxdg/0.27/
+ requests == 2.25.1                            => https://pypi.org/project/requests/2.25.1/
+ robotframework == 4.0.3                       => https://pypi.org/project/robotframework/4.0.3/
+ robotframework-assertion-engine == 0.0.6      => https://pypi.org/project/robotframework-assertion-engine/0.0.6/
+ robotframework-browser == 5.1.2               => https://pypi.org/project/robotframework-browser/5.1.2/
+ robotframework-pythonlibcore == 3.0.0         => https://pypi.org/project/robotframework-pythonlibcore/3.0.0/
+ robotframework-robocop == 1.7.1               => https://pypi.org/project/robotframework-robocop/1.7.1/
+ robotframework-tidy == 1.1.1                  => https://pypi.org/project/robotframework-tidy/1.1.1/
+ six == 1.15.0                                 => https://pypi.org/project/six/1.15.0/
+ toml == 0.10.2                                => https://pypi.org/project/toml/0.10.2/
+ typing-extensions == 3.10.0.0                 => https://pypi.org/project/typing-extensions/3.10.0.0/
+ typing-utils == 0.0.3                         => https://pypi.org/project/typing-utils/0.0.3/
+ urllib3 == 1.26.4                             => https://pypi.org/project/urllib3/1.26.4/
+ Werkzeug == 0.14.1                            => https://pypi.org/project/Werkzeug/0.14.1/
+ wrapt == 1.12.1                               => https://pypi.org/project/wrapt/1.12.1/
+ zipp == 3.4.1                                 => https://pypi.org/project/zipp/3.4.1/

Note that the above dependences are mainly dependencies of the following main dependencies of TestProject:

+ robotframework
+ robotframework-browser
+ bpython (not a necessity, this and its dependencies can be removed)

# REFERENCES

[1] https://linuxhint.com/install_sqlite_browser_ubuntu_1804/

[2] https://phoenixnap.com/kb/how-to-install-python-3-ubuntu

[3] https://github.com/nodesource/distributions/blob/master/README.md  > Node.js v16.x
