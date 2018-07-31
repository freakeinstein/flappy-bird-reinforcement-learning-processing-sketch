# flappy-bird-Q learning-processing-arduino-sketch-reinforcement learning

### Backstory:

This project makes use of an old work, a flappy bird game, which can be playable using an arduino based controller. Me with my classmate Denin did that as a hobby project during hardware freedom day 2015. Now, I found that, I could use above game to test Q learning algorithm.

### how it is modified:

I've used some global variables and function calls to retrieve enough data from the above code and to invoke everything during each loop. Check `tracker()` and `giveScoreIncrementReward()`.

### To run:

This sketch require processing IDE to execute. get it from http://processing.org

You should install 'minim' library available for processing from add library option in  the IDE.

This code can also be used with arduino, where the arduino sketch should provide click commands through serial communication. 
Corresponding arduino related code is commented out for now.

### If you wanna disable Q learning and play the game yourself:

just comment out function call to `tracker()` in the `void draw()` looper.

### see it working:

https://youtu.be/QggzjNfBKlY

### how it works: Q learning tutorial

http://freakeinstein.github.io/2016/10/20/Q-learning-flappy-bird-game-demystified-(part-1)/

### future updates:

This project is very basic immplementation. Try a Deep NN version of Q learning with computer vision.

### reference:

I've used this website to implement this project: http://www.cs.indiana.edu/~gasser/Salsa/
