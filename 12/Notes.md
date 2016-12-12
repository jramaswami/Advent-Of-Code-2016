# Notes for Day 12: Leonardo's Monorail

## Python Solution

The solution here in Python was my attempt to solve the puzzle quickly.  It
isn't really all that special, it just read the input file, splits it into
lines.  For each line, the code splits the line on whitespace and uses if
statements to perform the appropriate instruction where the return value 
from the instruction is the value by which to increment the pointer.

## Racket Solution

The Racket solution uses Racket's facility for producing DSL's to turn
the input into a language.  As with the other days where this strategy is
used, Matthew Butterick's [Beautiful Racket][1] was the inspiration.

All Butterick's examples use a `for/fold` to execute instructions, in a linear
manner.  However, this puzzle has a `jnz` instruction, which requires the
ability to execute the instructions non-linearly.  However, a recursive
function with the instruction pointer as a argument allows the implementation
of the `jnz`.

[1]: http://beautifulracket.com/
