*** Settings ***
Documentation		Main Page's elements' locators are defined here


*** Variable ***
&{MAIN_PAGE_LOCATOR}
...     title=//html/body/section/header/h1
...     key_column_title=//html/body/section/table/tbody/tr[1]/th[1]
...     value_column_title=//html/body/section/table/tbody/tr[1]/th[2]
...     username_key=//html/body/section/table/tbody/tr[2]/td[1]
...     username_value=//*[@id='username']
...     first_name_key=//html/body/section/table/tbody/tr[3]/td[1]
...     first_name_value=//*[@id='firstname']
...     last_name_key=//html/body/section/table/tbody/tr[4]/td[1]
...     last_name_value=//*[@id='lastname']
...     phone_number_key=//html/body/section/table/tbody/tr[5]/td[1]
...     phone_number_value=//*[@id='phone']

