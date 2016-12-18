"""
Advent of Code 2016
Day 18
Like a Rogue
"""

from collections import namedtuple

Pos = namedtuple('Pos', ['row', 'col'])


def is_safe(pos, tiles):
    """
    Returns True if tile at given position
    is safe.
    """
    if pos.col < 0 or pos.col >= len(tiles[0]):
        return True
    else:
        return tiles[pos.row][pos.col]


def make_tile(pos, tiles):
    """
    Make tile for given position by determining
    if it should be safe or not.
    """
    left = is_safe(Pos(pos.row - 1, pos.col - 1), tiles)
    center = is_safe(Pos(pos.row - 1, pos.col), tiles)
    right = is_safe(Pos(pos.row - 1, pos.col + 1), tiles)

    return not ((left and center and not right) or
                (center and right and not left) or
                (not center and not right and left) or
                (not center and not left and right))


def add_rows(num, tiles):
    """
    Add <num> rows to tiles.
    """
    for _ in range(num):
        tiles.append([make_tile(Pos(len(tiles), c), tiles)
                      for c in range(len(tiles[0]))])
    return tiles


def tiles_to_string(tiles):
    """
    Returns string representation
    of the tiles.
    """
    tile_str = ""
    for row in tiles:
        for col in row:
            if col:
                tile_str += "."
            else:
                tile_str += "^"
        tile_str += "\n"
    return tile_str.strip()


def string_to_tiles(tile_str):
    """
    Convert string to tiles.
    """
    tiles = []
    for row_str in tile_str.split("\n"):
        row = []
        for char in row_str:
            if char == ".":
                row.append(True)
            else:
                row.append(False)
        if row:
            tiles.append(row)
    return tiles


def count_safe_tiles(tiles):
    """
    Returns the number of safe tiles.
    """
    return sum([sum(row) for row in tiles])


def main():
    """
    Main program.
    """
    import sys
    inp = sys.stdin.read()
    if len(sys.argv) > 1:
        rows = int(sys.argv[1])
    else:
        rows = 40
    tiles = string_to_tiles(inp)
    tiles = add_rows(rows - len(tiles), string_to_tiles(inp))
    print(count_safe_tiles(tiles))


if __name__ == '__main__':
    main()
