"""
First part of day 10 puzzle.
"""

import collections


def bfs_search(queue, edges, bots_with_chips, target):
    """
    Use bfs to search for target comparison.
    """
    while queue:
        bot = queue.popleft()
        if bots_with_chips[bot] == target:
            return bot
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
            hi_edge = int(tokens[11])
            add_edge(bot, lo_edge, hi_edge, edges)

    print(bfs_search(queue, edges, bots_with_chips, (17, 61)))


if __name__ == '__main__':
    main()
