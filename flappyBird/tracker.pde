void tracker(float x, float y){
  boolean debug = false;
  
 // boolean last_reset = true; // to keep track of death penalty, kinda worst method but not interested to disturb original flappy bird code :(
 // boolean current_reset = true;
  //if(last_reset && !current_reset){ reset_episode = true; print("here 1"); }
  //else reset_episode = false;
  
  if(debug){
    fill(#000000);
    ellipse(x,y,10,10);
  }
  
  // below step is to keep track of the birds relative position from nearest next stump
  x_dist = dist(stumps.get(nextStump).posX+stump.width,stumps.get(nextStump).posY,birdPosition.x,stumps.get(nextStump).posY);
  y_dist = dist(birdPosition.x,stumps.get(nextStump).posY,birdPosition.x,birdPosition.y);
  
  //print(dist(stumps.get(nextStump).posX+stump.width,stumps.get(nextStump).posY,x,stumps.get(nextStump).posY),"  ",dist(x,stumps.get(nextStump).posY,x,y),"\n");
  //stumps.get(nextStump).posX+stump.width;
  
  if(debug){
    stroke(#000000);
    line(stumps.get(nextStump).posX+stump.width,stumps.get(nextStump).posY,x,stumps.get(nextStump).posY);
    line(x,stumps.get(nextStump).posY,x,y);
  }
  
  
  
  if(scene != 2){ // this is to skip intro scenes => useful during training.
   // last_reset = current_reset;
    //current_reset = true;
    reset_episode = true;
    ch = 'L';
  }else{
    //last_reset = current_reset;
    //current_reset = false;
    DoQLearningStep(); // if we're on game scene, do learning
  }
}