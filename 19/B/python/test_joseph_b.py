"""
Tests for joseph_b.py
"""

import unittest
from joseph_b import white_elephant_party


class TestJosephB(unittest.TestCase):
    """
    Tests for joseph_b.py
    """

    def test_white_elephant_party(self):
        """
        Tests for white_elephant_party
        """
        winner = white_elephant_party(5)
        self.assertEqual(winner, 2)


if __name__ == '__main__':
    unittest.main()
