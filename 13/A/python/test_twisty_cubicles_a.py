"""
Tests for twisty_cubicles_a
"""

# allow one letter variable names
# pylint: disable=invalid-name

import unittest
import twisty_cubicles_a as tca


class TestTwistyCubiclesA(unittest.TestCase):
    """
    Tests for twisty_cubicles_a
    """

    def test_count_bits(self):
        """
        Tests for count_bits()
        """
        self.assertEqual(tca.count_bits(6), 2)
        self.assertEqual(tca.count_bits(13), 3)

    def test_is_open(self):
        """
        Tests for is_open()
        """
        self.assertTrue(tca.is_open(0, 0, 10))
        self.assertFalse(tca.is_open(1, 0, 10))
        self.assertTrue(tca.is_open(0, 1, 10))

        test_layout = [[True, False, True, False, False, False,
                        False, True, False, False],
                       [True, True, False, True, True, False,
                        True, True, True, False],
                       [False, True, True, True, True, False,
                        False, True, True, True],
                       [False, False, False, True, False, True,
                        False, False, False, True],
                       [True, False, False, True, True, False,
                        True, True, False, True],
                       [True, True, False, False, True, True,
                        True, True, False, True],
                       [False, True, True, True, False, False,
                        True, False, False, False]]
        for y, row in enumerate(test_layout):
            for x, val in enumerate(row):
                if val:
                    m = "%d %d should be open" % (x, y)
                else:
                    m = "%d %d should be closed" % (x, y)
                self.assertEqual(tca.is_open(x, y, 10), val, m)

    def test_bfs(self):
        """
        Test case for bfs()
        """
        test_x, test_y, test_fav = 7, 4, 10
        self.assertEqual(tca.bfs(test_x, test_y, test_fav), 11)


if __name__ == '__main__':
    unittest.main()
