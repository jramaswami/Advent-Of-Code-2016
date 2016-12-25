"""
Advent of Code 2016
Day 25, Part A
Clock Signal
"""

import sys


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
        # print("\t", tokens_to_toggle, end="")
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
        # print(' -->', tokens_to_toggle)
    else:
        print("\tInvalid toggle instruction: out of range", off + ptr)

    return 1


def read_instructions():
    """
    Reads instructions
    """
    return [line.strip().split() for line in sys.stdin.readlines()]


def initialize_registers():
    """
    Initializes registers
    """
    registers = {'a': 0, 'b': 0, 'c': 0, 'd': 0}
    if len(sys.argv) > 1:
        for arg in sys.argv[1:]:
            tokens = arg.strip().split('=')
            if tokens[0] in registers:
                registers[tokens[0]] = int(tokens[1])
    return registers


def run_program(instructions, registers, buffer_size):
    """
    Run program until buffer reaches buffer size.
    When buffer is full, yield he buffer.
    """
    end_file = len(instructions)
    buffer = ''
    ptr = 0
    while ptr >= 0 and ptr < end_file:
        tokens = instructions[ptr]
        # print(ptr, '>', tokens, " | ", registers)
        if tokens[0] == 'cpy':
            # look for multiplication
            if instructions[ptr + 3][0] == 'jnz' \
            and instructions[ptr + 3][-1] == '-2' \
            and instructions[ptr + 5][0] == 'jnz' \
            and instructions[ptr + 5][-1] == '-5':
                if tokens[1] in registers:
                    mul1 = registers[tokens[1]]
                else:
                    mul1 = int(tokens[1])
                mul2 = registers[instructions[ptr + 5][1]]
                # print("\tmul:", mul1, "*", mul2, '-->',
                #      instructions[ptr + 1][1])
                res = mul1 * mul2
                registers[instructions[ptr + 5][1]] = 0
                registers[instructions[ptr + 1][1]] += res
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
            ptr += tgl(tokens[1], ptr, instructions, registers)
        elif tokens[0] == 'out':
            if tokens[1] in registers:
                val = str(registers[tokens[1]])
            else:
                val = tokens[1]
            buffer += val
            if len(buffer) == buffer_size:
                return buffer
            ptr += 1
        else:
            raise Exception("Unknown assembunny instruction %s" % tokens[0])


def main():
    """
    Main program.
    """

    instructions = read_instructions()
    right_signal = "01" * 10
    index = 1
    while True:
        registers = initialize_registers()
        registers['a'] = index
        buffer = run_program(instructions, registers, 20)
        if buffer == right_signal:
            print(index)
            return
        index += 1


if __name__ == '__main__':
    main()
