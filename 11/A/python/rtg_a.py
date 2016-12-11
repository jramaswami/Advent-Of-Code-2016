"""
Radioisotope Thermogenic Generators
Day 11 Puzzle, Part A
"""

from itertools import combinations, chain
from collections import deque

# Test Elements
HG = 1
HM = 2
LG = 3
LM = 4

# Puzzle Elements
POG = 1
POM = 2
THG = 3
THM = 4
PRG = 5
PRM = 6
RUG = 7
RUM = 8
COG = 9
COM = 10


def is_generator(elem):
    """
    Returns True if elem is a generator.
    """
    return elem % 2 == 1


def is_chip(elem):
    """
    Returns True if elem is chip.
    """
    return elem % 2 == 0


def floor_has_matching_generator(chip, floor):
    """
    Returns true if the floor has the
    matching generator for the given chip.
    """
    matching_generator = chip - 1
    return matching_generator in floor


def floor_has_generators(floor):
    """
    Returns True if the given floor has generators on it.
    All generators are odd numbered, if there are any
    odd numbers in floor then there are generators
    on the floor.
    """
    return len([x for x in floor if x % 2 == 1]) > 0


def floor_is_valid(floor):
    """
    Returns True if floor is in a valid state.  This
    means that if there are generators, each chip on
    the floor has its corresponding generator.
    """
    if floor_has_generators(floor):
        for elem in floor:
            if is_chip(elem):
                if not floor_has_matching_generator(elem, floor):
                    return False
    return True


def move_to(elems, floor):
    """
    Move elements to given floor,
    returning a new floor.
    """
    new_floor = list(floor)
    return sorted(new_floor + elems)


def move_from(elems, floor):
    """
    Move elements from given floor,
    returning a new floor.
    """
    new_floor = list(floor)
    for elem in elems:
        new_floor.remove(elem)
    return sorted(new_floor)


def next_buildings_generator(building, elevator, steps):
    """
    Generate possible next building states.
    """
    floor = building[elevator]

    choose1_it = combinations(floor, 1)
    choose2_it = combinations(floor, 2)
    for move in chain(choose1_it, choose2_it):
        move = list(move)
        if elevator > 0:
            # move them down one floor
            new_floor = move_from(move, floor)
            new_down = move_to(move, building[elevator - 1])
            if floor_is_valid(new_floor) and floor_is_valid(new_down):
                new_building = list(building)
                new_building[elevator] = new_floor
                new_building[elevator - 1] = new_down
                yield (new_building, elevator - 1, steps + 1)
        if elevator < 3:
            # move them up one floor
            new_floor = move_from(move, floor)
            new_up = move_to(move, building[elevator + 1])
            if floor_is_valid(new_floor) and floor_is_valid(new_up):
                new_building = list(building)
                new_building[elevator] = new_floor
                new_building[elevator + 1] = new_up
                yield (new_building, elevator + 1, steps + 1)


def mark(building, elevator, marked):
    """
    Marks the given building/elevator combination.
    """
    marked["E" + str(elevator) + str(building)] = True


def is_marked(building, elevator, marked):
    """
    Returns true if the building/elevator combination
    has been marked.
    """
    return "E" + str(elevator) + str(building) in marked


def bfs(init_building, init_elevator, desired_building):
    """
    Perform bfs of game states to find the number
    of steps required to get to desired building.
    """
    marked = {}
    queue = deque()

    # init queue
    for new_building, new_elevator, new_steps in \
            next_buildings_generator(init_building, init_elevator, 0):
        mark(new_building, new_elevator, marked)
        queue.append((new_building, new_elevator, new_steps))

    while queue:
        building, elevator, steps = queue.popleft()
        for new_building, new_elevator, new_steps in \
                next_buildings_generator(building, elevator, steps):

            if not is_marked(new_building, new_elevator, marked):
                if new_building == desired_building:
                    return new_steps
                else:
                    mark(new_building, new_elevator, marked)
                    queue.append((new_building, new_elevator, new_steps))


def main():
    """
    Main program.
    """
    # Test
    # desired_building = [[], [], [], [HG, HM, LG, LM]]
    # init_building = [[HM, LM], [HG, ], [LG, ], []]

    # Puzzle
    desired_building = [[],
                        [],
                        [],
                        [POG, POM, THG, THM, PRG, PRM, RUG, RUM, COG, COM]]
    init_building = [[POG, THG, THM, PRG, RUG, RUM, COG, COM],
                     [POM, PRM],
                     [],
                     []]

    init_elevator = 0
    steps = bfs(init_building, init_elevator, desired_building)
    print(steps)


if __name__ == '__main__':
    main()
