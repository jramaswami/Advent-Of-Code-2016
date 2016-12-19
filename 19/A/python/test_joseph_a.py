"""
Tests for joseph_a.py
"""

import unittest
from joseph_a import josephus_circle


class TestJosephA(unittest.TestCase):
    """
    Tests for joseph_a.py
    """

    def test_josephus_circle(self):
        """
        Tests for josephus_circle
        """
        self.assertEqual(josephus_circle(5), 3)
        self.assertEqual(josephus_circle(3001330), 1808357)


if __name__ == '__main__':
    unittest.main()
