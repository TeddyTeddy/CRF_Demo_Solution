import os
import json
import random
import demjson
import re

def write_to_file(data_file_name, item):
    full_path_to_file = os.path.join(os.getcwd(),'TestData', data_file_name)
    with open(full_path_to_file, 'w') as f:
        json.dump(item, f, indent=4)

def create_register_form_data(username, password, first_name, last_name, phone_number):
    register_form_data = {}
    register_form_data['username'] = username
    register_form_data['password'] = password
    register_form_data['first_name'] = first_name
    register_form_data['last_name'] = last_name
    register_form_data['phone_number'] = phone_number
    return register_form_data

def create_index_list(index_list_length, number_of_combinations):
    index_list = []
    for j in range(1, index_list_length+1):
        # pick a unique selected_index, which is not in the index_list yet
        selected_index = random.randint(1, number_of_combinations)
        while selected_index in index_list:
            selected_index = random.randint(1, number_of_combinations)
            print(index_list)
            print(selected_index)
        index_list.append(selected_index)
    return index_list

def create_register_form_data_set(usernames, passwords, first_names, last_names, phone_numbers, data_set_length):
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
                        # we need to select only a random slice of those combinations
                        if i in index_list:
                            register_form_data = create_register_form_data(username, password, first_name, last_name, phone_number)
                            print('1:', register_form_data)
                            data_set.append(register_form_data)
                            yield register_form_data
                        else: # do nothing
                            pass
                        i+=1
    write_to_file('RegisterFormDataSet.json', data_set)


def read_register_form_data_set(filename):
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
    if use_existing_form_data_set:
        return read_register_form_data_set('RegisterFormDataSet.json')
    else:
        usernames = load_data('Usernames.json')
        passwords = load_data('Passwords.json')
        first_names = load_data('Firstnames.json')
        last_names = load_data('Lastnames.json')
        phone_numbers = load_data('PhoneNumbers.json')
        return create_register_form_data_set(usernames, passwords, first_names, last_names, phone_numbers, data_set_length)

def load_data(data_file_name):
    file_path =  os.path.join(os.getcwd(),'TestData', data_file_name)
    data = []
    with open(file_path, 'r') as f:
        data = json.load(f)
    return data

if __name__ != '__main__':  # if the module is imported
    pass

