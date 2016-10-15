# flappy-bird-Q learning-processing-arduino-sketch-reinforcement learning

###Backstory:

This project uses version of a processing sketch which was a pure implementation of 'flappy bird game', capable of playing using arduino serial communication. Me with my classmate denin (@ MCA CET) took a night to code this, to demonstrate something on hardware freedom day 2015.

###how it modified:

I've used some global variables and function calls to retrieve enough data from the above code and to invoke everything during each loop. Check `tracker()` and `giveScoreIncrementReward()`.

###To run:

This sketch require processing IDE to execute. get it from http://processing.org

You should install 'minim' library available for processing from add library option in  the IDE.

This code can also be used with arduino, where the arduino sketch should provide click commands through serial communication. 
Corresponding arduino related code is commented out for now.

###If you wanna disable Q learning and play the game myself:

just comment out function call to `tracker()` in the `void draw()` looper.

###see it working:

https://youtu.be/QggzjNfBKlY

###how it works: [ working on it ]

http://freakeinstein.github.io
