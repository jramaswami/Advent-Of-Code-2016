"""
Tests for joseph_b.py
"""

import unittest
from joseph_b import josephus_circle


class TestJosephB(unittest.TestCase):
    """
    Tests for joseph_b.py
    """
    def test_josephus_circle(self):
        """
        Tests for josephus_circle
        """
        self.assertEqual(josephus_circle(5), 2)
        self.assertEqual(josephus_circle(20), 13)
        self.assertEqual(josephus_circle(27), 27)
        self.assertEqual(josephus_circle(68), 55)
        self.assertEqual(josephus_circle(94), 13)
        self.assertEqual(josephus_circle(100), 19)


if __name__ == '__main__':
    unittest.main()
