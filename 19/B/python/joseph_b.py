"""
Advent of Code 2016
Day 19, Part B
An Elephant Named Joseph
"""

from tqdm import tqdm


def white_elephant_party(elf_count):
    """
    Returns the "winner" of the elves
    white elephant party.
    """
    circle = []
    for index in range(1, elf_count + 1):
        circle.append(index)

    index = 0
    len_circle = len(circle)
    with tqdm(total=len_circle) as pbar:
        while len_circle > 1:
            vindex = (index + (len_circle // 2)) % len_circle
            del circle[vindex]
            len_circle = len_circle - 1
            if index < vindex:
                index = index + 1
            index = index % len_circle
            pbar.update(1)

    return circle[0]


def main():
    """
    Main program
    """
    # winning_elf = white_elephant_party(5)
    # winning_elf = white_elephant_party(3001330)
    import sys
    if len(sys.argv) > 1:
        elf_count = int(sys.argv[1])
        winning_elf = white_elephant_party(elf_count)
        print(winning_elf)
    else:
        print("Usage: python joseph_b <elf_count>")


if __name__ == '__main__':
    main()
