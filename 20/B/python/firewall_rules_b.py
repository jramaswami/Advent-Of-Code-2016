"""
Advent of Code 2016
Day 20, Part B
Firewall Rules
"""


def count_allowed(black_ranges):
    """
    Returns the count of allowed ip address
    given a list of blocked ranges as tuples.
    """
    allowed_ips = 0
    black_ranges = sorted(black_ranges)
    prev_start, prev_end = black_ranges[0]

    if prev_start > 0:
        allowed_ips = prev_start

    max_end = prev_end

    for next_start, next_end in black_ranges[1:]:
        gap = next_start - max_end - 1
        if gap > 0:
            allowed_ips = allowed_ips + gap
        prev_start, prev_end = next_start, next_end
        if prev_end > max_end:
            max_end = prev_end

    # Add any remaining ips allowed up up to max ip
    max_ip = 4294967295
    if max_end < max_ip:
        allowed_ips = allowed_ips + max_ip - max_end - 1

    return allowed_ips


def main():
    """
    Main program.
    """
    import sys
    black_ranges = []
    for line in sys.stdin:
        start, end = line.strip().split("-")
        black_ranges.append((int(start), int(end)))

    print(count_allowed(black_ranges))

if __name__ == '__main__':
    main()
