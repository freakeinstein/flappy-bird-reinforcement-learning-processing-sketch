void tracker(float x, float y){
  fill(#000000);
  ellipse(x,y,10,10);
  
  
  //stumps.get(nextStump).posX+stump.width;
  stroke(#000000);
  line(stumps.get(nextStump).posX+stump.width,stumps.get(nextStump).posY,x,stumps.get(nextStump).posY);
  line(x,stumps.get(nextStump).posY,x,y);
}