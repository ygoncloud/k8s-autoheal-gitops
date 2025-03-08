import unittest
from kubernetes import client, config

class TestKubernetesAPI(unittest.TestCase):
    def setUp(self):
        config.load_kube_config()  # Use in-cluster config if running inside a pod
        self.v1 = client.CoreV1Api()

    def test_get_pods(self):
        pods = self.v1.list_pod_for_all_namespaces(watch=False)
        self.assertGreaterEqual(len(pods.items), 0)

if __name__ == "__main__":
    unittest.main()

