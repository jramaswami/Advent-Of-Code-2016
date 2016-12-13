"""
Advent of Code 2016
Day 13, Part B
"""

# allow one letter variable names
# pylint: disable=invalid-name


from collections import deque


def make_maze(size_x, size_y, fav):
    """
    Make a string representation of the maze.
    """
    maze = ""
    for y in range(size_y):
        row = ""
        for x in range(size_x):
            if is_open(x, y, fav):
                row += "."
            else:
                row += "#"
        row = ("%02d" % y) + row + "\n"
        maze += row

    header1 = "  "
    header2 = "  "
    for i in range(size_x):
        header1 += ("%d" % (i // 10))
        header2 += ("%d" % (i % 10))
    return header1 + "\n" + header2 + "\n" + maze


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


def bfs(max_steps, fav):
    """
    Do bfs to find all unique
    """
    queue = deque()
    marked = {}
    start_x = start_y = 1
    queue.append((start_x, start_y, 0))
    marked[(start_x, start_y)] = True
    while queue:
        x, y, steps = queue.popleft()
        if steps < max_steps:
            #           N       E       S        W
            moves = ((0, -1), (0, 1), (1, 0), (-1, 0))
            for move_x, move_y in moves:
                new_x = x + move_x
                new_y = y + move_y
                if (new_x, new_y) not in marked and is_open(new_x, new_y, fav):
                    marked[(new_x, new_y)] = True
                    queue.append((new_x, new_y, steps + 1))
    return len(marked.keys())


def main():
    """
    Main program.
    """
    fav = 1358
    result = bfs(50, fav)
    print(result)


if __name__ == '__main__':
    main()
