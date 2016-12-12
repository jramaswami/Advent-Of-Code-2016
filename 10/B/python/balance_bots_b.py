"""
First part of day 10 puzzle.
"""

import collections


def bfs(queue, edges, bots_with_chips):
    """
    Use bfs to distribute chips.
    """
    while queue:
        print(queue)
        bot = queue.popleft()
        if bot < 1000:
            lo_chip = bots_with_chips[bot][0]
            hi_chip = bots_with_chips[bot][1]
            lo_bot = edges[bot][0]
            hi_bot = edges[bot][1]
            add_chip(lo_bot, lo_chip, bots_with_chips, queue)
            add_chip(hi_bot, hi_chip, bots_with_chips, queue)


def add_edge(bot, lo_edge, hi_edge, edges):
    """
    Add an edge to our bot graph.
    """
    edges[bot] = (lo_edge, hi_edge)


def add_chip(bot, chip, bots_with_chips, queue):
    """
    Add a chip to the robot.
    """
    if bot in bots_with_chips:
        if bots_with_chips[bot][1] >= 0:
            return
        prev_chip = bots_with_chips[bot][0]
        if prev_chip > chip:
            bots_with_chips[bot] = (chip, prev_chip)
        else:
            bots_with_chips[bot] = (prev_chip, chip)
        queue.append(bot)
    else:
        bots_with_chips[bot] = (chip, -1)


def main():
    """
    Main program.
    """
    edges = {}
    bots_with_chips = {}
    queue = collections.deque()

    import sys
    for line in sys.stdin:
        line = line.strip()
        tokens = line.split()
        if tokens[0] == "value":
            chip = int(tokens[1])
            bot = int(tokens[5])
            add_chip(bot, chip, bots_with_chips, queue)
        elif tokens[0] == "bot":
            bot = int(tokens[1])
            lo_edge = int(tokens[6])
            if tokens[5] == "output":
                lo_edge = 1000 + lo_edge
            hi_edge = int(tokens[11])
            if tokens[10] == "output":
                lo_edge = 1000 + hi_edge

            add_edge(bot, lo_edge, hi_edge, edges)

    bfs(queue, edges, bots_with_chips)
    print(bots_with_chips[1000][0] *
          bots_with_chips[1001][0]*
          bots_with_chips[1002][0])


if __name__ == '__main__':
    main()
