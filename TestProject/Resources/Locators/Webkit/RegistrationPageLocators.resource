*** Settings ***
Documentation		Registration Page's elements' locators are defined here


*** Variable ***
&{REGISTRATION_PAGE_LOCATOR}
...     form_title=//html/body/section/header/h1
...     username_label=//html/body/section/form/label[1]
...		username_field=//*[@id="username"]
...     password_label=//html/body/section/form/label[2]
...		password_field=//*[@id="password"]
...     firstname_label=//html/body/section/form/label[3]
...		firstname_field=//*[@id="firstname"]
...     lastname_label=//html/body/section/form/label[4]
...		lastname_field=//*[@id="lastname"]
...     phone_number_label=//html/body/section/form/label[5]
...		phone_number_field=//*[@id="phone"]
...		register_button=//input[@type="submit" and @value="Register"]


