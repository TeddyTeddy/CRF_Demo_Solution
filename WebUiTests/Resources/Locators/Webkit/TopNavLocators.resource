*** Settings ***
Documentation		Top Navigation Pane's elements' locators are defined here


*** Variable ***
&{TOP_NAV_LOCATOR}
...		main_title=//html/body/nav/h1/a
...     register=//html/body/nav/ul/li[1]/a
...     login=//html/body/nav/ul/li[2]/a
...     dynamic_username=//html/body/nav/ul/li[1]/span
...     logout=//html/body/nav/ul/li[2]/a