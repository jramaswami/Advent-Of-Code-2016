# Notes for Day 11: Radioisotope Thermoelectric Generators 

This puzzle took me a little while to figure out.  In the end, it is just
a breadth first search of all the possible moves.  My first solutions prune
out any possible game states that are invalid as per the rules.  This allows
for a quick solution to Part A.  Part B, however, took quite a long time to
produce a solution.

The key to a faster solution is to prune the possible game states.  In the
[solution thread][2], I saw a [suggestion][3] that the generator/microchip pairs
are interchangeable.  If I can figure out how to classify a the game state
using this hint, I'm sure that the solution will be faster.

For possible future investigations, the creator of Advent of Code stated
that this puzzle is based in the [Missionaries and Cannibals Problem][1].

[1]: https://en.wikipedia.org/wiki/Missionaries_and_cannibals_problem
[2]: https://www.reddit.com/r/adventofcode/comments/5hoia9/2016_day_11_solutions/
[3]: https://www.reddit.com/r/adventofcode/comments/5hoia9/2016_day_11_solutions/db1v1ws/
