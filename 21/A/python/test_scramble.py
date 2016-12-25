"""
Tests for scramble
"""

import unittest
import scramble


class TestScrambledA(unittest.TestCase):
    """Tests for scrambled_a"""

    def test_swap_position(self):
        """Tests for swap_position()"""
        self.assertEqual(scramble.swap_position(0, 4, 'abcde'), 'ebcda')
        self.assertEqual(scramble.swap_position(4, 0, 'abcde'), 'ebcda')

    def test_swap_letter(self):
        """Tests for swap_letter()"""
        self.assertEqual(scramble.swap_letter('a', 'e', 'abcde'), 'ebcda')
        self.assertEqual(scramble.swap_letter('b', 'd', 'abcde'), 'adcbe')

    def test_rotate(self):
        """Tests for rotate()"""
        self.assertEqual(scramble.rotate(1, 'abcde'), 'bcdea')
        self.assertEqual(scramble.rotate(3, 'abcde'), 'deabc')
        self.assertEqual(scramble.rotate(-1, 'abcde'), 'eabcd')
        self.assertEqual(scramble.rotate(-3, 'abcde'), 'cdeab')

    def test_rotate_on_letter(self):
        """Tests for rotate_on_letter()"""
        self.assertEqual(scramble.rotate_on_letter('d', 'ecabd'), 'decab')

    def test_reverse(self):
        """Tests for reverse()"""
        self.assertEqual(scramble.reverse(0, 4, 'abcde'), 'edcba')
        self.assertEqual(scramble.reverse(2, 3, 'abcde'), 'abdce')
        self.assertEqual(scramble.reverse(0, 3, 'abcde'), 'dcbae')
        self.assertEqual(scramble.reverse(3, 4, 'abcde'), 'abced')

    def test_move(self):
        """Tests for move()"""
        self.assertEqual(scramble.move(0, 4, 'abcde'), 'bcdea')
        self.assertEqual(scramble.move(1, 3, 'abcde'), 'acdbe')


if __name__ == '__main__':
    unittest.main()
