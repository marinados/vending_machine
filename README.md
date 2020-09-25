Hi, welcome to the world's most advanced vending machine.  

Just kidding.  
This is a simple Ruby implementation of a vending machine interface in the Terminal.

This one took around 5 hours to complete, but it's not the first iteration and counts a bit beyond pure coding.

Generally speaking, 2 hours is definitely not enough if we also count the "conceptual" phase. By the end of 5th hour, you're starting to get impatient, so it might be a bit long. Maybe I just type slowly.

*How to run it locally*
- Download the folder
- In the console, `cd` into the folder
- run `ruby main.rb`
- enjoy!

*How to run the tests*
- RSpec should be installed
- from the current folder, run `chmod +x run_rspec`
- run `./run_rspec`

_NB for the tests:_ I got a little lazy and out of time and only tested a bunch of outcomes. In a real time scenario there would we way more edge cases and just different scenarios but since I'm still only trying to force myself to do TDD, I first wrote the code :) But I'm conscious the ones present are not exhaustive. For one, I'm not even testing the interface, but it's not just that.

*Limitations*
This implements a very standard vending machine interface from the 80s, where you could only select one product at a time and insert payment coin by coin.  

This machine only accepts GBP, does no currency conversion and, most importantly, doesn't give you your money back in case something goes wrong, so be careful! This last thing is probably the first on the improvements list, if those were to be made. 

The change-giving algorithm is also currently very primitive and is following the strategy of limiting the number of coins to give back. This, of course, could be another improvement.

The vending machine administration interface is also absent, so it's a disposable vending machine: at the moment you cannot restock it with either products, or change and you cannot even get your money out of it (too bad for a vending machine, I know!)

I haven't added user friendly error messages, but for user's covenience it might also be an option.

And of course, some interface embellishment could be added, even though it's a console app :)
