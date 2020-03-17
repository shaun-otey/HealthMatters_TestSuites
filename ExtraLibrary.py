import pyotp, re, sys, boto3, botocore
# from PyPDF2 import PdfFileReader
from selenium.webdriver.common.action_chains import ActionChains
from SeleniumLibrary.locators import ElementFinder
from robot.libraries.BuiltIn import BuiltIn

class ExtraLibrary(object):
    def __init__(self):
        ctx = BuiltIn().get_library_instance('SeleniumLibrary')
        self._element_finder = ElementFinder(ctx)

    def get_two_factor_auth(self, token):
        """ Get auth token """
        self._code = pyotp.TOTP(token)
        return self._code.now()

    def rgb_to_hex(self, rgb):
        """ Convert from rgb to hex """
        r, g, b = map(int, re.search(r'rgb\((\d+),\s*(\d+),\s*(\d+)', rgb).groups())
        return '#%02x%02x%02x' % (r, g, b)

    def python_version(self):
        """ Get current running python version """
        return sys.version_info[0]

    # def extract_raw_pdf(self, file):
    #     pdf = PdfFileReader(open(file, 'rb'))
    #     text = ''
    #     for page in range(pdf.numPages):
    #         text += pdf.getPage(page).extractText()
    #     return text

    def line_segment(self, driver, locator, x_start, y_start, x_end, y_end):
        """ Draw a line segment """
        # element = self._element_find(locator, True, False)
        # element = self._element_finder.find(locator, None, True, False)
        element = self._element_finder.find(locator, required=False)
        if element is None:
            raise AssertionError("ERROR: Element %s not found." % (locator))
        x_s = float(x_start)
        y_s = float(y_start)
        x_e = float(x_end) - float(x_start)
        y_e = float(y_end) - float(y_start)
        ActionChains(driver).move_to_element(element).move_by_offset(x_s, y_s).click_and_hold().move_by_offset(x_e, y_e).release().perform()

    def _element_find(self, driver, locator, first_only, required, tag=None):
        if isinstance(locator, str):
            elements = self._element_finder.find(driver, locator, tag)
            if required and len(elements) == 0:
                raise ValueError("Element locator '" + locator + "' did not match any elements.")
            if first_only:
                if len(elements) == 0: return None
                return elements[0]
        elif isinstance(locator, WebElement):
            elements = locator
        return elements

    def frame_switch(self, driver, iframe_url):
        """ View raw HTML form an iframe """
        # from urllib.parse import urljoin
        # url = urljoin(base_url, src)
        # driver.get(url)
        # driver.switch_to.frame(driver.find_element_by_name("iframe_name"))
        driver.switch_to.frame(iframe_url)
        iframe = driver.page_source
        driver.switch_to.default_content()
        return iframe

    def perform_queue_action(self, name):
        """ Pop from an AWS sqs """
        queue = boto3.client('sqs', region_name='us-east-1')
        try:
            url = queue.get_queue_url(QueueName=name)['QueueUrl']
        except botocore.exceptions.NoCredentialsError:
            aws_key = os.environ.get('AWS_ACCESS_KEY_ID')
            aws_secret = os.environ.get('AWS_SECRET_ACCESS_KEY')
            queue = boto3.client('sqs', aws_access_key_id=aws_key, aws_secret_access_key=aws_secret, region_name='us-east-1')
            try:
                url = queue.get_queue_url(QueueName=name)['QueueUrl']
            except botocore.exceptions.NoCredentialsError:
                return 'NOCREDS'
        message_object = queue.receive_message(QueueUrl=url)
        try:
            message = message_object['Messages'][0]
        except KeyError:
            return 'EMPTYQ'
        else:
            body, receipt = message['Body'], message['ReceiptHandle']
        queue.delete_message(QueueUrl=url, ReceiptHandle=receipt)
        return body
