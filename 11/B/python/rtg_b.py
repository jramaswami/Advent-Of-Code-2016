"""
Radioisotope Thermogenic Generators
Day 11 Puzzle, Part B
"""

from itertools import combinations, chain
from collections import deque


def is_generator(elem):
    """
    Returns True if elem is a generator.
    """
    return elem % 2 == 1


def is_chip(elem):
    """
    Returns True if elem is chip.
    """
    return elem % 2 == 0 and elem > 0


def chip_and_generator_together(chip, building):
    """
    Returns true if the floor has the
    matching generator for the given chip.
    """
    matching_generator = chip - 1
    return building[matching_generator] == building[chip]


def floor_has_generators(floor, building):
    """
    Returns True if the given floor has generators on it.
    All generators are odd numbered, if there are any
    odd numbers in floor then there are generators
    on the floor.
    """
    for elem, loc in enumerate(building):
        if loc == floor and is_generator(elem):
            return True


def building_is_valid(building):
    """
    Returns True if building is a valid one.  This
    means that if there are generators, each chip on
    the floor has its corresponding generator.
    """
    # for each chip (even numbers)
    for chip in range(2, len(building), 2):
        loc = building[chip]
        if floor_has_generators(loc, building) \
        and not chip_and_generator_together(chip, building):
            return False
    return True


def move_to(elems, floor, building):
    """
    Move elements to given floor,
    returning a new floor.
    """
    new_building = list(building)
    for elem in elems:
        new_building[elem] = floor
    # move elevator too!
    new_building[0] = floor
    return tuple(new_building)


def buildings_generator(building):
    """
    Generate possible next building buildings.
    """
    floor = building[0]
    elems = [e for e, loc in enumerate(building) if e > 0 and loc == floor]

    choose1_it = combinations(elems, 1)
    choose2_it = combinations(elems, 2)
    for movers in chain(choose1_it, choose2_it):
        if floor > 0:
            # move them down one floor
            new_building = move_to(movers, floor - 1, building)
            if building_is_valid(new_building):
                yield new_building
        if floor < 3:
            # move them up one floor
            new_building = move_to(movers, floor + 1, building)
            if building_is_valid(new_building):
                yield new_building


def bfs(init_building, desired_building):
    """
    Perform bfs of game buildings to find the number
    of steps required to get to desired building.
    """
    marked = {}
    queue = deque()

    # init queue
    for new_building in buildings_generator(init_building):
        marked[new_building] = True
        queue.append((new_building, 1))

    prev_step = 0
    while queue:
        building, steps = queue.popleft()

        if steps != prev_step:
            print("step", steps, "...")
            prev_step = steps

        for new_building in buildings_generator(building):
            if new_building not in marked:
                if new_building == desired_building:
                    return steps + 1
                else:
                    marked[new_building] = True
                    queue.append((new_building, steps + 1))


def main():
    """
    Main program.
    """
    # Test
    # desired_building = (3, 3, 3, 3, 3)
    # init_building = (0, 1, 0, 2, 0)
    desired_building = (3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3)
    init_building = (0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0)

    steps = bfs(init_building, desired_building)
    print()
    print(steps)


if __name__ == '__main__':
    main()
