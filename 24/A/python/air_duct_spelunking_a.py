"""
Advent of Code 2016
Day 24, Part A
Air Duct Spelunking
"""


from collections import namedtuple
import heapq

Pos = namedtuple('Pos', ['row', 'col'])
Path = namedtuple('Path', ['position', 'steps', 'visited', 'path', 'nums'])
QueueItem = namedtuple('QueueItem', ['remaining', 'steps', 'path'])


def get_map_details(air_duct_map):
    """
    Returns a tuple for the position
    of the starting point, 0; and
    a dict of all the positive numbers
    on the map with the number as the
    key and the value as False, since
    the number has not been found yet.
    """
    start = None
    nums = []
    for row_index, row in enumerate(air_duct_map):
        for col_index, val in enumerate(row):
            if val == '0':
                start = Pos(row_index, col_index)
            if val not in ['#', '.', '0']:
                nums.append(val)
    return start, sorted(nums)


def read_map(iterable):
    """
    Reads data from iterable into a map.
    """
    return [line.strip() for line in iterable]


def get_neighbors(pos, air_duct_map):
    """
    Returns list of positions
    that are neighbors of the given
    cell.
    """
    neighbors = []

    if pos.row >= 0:
        if air_duct_map[pos.row - 1][pos.col] != '#':
            neighbors.append(Pos(pos.row - 1, pos.col))

    if pos.row < len(air_duct_map) - 1:
        if air_duct_map[pos.row + 1][pos.col] != '#':
            neighbors.append(Pos(pos.row + 1, pos.col))

    if pos.col >= 0:
        if air_duct_map[pos.row][pos.col - 1] != '#':
            neighbors.append(Pos(pos.row, pos.col - 1))

    if pos.col < len(air_duct_map[0]) - 1:
        if air_duct_map[pos.row][pos.col + 1] != '#':
            neighbors.append(Pos(pos.row, pos.col + 1))

    return neighbors


def a_star(air_duct_map, start, nums):
    """
    Returns the length of the shortest path
    to finding every number on the air duct
    map.
    """
    queue = []
    start_path = Path(start, 0, (start, ), (start, ), list(nums))
    heapq.heappush(queue, (len(nums), 0, start_path))
    while queue:
        item = heapq.heappop(queue)
        current = item[2]
        print('$', current.position, current.nums, current.steps, current.path)
        if current.nums == []:
            print(current.path)
            return current.steps

        for neighbor in get_neighbors(current.position, air_duct_map):
            if neighbor not in current.visited:
                val = air_duct_map[neighbor.row][neighbor.col]
                if val not in ['0', '.', '#'] and val in current.nums:
                    next_visited = (neighbor, )
                    index = nums.index(val)
                    next_nums = current.nums[:index] + current.nums[index + 1:]
                    print('# Found', val, 'at', neighbor, next_nums, len(current.path))
                else:
                    next_visited = current.visited + (neighbor, )
                    next_nums = current.nums
                next_path = current.path + (neighbor, )
                next_steps = current.steps + 1
                heapq.heappush(queue, (next_steps, len(next_nums),
                                       Path(neighbor, next_steps, next_visited,
                                            next_path, next_nums)))


def main():
    """
    Main program
    """
    import sys
    air_duct_map = read_map(sys.stdin)
    print(air_duct_map)
    start, nums = get_map_details(air_duct_map)
    print(start, nums)
    print(a_star(air_duct_map, start, nums))


if __name__ == '__main__':
    main()
