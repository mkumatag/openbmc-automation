#!/usr/bin/python -u
import sys
from robot.libraries.BuiltIn import BuiltIn
import imp
import string



def get_sensor(module_name, value):
	m = imp.load_source('module.name', module_name)

	for i in m.ID_LOOKUP['SENSOR']:

		if m.ID_LOOKUP['SENSOR'][i] == value:
			return i

	return 0xFF
	
def get_inventory_sensor (module_name, value):
	m = imp.load_source('module.name', module_name)

	value = string.replace(value, '/org/openbmc/inventory', '<inventory_root>')

	for i in m.ID_LOOKUP['SENSOR']:

		if m.ID_LOOKUP['SENSOR'][i] == value:
			return i

	return 0xFF




def call_keyword(keyword):
    return BuiltIn().run_keyword(keyword)