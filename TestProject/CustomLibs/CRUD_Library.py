from robot.api.deco import keyword
import requests

class CRUD_Library:

    ROBOT_LIBRARY_SCOPE = 'TEST SUITE'

    def __init__(self, base_url):
        """ Initializes the library with the given parameters.

        a full route                => http://0.0.0.0:8080/api/users
        the base_url of the route   => http://0.0.0.0:8080/api
        the endpoint of the route   =>                        /users

        Args:
            base_url (str): base url of the routes provided by the API. May or may not end with /
        """
        self._base_url = base_url
        self._session = requests.Session()
        self._response = None
        self._default_headers = {'Content-Type': 'application/json'}

    def __del__(self):
        self._session.close()

    @staticmethod
    def form_full_route(base_url, endpoint):
        if base_url.endswith('/'):
            return base_url[0:(len(base_url)-1)] + endpoint     # to prevent adding // to full route
        else:
            return base_url + endpoint

    @keyword
    def GET(self, endpoint, query_params=None, headers=None):
        """ Sends a GET request to the endpoint.

        a full route                => http://0.0.0.0:8080/api/users
        the base_url of the route   => http://0.0.0.0:8080/api
        the endpoint of the route   =>                        /users

        endpoint must start with / character.

        Args:
            endpoint (str): The endpoint is joined with the base_url given on library init to get the full route
            query_params (str/dict, optional): Request query parameters as a JSON object (str) or a dictionary. Defaults to None.
            headers (dict, optional): Headers as dictionary to add. Defaults to None.

        Returns:
            dict: Returns the whole response body as dictionary
        """
        full_route = CRUD_Library.form_full_route(self._base_url, endpoint)
        if headers:
            request_headers = {**(self._default_headers), **headers}        # Python >= 3.5; a new dictionary containing the items from both headers and and default_headers
        else:
            request_headers = self._default_headers
        self._response = self._session.get(full_route, params=query_params, headers=request_headers)
        return self._response.json()  # returns a dictionary


