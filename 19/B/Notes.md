# Notes for Advent of Code 2016, Day 19: An Elephant Named Joseph

## Part A

To get the answer to part A I wrote a simulation that produced the answer in
a few seconds.  However, when I moved on to Part B and a simulation failed
to produce an answer in a timely manner, I realized that simulation is not
really the way to go.  Instead, I recognized that Part A is equivalent to
the [Josephus Problem][1].  I did so because of the clue left by the puzzle
creator:  *the elephant's name is Joseph*.  Once I realized this, I produced
a far faster solution using the appropriate formula.

## Part B

As I stated above, my first attempt at this problem was simulation.  This
was far too slow.  In fact, I was able to research, write the code, and
run the faster solution before the simulation finished!  

Part B is *not* equivalent to the original Josephus Problem.  However, I 
was able to produce a solution by looking at the simulations for n &le; 100.
I saw a pattern and used that to write the appropriate formula:  


<table>
<tr><td>j(n) = j(3<sup>x</sup> + m)</td><td> = m if m &le; 3<sup>x</sup></td></tr>
<tr><td>&nbsp;</td><td>= 2m + 3<sup>x</sup> if m &gt; 3<sup>x</sup></td></tr>
</table>

I was inspired to do so after viewing the [Numberphile video on the Josephus
Problem][2].

[1]: https://en.wikipedia.org/wiki/Josephus_problem
[2]: https://www.youtube.com/watch?v=uCsD3ZGzMgE
