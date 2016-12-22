"""
Advent of Code 2016
Day 22, Part B
Grid Computing
"""

from collections import namedtuple


Cell = namedtuple('Cell', ['row', 'col', 'used', 'avail'])

class Grid(object):
    """
    Class to represent the grid.
    """
    def __init__(self, height=0, width=0, data=None):
        self.data = data
        self.empty_node = None
        self.goal_node = None
        self.height = height
        self.width = width

    def get_cell(self, row, col):
        """
        Returns the cell from the given row and col
        """
        return self.data[col * self.width + row]

    def get_neighbors(self, row_index, col_index):
        """
        Returns a list of neighbors for the given position.
        """
        neighbors = []
        # up
        if row_index > 0:
            neighbors.append(self.get_cell(row_index - 1, col_index))
        # down
        if row_index < self.height - 1:
            neighbors.append(self.get_cell(row_index + 1, col_index))
        # left
        if col_index > 0:
            neighbors.append(self.get_cell(row_index, col_index - 1))
        # right
        if col_index < self.width - 1:
            neighbors.append(self.get_cell(row_index, col_index + 1))

        return neighbors

    def append(self, cell):
        """
        Append cell to grid's data
        """
        self.data.append(cell)
        if cell.used == 0:
            self.empty_node = cell

    def stripped_data(self):
        """
        Returns data as tuple of tuples where each
        tuple is the used and avail for each cell.
        """
        return tuple([(c.used, c.avail) for c in self.data])

    def read_data(self, iterable):
        """
        Reads data from iterable
        """
        self.data = []
        offset = len('/dev/grid/')
        for line in iterable:
            tokens = line.strip().split()
            if line.startswith('/dev/grid/'):
                name_tokens = tokens[0][offset:].split('-')
                xpos = int(name_tokens[1][1:])
                if self.height < xpos + 1:
                    self.height = xpos + 1
                ypos = int(name_tokens[2][1:])
                if self.width < ypos + 1:
                    self.width = ypos + 1
                used = int(tokens[2][:-1])
                avail = int(tokens[3][:-1])
                self.append(Cell(ypos, xpos, used, avail))
        self.goal_node = self.get_cell(0, self.width - 1)


    def find_shortest_path(empty_node, grid):
        """
        Returns the length of the shortest path.
        """
        queue = heapq([])
        marked = {}


def main():
    """
    Main program.
    """
    # read data into a list and get
    # the maximum x and y
    import sys
    grid, empty_node = read_grid(sys.stdin)

if __name__ == '__main__':
    main()
