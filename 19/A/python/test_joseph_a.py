"""
Tests for joseph_a.py
"""

import unittest
from joseph_a import white_elephant_party


class TestJosephA(unittest.TestCase):
    """
    Tests for joseph_a.py
    """

    def test_white_elephant_party(self):
        """
        Tests for white_elephant_party
        """
        winner = white_elephant_party(5)
        self.assertEqual(winner.id, 3)


if __name__ == '__main__':
    unittest.main()
