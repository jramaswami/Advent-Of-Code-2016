"""
Advent of Code 2016
Day 23, Part A
Safe Cracking
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
    if reg in registers:
        registers[reg] = val
    return 1


def jnz(val, off):
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
    lines = [line.strip().split() for line in sys.stdin.readlines()]
    end_file = len(lines)
    registers = {'a': 0, 'b': 0, 'c': 0, 'd': 0}

    # init registers if necessary
    if len(sys.argv) > 1:
        for arg in sys.argv[1:]:
            tokens = arg.strip().split('=')
            if tokens[0] in registers:
                registers[tokens[0]] = int(tokens[1])


    print("Registers Initialized:")
    for k in sorted(registers.keys()):
        print(k, ": ", registers[k])

    ptr = 0
    while ptr >= 0 and ptr < end_file:
        tokens = lines[ptr]
        print(ptr, '>', tokens)
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
            if tokens[2] in registers:
                off = registers[tokens[2]]
            else:
                off = int(tokens[2])
            ptr += jnz(val, off)
        elif tokens[0] == 'tgl':
            if tokens[1] in registers:
                off = registers[tokens[1]]
            else:
                off = int(tokens[1])

            if ptr + off < len(lines):
                tokens_to_toggle = lines[ptr + off]
                print("\t", tokens_to_toggle, end="")
                if len(tokens_to_toggle) == 2:
                    # one argument instruction
                    if tokens_to_toggle[0] == 'inc':
                        tokens_to_toggle[0] = 'dec'
                    else:
                        tokens_to_toggle[0] = 'inc'
                elif len(tokens_to_toggle) == 3:
                    # two argument instruction
                    if tokens_to_toggle[0] == 'jnz':
                        tokens_to_toggle[0] = 'cpy'
                    else:
                        tokens_to_toggle[0] = 'jnz'
                else:
                    raise Exception("Toggle error, too many tokens: %s"
                                    % str(tokens_to_toggle))
                print(' -->', tokens_to_toggle)
            else:
                print("\tInvalid toggle instruction: out of range", off + ptr)
            ptr += 1
        else:
            raise Exception("Unknown assembunny instruction %s" % tokens[0])

    print("Final Registers:")
    for k in sorted(registers.keys()):
        print(k, ": ", registers[k])


if __name__ == '__main__':
    main()
