void stumper(float x,float y){
  image(stumpi,x,y-stumpi.height);
  image(stump,x,y+stumpDiffY);
}

void checkScored()
{
     if(stumps.get(nextStump).posX+stump.width < birdX){
       score++;
       if(nextStump<4)nextStump++; else nextStump=0;
       scoreSound.trigger();
       giveScoreIncrementReward();
     }
}