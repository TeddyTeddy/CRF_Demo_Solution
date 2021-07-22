import os
import json
import random
import demjson
import re

def write_to_file(data_file_name, item):
    """ Writes the item to the file described in data_file_name.
       The file will be written under TestData/ folder.

    Args:
        data_file_name (str): a *.json where * can be any file name.
        item (a serializable json object, for ex of type: list, dict): The object whose content to be written to json file.
    """
    full_path_to_file = os.path.join(os.getcwd(),'TestData', data_file_name)
    with open(full_path_to_file, 'w') as f:
        json.dump(item, f, indent=4)

def create_register_form_data(username, password, first_name, last_name, phone_number):
    """ Returns a register_form_data (dict) containing username, password, first_name, last_name and phone_number items

    Args:
        username (dict): [description]
        password (dict): [description]
        first_name (dict): [description]
        last_name (dict): [description]
        phone_number (dict): [description]

    Returns:
        dict: register_form_data
    """
    register_form_data = {}
    register_form_data['username'] = username
    register_form_data['password'] = password
    register_form_data['first_name'] = first_name
    register_form_data['last_name'] = last_name
    register_form_data['phone_number'] = phone_number
    return register_form_data

def create_index_list(index_list_length, number_of_combinations):
    """ An index_list is a list of selected indexes.
        A selected index is a unique random number between the range [1, number_of_combinations] (both inclusive)

    Args:
        index_list_length (int): number of indexes to put into index_list (i.e. length of index_list)
        number_of_combinations (int): defines how many combinations of usernames, passwords, first_names, last_names and the phone numbers
                                      exist under TestData/ folder.

    Returns:
        list of integers: An index_list
    """
    index_list = []
    for j in range(1, index_list_length+1):
        # pick a unique selected_index, which is not in the index_list yet
        selected_index = random.randint(1, number_of_combinations)
        while selected_index in index_list: # if the selected_index is not unique, make it unique
            selected_index = random.randint(1, number_of_combinations)
        index_list.append(selected_index)
    return index_list

def create_register_form_data_set(usernames, passwords, first_names, last_names, phone_numbers, data_set_length):
    """ A generator/iterator yielding registration_form_data one at a time for each next() call

    Args:
        usernames (list of dict): a list of username instances. For examples, refer to TestData/Usernames.json
        passwords (list of dict): a list of password instances. For examples, refer to TestData/Passwords.json
        first_names (list of dict): a list of first name instances. For examples, refer to TestData/FirstNames.json
        last_names (list of dict): a list of last name instances. For examples, refer to TestData/LastNames.json
        phone_numbers (list of dict): a list of phone number instances. For example, refer to TestData/PhoneNumbers.json
        data_set_length (int): how many registration_form_data instances do you want this generator/iterator to return.

    Yields:
        [dictionary]: a Python dict object, representing registration_form_data
    """
    i = 1
    number_of_combinations = len(usernames) * len(passwords) * len(first_names) * len(last_names) * len(phone_numbers)
    index_list = create_index_list(data_set_length, number_of_combinations)
    data_set = []
    for username in usernames:
        for password in passwords:
            for first_name in first_names:
                for last_name in last_names:
                    for phone_number in phone_numbers:
                        # no need to include descriptions in fields, as they are for documentation purposes only
                        if 'description' in username: del username['description']
                        if 'description' in password: del password['description']
                        if 'description' in first_name: del first_name['description']
                        if 'description' in last_name: del last_name['description']
                        if 'description' in phone_number: del phone_number['description']
                        # there are 4069520 combinations of usernames, passwords, first_names, last_names, phone_numbers
                        # To stay practical for this assignment, we need to select only a random slice of those combinations
                        if i in index_list:
                            register_form_data = create_register_form_data(username, password, first_name, last_name, phone_number)
                            print('1:', register_form_data)
                            data_set.append(register_form_data)
                            yield register_form_data
                        else: # do nothing
                            pass
                        i+=1
    write_to_file('RegistrationFormDataSet.json', data_set)


