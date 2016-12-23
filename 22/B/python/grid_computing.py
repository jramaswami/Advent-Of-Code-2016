"""
Advent of Code 2016
Day 22, Part B
Grid Computing
"""

import heapq
from collections import namedtuple

Node = namedtuple('Node', ['used', 'avail'])
Grid = namedtuple('Grid', ['data', 'height', 'width', 'empty', 'target'])
QueueItem = namedtuple('QueueItem', ['priority', 'steps', 'grid'])


def grid_to_string(grid):
    """
    Returns grid string
    """
    grid_string = ""
    for row in range(grid.height):
        for col in range(grid.width):
            index = row_col_to_index(row, col, grid)
            if index == grid.target:
                grid_string = grid_string + "*"
            grid_string = grid_string + \
                str((grid.data[index].used, grid.data[index].avail))
        grid_string = grid_string + "\n"
    return grid_string


def read_grid(iterable):
    """
    Returns Grid read from the iterable
    """
    data = []
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
            data.append(Node(int(tokens[2][:-1]), int(tokens[3][:-1])))
            if int(tokens[2][:-1]) == 0:
                empty = len(data) - 1

    return Grid(tuple(data), height, width, empty, len(data) - width)


def row_col_to_index(row, col, grid):
    """
    Returns the index of the row, col
    coordinates in the grid.

    Grid is rotated so that cols are actually
    rows, based on the format of the input
    data.
    """
    return row * grid.height + col


def index_to_row_col(index, grid):
    """
    Returns the the row, col coordinates
    in the grid of the given index.

    Grid is rotated so that cols are actually
    rows, based on the format of the input
    data.
    """
    return (index // grid.height, index % grid.height)


def get_neighbors(index, grid):
    """
    Returns a list of the indices of the
    neighbors of the node at the given
    row, col
    """
    neighbors = []
    row, col = index_to_row_col(index, grid)
    if row > 0:
        up_index = row_col_to_index(row - 1, col, grid)
        assert up_index >= 0
        assert up_index < len(grid.data)
        neighbors.append(up_index)
    if row < grid.height - 1:
        down_index = row_col_to_index(row + 1, col, grid)
        assert down_index >= 0
        assert down_index < len(grid.data)
        neighbors.append(down_index)
    if col > 0:
        left_index = row_col_to_index(row, col - 1, grid)
        assert left_index >= 0
        assert left_index < len(grid.data)
        neighbors.append(left_index)
    if col < grid.width - 1:
        right_index = row_col_to_index(row, col + 1, grid)
        assert right_index >= 0
        if right_index >= len(grid.data):
            print('$$', right_index, row, col + 1, grid.width)
        assert right_index < len(grid.data)
        neighbors.append(right_index)
    return neighbors


def move_empty_node(empty_index, neighbor_index, grid):
    """
    Returns a new Grid with the empty moved.
    """
    neighbor_node = grid.data[neighbor_index]
    empty_node = grid.data[grid.empty]
    new_neighbor_node = Node(0,
                             neighbor_node.used + neighbor_node.avail)
    new_empty_node = Node(neighbor_node.used,
                          empty_node.avail - neighbor_node.used)
    new_data = list(grid.data)
    new_data = new_data[:neighbor_index] + [new_neighbor_node] + \
        new_data[neighbor_index + 1:]
    new_data = new_data[:grid.empty] + [new_empty_node] + \
        new_data[grid.empty + 1:]

    if neighbor_index == grid.target:
        new_target = grid.empty
    else:
        new_target = grid.target

    new_grid = Grid(tuple(new_data), grid.height, grid.width,
                    neighbor_index, new_target)
    return new_grid


def grid_priority(grid):
    """
    Returns grid priority
    """
    target_row, target_col = index_to_row_col(grid.target, grid)
    empty_row, empty_col = index_to_row_col(grid.empty, grid)
    priority = (100 * (target_row + target_col)) + \
        abs(target_row - empty_row) + \
        abs(target_col - empty_col)
    return priority


def shortest_path(grid):
    """
    Returns the length of the shortest path
    """
    queue = []
    marked = {}
    # init queue
    marked[grid] = True
    for neighbor_index in get_neighbors(grid.empty, grid):
        if grid.data[neighbor_index].used <= grid.data[grid.empty].avail:
            new_grid = move_empty_node(grid.empty, neighbor_index, grid)
            queue_item = QueueItem(grid_priority(new_grid), 1, new_grid)
            heapq.heappush(queue, queue_item)
            marked[new_grid] = True

    while queue:
        item = heapq.heappop(queue)
        grid = item.grid
        if grid.target == 0:
            return item.steps

        for neighbor_index in get_neighbors(grid.empty, grid):
            if neighbor_index >= len(grid.data):
                print(neighbor_index)
            if grid.data[neighbor_index].used <= grid.data[grid.empty].avail:
                new_grid = move_empty_node(grid.empty, neighbor_index, grid)
                if new_grid not in marked:
                    priority = grid_priority(new_grid)
                    queue_item = QueueItem(priority, item.steps + 1, new_grid)
                    heapq.heappush(queue, queue_item)
                    marked[new_grid] = True


def main():
    """
    Main program.
    """
    import sys
    grid = read_grid(sys.stdin)
    print(grid_to_string(grid))
    # print(shortest_path(grid))


if __name__ == '__main__':
    main()
