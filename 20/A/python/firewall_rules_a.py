"""
Advent of Code 2016
Day 20, Part A
Firewall Rules
"""


def find_lowest_allowed(black_ranges):
    """
    Returns the lowest allowed ip address
    given a list of blocked ranges as tuples.
    """
    black_ranges = sorted(black_ranges)
    min_start, max_end = black_ranges[0]

    if min_start > 0:
        return 0

    for next_start, next_end in black_ranges[1:]:
        # The next start must be less than the
        # current max, equal to the current max
        # or abut the current max (i.e. equal
        # current max + 1)
        if next_start <= max_end + 1:
            max_end = next_end
        else:
            return max_end + 1


def main():
    """
    Main program.
    """
    import sys
    black_ranges = []
    for line in sys.stdin:
        start, end = line.strip().split("-")
        black_ranges.append((int(start), int(end)))

    print(find_lowest_allowed(black_ranges))

if __name__ == '__main__':
    main()
