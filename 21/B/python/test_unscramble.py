"""
Tests for unscramble.py
"""

import unittest
import unscramble


class TestUnscramble(unittest.TestCase):
    """
    Tests for unscramble.py
    """

    def test_unscramble(self):
        """
        Tests for unscramble()
        """
        with open('../../test1.txt') as test_fh:
            instructions = test_fh.readlines()
        self.assertIn('abcde', unscramble.unscramble(instructions, 'decab'))
        with open('../../input.txt') as test_fh:
            instructions = test_fh.readlines()
        self.assertIn('abcdefgh',
                      unscramble.unscramble(instructions, 'gbhcefad'))



if __name__ == '__main__':
    unittest.main()
