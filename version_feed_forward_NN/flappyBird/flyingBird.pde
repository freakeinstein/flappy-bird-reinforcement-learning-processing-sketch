void flyingBird(){
  float posY=0;
  if(!hit){
  posY = sin(radians(deg)*10);brd+=1;}
  applyForces();
  translate(birdPosition.x,birdPosition.y+posY*5);
  if(gravity.y/12 != 0)
  rotate(velocity.y/12);
  else rotate(radians(90));
 image(bird[brd/10],-bird[brd/10].width/2,-bird[brd/10].height/2);
 resetMatrix();
 deg+=1;
 if(brd>20) brd=0;
 if(deg>360) deg=0;
 floorHit();
}


void applyForces(){
  velocity.add(gravity);
  velocity.limit(7);
  birdPosition.add(velocity);
}

void floorHit(){
  if((birdPosition.y > BY || birdPosition.y < 0) && (!hit || stumpHit)){
    birdPosition.sub(velocity);
    velocity.set(0,0);
    gravity.set(0,0);
    hit=true;
    if(!stumpHit)hitSnd=true;
    scene=3;
  }
}