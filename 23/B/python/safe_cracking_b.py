"""
Advent of Code 2016
Day 23, Part B
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


def cpy(src, dst, registers):
    """
    Copy given value into given register
    """
    if src in registers.keys():
        val = registers[src]
    else:
        val = int(src)
    if dst in registers:
        registers[dst] = val
    return 1


def jnz(val, off, registers):
    """
    Increment instruction pointer by off
    if reg value is zero
    """
    if val in registers.keys():
        val = registers[val]
    else:
        val = int(val)
    if off in registers:
        off = registers[off]
    else:
        off = int(off)
    if val == 0:
        return 1
    else:
        return off


def tgl(off, ptr, lines, registers):
    """
    Toggles instructions
    """
    if off in registers:
        off = registers[off]
    else:
        off = int(off)

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

    return 1


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
        print(ptr, '>', tokens, " | ", registers)
        if tokens[0] == 'cpy':
            # look for multiplication
            if lines[ptr + 3][0] == 'jnz' and lines[ptr + 3][-1] == '-2' \
            and lines[ptr + 5][0] == 'jnz' and lines[ptr + 5][-1] == '-5':
                if tokens[1] in registers:
                    mul1 = registers[tokens[1]]
                else:
                    mul1 = int(tokens[1])
                mul2 = registers[lines[ptr + 5][1]]
                print("\tmul:", mul1, "*", mul2, '-->', lines[ptr + 1][1])
                res = mul1 * mul2
                registers[lines[ptr + 5][1]] = 0
                registers[lines[ptr + 1][1]] += res
                ptr = ptr + 6
            else:
                ptr += cpy(tokens[1], tokens[2], registers)
        elif tokens[0] == 'inc':
            ptr += inc(tokens[1], registers)
        elif tokens[0] == 'dec':
            ptr += dec(tokens[1], registers)
        elif tokens[0] == 'jnz':
            ptr += jnz(tokens[1], tokens[2], registers)
        elif tokens[0] == 'tgl':
            ptr += tgl(tokens[1], ptr, lines, registers)
        else:
            raise Exception("Unknown assembunny instruction %s" % tokens[0])

    print("Final Registers:")
    for k in sorted(registers.keys()):
        print(k, ": ", registers[k])


if __name__ == '__main__':
    main()
