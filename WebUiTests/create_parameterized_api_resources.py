import itertools
import os
import glob
import json

def write_to_file(api_resource_file_path, item_list):
    full_path_to_file = os.path.join(os.getcwd(), api_resource_file_path)
    with open(full_path_to_file, 'w') as f:
        for item in item_list:
            f.write(f'{item}\n')

def get_resource_profiles():
    # https://stackoverflow.com/questions/3207219/how-do-i-list-all-files-of-a-directory
    # list all the files whose name matching the pattern *ResourceProfile.json
    resource_profile_files =  glob.glob(os.path.join(os.getcwd(),'Profiles', '*ResourceProfile.json'))
    resource_profiles = []
    for file_path in resource_profile_files:
        with open(file_path, 'r') as f:
            profile = json.load(f)
            resource_profiles.append(profile)
    return resource_profiles

def api_resource_file_exists(full_path_to_file):
    return os.path.isfile(full_path_to_file) and (os.path.getsize(full_path_to_file) != 0)

def display_resource_profile(profile, index):
        print(f'{index}: api resource \"{ profile["api_resource"] }\" with the following information:')
        print(f'   keys: { profile["api_resource_keys"]}')
        full_path_to_file = os.path.join(os.getcwd(), profile['api_resource_file_path'])
        if api_resource_file_exists(full_path_to_file):
            print(f'   api_resource_file_path: {full_path_to_file} (exists and has data in it)')
        else:
            print(f'   api_resource_file_path: {full_path_to_file} (does not exist or empty)')

def show_api_resources(resource_profiles):
    print("Below is a list of found resource profiles under Profiles/ directory")
    i = 0
    for profile in resource_profiles:
        display_resource_profile(profile, i)
        i+=1

def select_resource_profile(resource_profiles):
    i = 0
    resource_profile_index = None
    while True:
        choice = input(f'Enter a number shown above to select a corresponding resource profile, or press ENTER only to stop: ')
        if len(choice) > 0:  # not pressed ENTER
            resource_profile_index = int(choice)
            if resource_profile_index >= len(resource_profiles):
                print(f'{choice} is not a valid number. Enter a valid number between [0, {len(resource_profiles)-1}]')
            else:
                break  # a valid resource_profile_index chosen
        else:
            break              # pressed ENTER to exit
    return resource_profile_index

def get_json_api_resource(resource_items):
    # form json_api_resource from resource_items
    return '{' + ','.join(resource_items) + '}'

def get_keys_item(key, value):
    if type(value) is int or type(value) is float:
        item = f'"{key}":{value}'       # e.g. "description":100.0
    elif type(value) is str:
        item = f'"{key}":"{value}"'     # e.g. "name":"['1','2','3']"
    elif type(value) is dict:
        # https://stackoverflow.com/questions/18283725/how-to-create-a-python-dictionary-with-double-quotes-as-default-quote-format
        item = f'"{key}":{json.dumps(value)}'   #  e.g. "name":{"key": "value"}
    elif type(value) is bool:
        if value: # if True
            item = f'"{key}":true'
        else : # if False
            item = f'"{key}":false'
    elif type(value) is list:
        item = f'"{key}": {value}'
    elif value is None:
        item = f'"{key}": null'
    else:
        raise AssertionError(f'create_resources(): item cannot be formed based on type(value): {type(value)}')
    return item

