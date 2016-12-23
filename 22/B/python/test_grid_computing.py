"""
Tests for grid_computing
"""

import unittest
import grid_computing as gc


class TestGridComputing(unittest.TestCase):
    """
    Tests for grid_computing
    """

    def test_read_grid(self):
        """
        Tests for read_grid()
        """
        with open('../../test0.txt') as in_fh:
            grid = gc.read_grid(in_fh)
            expected_data = (gc.Node(68, 24), gc.Node(73, 14), gc.Node(64, 25),
                             gc.Node(65, 23), gc.Node(69, 25), gc.Node(70, 15),
                             gc.Node(71, 21), gc.Node(69, 22), gc.Node(70, 20))
            self.assertEqual(grid.data, expected_data)
            self.assertEqual(grid.width, 3)
            self.assertEqual(grid.height, 3)

    def test_row_col_to_index(self):
        """
        Tests for row_col_to_index
        """
        with open('../../test0.txt') as in_fh:
            grid = gc.read_grid(in_fh)
            index = gc.row_col_to_index(1, 1, grid)
            self.assertEqual(index, 4)
            self.assertEqual(grid.data[index], gc.Node(69, 25))

    def test_index_to_row_col(self):
        """
        Tests for row_col_to_index
        """
        with open('../../test0.txt') as in_fh:
            grid = gc.read_grid(in_fh)
            row, col = gc.index_to_row_col(4, grid)
            self.assertEqual(row, 1)
            self.assertEqual(col, 1)

    def test_shortest_path(self):
        """
        Tests for shortest_path
        """
        with open('../../test2.txt') as in_fh:
            grid = gc.read_grid(in_fh)
            result = gc.shortest_path(grid)
            self.assertEqual(result, 7)

if __name__ == '__main__':
    unittest.main()
