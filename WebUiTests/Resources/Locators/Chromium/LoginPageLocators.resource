*** Settings ***
Documentation		Login Page's elements' locators are defined here


*** Variable ***
&{LOGIN_PAGE_LOCATOR}
...     form_title=//html/body/section/header/h1
...     username_label=//html/body/section/form/label[1]
...		username_field=//*[@id="username"]
...     password_label=//html/body/section/form/label[2]
...		password_field=//*[@id="password"]
...		login_button=//input[@type="submit" and @value="Log In"]


