"""
Advent of Code 2016
Day 19, Part B
An Elephant Named Joseph
"""
# pylint: disable=invalid-name


def josephus_circle(n):
    """
    Returns the "winner" of the josephus circle. Uses
    the following math to determine "winner":

    where j(n) = j(3^x + m) = m if m ≤ 3^x
                            = 2m - 3^x if m > 3^x
    """
    # find power of three
    x = 0
    while pow(3, x) < n:
        x = x + 1
    x = x - 1
    y = pow(3, x)
    m = (n - y)
    if m <= y:
        return m
    else:
        return (2 * m) - y


def main():
    """
    Main program
    """
    import sys
    if len(sys.argv) > 1:
        print(josephus_circle(int(sys.argv[1])))
    else:
        print("Usage: python joseph_b <elf_count>")


if __name__ == '__main__':
    main()