def create_resources(key_combination, values):
    """
    key_combination: a tuple containing a key names' combination (e.g. ('name',) or ('description',) or ('name', 'description'))
    values = a list of values which will be combined against key_combination's items (e.g. ['null', '[]'] )

    For example, if key_combination=('name', 'description') and values=['null', '[]'] then the outcome will be:
    [
        {"name":"null","description":"null"},
        {"name":"null","description":"[]"},
        {"name":"[]","description":"null"},
        {"name":"[]","description":"[]"},
    ]
    """
    list_of_lists = []
    for key in key_combination: # e.g. key_combination = ('name', 'description') & key = 'name'
        keys_items = []
        for value in values:  # e.g. values = ['null', '[]']
            keys_items.append(get_keys_item(key, value))  # e.g. keys_items = ['"name":"null"', '"name":"[]"']
        list_of_lists.append(keys_items)    # e.g. list_of_lists = [['"name":"null"', '"name":"[]"'], ['"description":"null"', '"description":"[]"']]
    # create a cross combination of items in list_of_lists
    # https://stackoverflow.com/questions/798854/all-combinations-of-a-list-of-lists
    iterable = itertools.product(*list_of_lists)
    result = []
    for resource_items in iterable:  # e.g. iterable will be (('"name":"null"', '"description":"null"'), ('"name":"null"', '"description":"[]"'),('"name":"[]"', '"description":"null"'), ('"name":"[]"', '"description":"[]"'))
        # resource_items will be e.g. ('"name":"null"', '"description":"null"')
        json_api_resource = get_json_api_resource(resource_items)  # e.g. '{"name":"null","description":"null"}'
        # do a final check: did get_json_api_resource() method return a valid json?
        # https://stackoverflow.com/questions/5508509/how-do-i-check-if-a-string-is-valid-json-in-python
        json.loads(json_api_resource)
        result.append(json_api_resource)
    return result

def create_parameterized_resources(keys, values):
    """
    keys: a list containing key names for the API resource (e.g. ["name", "description"])
    values: a list containing different key values (e.g. ['null', '[]'])

    The output sum of all keys' combinations of length r (r from 0 to len(keys)) vs. values

    For example: Given keys=["name", "description"] and values=['null', '[]']
    The output is:
    [
        '{}',
        '{"name":"null"}',
        '{"name":"[]"}',
        '{"description":"null"}',
        '{"description":"[]"}',
        '{"name":"null","description":"null"}',
        '{"name":"null","description":"[]"}',
        '{"name":"[]","description":"null"}',
        '{"name":"[]","description":"[]"}'
    ]

    Note that each item in the output list is a JSON representation of an API resource

    """
    result = ["{}"]  # an empty resource must always be the first; it represents 0.th length combinations of keys items
    l = 1
    while l <= len(keys):  # e.g. l = 1
        # calculate combinations of length l for keys items
        # https://www.geeksforgeeks.org/permutation-and-combination-in-python/
        combs = itertools.combinations(keys, l)
        for key_combination in list(combs):  # e.g. list(combs) = [('name',), ('description',)]
            result += create_resources(key_combination, values)  # e.g. key_combination: ('name',)
        l+=1
    return result

def get_users_choice(question):
    choice = input(question)
    if choice == "y" or choice == "Y":
        return True
    return False


if __name__ == '__main__':

    values = [None, [], [1,2,3], True, False, {}, {"key":"value"}, 0, -1, 1, 1.0E+2, "valid string" ]
    # read *ResourceProfile.json files into resource_profiles dictionary
    resource_profiles = get_resource_profiles()

    # Show user all the api resources names
    show_api_resources(resource_profiles)
    # Prompt user to select an api resource to parameterize
    selected_profile_index = select_resource_profile(resource_profiles)

    if selected_profile_index is not None:
        print("\n********************************\nThe following api resource is selected:")
        display_resource_profile(resource_profiles[selected_profile_index], selected_profile_index)
        proceed = get_users_choice("Proceed to overwrite the API resource file? (Y/N)")
        if proceed:
            print(f'Overwriting {resource_profiles[selected_profile_index]["api_resource_file_path"]} ...')
            parameterized_resource_list = create_parameterized_resources(resource_profiles[selected_profile_index]["api_resource_keys"], values)
            write_to_file(resource_profiles[selected_profile_index]["api_resource_file_path"], parameterized_resource_list)
        else:
            print("Api resource file kept untouched, aborting")
    else:
        print("No api resource is selected, aborting")