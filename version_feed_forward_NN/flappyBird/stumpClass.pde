class Stump{
  float posX=0,posY;
  Stump(float y,float x)
  {
    posY = y;
    posX = x+width;
  }
  void update(){
    posX-=1.86;
        //rect(posX-20,posY,stump.width,stumpDiffY);
  }
  void display(){
    stumper(posX,posY);
  }
  
  void checkPassed()
  {
     if( posX+stump.width < 0){
     posX = stumpDiffX+width;
     stumpCount++;
     }
  }
  void checkHit(){
    if(birdPosition.x>=(posX-15) && birdPosition.x <=(posX-15)+stump.width && !stumpHit)
    {
      if(birdPosition.y<posY || birdPosition.y>posY+stumpDiffY){
        hit=true;
        stumpHit=true;
        hitSnd=true;
      }
    }
  }
}