import json
from flask import request, abort
from functools import wraps

from jose import jwt
from urllib.request import urlopen

AUTH0_DOMAIN = 'ry-fsnd.auth0.com'
ALGORITHMS = ['RS256']
API_AUDIENCE = 'fsnd-capstone'


# AuthError Exception
class AuthError(Exception):
    """
    AuthError Exception
    A standardized way to communicate auth failure modes
    """

    def __init__(self, error, status_code):
        self.error = error
        self.status_code = status_code


# Auth Header
def get_token_auth_header():
    auth_header = request.headers.get("Authorization", None)

    if auth_header is None:
        raise AuthError({
            "code": "authorization_header_missing",
            "description": "Authorization Header is required."
        }, 401)

    auth_header_values = auth_header.split(" ")
    if len(auth_header_values) != 2:
        raise AuthError({
            "code": "invalid_authorization_header",
            "description": "Authorization Header is malformed."
        }, 401)
    elif auth_header_values[0].lower() != "bearer":
        raise AuthError({
            "code": "invalid_authorization_header",
            "description": "Authorization Header must start with \"Bearer\"."
        }, 401)

    return auth_header_values[1]


def check_permissions(permission, payload):
    if 'permissions' not in payload:
        raise AuthError({
            'code': 'invalid_claims',
            'description': 'Permissions not included in JWT.'
        }, 400)

    if permission not in payload['permissions']:
        raise AuthError({
            'code': 'unauthorized',
            'description': 'Requested Permission not found.'
        }, 401)

    return True


def verify_decode_jwt(token):
    url_string = "https://{}/.well-known/jwks.json".format(AUTH0_DOMAIN)
    json_url = urlopen(url_string)
    jwks = json.loads(json_url.read())
    unverified_header = jwt.get_unverified_header(token)
    rsa_key = {}

    if 'kid' not in unverified_header:
        raise AuthError({
            'code': 'invalid_authorization_header',
            'description': 'Authorization Header is malformed.'
        }, 401)

    for key in jwks['keys']:
        if key['kid'] == unverified_header['kid']:
            rsa_key = {
                'kty': key['kty'],
                'kid': key['kid'],
                'use': key['use'],
                'n': key['n'],
                'e': key['e']
            }

    if rsa_key:
        try:
            payload = jwt.decode(
                token,
                rsa_key,
                algorithms=ALGORITHMS,
                audience=API_AUDIENCE,
                issuer='https://{}/'.format(AUTH0_DOMAIN)
            )

            return payload

        except jwt.ExpiredSignatureError:
            raise AuthError({
                'code': 'token_expired',
                'description': 'Token expired.'
            }, 401)

        except jwt.JWTClaimsError:
            raise AuthError({
                'code': 'invalid_claims',
                'description':
                    'Incorrect claims. Please check the audience and issuer.'
            }, 401)

        except Exception:
            raise AuthError({
                'code': 'invalid_authorization_header',
                'description': 'Unable to parse authentication token.'
            }, 401)

    raise AuthError({
        'code': 'invalid_authorization_header',
        'description': 'Unable to find the appropriate key.'
    }, 401)


def requires_auth(permission=''):
    def requires_auth_decorator(f):
        @wraps(f)
        def wrapper(*args, **kwargs):
            try:
                token = get_token_auth_header()
                payload = verify_decode_jwt(token)
                check_permissions(permission, payload)
            except AuthError as authError:
                raise abort(authError.status_code,
                            authError.error["description"])

            return f(payload, *args, **kwargs)

        return wrapper

    return requires_auth_decorator
