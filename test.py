import unittest
from app import app

class TestApp(unittest.TestCase):

    def setUp(self):
        self.app = app.test_client()

    def test_main(self):
        rv = self.app.get('/')
        assert rv.status == '200 OK'

if __name__ == '__main__':
  unittest.main(argv=['ignore'], exit=False)