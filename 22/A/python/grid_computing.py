"""
Advent of Code 2016
Day 22, Part A
Grid Computing
"""

USED = 0
AVAIL = 1


def get_neighbors(row_index, col_index, grid):
    """
    Returns a list of neighbors for the given position.
    """
    neighbors = []
    # up
    if row_index > 0:
        neighbors.append(grid[row_index - 1][col_index])
    # down
    if row_index < len(grid) - 1:
        neighbors.append(grid[row_index + 1][col_index])
    # left
    if col_index > 0:
        neighbors.append(grid[row_index][col_index - 1])
    # right
    if col_index < len(grid[0]) - 1:
        neighbors.append(grid[row_index][col_index + 1])

    return neighbors


def count_viable_pairs(grid):
    """
    Returns a count of the viable pairs in the grid.
    """
    count = 0
    for row_index, row in enumerate(grid):
        for col_index, storage_data in enumerate(row):
            if storage_data[USED] > 0:
                for neighbor in get_neighbors(row_index, col_index, grid):
                    if storage_data[USED] <= neighbor[AVAIL]:
                        count += 1

    return count


def read_data(iterable):
    """
    Reads data from iterable and returns
    a grid.
    """
    offset = len('/dev/grid/')
    maxx = 0
    maxy = 0
    data = []
    for line in iterable:
        tokens = line.strip().split()
        if line.startswith('/dev/grid/'):
            name_tokens = tokens[0][offset:].split('-')
            xpos = int(name_tokens[1][1:])
            if maxx < xpos:
                maxx = xpos
            ypos = int(name_tokens[2][1:])
            if maxy < ypos:
                maxy = ypos
            used = int(tokens[2][:-1])
            avail = int(tokens[3][:-1])
            data.append((xpos, ypos, used, avail))

    # now take data in list form and put it into
    # a grid instead
    grid = []
    for _ in range(maxy + 1):
        grid.append([0] * (maxx + 1))

    for datum in data:
        grid[datum[1]][datum[0]] = (datum[2], datum[3])

    return grid


def main():
    """
    Main program.
    """
    # read data into a list and get
    # the maximum x and y
    import sys
    grid = read_data(sys.stdin)
    print(count_viable_pairs(grid))

if __name__ == '__main__':
    main()
