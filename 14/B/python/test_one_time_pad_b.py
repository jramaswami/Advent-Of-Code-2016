"""
Tests for one_time_pad_b
"""
import unittest
import one_time_pad_b as otp


class OneTimePadBTests(unittest.TestCase):
    """
    Tests for one_time_pad_b
    """

    def test_stretched_generate_digest(self):
        """
        Tests for generate_stretched_digest
        """
        expected = 'a107ff634856bb300138cac6568c0f24'
        result = otp.generate_stretched_digest('abc', 0)
        self.assertEqual(result, expected)

    def test_get_next_valid_key(self):
        """
        Tests for get next_valid_key
        """
        queue = otp.KeyQueue("abc")
        key1 = queue.get_next_valid_key()
        self.assertEqual(key1.index, 10)

        queue = otp.KeyQueue("abc")
        for _ in range(64):
            key64 = queue.get_next_valid_key()
        self.assertEqual(key64.index, 22551)


if __name__ == '__main__':
    unittest.main()
