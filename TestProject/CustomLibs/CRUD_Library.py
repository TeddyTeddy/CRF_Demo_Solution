from robot.api.deco import keyword
from robot.api import logger
import requests
from requests.exceptions import HTTPError

class CRUD_Library:
    """HTTP JSON API test library for Robot Framework.
    """
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
        self._default_headers = {'Content-Type': 'application/json'}

    def __del__(self):
        self._session.close()

    @staticmethod
    def form_full_route(base_url, endpoint):
        """Adds endpoint to base_url and returns the full route as a result
           If base_url ends with / it ignores it.
        Args:
            base_url (str): base url of the full route
            endpoint (type): endpoint of the full route

        Returns:
            str: the full route
        """
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
        response = self._session.get(full_route, params=query_params, headers=request_headers)

        try:
            response.raise_for_status() # If the response was successful, no Exception will be raised
            return response.json()  # returns a dictionary
        except HTTPError as http_err: #  for 4XX and 5XX codes
            if http_err.response.status_code in range(500, 600):  # for 5XX codes
                logger.error(f'HTTP error occurred: {http_err}')
                assert False, "System under test has crashed with 5XX"
            elif http_err.response.status_code in range(400, 500):  # for 4XX codes
                return response.json()  # returns a dictionary
        except Exception as other_error:
            logger.error(f'Other error occurred: {other_error}')
            assert False, "Do not proceed with executing the rest of the test, investigate this exception"


    @keyword
    def PUT(self, endpoint, body=None, headers=None):
        """	Sends a PUT request to the endpoint.
            The endpoint is joined with the base_url given on library init.

        Args:
            endpoint (str): The endpoint is joined with the base_url given on library init to get the full route
            body (dict, optional): Request body parameters as a dictionary. Defaults to None.
            headers (dict, optional): Headers as dictionary to add. Defaults to None.
        """
        full_route = CRUD_Library.form_full_route(self._base_url, endpoint)
        if headers:
            request_headers = {**(self._default_headers), **headers}        # Python >= 3.5; a new dictionary containing the items from both headers and and default_headers
        else:
            request_headers = self._default_headers
        response = self._session.put(full_route, data=body, headers=request_headers)

        try:
            response.raise_for_status() # If the response was successful, no Exception will be raised
            return response.json()  # returns a dictionary
        except HTTPError as http_err: #  for 4XX and 5XX codes
            if http_err.response.status_code in range(500, 600):  # for 5XX codes
                logger.error(f'HTTP error occurred: {http_err}')
                assert False, "System under test has crashed with 5XX."
            elif http_err.response.status_code in range(400, 500):  # for 4XX codes
                if response.headers.get('content-type') == 'application/json':
                    return response.json()  # returns a dictionary
                else:
                    logger.info(f'HTTP error occurred: {http_err}')
                    assert False, f"We expected a JSON, but received {response.headers.get('content-type')}"

        except Exception as other_error:
            logger.error(f'Other error occurred: {other_error}')
            assert False    # Do not proceed with executing the rest of the test, investigate this exception