def read_registration_form_data_set(filename='RegistrationFormDataSet.json'):
    """ Reads the TestData/RegistrationFormDataSet.json file one register_form_data at a time.
        An example of register_form_data instance can be listed as:

    {
        "username": {
            "value": "# 123abc",
            "isValid": false,
            "expected_error": "Minimum 8 characters required. Space character is not allowed"
        },
        "password": {
            "value": "ABC!?.abABC!?.abABC!?.",
            "isValid": false,
            "expected_error": "Min 8 characters. Must contain at least one character from [a-z], [A-Z], [0-9] and [!?.]"
        },
        "first_name": {
            "value": "Helena!.?",
            "isValid": false,
            "expected_error": "Each first name must contain only characters from the set [a-zA-Z]. First names must be seperated by a a single space. First names must have at least 2 characters"
        },
        "last_name": {
            "value": "W Xi",
            "isValid": false,
            "expected_error": "Each last name must contain only characters from the set [a-zA-Z]. Last names must be seperated by a a single space. Last names must have at least 2 characters"
        },
        "phone_number": {
            "value": "",
            "isValid": false,
            "expected_error": "Please fill out this field."
        }
    },

    Note that the file contains a list of register_form_data instances.
    Args:
        filename (str, optional): The json file which is supposed to contain register_form_data instances in a list.
                                  Defaults to 'RegistrationFormDataSet.json'. Look under TestData/ folder the file with that name

    Yields:
        [dictionary]: a Python dict object, which is initialized by reading register_form_data's lines, representing registration_form_data
    """
    file_path =  os.path.join(os.getcwd(),'TestData', filename)
    lines = []
    with open(file_path, 'r') as reader:
        for line in reader:
            if 'expected_error' not in line and ('[' in line or ']' in line):
                # beginning or end of a json array
                continue
            match = re.search(r'^    }', line)
            if match:
                lines.append('    }')
                yield demjson.decode(''.join(lines))
                del lines
                lines = []
            else:
                lines.append(line)

def registration_form_data_generator_factory(data_set_length=100, use_existing_form_data_set = True):
    """ Returns the proper iterator instance based on use_existing_form_data_set value

    Args:
        data_set_length (int, optional): the number of form_data_sets the iterator will return. Defaults to 100.
        use_existing_form_data_set (bool, optional): if true, then this method returns an iterator
                                   iteratively reading existing TestData/RegistrationFormDataSet.json contents
                                   (one registration_form_data at a time ignoring data_set_length).
                                   If false, then the factory returns 'yet another' iterator. This iterator uses data_set_length
                                   to populate as many registration_form_data instances as data_set_length (e.g. 100). Defaults to True.

    Returns:
        [iterator/generator]: an iterator yielding a register_form_data at each next() call
    """
    if use_existing_form_data_set:
        return read_registration_form_data_set('RegistrationFormDataSet.json')
    else:
        usernames = load_data('Usernames.json')
        passwords = load_data('Passwords.json')
        first_names = load_data('Firstnames.json')
        last_names = load_data('Lastnames.json')
        phone_numbers = load_data('PhoneNumbers.json')
        return create_register_form_data_set(usernames, passwords, first_names, last_names, phone_numbers, data_set_length)

def load_data(data_file_name):
    """ Expects data_file_name to be under TestData folder under the project directory
        Reads the json content and returns it as a python type

    Args:
        data_file_name (str): a json file name (e.g. TestData/Firstnames.json or TestData/PhoneNumbers.json)

    Returns:
        [list]: data content of the file (i.e. Firstnames or PhoneNumbers)
    """
    file_path =  os.path.join(os.getcwd(),'TestData', data_file_name)
    data = []
    with open(file_path, 'r') as f:
        data = json.load(f)
    return data

if __name__ != '__main__':  # if the module is imported
    pass

