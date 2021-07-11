from RegistrationFormDataUtils import   registration_form_data_generator_factory
from robot.api.deco import keyword
from robot.api import logger


class RegistrationFormDataReader:

    def __init__(self, data_set_length, use_existing_form_data_set):
        self._iterator = registration_form_data_generator_factory(data_set_length, use_existing_form_data_set)

    def __del__(self):
        pass

    @keyword
    def read_registration_form_data(self):
        try:
            registration_form_data = next(self._iterator)
        except StopIteration:
            return None
        else:
            return registration_form_data


