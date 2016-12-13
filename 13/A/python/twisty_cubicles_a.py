"""
Advent of Code 2016
Day 13, Part A
"""

# allow one letter variable names
# pylint: disable=invalid-name


from collections import deque


def count_bits(n):
    """
    Returns the number of bits in the given integer.
    """
    count = 0
    while n > 0:
        count += n & 1
        n >>= 1
    return count


def is_open(x, y, fav):
    """
    Returns True if given x, y position is open.
    """
    if is_in_bounds(x, y):
        t = (x * x) + (3 * x) + (2 * x * y) + y + (y * y) + fav
        return count_bits(t) % 2 == 0
    else:
        return False


def is_in_bounds(x, y):
    """
    Returns True if the given x, y postion is
    still in the building.
    """
    return x >= 0 and y >= 0


def bfs(target_x, target_y, fav):
    """
    Do a bfs to find the shortest route to
    given x y position.
    """
    queue = deque()
    marked = {}
    start_x = start_y = 1
    queue.append((start_x, start_y, 0))
    marked[(start_x, start_y)] = True
    while queue:
        x, y, steps = queue.popleft()
        print(x, y, steps)
        if (x, y) == (target_x, target_y):
            return steps

        #        N, NE, E, SE, S, SW, W, NW
        moves = ((0, -1), (-1, 1), (0, 1), (1, 1),
                 (1, 0), (1, -1), (0, -1), (-1, -1))
        for move_x, move_y in moves:
            new_x = x + move_x
            new_y = y + move_y
            if (new_x, new_y) not in marked and is_open(new_x, new_y, fav):
                marked[(new_x, new_y)] = True
                queue.append((new_x, new_y, steps + 1))


def main():
    """
    Main program.
    """
    test_x, test_y, test_fav = 7, 4, 10
    result = bfs(test_x, test_y, test_fav)

    print(result)


if __name__ == '__main__':
    main()
