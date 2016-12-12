"""
Advent of Code 2016
Day 12, Part A
"""


def inc(reg, registers):
    """
    Increment value in given register
    """
    registers[reg] += 1
    return 1


def dec(reg, registers):
    """
    Decrement value in given register
    """
    registers[reg] -= 1
    return 1


def cpy(val, reg, registers):
    """
    Copy given value into given register
    """
    registers[reg] = val
    return 1


def jnz(val, off, registers):
    """
    Increment instruction pointer by off
    if reg value is zero
    """
    if val == 0:
        return 1
    else:
        return off


def main():
    """
    Main program.
    """
    import sys
    lines = [line.strip() for line in sys.stdin.readlines()]
    end_file = len(lines)
    registers = {'a': 0, 'b': 0, 'c': 0, 'd': 0}
    ptr = 0
    while ptr >= 0 and ptr < end_file:
        tokens = lines[ptr].split()
        if tokens[0] == 'cpy':
            if tokens[1] in registers.keys():
                val = registers[tokens[1]]
            else:
                val = int(tokens[1])
            ptr += cpy(val, tokens[2], registers)
        elif tokens[0] == 'inc':
            ptr += inc(tokens[1], registers)
        elif tokens[0] == 'dec':
            ptr += dec(tokens[1], registers)
        elif tokens[0] == 'jnz':
            if tokens[1] in registers.keys():
                val = registers[tokens[1]]
            else:
                val = int(tokens[1])
            ptr += jnz(val, int(tokens[2]), registers)
        else:
            raise Exception("Unknown assembunny instruction %s" % tokens[0])

    print("Registers")
    for k in sorted(registers.keys()):
        print(k, ": ", registers[k])


if __name__ == '__main__':
    main()
