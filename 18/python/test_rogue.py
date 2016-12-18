"""
Tests for rogue.py
"""

import unittest
import rogue as rg


class RogueTests(unittest.TestCase):
    """
    Tests for rogue.py
    """

    def test_is_safe(self):
        """
        Tests for is_safe
        """
        tiles = [[1, 1, 0, 0, 1], ]
        self.assertTrue(rg.is_safe(rg.Pos(0, 0), tiles))
        self.assertTrue(rg.is_safe(rg.Pos(0, 1), tiles))
        self.assertTrue(rg.is_safe(rg.Pos(0, 4), tiles))
        self.assertFalse(rg.is_safe(rg.Pos(0, 2), tiles))
        self.assertFalse(rg.is_safe(rg.Pos(0, 3), tiles))
        self.assertTrue(rg.is_safe(rg.Pos(0, -1), tiles))
        self.assertTrue(rg.is_safe(rg.Pos(0, 5), tiles))
        self.assertTrue(rg.is_safe(rg.Pos(0, 6), tiles))

    def test_make_tile(self):
        """
        Tests for make_tile
        """
        tiles = [[True, True, False, False, True], ]
        self.assertTrue(rg.make_tile(rg.Pos(1, 0), tiles))
        self.assertFalse(rg.make_tile(rg.Pos(1, 1), tiles))
        self.assertFalse(rg.make_tile(rg.Pos(1, 2), tiles))
        self.assertFalse(rg.make_tile(rg.Pos(1, 3), tiles))
        self.assertFalse(rg.make_tile(rg.Pos(1, 4), tiles))
        tiles.append([rg.make_tile(rg.Pos(1, c), tiles)
                      for c in range(len(tiles[0]))])
        self.assertEqual(tiles[1], [True, False, False, False, False])
        expected = [[True, True, False, False, True],
                    [True, False, False, False, False]]
        self.assertEqual(tiles, expected)

    def test_add_rows(self):
        """
        Tests for add_rows
        """
        tiles = [[True, True, False, False, True], ]
        expected = [[True, True, False, False, True],
                    [True, False, False, False, False],
                    [False, False, True, True, False]]
        result = rg.add_rows(2, tiles)
        self.assertEqual(result, expected)

    def test_tiles_to_string(self):
        """
        Tests for tiles_to_string
        """
        tiles = [[True, True, False, False, True], ]
        expected = "..^^."
        self.assertEqual(rg.tiles_to_string(tiles), expected)
        tiles = [[True, True, False, False, True],
                 [True, False, False, False, False],
                 [False, False, True, True, False]]
        expected = "..^^.\n.^^^^\n^^..^"
        self.assertEqual(rg.tiles_to_string(tiles), expected)

    def test_string_to_tiles(self):
        """
        Tests for string_to_tiles
        """
        expected = [[True, True, False, False, True],
                    [True, False, False, False, False],
                    [False, False, True, True, False]]
        tile_str = "..^^.\n.^^^^\n^^..^"
        self.assertEqual(rg.string_to_tiles(tile_str), expected)

        expected = [[True, True, False, False, True], ]
        tile_str = "..^^."
        self.assertEqual(rg.string_to_tiles(tile_str), expected)

    def test_count_safe_tiles(self):
        """
        Tests for count_safe_tiles
        """
        tiles = rg.string_to_tiles("..^^.\n.^^^^\n^^..^\n")
        actual = rg.count_safe_tiles(tiles)
        expected = 6
        self.assertEqual(actual, expected)

        tile_str = ".^^.^.^^^^" + \
                   "^^^...^..^" + \
                   "^.^^.^.^^." + \
                   "..^^...^^^" + \
                   ".^^^^.^^.^" + \
                   "^^..^.^^.." + \
                   "^^^^..^^^." + \
                   "^..^^^^.^^" + \
                   ".^^^..^.^^" + \
                   "^^.^^^..^^"
        tiles = rg.string_to_tiles(tile_str)
        actual = rg.count_safe_tiles(tiles)
        expected = 38
        self.assertEqual(actual, expected)


if __name__ == '__main__':
    unittest.main()
