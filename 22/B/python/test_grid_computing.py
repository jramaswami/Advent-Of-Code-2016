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
            expected = [[(68, 24), (65, 23), (71, 21)],
                        [(73, 14), (69, 25), (69, 22)],
                        [(64, 25), (70, 15), (70, 20)]]
            grid = gc.Grid()
            grid.read_data(in_fh)
            for row_index, row in enumerate(expected):
                for col_index, val in enumerate(row):
                    cell = grid.get_cell(row_index, col_index)
                    msg = str(cell) + " should be " + \
                        str((row_index, col_index)) + " " + str(val)
                    self.assertEqual(cell.used, val[0], msg)
                    self.assertEqual(cell.avail, val[1], msg)

        with open('../../test2.txt') as in_fh:
            expected = [[(8, 2), (7, 2), (6, 4)],
                        [(6, 5), (0, 8), (8, 1)],
                        [(28, 4), (7, 4), (6, 3)]]
            grid = gc.Grid()
            grid.read_data(in_fh)
            for row_index, row in enumerate(expected):
                for col_index, val in enumerate(row):
                    cell = grid.get_cell(row_index, col_index)
                    msg = str(cell) + " should be " + \
                        str((row_index, col_index)) + " " + str(val)
                    self.assertEqual(cell.used, val[0], msg)
                    self.assertEqual(cell.avail, val[1], msg)
            self.assertEqual(grid.empty_node.row, 1)
            self.assertEqual(grid.empty_node.col, 1)

    def test_get_neighbors(self):
        """
        Tests for get_neighbors()
        """
        with open('../../test0.txt') as in_fh:
            grid = gc.Grid()
            grid.read_data(in_fh)
            # 0, 0
            self.assertEqual(grid.get_neighbors(0, 0),
                             [gc.Cell(1, 0, 73, 14),
                              gc.Cell(0, 1, 65, 23)])
            # 1, 1
            self.assertEqual(grid.get_neighbors(1, 1),
                             [gc.Cell(0, 1, 65, 23),
                              gc.Cell(2, 1, 70, 15),
                              gc.Cell(1, 0, 73, 14),
                              gc.Cell(1, 2, 69, 22)])
            # 1, 0
            self.assertEqual(grid.get_neighbors(1, 0),
                             [gc.Cell(0, 0, 68, 24),
                              gc.Cell(2, 0, 64, 25),
                              gc.Cell(1, 1, 69, 25)])


if __name__ == '__main__':
    unittest.main()
