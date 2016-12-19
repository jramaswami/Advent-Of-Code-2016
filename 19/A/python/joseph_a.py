"""
Advent of Code 2016
Day 19, Part A
An Elephant Named Joseph
"""

from collections import deque, namedtuple

Elf = namedtuple('Elf', ['id', 'presents'])


def white_elephant_party(elf_count):
    """
    Returns the "winner" of the elves
    white elephant party.  Uses simulation
    to determine "winner."
    """
    queue = deque()
    for index in range(1, elf_count + 1):
        queue.append(Elf(index, 1))
    while len(queue) > 1:
        left_elf = queue.popleft()
        right_elf = queue.popleft()
        queue.append(Elf(left_elf.id, right_elf.presents + left_elf.presents))

    return queue.pop()


def main():
    """
    Main program
    """
    # winning_elf = white_elephant_party(5)
    winning_elf = white_elephant_party(3001330)
    print(winning_elf.id)


if __name__ == '__main__':
    main()
