from RegistrationFormDataUtils import registration_form_data_generator_factory
from robot.api.deco import keyword


class RegistrationFormDataReader:

    def __init__(self, data_set_length, use_existing_form_data_set):
        """ Initializes _iterator instance.

        Args:
            data_set_length (int): how many registration_form_data instances do you want the reader to return.
                                   For an example of 100 registration_form_data instances, refer to TestData/RegisterFormDataSet.json
            use_existing_form_data_set (bool): if true, then registration_form_data_generator_factory returns an iterator
                                   iteratively reading existing TestData/RegisterFormDataSet.json contents
                                   (one registration_form_data at a time ignoring data_set_length).
                                   If false, then the factory returns 'yet another' iterator, which uses data_set_length
                                   to populate as many registration_form_data instances as data_set_length value (e.g. 100)
        """
        self._iterator = registration_form_data_generator_factory(data_set_length, use_existing_form_data_set)

    def __del__(self):
        pass

    @keyword
    def read_registration_form_data(self):
        try:
            registration_form_data = next(self._iterator)
        except StopIteration:
            # to signal that creation of registration_form_data instances has finished
            return None
        else:
            return registration_form_data
