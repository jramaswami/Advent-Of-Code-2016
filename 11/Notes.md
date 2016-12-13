# Notes for Day 11: Radioisotope Thermoelectric Generators 

This puzzle took me a little while to figure out.  In the end, it is just
a breadth first search of all the possible moves.  My first solutions prune
out any possible game states that are invalid as per the rules.  This allows
for a quick solution to Part A.  Part B, however, took quite a long time to
produce a solution.

I tried to implement an A\* search algorithm but it failed.  I'm not really
sure how to score the priority of each possible game state.

So, instead I focused on making the BFS faster.  The key to a faster solution
is to prune the possible game states.  In the [solution thread][2], I saw a
[suggestion][3] that the generator/microchip pairs are interchangeable. To
that end, I implemented a classification scheme to classify each building
according to the locations of generator/microchip pairs rather than 
by the location of each generator and microchip.  Without this crucial
pruning step, it took quite a while to come up with a solution to Part B;
on the order of start the solution, get up, brew tea, let the dogs out,
and come back to see what the solution was.  With the classification scheme,
it takes less than 10 seconds to solve Part B.  Quite a speed up!

For possible future investigations, the creator of Advent of Code stated
that this puzzle is based in the [Missionaries and Cannibals Problem][1].

[1]: https://en.wikipedia.org/wiki/Missionaries_and_cannibals_problem
[2]: https://www.reddit.com/r/adventofcode/comments/5hoia9/2016_day_11_solutions/
[3]: https://www.reddit.com/r/adventofcode/comments/5hoia9/2016_day_11_solutions/db1v1ws/
