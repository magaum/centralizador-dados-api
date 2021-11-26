import unittest
from unittest.mock import patch, MagicMock
import app

class TestApp(unittest.TestCase):
    def test_invalid_event(self):
        #arrange
        event = {}
        context = {}
        #act & #assert
        with self.assertRaises(ValueError):
            app.handler(event, context)


    @patch('app.os.getenv', MagicMock(return_value = "workflow_test"))
    @patch('app.glue_client.start_workflow_run', MagicMock(return_value = { "status": 200 }))
    def test_default_glue_workflow(self):
        #arrange
        event = {}
        context = {}

        #act
        response = app.handler(event, context)

        #assert
        self.assertIn('status', response)
        self.assertEqual(response['status'], 200)

if __name__ == '__main__':
    unittest.main()