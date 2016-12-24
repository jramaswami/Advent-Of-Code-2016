"""
Advent of Code 2016
Day 24, Part A
Air Duct Spelunking
"""

import math
from itertools import permutations
from collections import namedtuple, deque

Pos = namedtuple('Pos', ['row', 'col'])


def get_target_positions(air_duct_map):
    """
    Returns a tuple for the position
    of the starting point, 0; and
    a dict of all the positive numbers
    on the map with the number as the
    key and the value as False, since
    the number has not been found yet.
    """
    nums = {}
    for row_index, row in enumerate(air_duct_map):
        for col_index, val in enumerate(row):
            if val not in ['#', '.']:
                nums[val] = Pos(row_index, col_index)
    return nums


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


def get_distances(air_duct_map, start, targets):
    """
    Returns a dict of the distances between start
    and all targets.
    """
    visited = {}
    dist = {}
    for target in targets:
        dist[target] = float('inf')
    queue = deque()
    queue.append((0, start))
    visited[start] = True
    while queue:

        # pop current
        steps, current = queue.popleft()

        # if current is a target update distance
        val = air_duct_map[current.row][current.col]
        if val in targets:
            dist[val] = steps
            targets.remove(val)

        # if all targets are found stop looking
        if not targets:
            return dist
        for neighbor in get_neighbors(current, air_duct_map):
            if neighbor not in visited:
                visited[neighbor] = True
                queue.append((steps + 1, neighbor))


def compute_total_distance(path, distances):
    """
    Returns the total distance of the given
    path.
    """
    prev = '0'
    total_distance = 0
    for current in path:
        total_distance += distances[prev][current]
        prev = current
    return total_distance


def main():
    """
    Main program
    """
    import sys
    air_duct_map = read_map(sys.stdin)
    target_positions = get_target_positions(air_duct_map)
    targets = list(target_positions.keys())
    distances = {}
    for target in targets:
        targets0 = list(targets)
        targets0.remove(target)
        distances[target] = get_distances(air_duct_map,
                                          target_positions[target],
                                          targets0)

    targets.remove('0')
    shortest_path = None
    shortest_distance = math.inf
    for path in permutations(targets):
        total_distance = compute_total_distance(path, distances)
        # Add return from last part of path to '0'
        total_distance += distances[path[-1]]['0']
        if total_distance < shortest_distance:
            shortest_path = path
            shortest_distance = total_distance
    print(shortest_path)
    print(shortest_distance)

if __name__ == '__main__':
    main()
