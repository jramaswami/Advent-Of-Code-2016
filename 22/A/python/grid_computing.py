"""
Advent of Code 2016
Day 22, Part A
Grid Computing
"""

USED = 0
AVAIL = 1


def count_viable_pairs(data):
    """
    Returns a count of the viable pairs in the data.
    """
    count = 0
    for this_index, this_node in enumerate(data):
        if this_node[USED] > 0:
            for that_index, that_node in enumerate(data):
                if this_node[USED] <= that_node[AVAIL]:
                    if this_index != that_index:
                        count += 1
    return count


def read_nodes(iterable):
    """
    Reads node data from iterable and
    returns a list of tuples where
    the first entry is the used and the
    second is the available.
    """
    offset = len('/dev/grid/')
    maxx = 0
    maxy = 0
    nodes = []
    for line in iterable:
        tokens = line.strip().split()
        if line.startswith('/dev/grid/'):
            name_tokens = tokens[0][offset:].split('-')
            xpos = int(name_tokens[1][1:])
            if maxx < xpos:
                maxx = xpos
            ypos = int(name_tokens[2][1:])
            if maxy < ypos:
                maxy = ypos
            used = int(tokens[2][:-1])
            avail = int(tokens[3][:-1])
            nodes.append((used, avail))
    return nodes


def main():
    """
    Main program.
    """
    import sys
    nodes = read_nodes(sys.stdin)
    print(count_viable_pairs(nodes))

if __name__ == '__main__':
    main()
