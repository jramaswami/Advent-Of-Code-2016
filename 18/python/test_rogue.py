"""
Tests for rogue.py
"""

import unittest
import rogue as rg


class RogueTests(unittest.TestCase):
    """
    Tests for rogue.py
    """

    def test_string_to_row(self):
        """
        Tests for string_to_row
        """
        expected = [True, True, False, False, True]
        tile_str = "..^^.\n"
        self.assertEqual(rg.string_to_row(tile_str), expected)

        expected = [True, True, False, False, True]
        tile_str = "..^^."
        self.assertEqual(rg.string_to_row(tile_str), expected)

    def test_count_safe_tiles(self):
        """
        Tests for count_safe_tiles
        """
        init_tiles = rg.string_to_row("..^^.")
        actual = rg.count_safe_tiles(3, init_tiles)
        expected = 6
        self.assertEqual(actual, expected)

        tile_str = ".^^.^.^^^^"
        init_tiles = rg.string_to_row(tile_str)
        actual = rg.count_safe_tiles(10, init_tiles)
        expected = 38
        self.assertEqual(actual, expected)

    def test_rows_generator(self):
        """
        Tests for rows_generator
        """
        init = [True, True, False, False, True]
        expected = [[True, True, False, False, True],
                    [True, False, False, False, False],
                    [False, False, True, True, False]]
        index = 0
        for row in rg.rows_generator(3, init):
            self.assertEqual(row, expected[index])
            index += 1

if __name__ == '__main__':
    unittest.main()
