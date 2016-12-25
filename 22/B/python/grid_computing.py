"""
Advent of Code 2016
Day 22, Part B
Grid Computing
"""

import heapq
from collections import namedtuple, defaultdict

Node = namedtuple('Node', ['used', 'avail'])
Grid = namedtuple('Grid', ['data', 'height', 'width', 'empty', 'target'])
QueueItem = namedtuple('QueueItem', ['priority', 'steps', 'grid'])

SIZE = 0
USED = 1

def grid_to_string(grid):
    """
    Returns grid string
    """
    grid_string = ""
    for row in grid:
        grid_string += " ".join([str(n) for n in row]).strip() + "\n"
    return grid_string


def read_grid(iterable):
    """
    Returns Grid read from the iterable
    """
    rows = defaultdict(list)
    offset = len('/dev/grid')
    height = width = 0
    empty = None
    for line in iterable:
        tokens = line.strip().split()
        if line.startswith('/dev/grid'):
            name_tokens = tokens[0][offset:].split('-')
            col = int(name_tokens[1][1:])
            if col + 1 > width:
                width = col + 1
            row = int(name_tokens[2][1:])
            if row + 1 > height:
                height = row + 1

            node = [int(tokens[1][:-1]), int(tokens[2][:-1])]
            rows[row].append(node)

    grid = []
    for row in range(height):
        grid.append(rows[row])
    return grid


def get_neighbors(row, col, grid):
    """
    Returns list of tuples (row, col)
    that are neighbors of the given
    cell.
    """
    neighbors = []

    if row >= 0:
        neighbors.append((row - 1, col))

    if row < len(grid) - 1:
        neighbors.append((row + 1, col))

    if col >= 0:
        neighbors.append((row, col - 1))

    if col < len(grid[0]) - 1:
        neighbors.append((row, col + 1))

    return neighbors


def a_star(grid):
    """
    A star to find shortest path to the
    postion right beside our target

    Returns list that is the path.
    """
    # find where we start
    current = None
    for row_index, row in enumerate(grid):
        for col_index, node in enumerate(row):
            if node[USED] == 0:
                current = (row_index, col_index)
        if current:
            break

    queue = []
    visited = {}
    heapq.heappush(queue, (0, current, []))
    path = []
    goal = (0, len(grid[0]) - 2)
    while queue:
        _, current, path = heapq.heappop(queue)
        if current == goal:
            return len(path) + 1 + (5 * goal[1])

        visited[current] = True
        for neighbor in get_neighbors(current[0], current[1], grid):
            if neighbor in visited:
                continue

            neighbor_used = grid[neighbor[0]][neighbor[1]][USED]
            current_size = grid[current[0]][current[1]][SIZE]
            if neighbor_used > current_size:
                continue

            # c_dist = abs(current[0] - goal[0]) + abs(current[1] - goal[1])
            n_dist = abs(neighbor[0] - goal[0]) + abs(neighbor[1] - goal[1])
            new_path = list(path)
            new_path.append(neighbor)
            heapq.heappush(queue, (n_dist, neighbor, new_path))
            visited[neighbor] = True


def main():
    """
    Main program.
    """
    import sys
    grid = read_grid(sys.stdin)
    print(a_star(grid))


if __name__ == '__main__':
    main()
