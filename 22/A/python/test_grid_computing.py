"""
Tests for grid_computing
"""

import unittest
import grid_computing as gc


class TestGridComputing(unittest.TestCase):
    """
    Tests for grid_computing
    """

    def test_read_data(self):
        """
        Tests for read_data()
        """
        with open('../../test0.txt') as in_fh:
            expected = [[(68, 24), (65, 23), (71, 21)],
                        [(73, 14), (69, 25), (69, 22)],
                        [(64, 25), (70, 15), (70, 20)]]
            grid = gc.read_data(in_fh)
            self.assertEqual(grid, expected)

    def test_get_neighbors(self):
        """
        Tests for get_neighbors()
        """
        with open('../../test0.txt') as in_fh:
            grid = gc.read_data(in_fh)
            # 0, 0
            self.assertEqual(gc.get_neighbors(0, 0, grid),
                             [(73, 14), (65, 23)])
            # 1, 1
            self.assertEqual(gc.get_neighbors(1, 1, grid),
                             [(65, 23), (70, 15), (73, 14), (69, 22)])
            # 1, 0
            self.assertEqual(gc.get_neighbors(1, 0, grid),
                             [(68, 24), (64, 25), (69, 25)])

    def count_viable_pairs(self):
        """
        Tests for count_viable_pairs()
        """
        grid = [[(68, 24), (65, 70), (71, 21)],
                [(73, 14), (81, 25), (69, 22)],
                [(64, 25), (70, 100), (170, 20)]]
        self.assertEqual(gc.count_viable_pairs(grid), 3)
        grid = [[(65, 70), (68, 24), (71, 70)],
                [(73, 14), (81, 25), (69, 22)],
                [(64, 25), (70, 100), (110, 20)]]
        self.assertEqual(gc.count_viable_pairs(grid), 5)

if __name__ == '__main__':
    unittest.main()
