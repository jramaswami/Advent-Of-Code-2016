"""
Tests for air_duct_spelunking_a
"""

import unittest
import air_duct_spelunking_a as ads


class TestAirDuctSpelunkingA(unittest.TestCase):
    """
    Tests for air_duct_spelunking_a
    """

    def test_read_air_duct_map(self):
        """
        Tests for read_air_duct_map()
        """
        with open('../../test1.txt') as in_fh:
            adm = ads.read_map(in_fh)
            expected = ['###########',
                        '#0.1.....2#',
                        '#.#######.#',
                        '#4.......3#',
                        '###########']
            self.assertEqual(adm, expected)

    def test_get_map_details(self):
        """
        Tests for get_map_details()
        """
        with open('../../test1.txt') as in_fh:
            adm = ads.read_map(in_fh)
            start, nums = ads.get_map_details(adm)
            self.assertEqual(start, ads.Pos(1, 1))
            self.assertEqual(nums, ['1', '2', '3', '4'])

    def test_get_neighbors(self):
        """
        Tests for get_neigbhors()
        """
        with open('../../test1.txt') as in_fh:
            adm = ads.read_map(in_fh)
            neighbors = ads.get_neighbors(ads.Pos(1, 1), adm)
            self.assertEqual(neighbors, [ads.Pos(2, 1), ads.Pos(1, 2)])

            neighbors = ads.get_neighbors(ads.Pos(1, 3), adm)
            self.assertEqual(neighbors, [ads.Pos(1, 2), ads.Pos(1, 4)])


if __name__ == '__main__':
    unittest.main()
