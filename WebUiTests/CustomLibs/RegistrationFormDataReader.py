from RegistrationFormDataUtils import registration_form_data_generator_factory, read_registration_form_data_set, load_data
from robot.api.deco import keyword


class RegistrationFormDataReader:

    def __init__(self, data_set_length, use_existing_form_data_set):
        """ Initializes _iterator instance.

        Args:
            data_set_length (int): how many registration_form_data instances do you want the reader to return.
                                   For an example of 100 registration_form_data instances, refer to TestData/RegistrationFormDataSet.json
            use_existing_form_data_set (bool): if true, then registration_form_data_generator_factory returns an iterator
                                   iteratively reading existing TestData/RegistrationFormDataSet.json contents
                                   (one registration_form_data at a time ignoring data_set_length).
                                   If false, then the factory returns 'yet another' iterator, which uses data_set_length
                                   to populate as many registration_form_data instances as data_set_length value (e.g. 100)
        """
        self._random_form_data_generator = registration_form_data_generator_factory(data_set_length, use_existing_form_data_set)
        self._valid_form_data_generator = read_registration_form_data_set('ManyValidUsers.json')
        self._usernames = None
        self._passwords = None
        self._first_names = None
        self._last_names = None

    def __del__(self):
        del self._random_form_data_generator
        del self._valid_form_data_generator
        del self._usernames
        del self._passwords
        del self._first_names
        del self._last_names

    @keyword
    def read_random_registration_form_data(self):
        try:
            registration_form_data = next(self._random_form_data_generator)
        except StopIteration:
            # to signal that creation of registration_form_data instances has finished
            return None
        else:
            return registration_form_data

    @keyword
    def read_one_valid_users_registration_form_data(self):
        try:
            registration_form_data = next(self._valid_form_data_generator)
        except StopIteration:
            # implementing a cyclic reading of many valid users: i.e.
            # once finished reading the valid users one by one
            # reading goes back to the first valid user
            del self._valid_form_data_generator
            self._valid_form_data_generator = read_registration_form_data_set('ManyValidUsers.json')
            # to signal that creation of registration_form_data instances has finished
            return None
        else:
            return registration_form_data

    @staticmethod
    def look_for(list_of_items, description):
        for item in list_of_items:
            if description in item['description']:  # case sensitive search
                return item
        assert False    # should never happen, make sure that description is set correctly

    @keyword
    def do_manipulate(self, registration_form_data, key, description):
        if key == 'username':
            if self._usernames is None:
                self._usernames = load_data('Usernames.json')
            username = RegistrationFormDataReader.look_for(self._usernames, description)
            registration_form_data['username'] = username
            return
        if key == 'password':
            if self._passwords is None:
                self._passwords = load_data('Passwords.json')
            password = RegistrationFormDataReader.look_for(self._passwords, description)
            registration_form_data['password'] = password
            return
        if key == 'first_name':
            if self._first_names is None:
                self._first_names = load_data('Firstnames.json')
            first_name = RegistrationFormDataReader.look_for(self._first_names, description)
            registration_form_data['first_name'] = first_name
            return
        if key == 'last_name':
            if self._last_names is None:
                self._last_names = load_data('Lastnames.json')
            last_name = RegistrationFormDataReader.look_for(self._last_names, description)
            registration_form_data['last_name'] = last_name
            return
        assert False    # should never happen, make sure that key is set correctly


