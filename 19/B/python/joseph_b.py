"""
Advent of Code 2016
Day 19, Part B
An Elephant Named Joseph
"""
# pylint: disable=invalid-name


def white_elephant_party(elf_count):
    """
    Returns the "winner" of the elves
    white elephant party.  Uses simulation
    to determine "winner."
    """
    circle = []
    for index in range(1, elf_count + 1):
        circle.append(index)

    index = 0
    len_circle = len(circle)
    while len_circle > 1:
        vindex = (index + (len_circle // 2)) % len_circle
        del circle[vindex]
        len_circle = len_circle - 1
        if index < vindex:
            index = index + 1
        index = index % len_circle

    return circle[0]


def josephus_circle(n):
    """
    Returns the "winner" of the josephus circle. Uses
    the following math to determine "winner":

    where j(n) = j(3^x + m) = m if m ≤ 3^x
                            = 3^x + 2(m - 3^x) if m > 3^x
    """
    # find power of three
    x = 0
    while pow(3, x) < n:
        x = x + 1
    x = x - 1
    y = pow(3, x)
    m = (n - y)
    if m > y:
        return y + (2 * (m - y))
    else:
        return m


def main():
    """
    Main program
    """
    import sys
    if len(sys.argv) > 1:
        elf_count = int(sys.argv[1])
        # winning_elf = white_elephant_party(elf_count)
        winning_elf = josephus_circle(elf_count)
        print(winning_elf)
    else:
        print("Usage: python joseph_b <elf_count>")


if __name__ == '__main__':
    main()
