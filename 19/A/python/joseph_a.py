"""
Advent of Code 2016
Day 19, Part A
An Elephant Named Joseph
"""
# pylint: disable=invalid-name


def josephus_circle(n):
    """
    Returns the "winner" of the josephus circle. Uses
    the following math to determine "winner":

    where j(n) = j(2^x + m) = 2m + 1
    """
    # find power of two
    x = 0
    while pow(2, x) < n:
        x = x + 1
    x = x - 1
    y = pow(2, x)
    m = (n - y)
    return (2 * m) + 1


def main():
    """
    Main program
    """
    import sys
    if len(sys.argv) > 1:
        print(josephus_circle(int(sys.argv[1])))
    else:
        print("Usage: python joseph_a.py <elf count>")


if __name__ == '__main__':
    main()
