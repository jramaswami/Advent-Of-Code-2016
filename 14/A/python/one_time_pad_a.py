"""
Advent of Code
Day 14, Part A
One Time Pad
"""

from collections import deque, namedtuple
from hashlib import md5


Key = namedtuple('Key', ['digest', 'trip', 'quints', 'index'])


class KeyQueue(object):
    """
    Class the represent a queue of candidate keys.
    """

    def __init__(self, salt):
        self._salt = salt
        self._index = 0
        self._queue = deque()
        for _ in range(1000):
            self.append_new_candidate()

    def pop_next_candidate(self):
        """
        Removes the next key from the queue, replacing
        it with a new one to maintain the queue at 1000
        future possible keys.

        Returns the key and its index.
        """
        candidate = self._queue.popleft()
        self.append_new_candidate()
        assert len(self._queue) == 1000
        return candidate

    def is_valid_key(self, candidate):
        """
        Determines if key is a valid one based on
        the next keys in the queue.  The queue should
        only have 1000 keys in it.
        """
        assert len(self._queue) == 1000
        for future in self._queue:
            if candidate.trip in future.quints:
                return True
        return False

    def get_next_valid_key(self):
        """
        Returns next valid key.
        """
        while True:
            candidate = self.pop_next_candidate()
            if self.is_valid_key(candidate):
                return candidate

    def append_new_candidate(self):
        """
        Appends the next candidate key to the queue.
        """
        digest = generate_digest(self._salt, self._index)
        trip, quints = find_trip_and_quints(digest)
        candidate = Key(digest, trip, quints, self._index)
        self._queue.append(candidate)
        self._index += 1


def find_trip_and_quints(key):
    """
    Returns the triples of a given key.
    """
    limit3 = len(key) - 3
    limit5 = limit3 - 2
    trip = ""
    quints = {}
    index = 0
    while True:
        if index > limit3:
            return (trip, list(quints.keys()))
        else:
            char = key[index]
            if char == key[index + 1] and char == key[index + 2]:
                if not trip:
                    trip = char
                if index <= limit5 \
                and char == key[index + 3] \
                and char == key[index + 4]:
                    quints[char] = True
                    index += 5
                else:
                    index += 3
            else:
                index += 1


def generate_digest(salt, index):
    """
    Generate md5 key for given salt and index."
    """
    inp = salt + str(index)
    key_generator = md5()
    key_generator.update(inp.encode())
    return key_generator.hexdigest()


def main():
    """
    Main program.
    """
    # salt = 'abc'  # test salt
    salt = 'ihaygndm'
    queue = KeyQueue(salt)
    for _ in range(64):
        key = queue.get_next_valid_key()
    print(key)

if __name__ == '__main__':
    main()
