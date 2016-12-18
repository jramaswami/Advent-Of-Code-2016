"""
Advent of Code 2016
Day 18
Like a Rogue
"""

SAFE = True
TRAP = False


def rows_generator(num, init):
    """
    Generator for rows.
    """
    yield init
    prev_row = init
    for _ in range(1, num):
        next_row = []
        for index, _ in enumerate(prev_row):
            if index == 0:
                left = SAFE
            else:
                left = prev_row[index - 1]
            center = prev_row[index]
            if index == len(prev_row) - 1:
                right = SAFE
            else:
                right = prev_row[index + 1]

            current = not ((left and center and not right) or
                           (center and right and not left) or
                           (not center and not right and left) or
                           (not center and not left and right))

            next_row.append(current)

        prev_row = next_row
        yield next_row
    return


def string_to_row(row_str):
    """
    Convert string to row of tiles.
    """
    row = []
    for char in row_str.strip():
        if char == ".":
            row.append(True)
        else:
            row.append(False)
    return row


def count_safe_tiles(num_rows, init_row):
    """
    Returns the number of safe tiles.
    """
    return sum([sum(row) for row in rows_generator(num_rows, init_row)])


def main():
    """
    Main program.
    """
    import sys
    if len(sys.argv) > 1:
        num_rows = int(sys.argv[1])
    else:
        print("Usage: python rogue.py num_rows < input_file.txt")
        return
    inp = sys.stdin.readline()
    init_row = string_to_row(inp)
    print(count_safe_tiles(num_rows, init_row))


if __name__ == '__main__':
    main()
