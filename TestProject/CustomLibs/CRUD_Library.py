from robot.api.deco import keyword
import requests
import demjson

class CRUD_Library:

    ROBOT_LIBRARY_SCOPE = 'TEST SUITE'

    def __init__(self, base_url):
        """ Initializes the library with the given parameters.

        a full route                => http://0.0.0.0:8080/api/users
        the base_url of the route   => http://0.0.0.0:8080/api
        the endpoint of the route       =>                    /users

        Args:
            base_url (str): base url of the routes provided by the API. May or may not end with /
        """
        self._base_url = base_url
        self._session = requests.Session()
        self._response = None

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
            headers (str, optional): Headers as a JSON object (str) to add or override for the request. Defaults to None.

        Returns:
            dict: Returns the whole response body as dictionary
        """
        full_route = CRUD_Library.form_full_route(self._base_url, endpoint)
        headers = demjson.decode(headers)
        self._response = self._session.get(full_route, params=query_params, headers=headers)
        return self._response.json()  # returns a dictionary


