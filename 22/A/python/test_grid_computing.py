"""
Tests for grid_computing
"""

import unittest
import grid_computing as gc


class TestGridComputing(unittest.TestCase):
    """
    Tests for grid_computing
    """

    def test_read_nodes(self):
        """
        Tests for read_nodes()
        """
        with open('../../test0.txt') as in_fh:
            expected = [(68, 24), (73, 14), (64, 25),
                        (65, 23), (69, 25), (70, 15),
                        (71, 21), (69, 22), (70, 20)]
            nodes = gc.read_nodes(in_fh)
            self.assertEqual(nodes, expected)

    def test_count_viable_pairs(self):
        """
        Tests for count_viable_pairs()
        """
        nodes = [(68, 24), (65, 70), (71, 21),
                 (73, 14), (81, 25), (69, 22),
                 (64, 25), (70, 100), (170, 20)]
        self.assertEqual(gc.count_viable_pairs(nodes), 11)

if __name__ == '__main__':
    unittest.main()
