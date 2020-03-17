import pyotp, re, sys

class AuthLibrary(object):
    def get_two_factor_auth(self,token):
        self._code = pyotp.TOTP(token)
        return self._code.now()

    def rgb_to_hex(self,rgb):
        r,g,b = map(int,re.search(r'rgb\((\d+),\s*(\d+),\s*(\d+)',rgb).groups())
        return '#%02x%02x%02x' % (r,g,b)

    def python_version(self):
        return sys.version_info[0]
