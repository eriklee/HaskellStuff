BoggleSolver
============
At an interview recently I was asked to code a Boggle solver given an isWord() function.  In the interview I asked for an isPrefix() function as well to prune my searches, which I was given and used in my pseudocode solution. 

After finishing we briefly discussed the importance of pruning and tried to work out some rough time estimates for how long it might take to solve a board without pruning and with it. We decided that pruning would probably have a significant impact on how long it would take to run, but obviously these were just back of the envelope calculations.

While trying really hard not to work on my project today I decided to write a program to solve the puzzles and see what kind of difference pruning made. I'm not a Haskell pro by any means, but I find it fun to use and decided to use that. It's pretty short and not particularly well optimized, but still solves boards up to 6x6 in about .5 seconds on my laptop with pruning. I have no idea how long it takes to do a 5x5 or 6x6 board without pruning because it does *not* take half a second.

In conclusion, it is a pretty safe claim that the cost of making a dictionary trie is massively, massively made up for by the drastic search space reduction it allows for.

Usage
-----
After compiling with ghc it expects input given all in one line, at least as long as _sizeM_ * _sizeN_ (defined in the file). Examples are included (x-_.in where x is the square board size)
