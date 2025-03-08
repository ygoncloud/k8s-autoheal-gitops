import unittest
from app import app

class TestHealthChecks(unittest.TestCase):
    def setUp(self):
        self.app = app.test_client()
    
    def test_health_check(self):
        response = self.app.get("/health")
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.data, b"OK")
    
    def test_readiness_check(self):
        response = self.app.get("/ready")
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.data, b"Ready")

if __name__ == "__main__":
    unittest.main()

