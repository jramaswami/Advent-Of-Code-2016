"""
Tests for one_time_pad_a
"""
import unittest
import one_time_pad_a as otp


class OneTimePadATests(unittest.TestCase):
    """
    Tests for one_time_pad_a
    """

    def test_find_trip_and_quints(self):
        """
        Tests for find_trip_and_quints
        """
        self.assertEqual(otp.find_trip_and_quints('aaa'), ('a', []))
        self.assertEqual(otp.find_trip_and_quints('aaaaa'), ('a', ['a']))
        self.assertEqual(otp.find_trip_and_quints('aaalkjltttttpqkh'),
                         ('a', ['t']))
        self.assertEqual(otp.find_trip_and_quints('aaaaalkjltttpqkh'),
                         ('a', ['a']))

    def test_get_next_valid_key(self):
        """
        Tests for get next_valid_key
        """
        queue = otp.KeyQueue("abc")
        key1 = queue.get_next_valid_key()
        self.assertEqual(key1.index, 39)
        key2 = queue.get_next_valid_key()
        self.assertEqual(key2.index, 92)

        queue = otp.KeyQueue("abc")
        for _ in range(64):
            key64 = queue.get_next_valid_key()
        self.assertEqual(key64.index, 22728)


if __name__ == '__main__':
    unittest.main()
