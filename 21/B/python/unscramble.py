"""
Advent of Code 2016
Day 21, Part B
Scrambled Letters and Hash
"""

from itertools import permutations

RIGHT = -1
LEFT = 1


def swap_position(posx, posy, pwd):
    """
    Swap position x with y.
    """
    left = min(posx, posy)
    right = max(posx, posy)
    return pwd[:left] + pwd[right] + pwd[left + 1:right] + \
        pwd[left] + pwd[right + 1:]


def swap_letter(ltrx, ltry, pwd):
    """
    Swap letter x with y.
    """
    posx = pwd.index(ltrx)
    posy = pwd.index(ltry)
    return swap_position(posx, posy, pwd)


def rotate(offset, pwd):
    """
    Rotate password by offset steps
    """
    offset = offset % len(pwd)
    return pwd[offset:] + pwd[:offset]


def rotate_on_letter(ltr, pwd):
    """
    Rotate password on index of letter.
    """
    index = pwd.index(ltr)
    offset = index + 1
    if index >= 4:
        offset += 1
    return rotate(RIGHT * offset, pwd)


def reverse(posx, posy, pwd):
    """
    Reverse string in range [posx, posy]
    """
    left = min(posx, posy)
    right = max(posx, posy)
    if left == 0:
        return pwd[:left] + pwd[right::-1] + pwd[right+1:]
    else:
        return pwd[:left] + pwd[right:left-1:-1] + pwd[right+1:]


def move(posx, posy, pwd):
    """
    Move letter from position x to position y.
    """
    ltr = pwd[posx]
    pwd = pwd[:posx] + pwd[posx+1:]
    pwd = pwd[:posy] + ltr + pwd[posy:]
    return pwd


def scramble(instructions, unscrambled):
    """
    Scrambles unscrambled according to list
    of instructions.
    """
    scrambled = unscrambled
    for line in instructions:
        tokens = line.split()
        if line.startswith('swap position'):
            posx, posy = int(tokens[2]), int(tokens[-1])
            scrambled = swap_position(posx, posy, scrambled)
        elif line.startswith('swap letter'):
            ltrx, ltry = tokens[2], tokens[-1]
            scrambled = swap_letter(ltrx, ltry, scrambled)
        elif line.startswith('rotate left'):
            offset = int(tokens[2])
            scrambled = rotate(LEFT * offset, scrambled)
        elif line.startswith('rotate right'):
            offset = int(tokens[2])
            scrambled = rotate(RIGHT * offset, scrambled)
        elif line.startswith('rotate based on position of letter'):
            ltr = tokens[-1]
            scrambled = rotate_on_letter(ltr, scrambled)
        elif line.startswith('reverse positions'):
            posx, posy = int(tokens[2]), int(tokens[-1])
            scrambled = reverse(posx, posy, scrambled)
        elif line.startswith('move position'):
            posx, posy = int(tokens[2]), int(tokens[-1])
            posx, posy = int(tokens[2]), int(tokens[-1])
            scrambled = move(posx, posy, scrambled)

        else:
            print("Invalid command:", line)
            return

    return scrambled


def unscramble(instructions, scrambled):
    """
    Unscrambles scrambled using list
    of instructions given by trying
    to scramble each possible permutation
    of the scrambled string to see if
    it matches.
    """
    possibles = []
    for candidate in ["".join(x) for x in list(permutations(scrambled))]:
        if scramble(instructions, candidate) == scrambled:
            possibles.append(candidate)
    return possibles


def main():
    """
    Main program.
    """
    import sys
    if len(sys.argv) < 3:
        print("Usage:", sys.argv[0],
              "<unscrambled password> <instructions file>")
        return

    scrambled = sys.argv[1].strip()
    input_file = sys.argv[2].strip()
    with open(input_file) as input_fh:
        instructions = input_fh.readlines()
    print(unscramble(instructions, scrambled))

if __name__ == '__main__':
    main()
